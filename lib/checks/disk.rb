require 'forwardable'

module Checks
  class Disk

    extend Forwardable

    class Result

      attr_reader :total, :used, :available

      def initialize check
        @check = check
        @result = yield

        @total = 0
        @used = 0
        @available = 0

        @status = 'NOTOK'
      end

      def for_json
        if success?

          splut = result.stdout.split(/\n/)[1].split(/\s+/)

          @total = splut[1].to_i
          @used = splut[2].to_i
          @available = splut[3].to_i

          if error?
            @status = 'ERROR'
          elsif warn?
            @status = 'WARN'
          else
            @status = 'OK'
          end
        end

        output
      end

      def success?
        result.exit_status == 0
      end

      def warn?
        percent_free <= 0 || percent_used >= check.warn_level
      end

      def error?
        percent_free <= 0 || percent_used >= check.error_level
      end

      def percent_free
        total > 0 ? ((available.to_f / total.to_f) * 100).round(3) : 0
      end

      def percent_used
        total > 0 ? ((used.to_f / total.to_f) * 100).round(3) : 0
      end

      private

      attr_reader :check, :host, :result
      attr_accessor :status

      def output
        {
          status: status,
          check: {
            warn_level: check.warn_level,
            error_level: check.error_level
          },
          response: {
            total: total,
            used: used,
            available: available,
            percent_free: percent_free,
            percent_used: percent_used
          }
        }
      end
    end

    # ---------------------------------------------------------------------- #

    attr_reader :disk, :result, :warn_level, :error_level, :result

    def initialize attributes={}
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    # def initialize disk, warn_level: 80, error_level: 90
    #   @disk = disk
    #   @warn_level = warn_level.to_f
    #   @error_level = error_level.to_f
    # end

    def check! host
      @result = Result.new(self) { host.run!(command) }
    end

    def check_type
      'disk'
    end

    private

    attr_writer :disk, :result, :warn_level, :error_level

    def_delegators :@result, :total, :available, :used

    def command
      sprintf('df %s', disk)
    end
  end
end
