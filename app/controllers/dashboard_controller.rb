class DashboardController < ApplicationController

  def index
    @hosts = Host.all
    # @results = Result.order_by('created_at DESC')
  end
end
