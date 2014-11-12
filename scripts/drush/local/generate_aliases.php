<?php
/**
 * This contains all the functions hooked in to generate
 * a list of aliases by reading off of the sources listed
 * in ~/.elmsln/elmsln-hosts
 *
 * This allows sys admins to manage multiple ELMSLN deployments
 * from one console and yes, perform ridiculous cross system
 * operations against patterns of targets with relative ease.
 */

/**
 * Wrapper for alias file that builds out aliases
 * @param  array $aliases aliases from drush sa command
 */
function _elmsln_alises_build(&$aliases) {
  // static cache assembled aliases as this can get tripped often
  static $pulledaliases = array();
  if (empty($pulledaliases)) {    // read off the .elmsln/elmsln-hosts manifest
    $pulledaliases = array();
    $home = getenv("HOME");
    // if somehow that isn't set..
    if (empty($home)) {
      $usr = posix_getpwuid(posix_getuid());
      $home = $user['dir'];
    }
    $file = "$home/.elmsln/elmsln-hosts";
    $hosts = file_get_contents($file);
    $lines = explode("\n", $hosts);
    // read each line of the config file
    foreach ($lines as $key => $line) {
      // make sure this line isn't a comment and has a=
      if (strpos($line, 'ssh') === 0) {
        $server = array();
        $line = str_replace('ssh ', '', $line);
        $tmp = explode(' ', $line);
        foreach ($tmp as $item) {
          if (strpos($item, '@')) {
            $tmp2 = explode('@', $item);
            if (count($tmp2) == 2) {
              $server['remote-user'] = $tmp2[0];
              $server['remote-host'] = $tmp2[1];
            }
          }
          else {
            $server['ssh-options'] .= $item . ' ';
          }
        }
        // ensure we have 2 settings before doing this
        if (count($server) == 3) {
          // try for a nice name
          if ($key > 0 && strpos($lines[$key-1], '#') === 0) {
            $aliaskey = _elmsln_alias_server_name($lines[$key-1]);
          }
          else {
            $aliaskey = _elmsln_alias_server_name($server['remote-host']);
          }
          $pulledaliases[$aliaskey] = _elmsln_alias_build_aliases($aliaskey, $server);
        }
      }
    }
  }
  // @todo add support for bundled stacks across deployments
  // for example: elmsln-courses-all which trips all the courses-all
  // stacks found across known hosts. This could allow for applying
  // something JUST to all courses that we are managing
  // add support for bundled and nested targets
  $aliases['elmsln-all'] = array('site-list' => array());
  // now convert these to aliases style
  foreach ($pulledaliases as $system => $onsystem) {
    $aliases[$system] = array('site-list' => array());
    array_push($aliases['elmsln-all']['site-list'], '@' . $system);
    foreach ($onsystem as $alias => $settings) {
      array_push($aliases[$system]['site-list'], '@' . $system . '.' . $alias);
      // @todo need to deep load and repair parents
      if (isset($settings['parent'])) {
        $settings['parent'] = str_replace('@', '@' . $system . '.' . $alias . '.', $settings['parent']);
        //print $settings['parent'] . "\n";
      }
      $aliases[$system . '.' . $alias] = $settings;

    }
    sort($aliases[$system]['site-list']);
  }
}

/**
 * Execute remote alias generation; assumes SSH key binding is in place.
 * @param  array $server ssh parameters to connect remotely
 * @param  string $script script to execute
 * @return string         string that is a serialized array
 */
function _elmsln_alias_execute($server, $script) {
  $output = array();
  $error = FALSE;
  // Setup connection string
  $string = $server['ssh-options'] . ' ' . $server['remote-user'] . '@' . $server['remote-host'];
  // Execute script
  $cmd = "ssh $string $script 2>&1";
  $output['command'] = $cmd;
  exec($cmd, $output, $error);
  if ($error) {
    print 'ERROR IN SSH CONNECTION';
  }
  return $output;
}

/**
 * convert a server name into an alias bucket
 * @param  string $key url to a server to remote connect to
 * @return string         cleaned up to avoid grouping issues
 */
function _elmsln_alias_server_name($key) {
  return ereg_replace("[^a-z]", '', strtolower($key));
}

/**
 * build aliases by running the remote alias generator
 * @param  string $key    server/alias group
 * @param  string $server url to a server to remote connect to
 * @return array         list of aliases w/ their connection credentials
 */
function _elmsln_alias_build_aliases($key, $server) {
  // Create an array to hold the cache, this prevents unneeded ssh connections
  static $systems = array();
  if (!empty($systems[$key])) {
    return $systems[$key];
  }
  // change home directory location if not running linux
  $return = _elmsln_alias_execute($server, "php /home/{$server['remote-user']}/.drush/elmsln.remoteconnect.php");
  // unserialize directly into our expected aliases array
  $system = unserialize($return[0]);
  // append remote connection settings
  foreach ($system as &$alias) {
    if (isset($alias['root'])) {
      $alias += $server;
    }
  }
  $systems[$key] = $system;
  return $systems[$key];
}