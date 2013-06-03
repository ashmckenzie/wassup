require 'kiqstand'

class CheckerWorker

  include Sidekiq::Worker

  sidekiq_options queue: 'high'
  sidekiq_options retry: false

  def perform host_id, checks
    host = Host.find(host_id['$oid'])

    checks.each do |opts|
      check = check!(host, opts)
      Rails.logger.info ">> #{host.hostname}: #{check.check_type} - #{check.result.for_json}"
    end
  end

  private

  def check! host, options
    result = Result.create(host: host, checked_on: nodename)

    check = check_from_options(options)

    # Exception / timeout handling here
    check.check!(host)

    result.outcome = check.result_as_json
    result.save!

    check
  end

  def check_from_options options
    BaseCheck.create(options)
  end

  def nodename
    `uname -n`.chomp!
  end
end
