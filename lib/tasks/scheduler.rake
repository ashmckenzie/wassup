namespace :scheduler do

  desc 'Start the scheduler'
  task :start => :environment do
    scheduler = Rufus::Scheduler.start_new

    # NEED another scheduler here to do the 'monitoring'

    scheduler.every '1m', first_in: 0 do

      # Checks::Disk.new('/', warn_level: 85, error_level: 95).check!(Host.first)
      # d = Checks::Disk.new('/', warn_level: 70, error_level: 95)

      checks = [
        {
          klass: 'Checks::Disk',
          initialize_with: {
            disk: '/',
            warn_level: 70,
            error_level: 95
          }
        }
      ]

      hosts = Host.all
      # hosts = [ Host.all[1] ]

      hosts.each do |host|
        message = "Kicking of checks for #{host.label} (#{host.hostname})"
        $stderr.puts message
        Rails.logger.info message
        CheckerWorker.perform_async(host.id, checks)
      end

    end

    scheduler.join
  end
end
