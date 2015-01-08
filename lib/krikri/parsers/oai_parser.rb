module Krikri
  class OaiParser < Krikri::XmlParser
    attr_reader :header

    def initialize(record, root_path = '/', ns = {})
      ns = { oai: 'http://www.openarchives.org/OAI/2.0/' }.merge(ns)
      xml = Nokogiri::XML(record.to_s)
      @header = Value.new(xml.at_xpath('//oai:header', ns), ns)
      super
    end
  end
end
