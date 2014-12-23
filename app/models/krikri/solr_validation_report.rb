module Krikri
  # Configures data from a solr response for display
  # Subclass of Blacklight's SolrDocument model
  class SolrValidationReport < SolrDocument

    # override to_partial_path in SolrDocument, which returns 'catalog/document'
    def to_partial_path
      'validation_reports/document'
    end

  end
end
