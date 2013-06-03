module Checks
  class Disk < BaseCheck

    class Result < BaseResult

      attr_reader :total, :used, :available

      def initialize check, &blk
        @total = -1
        @used = -1
        @available = -1

        super(check, blk)
      end

      def for_json
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

      def warn?
        percent_free <= 0 || percent_used >= check.warn_level
      end

      def error?
        percent_free <= 0 || percent_used >= check.error_level
      end

      protected

      def process!
        if success?
          x, @total, @used, @available = result.stdout.split(/\n/)[1].split(/\s+/)

          @total = total.to_i
          @used = used.to_i
          @available = available.to_i

          @status = 'OK'

        elsif error?
          @status = 'ERROR'

        elsif warn?
          @status = 'WARN'

        else
          # NOTOK
        end
      end

      private

      def percent_free
        total > 0 ? ((available.to_f / total.to_f) * 100).round(3) : -1
      end

      def percent_used
        total > 0 ? ((used.to_f / total.to_f) * 100).round(3) : -1
      end
    end

    # -------------------------------------------------------------------- #

    attr_reader :disk, :result, :warn_level, :error_level

    def initialize eattributes={}
      @warn_level = 80
      @error_level = 90
      super
    end

    def check_type
      'disk'
    end

    def check! host
      @result = Result.new(self) { host.run!(command) }
    end

    protected

    def_delegators :@result, :total, :available, :used

    private

    attr_writer :disk, :warn_level, :error_level

    def command
      sprintf('df %s', disk)
    end
  end
end
