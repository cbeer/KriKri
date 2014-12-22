module Krikri
  module ValidationReportHelper

    def report_list
      Krikri::ValidationReportList.new(blacklight_config).report_list
    end

    # # Generate a link for a single report from report_list
    # # @param Hash
    # def display_link(report)

    #   if report[:link_url]
    #     return link_to report[:label] report[:link_url]
    #   end

    #   return report[:label]
    # end

  end
end
