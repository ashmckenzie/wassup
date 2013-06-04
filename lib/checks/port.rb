require 'socket'
require 'timeout'
require 'ostruct'

module Checks
  class Port < BaseCheck

    class Result < BaseResult

      attr_reader :output

      def initialize check, result, message
        @output = nil

        super
      end

      def for_json
        {
          check: {
            type: check.check_type,
            port_number: check.port_number,
            timeout_in_seconds: check.timeout_in_seconds
          }
        }
      end

      def success?
        !error?
      end

      def warn?
        result.exit_status == 1
      end

      def error?
        result.exit_status == 2
      end

      protected

      def process!
        if success?
          @status = 'OK'

        elsif warn?
          @status = 'WARN'

        elsif error?
          @status = 'ERROR'

        else
          # NOTOK
        end
      end
    end

    # -------------------------------------------------------------------- #

    # reload! ; host = Host.first ; check = Checks::Port.new(port_number: 80) ; check.check!(host)

    attr_reader :port_number, :timeout_in_seconds

    def initialize eattributes={}
      @timeout_in_seconds = 3
      super
    end

    def check_type
      'port'
    end

    def check! host
      outcome = command(host)
      @result = Result.new(self, outcome, outcome.message)
    end

    protected

    def_delegators :@result

    private

    attr_writer :port_number, :timeout_in_seconds

    def command host
      result = OpenStruct.new(
        exit_status: 0,  # OK
        message: "Connected to port #{port_number}"
      )

      begin
        timeout(timeout_in_seconds) do
          TCPSocket.new(host.hostname, port_number)
        end

      rescue Timeout::Error => e
        result.exit_status = 1  # WARN
        result.message = e.inspect

      rescue => e
        result.exit_status = 2  # ERROR
        result.message = e.inspect
      end

      result
    end
  end
end
