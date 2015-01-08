module Krikri
  ##
  # A MODS parser. Uses XML parser with a root path to match the
  # metadata path. Defaults to the MODS namespace being the default namespace.
  # @see Krikri::XmlParser
  class ModsParser < XmlParser
    def initialize(record, root_path = '//mods:mods', ns = {})
      ns = { mods: 'http://www.loc.gov/mods/v3' }.merge(ns)
      super(record, root_path, ns)
    end
  end
end
