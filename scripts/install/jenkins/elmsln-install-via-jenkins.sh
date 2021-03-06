#!/bin/bash
# This install script will build job files correctly that drush-create-site
# will pick up and build the initial sites for the system.
# Only user this to initially setup the system as it will add in jobs
# that would fail after the fact.

# provide messaging colors for output to console
txtbld=$(tput bold)             # Bold
bldgrn=$(tput setaf 2) #  green
bldred=${txtbld}$(tput setaf 1) #  red
txtreset=$(tput sgr0)
elmslnecho(){
  echo "${bldgrn}$1${txtreset}"
}
elmslnwarn(){
  echo "${bldred}$1${txtreset}"
}

# where am i? move to where I am. This ensures source is properly sourced
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
# include our config settings
source ../../config/scripts/drush-create-site/config.cfg

# check that we are the root user
if [[ $EUID -ne 0 ]]; then
  elmslnwarn "Please run as root"
  exit 1
fi
#test for empty vars. if empty required var -- exit
if [ -z $fileloc ]; then
  elmslnwarn "please update your config.cfg file, file location variable missing"
  exit 1
fi
if [ -z $site_email ]; then
  elmslnwarn "please update your config.cfg file, site email variable missing"
  exit 1
fi
if [ -z $admin ]; then
  elmslnwarn "please update your config.cfg file, admin email variable missing"
  exit 1
fi
if [ -z $webdir ]; then
  elmslnwarn "please update your config.cfg file, webdir variable missing"
  exit 1
fi

core='7.x'
# all distributions / stacks we have
# @todo add in discuss / comply once we have things at least functional there
distros=('cis' 'mooc' 'cle' 'icor' 'elmsmedia' 'meedjum_blog')
stacklist=('online' 'courses' 'studio' 'interact' 'media' 'blog')
# things to build place holder sites for
buildlist=('courses' 'studio' 'interact' 'blog')
# things to default to central authority status
authoritydistros=('elmsmedia' 'cis')
authoritylist=('media' 'online')
# array of instance definitions for the distro type
instances=('FALSE' 'TRUE' 'TRUE' 'TRUE' 'FALSE' 'TRUE')
ignorelist=('TRUE' 'FALSE' 'FALSE' 'FALSE' 'TRUE' 'FALSE')
defaulttitle=('Course information system' 'Course outline' 'Collaborative studio' 'Interactive object repository' 'Media asset management' 'Course Blog')
moduledir=$elmsln/config/shared/drupal-${core}/modules/_elmsln_scripted
cissettings=${university}_${host}_settings

