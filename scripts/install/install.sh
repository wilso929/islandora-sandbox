#!/bin/bash

# site paths
site_path=/var/www/drupal
drush="$site_path"/vendor/drush/drush/drush

# configure search_api_solr_module
solr_host=dsu-fedora.utsc.utoronto.ca
solr_core=multisite
cantaloupe_url=https://memory.digital.utsc.utoronto.ca/iiif-server/iiif/2

# configure blazegraph
blazegraph_url=http://dsu.utsc.utoronto.ca:8080/bigdata
blazegraph_namespace=collection3-D9

# configure fits
fits_mode="local"
fits_url=/opt/fits-1.4.1/fits.sh
fits_config_var="fits-path"

# configure Solr
"$drush" -y config-set search_api.server.default_solr_server backend_config.connector_config.scheme https
"$drush" -y config-set search_api.server.default_solr_server backend_config.connector_config.host ${solr_host}
"$drush" -y config-set search_api.server.default_solr_server backend_config.connector_config.core ${solr_core}

# set correct URL for advanced queue runner
"$drush" -y config-set --input-format=yaml advancedqueue_runner.settings drush_path "${site_path}"/vendor/drush/drush/drush
"$drush" -y config-set --input-format=yaml advancedqueue_runner.settings root_path "${site_path}"

# set correct endpont and namespace for blazegraph
"$drush" -y config-set --input-format=yaml triplestore_indexer.settings server_url "${blazegraph_url}"
"$drush" -y config-set --input-format=yaml triplestore_indexer.settings namespace "${blazegraph_namespace}"

# set corret endpoint for openseadraon and iiif_settings
"$drush" -y config:set openseadragon.settings iiif_server "${cantaloupe_url}"
"$drush" -y config:set islandora_iiif.settings iiif_server "${cantaloupe_url}"
"$drush" -y config:set islandora_mirador.settings iiif_manifest_url "${cantaloupe_url}"

# set correct settings for fits 
"$drush" -y config-set --input-format=yaml fits.fitsconfig fits-method "${fits_mode}"
"$drush" -y config-set --input-format=yaml fits.fitsconfig "${fits_config_var}" "${fits_url}"
