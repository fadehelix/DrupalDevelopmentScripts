<?php

function show_taxonomy_terms_drush_command() {
  $items = array();

  $items['show-all-terms'] = array(
    'aliases' => array('att'),
    'description' => 'Show terms of all taxonomies',
    'arguments' => array(),
    'examples' => array(
      'drush att' =>  'Display list of all names and ids of terms',
     ),
     'bootstrap' => DRUSH_BOOTSTRAP_MAX, //Full bootstrap.
  );
  return $items;
}

function drush_all_taxonomy_terms_show_all_terms() {
  //Get all vocabularies
  $vocabularies = taxonomy_get_vocabularies();
  $terms = array();
  
  //Dislpay vocabularies
  foreach($vocabularies as $v) {  
    //Get all terms for current vacabulary
    $terms = taxonomy_get_tree($v->vid);
    //Display id and name of terms
    foreach($terms as $t) {
      print 'Vocabulary: ' . $v->name . ' > ' . $t->name . ' - ' . $t->tid . "\n";
    }
    print "\n";
  }
}