# used for random password generation
COUNTER=0
char=(0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V X W Y Z)
max=${#char[*]}

# generate a scripted directory
if [ ! -d ${moduledir} ];
  then
  mkdir -p ${moduledir}
  mkdir -p ${moduledir}/${university}
fi
# work on authoring the connector module automatically
if [ ! -d ${moduledir}/${university}/${cissettings} ];
  then
  mkdir -p ${moduledir}/${university}/${cissettings}
  chown -R $USER:$webgroup ${moduledir}
  infofile=${moduledir}/${university}/${cissettings}/${cissettings}.info
  modulefile=${moduledir}/${university}/${cissettings}/${cissettings}.module
  touch $infofile
  chmod 744 $infofile
  touch $modulefile
  chmod 744 $modulefile
  # write the .info file
  echo -e "name = ${university} ${host} Settings\ndescription = This contains registry information for all ${host} connection details\ncore = ${core}\npackage = ${university}" >> $infofile
  # write the .module file
  echo -e "<?php\n\n// service module that makes this implementation specific\n\n/**\n * Implements hook_cis_service_registry().\n */\nfunction ${university}_${host}_settings_cis_service_registry() {\n  \$items = array(\n" >> $modulefile
  # write the array of connection values dynamically
  for distro in "${distros[@]}"
  do
    # array built up to `word
    echo -e "    // ${distro} distro instance called ${stacklist[$COUNTER]}\n    '${distro}' => array(\n      'protocol' => '${protocol}',\n      'service_address' => '${serviceprefix}${stacklist[$COUNTER]}.${serviceaddress}',\n      'address' => '${stacklist[$COUNTER]}.${address}',\n      'user' => 'SERVICE_${distro}_${host}',\n      'mail' => 'SERVICE_${distro}_${host}@${emailending}'," >> $modulefile
    # generate a random 30 digit password
    pass=''
    for i in `seq 1 30`
    do
      let "rand=$RANDOM % 62"
      pass="${pass}${char[$rand]}"
    done
    # write password to file
    echo -e "      'pass' => '$pass'," >> $modulefile
    # finish off array
    echo -e "      'instance' => ${instances[$COUNTER]}," >> $modulefile
    echo -e "      'default_title' => '${defaulttitle[$COUNTER]}'," >> $modulefile
    echo -e "      'ignore' => ${ignorelist[$COUNTER]},\n    ),\n" >> $modulefile
    COUNTER=$COUNTER+1
 done
  # close out function and file
  echo -e "  );\n\n  return \$items;\n}\n\n" >> $modulefile
  # add the function to include this in build outs automatically
  echo -e "/**\n * Implements hook_cis_service_instance_options_alter().\n */\nfunction ${university}_${host}_settings_cis_service_instance_options_alter(&\$options, \$course, \$service) {\n  // modules we require for all builds\n  \$options['en'][] = '$cissettings';\n}\n" >> $modulefile
fi

#test mysql login
#mysql -u$dbsu -p$dbsupw -e exit
#if [[ $? > 0 ]];then
  #echo "mysql connection failed"
  #exit 1
#fi

# make sure drush is happy before we begin drush calls
drush cc drush
chown -R $USER $HOME/.drush
# make sure the entire directory is writable by the current user
chown -R $USER:$webgroup $elmsln

# random password for defaultdbo
dbpw=''
for j in `seq 1 30`
do
  let "rand=$RANDOM % 62"
  dbpw="${dbpw}${char[$rand]}"
done

# build the default sites
for build in "${buildlist[@]}"
  do
  # install default site for associated stacks in the build list
  cd $stacks/$build
  drush site-install -y --db-url=mysql://elmslndfltdbo:$dbpw@localhost/default_$build --db-su=$dbsu --db-su-pw=$dbsupw --account-mail="$admin" --site-mail="$site_email"
done

COUNTER=0
# install central providers this is currently ELMS Media and CIS
for tool in "${authoritylist[@]}"
  do
  dist=${authoritydistros[$COUNTER]}
  # generate a random 30 digit password
  dbpw=''
  for k in `seq 1 30`
  do
    let "rand=$RANDOM % 62"
    dbpw="${dbpw}${char[$rand]}"
  done
  # move to the directory of this authority
  cd ${webdir}/${tool}
  sitedir=${webdir}/${tool}/sites
  drush site-install ${dist} -y --db-url=mysql://${tool}_${host}:$dbpw@localhost/${tool}_${host} --db-su=$dbsu --db-su-pw=$dbsupw  --account-mail="$admin" --site-mail="$site_email" --site-name="$tool"
  #move out of $tool site directory to host
  mkdir -p $sitedir/$tool/$host
  mkdir -p $sitedir/$tool/$host/files
  #modify ownership of these directories
  chown -R $wwwuser:$webgroup $sitedir/$tool/$host/files
  chmod -R 755 $sitedir/$tool/$host/files

  # setup private file directory
  mkdir -p $drupal_priv/$tool
  mkdir -p $drupal_priv/$tool/$tool
  chown -R $wwwuser:$webgroup $drupal_priv
  chmod -R 755 $drupal_priv

  # copy the default settings file to this location
  # we leave the original for the time being because this is the first instace
  # of the system. most likely we'll always need a default to fall back on anyway
  cp "$sitedir/default/settings.php" "$sitedir/$tool/$host/settings.php"
  chown $USER:$webgroup $sitedir/default/settings.php
  chown $USER:$webgroup $sitedir/$tool/$host/settings.php
  chmod -R 755 $sitedir/$tool/$host/settings.php

  # establish these values real quick so its more readable below
  site_domain="$tool.${address}"
  site_service_domain="${serviceprefix}$tool.${serviceaddress}"
  # add site to the sites array
  echo "\$sites = array(" >> $sitedir/sites.php
  echo "  '$site_domain' => '$tool/$host'," >> $sitedir/sites.php
  echo "  '$site_service_domain' => '$tool/services/$host'," >> $sitedir/sites.php
  echo ");" >> $sitedir/sites.php
  # set base_url
  echo "\$base_url= '$protocol://$site_domain';" >> $sitedir/$tool/$host/settings.php

  # enable the cis_settings registry, set private path then execute clean up routines
  drush -y --uri=$protocol://$site_domain en $cissettings
  drush -y --uri=$protocol://$site_domain vset file_private_path ${drupal_priv}/$tool/$tool
  # distro specific additional install routine
  drush -y --uri=$protocol://$site_domain cook elmsln_$dist
  # clean up tasks per distro here
  if [ $dist == 'cis' ];
    then
    drush -y --uri=$protocol://$site_domain vset site_slogan 'Welcome to ELMSLN'
    drush -y --uri=$protocol://$site_domain vset cis_college_name $host
  fi

  # add in our cache bins now that we know it built successfully
  echo "" >> $sitedir/$tool/$host/settings.php
  echo "" >> $sitedir/$tool/$host/settings.php
  echo "\$conf['cache_prefix'] = '$tool_$host';" >> $sitedir/$tool/$host/settings.php
  echo "" >> $sitedir/$tool/$host/settings.php
  echo "require_once DRUPAL_ROOT . '/../../shared/drupal-7.x/settings/shared_settings.php';" >> $sitedir/$tool/$host/settings.php

  # adding servies conf file
  if [ ! -d $sitedir/$tool/services/$host ];
    then
      mkdir -p $sitedir/$tool/services/$host
      mkdir -p $sitedir/$tool/services/$host/files
      chown -R $wwwuser:$webgroup $sitedir/$tool/services/$host/files
      chmod -R 755 $sitedir/$tool/services/$host/files
      if [ -f $sitedir/$tool/$host/settings.php ]; then
        cp $sitedir/$tool/$host/settings.php $sitedir/$tool/services/$host/settings.php
      fi
      if [ -f $sitedir/$tool/services/$host/settings.php ]; then
        chown $USER:$webgroup $sitedir/$tool/services/$host/settings.php
        echo "" >> $sitedir/$tool/services/$host/settings.php
        echo "" >> $sitedir/$tool/services/$host/settings.php
        echo "\$conf['restws_basic_auth_user_regex'] = '/^SERVICE_.*/';" >> $sitedir/$tool/services/$host/settings.php
      fi
  fi
  # make sure everything in that folder is as it should be ownerwise
  chown -R $wwwuser:$webgroup $sitedir/$tool/$host/files
  # forcibly apply 1st ELMSLN global update since it isn't fixed tools
  # this makes it so that we don't REQUIRE multi-sites to run tools (stupid)
  # while still fixing the issue with httprl when used in multisites
  drush -y --uri=$protocol://$site_domain cook d7_elmsln_global_1413916953 --dr-locations=/var/www/elmsln/scripts/upgrade/drush_recipes/d7/global
  # ELMSLN clean up for authority distributions (single point)
  drush -y --uri=$protocol://$site_domain cook elmsln_authority_setup

  COUNTER=$COUNTER+1
done

# perform some clean up tasks
# check for tmp directory in config area
if [ ! -d $elmsln/config/_nondrupal/piwik/tmp ];
then
  mkdir $elmsln/config/_nondrupal/piwik/tmp
  chown -R $wwwuser:$webgroup $elmsln/config/_nondrupal/piwik/tmp
fi
chown -R $wwwuser:$wwwuser $elmsln/config/_nondrupal/piwik
chmod -R 0755 $elmsln/config/_nondrupal/piwik
# jobs file directory
chown -R $wwwuser:$webgroup $elmsln/config/jobs
chmod -R 755 $elmsln/config/jobs
# make sure webserver owns the files
find $configsdir/stacks/ -type d -name files | xargs chown -R $wwwuser:$webgroup

# clean up tmp directory .htaccess to make drupal happy
rm /tmp/.htaccess
# last second security hardening as clean up to enforce defaults
bash /var/www/elmsln/scripts/utilities/harden-security.sh
# a message so you know where our head is at. you get candy if you reference this
elmslnecho "╔───────────────────────────────────────────────────────────────╗"
elmslnecho "║           ____  Welcome to      ____                          ║"
elmslnecho "║          |     |      /\  /\   /     |     |\   |             ║"
elmslnecho "║          |____ |     |  \/  |  \___  |     | \  |             ║"
elmslnecho "║          |     |     |      |      \ |     |  \ |             ║"
elmslnecho "║          |____ |____ |      |  ____/ |____ |   \|             ║"
elmslnecho "║                                                               ║"
elmslnecho "╟───────────────────────────────────────────────────────────────╢"
elmslnecho "║ If you are still having problems you may submit issues to     ║"
elmslnecho "║   http://github.com/btopro/elmsln/issues                      ║"
elmslnecho "╟───────────────────────────────────────────────────────────────╢"
elmslnecho "║ NOTES                                                         ║"
elmslnecho "║ There is a module that was authored during installation at    ║"
elmslnecho "║ config/shared/drupal-7.x/modules/_elmsln_scripted             ║"
elmslnecho "║ You may want to open this up and review it but it is your     ║"
elmslnecho "║ connection keychain for how all the webservices talk.         ║"
elmslnecho "║                                                               ║"
elmslnecho "╠───────────────────────────────────────────────────────────────╣"
elmslnecho "║ Use this link to access the Course Information System:        ║"
elmslnecho "║   $protocol://$site_domain                                   "
elmslnecho "║                                                               ║"
elmslnecho "║Welcome to the Singularity of edtech.. build the future..      ║"
elmslnecho "╚───────────────────────────────────────────────────────────────╝"
