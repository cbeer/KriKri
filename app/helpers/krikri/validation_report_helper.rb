module Krikri
  # Helper methods for Validation Reports
  module ValidationReportHelper

    def report_list
      Krikri::ValidationReportList.new(blacklight_config).report_list
    end

  end
end
