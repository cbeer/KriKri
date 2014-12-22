module Krikri
  module ValidationReportHelper

    def report_list
      Krikri::ValidationReportList.new(blacklight_config).report_list
    end

  end
end
