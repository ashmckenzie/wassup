module Checks
  class Process < BaseCheck

    class Result < BaseResult

      attr_reader :output

      def initialize check, &blk
        @output = nil

        super(check, blk)
      end

      def for_json
        {
          status: status,
          check: {
            minimum: check.minimum,
            maximum: check.maximum
          },
          response: {
            output: result,
            count: count
          }
        }
      end

      def warn?
        false
      end

      def error?
        (check.minimum > 0 && count < check.minimum) || (check.maximum > 0 && count > check.maximum)
      end

      protected

      def process!
        if error?
          @status = 'ERROR'

        elsif success?
          @status = 'OK'

        else
          # NOTOK
        end
      end

      private

      def count
        @count ||= result.split(/\n/).count
      end
    end

    # -------------------------------------------------------------------- #

    # reload! ; host = Host.first ; check = Checks::Process.new(string: 'redis', minimum: 1) ; check.check!(host)

    attr_reader :string, :minimum, :maximum

    def initialize eattributes={}
      @minimum = 1
      @maximum = 0
      super
    end

    def check_type
      'process'
    end

    def check! host
      @result = Result.new(self) { host.run!(command) }
    end

    protected

    def_delegators :@result

    private

    attr_writer :string, :minimum, :maximum

    def command
      special_string = "[#{string[0]}]#{string[1..-1]}"
      sprintf("ps aux | grep '%s'", special_string)
    end
  end
end
