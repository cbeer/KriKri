# -*- encoding : utf-8 -*-
#
require 'blacklight/catalog'

module Krikri
  class ValidationReportsController < ApplicationController

    include Blacklight::Catalog
    helper Blacklight::CatalogHelper
    #include Krikri::ValidationReport

    configure_blacklight do |config|
      ##
      # Default parameters to send to solr for all search-like requests.
      # See also SolrHelper#solr_search_params.
      config.default_solr_params = {
        :qt => 'standard',
        :rows => 10,
        :q => "+id:[* TO *]-preview_id:[* TO *]"
      }

      # solr field configuration for search results/index views
      config.index.title_field = 'sourceResource_title'

      # solr fields to be displayed in the index (search results) view
      #   The ordering of the field names is the order of the display
      config.add_index_field 'id', :label => 'ID'
      config.add_index_field 'sourceResource_description', :label => 'Description'
      config.add_index_field 'sourceResource_date_providedLabel', :label => 'Date'
      config.add_index_field 'sourceResource_type_id', :label => 'Type'
      config.add_index_field 'sourceResource_format', :label => 'Format'
      config.add_index_field 'sourceResource_rights', :label => 'Rights'
      config.add_index_field 'dataProvider_name', :label => 'Data Provider'

      config.index.thumbnail_field = :preview_id

      # TODO: Decide whether we want the show (single result) view metadata
      # to come from the search index or from marmotta
      #
      # solr fields to be displayed in the show (single result) view
      #   The ordering of the field names is the order of the display
      config.add_show_field 'sourceResource_title', :label => 'Title'
      config.add_show_field 'sourceResource_description', :label => 'Description'
      config.add_show_field 'sourceResource_date_providedLabel', :label => 'Date'
      config.add_show_field 'sourceResource_type_id', :label => 'Type'
      config.add_show_field 'sourceResource_format', :label => 'Format'
      config.add_show_field 'sourceResource_rights', :label => 'Rights'
      config.add_show_field 'dataProvider_name', :label => 'Data Provider'
      config.add_show_field 'sourceResource_creator_name', :label => 'Creator'
      config.add_show_field 'sourceResource_spatial_name', :label => 'Place'
      config.add_show_field 'sourceResource_subject_name', :label => 'Subject'
      config.add_show_field('sourceResource_collection_title',
                            :label => 'Collection')

      ##
      # Set solr_document_model to SolrValidation Report instead of the default,
      # which is SolrDocument.
      config.solr_document_model = SolrValidationReport

    end
  end
end
