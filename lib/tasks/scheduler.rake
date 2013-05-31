namespace :scheduler do

  desc 'Start the scheduler'
  task :start => :environment do
    scheduler = Rufus::Scheduler.start_new

    # NEED another scheduler here to do the 'monitoring'

    scheduler.every '1m', first_in: 0 do

      hosts = Host.all

      hosts.each do |host|
        message = "Kicking of checks for #{host.label} (#{host.hostname})"
        $stderr.puts message
        Rails.logger.info message
        CheckerWorker.perform_async(host.id, host.checks)
      end

    end

    scheduler.join
  end
end
