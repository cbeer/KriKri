# -*- encoding : utf-8 -*-
#
require 'blacklight/controller'
require 'blacklight/catalog'

module Krikri
  # Marshals SolrValidationReports for views
  # Sets default Solr request params for Validation Reports
  class ValidationReportsController < ApplicationController
    include Blacklight::Controller
    include Blacklight::Catalog
    helper Blacklight::UrlHelperBehavior
    helper Blacklight::CatalogHelperBehavior
    helper Blacklight::BlacklightHelperBehavior

    layout 'krikri/blacklight'

    configure_blacklight do |config|

      # Default parameters to send to solr for all search-like requests.
      config.default_solr_params = {
        :qt => 'standard',
        :rows => 10
      }

      # solr field configuration for search results/index views
      config.index.title_field = 'sourceResource_title'

      # solr fields to be displayed in the index (search results) view
      #   The ordering of the field names is the order of the display
      config.add_index_field 'id', :label => 'ID'
      config.add_index_field 'isShownAt_id', :label => 'Is Shown At'
      config.add_index_field 'sourceResource_type_id', :label => 'Type'
      config.add_index_field 'sourceResource_format', :label => 'Format'
      config.add_index_field 'sourceResource_rights', :label => 'Rights'
      config.add_index_field 'dataProvider_name', :label => 'Data Provider'
      config.add_index_field 'preview_id', :label => 'Preview URL'

      config.index.thumbnail_field = :preview_id

      # Set solr_document_model to SolrValidation Report instead of the default,
      # which is SolrDocument.
      config.solr_document_model = SolrValidationReport

    end

    # Override Blacklight::UrlHelperBehavior
    # TODO: Investigate possibility of setting config.show.route instead
    Blacklight::UrlHelperBehavior.class_eval do
      # Create a link to a document's catalog show view.
      # The link does not include session tracking params.
      def link_to_document(doc, field_or_opts = nil, opts = { :counter => nil })
        if field_or_opts.kind_of? Hash
          opts = field_or_opts
          if opts[:label]
            Deprecation.warn self, 'The second argument to link_to_document' /
              ' should now be the label.'
            field = opts.delete(:label)
          end
        else
          field = field_or_opts
        end

        field ||= document_show_link_field(doc)
        label = presenter(doc).render_document_index_label field, opts
        # The following line differs from the original method.
        link_to label, '/catalog/' + doc.id
      end
    end
  end
end
