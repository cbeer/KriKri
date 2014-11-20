module Krikri
  # Marshalls ValidationReports for views
  class ValidationReportsController < ApplicationController

    def index
      @report_list = ValidationReport.all
    end

    def show
      @docs = ValidationReport.find(params[:id])
    end

  end
end
