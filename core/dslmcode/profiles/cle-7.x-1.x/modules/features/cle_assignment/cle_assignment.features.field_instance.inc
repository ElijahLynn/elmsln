<?php
/**
 * @file
 * cle_assignment.features.field_instance.inc
 */

/**
 * Implements hook_field_default_field_instances().
 */
function cle_assignment_field_default_field_instances() {
  $field_instances = array();

  // Exported field_instance: 'comment-comment_node_cle_assignment-comment_body'
  $field_instances['comment-comment_node_cle_assignment-comment_body'] = array(
    'bundle' => 'comment_node_cle_assignment',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => '',
    'display' => array(
      'default' => array(
        'label' => 'hidden',
        'module' => 'text',
        'settings' => array(),
        'type' => 'text_default',
        'weight' => 0,
      ),
    ),
    'entity_type' => 'comment',
    'field_name' => 'comment_body',
    'label' => 'Comment',
    'required' => TRUE,
    'settings' => array(
      'text_processing' => 1,
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'module' => 'text',
      'settings' => array(
        'rows' => 5,
      ),
      'type' => 'text_textarea',
      'weight' => 0,
    ),
  );

  // Exported field_instance: 'node-cle_assignment-body'
  $field_instances['node-cle_assignment-body'] = array(
    'bundle' => 'cle_assignment',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => '',
    'display' => array(
      'default' => array(
        'label' => 'hidden',
        'module' => 'text',
        'settings' => array(),
        'type' => 'text_default',
        'weight' => 9,
      ),
      'teaser' => array(
        'label' => 'hidden',
        'module' => 'text',
        'settings' => array(
          'trim_length' => 600,
        ),
        'type' => 'text_summary_or_trimmed',
        'weight' => 1,
      ),
    ),
    'entity_type' => 'node',
    'field_name' => 'body',
    'label' => 'Body',
    'required' => 0,
    'settings' => array(
      'better_formats' => array(
        'allowed_formats' => array(
          'plain_text' => 0,
          'student_work' => 0,
          'textbook_editor' => 'textbook_editor',
        ),
        'allowed_formats_toggle' => 1,
        'default_order_toggle' => 0,
        'default_order_wrapper' => array(
          'formats' => array(
            'plain_text' => array(
              'weight' => 10,
            ),
            'student_work' => array(
              'weight' => 0,
            ),
            'textbook_editor' => array(
              'weight' => -10,
            ),
          ),
        ),
      ),
      'display_summary' => 1,
      'text_processing' => 1,
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'text',
      'settings' => array(
        'rows' => 20,
        'summary_rows' => 5,
      ),
      'type' => 'text_textarea_with_summary',
      'weight' => 5,
    ),
  );

  // Exported field_instance: 'node-cle_assignment-field_color'
  $field_instances['node-cle_assignment-field_color'] = array(
    'bundle' => 'cle_assignment',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => 'This helps to identify assignments when viewing multiple',
    'display' => array(
      'default' => array(
        'label' => 'hidden',
        'module' => 'jquery_colorpicker',
        'settings' => array(),
        'type' => 'jquery_colorpicker_color_display',
        'weight' => 0,
      ),
    ),
    'entity_type' => 'node',
    'field_name' => 'field_color',
    'label' => 'Color',
    'required' => 1,
    'settings' => array(
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 0,
      'module' => 'jquery_colorpicker',
      'settings' => array(),
      'type' => 'jquery_colorpicker',
      'weight' => 4,
    ),
  );

  // Exported field_instance: 'node-cle_assignment-field_due_date'
  $field_instances['node-cle_assignment-field_due_date'] = array(
    'bundle' => 'cle_assignment',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => '',
    'display' => array(
      'default' => array(
        'label' => 'inline',
        'module' => 'date',
        'settings' => array(
          'format_type' => 'long',
          'fromto' => 'both',
          'multiple_from' => '',
          'multiple_number' => '',
          'multiple_to' => '',
        ),
        'type' => 'date_default',
        'weight' => 4,
      ),
    ),
    'entity_type' => 'node',
    'field_name' => 'field_due_date',
    'label' => 'Due Date',
    'required' => 0,
    'settings' => array(
      'default_value' => 'blank',
      'default_value2' => 'same',
      'default_value_code' => '',
      'default_value_code2' => '',
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'date',
      'settings' => array(
        'increment' => 15,
        'input_format' => 'm/d/Y - g:i:sa',
        'input_format_custom' => '',
        'label_position' => 'above',
        'text_parts' => array(),
        'year_range' => '-0:+1',
      ),
      'type' => 'date_select',
      'weight' => 6,
    ),
  );

  // Exported field_instance: 'node-cle_assignment-field_media_requirements'
  $field_instances['node-cle_assignment-field_media_requirements'] = array(
    'bundle' => 'cle_assignment',
    'default_value' => array(
      0 => array(
        'value' => 'field_images',
      ),
      1 => array(
        'value' => 'body',
      ),
    ),
    'deleted' => 0,
    'description' => '',
    'display' => array(
      'default' => array(
        'label' => 'inline',
        'module' => 'list',
        'settings' => array(),
        'type' => 'list_default',
        'weight' => 7,
      ),
    ),
    'entity_type' => 'node',
    'field_name' => 'field_media_requirements',
    'label' => 'Media Requirements',
    'required' => 1,
    'settings' => array(
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'options',
      'settings' => array(),
      'type' => 'options_buttons',
      'weight' => 7,
    ),
  );

  // Exported field_instance: 'node-cle_assignment-field_number'
  $field_instances['node-cle_assignment-field_number'] = array(
    'bundle' => 'cle_assignment',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => 'This is used as the Assignment number which helps students with sorting of items as to what order to accomplish them in',
    'display' => array(
      'default' => array(
        'label' => 'inline',
        'module' => 'text',
        'settings' => array(),
        'type' => 'text_default',
        'weight' => 2,
      ),
    ),
    'entity_type' => 'node',
    'field_name' => 'field_number',
    'label' => 'Number',
    'required' => 1,
    'settings' => array(
      'better_formats' => array(
        'allowed_formats' => array(
          'plain_text' => 'plain_text',
          'student_work' => 'student_work',
          'textbook_editor' => 'textbook_editor',
        ),
        'allowed_formats_toggle' => 0,
        'default_order_toggle' => 0,
        'default_order_wrapper' => array(
          'formats' => array(
            'plain_text' => array(
              'weight' => 10,
            ),
            'student_work' => array(
              'weight' => 0,
            ),
            'textbook_editor' => array(
              'weight' => -10,
            ),
          ),
        ),
      ),
      'text_processing' => 0,
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'select_or_other',
      'settings' => array(
        'available_options' => '1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
I
I
II
P',
        'available_options_php' => '',
        'markup_available_options_php' => '&lt;none&gt;',
        'other' => 'Other',
        'other_size' => 60,
        'other_title' => '',
        'other_unknown_defaults' => 'available',
        'sort_options' => 1,
      ),
      'type' => 'select_or_other',
      'weight' => 5,
    ),
  );

  // Exported field_instance: 'node-cle_assignment-field_sub_number'
  $field_instances['node-cle_assignment-field_sub_number'] = array(
    'bundle' => 'cle_assignment',
    'default_value' => NULL,
    'deleted' => 0,
    'description' => '',
    'display' => array(
      'default' => array(
        'label' => 'inline',
        'module' => 'text',
        'settings' => array(),
        'type' => 'text_default',
        'weight' => 3,
      ),
    ),
    'entity_type' => 'node',
    'field_name' => 'field_sub_number',
    'label' => 'Sub-number',
    'required' => 0,
    'settings' => array(
      'better_formats' => array(
        'allowed_formats' => array(
          'plain_text' => 'plain_text',
          'student_work' => 'student_work',
          'textbook_editor' => 'textbook_editor',
        ),
        'allowed_formats_toggle' => 0,
        'default_order_toggle' => 0,
        'default_order_wrapper' => array(
          'formats' => array(
            'plain_text' => array(
              'weight' => 10,
            ),
            'student_work' => array(
              'weight' => 0,
            ),
            'textbook_editor' => array(
              'weight' => -10,
            ),
          ),
        ),
      ),
      'text_processing' => 0,
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'select_or_other',
      'settings' => array(
        'available_options' => 'a
b
c
d
1
2
3
4
5
I
II
i
ii
i',
        'available_options_php' => '',
        'markup_available_options_php' => '&lt;none&gt;',
        'other' => 'Other',
        'other_size' => 60,
        'other_title' => '',
        'other_unknown_defaults' => 'available',
        'sort_options' => 1,
      ),
      'type' => 'select_or_other',
      'weight' => 6,
    ),
  );

  // Exported field_instance: 'node-cle_assignment-field_visibility'
  $field_instances['node-cle_assignment-field_visibility'] = array(
    'bundle' => 'cle_assignment',
    'default_value' => array(
      0 => array(
        'value' => 1,
      ),
    ),
    'deleted' => 0,
    'description' => 'Public Assignments will be visible to everyone in the class.  This is useful when the assignment requires open critique and response.  Private Assignments will only be visible by you, the student submitting the work, and any support staff / TAs.',
    'display' => array(
      'default' => array(
        'label' => 'hidden',
        'settings' => array(),
        'type' => 'hidden',
        'weight' => 6,
      ),
    ),
    'entity_type' => 'node',
    'field_name' => 'field_visibility',
    'label' => 'Visibility',
    'required' => 1,
    'settings' => array(
      'user_register_form' => FALSE,
    ),
    'widget' => array(
      'active' => 1,
      'module' => 'options',
      'settings' => array(),
      'type' => 'options_buttons',
      'weight' => 5,
    ),
  );

  // Exported field_instance: 'node-cle_assignment-og_group_ref'
  $field_instances['node-cle_assignment-og_group_ref'] = array(
    'bundle' => 'cle_assignment',
    'default_value' => NULL,
    'default_value_function' => 'entityreference_prepopulate_field_default_value',
    'deleted' => 0,
    'description' => '',
    'display' => array(
      'default' => array(
        'label' => 'inline',
        'module' => 'og_ui',
        'settings' => array(),
        'type' => 'og_list_default',
        'weight' => 1,
      ),
    ),
    'entity_type' => 'node',
    'field_name' => 'og_group_ref',
    'label' => 'Section',
    'required' => 1,
    'settings' => array(
      'behaviors' => array(
        'og_widget' => array(
          'admin' => array(
            'widget_type' => 'options_select',
          ),
          'default' => array(
            'widget_type' => 'options_select',
          ),
          'status' => TRUE,
        ),
        'prepopulate' => array(
          'action' => 'disable',
          'action_on_edit' => 1,
          'fallback' => 'none',
          'og_context' => 1,
          'skip_perm' => 0,
          'status' => 1,
        ),
      ),
      'user_register_form' => FALSE,
    ),
    'view modes' => array(
      'full' => array(
        'custom settings' => FALSE,
        'label' => 'Full',
        'type' => 'og_list_default',
      ),
      'teaser' => array(
        'custom settings' => FALSE,
        'label' => 'Teaser',
        'type' => 'og_list_default',
      ),
    ),
    'widget' => array(
      'active' => 0,
      'module' => 'og',
      'settings' => array(),
      'type' => 'og_complex',
      'weight' => 3,
    ),
  );

  // Translatables
  // Included for use with string extractors like potx.
  t('Body');
  t('Color');
  t('Comment');
  t('Due Date');
  t('Media Requirements');
  t('Number');
  t('Public Assignments will be visible to everyone in the class.  This is useful when the assignment requires open critique and response.  Private Assignments will only be visible by you, the student submitting the work, and any support staff / TAs.');
  t('Section');
  t('Sub-number');
  t('This helps to identify assignments when viewing multiple');
  t('This is used as the Assignment number which helps students with sorting of items as to what order to accomplish them in');
  t('Visibility');

  return $field_instances;
}
