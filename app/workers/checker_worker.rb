require 'kiqstand'

class CheckerWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'high'
  sidekiq_options retry: false

  def perform host_id, checks
    host = Host.find(host_id['$oid'])

    checks.each do |check_options|
      check = Check.create(check_options)
      check.check!(host)
      host.results << Result.new(outcome: check.result.for_json)
      Rails.logger.info ">> #{host.hostname}: #{check.check_type} - #{check.result.for_json}"
    end
  end
end
