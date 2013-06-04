class DashboardController < ApplicationController

  def index
    @hosts = Host.all
  end
end
