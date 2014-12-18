require 'rails'
require "krikri/engine"
require 'blacklight'

module Krikri
  # autoload libraries
  autoload :IndexService,       'krikri/index_service'
  autoload :ValidationReport,   'krikri/validation_report'
end
