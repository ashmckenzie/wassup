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
    check = BaseCheck.create(options)

    # Create it here so we can see it's PENDING
    #
    result = Result.create(host: host, checked_on: nodename)

    # Exception / timeout handling here
    check.check!(host)

    # TODO: why can I not #update ??
    result.status = check.result.status
    result.message = check.result.message
    result.outcome = check.result.for_json
    result.save!

    check
  end

  def nodename
    `uname -n`.chomp!
  end
end
