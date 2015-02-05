module Krikri
  module OaiParserHeaders
    extend ActiveSupport::Concern

    def header
      header_node = Nokogiri::XML(record.to_s).at_xpath('//xmlns:header')
      self.class::Value.new(header_node, root.namespaces)
    end
  end
end
