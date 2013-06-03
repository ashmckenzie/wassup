require 'socket'
require 'timeout'

module Checks
  class Port < BaseCheck

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
            type: check.check_type,
            port_number: check.port_number,
            timeout_in_seconds: check.timeout_in_seconds
          },
          response: {
            output: result
          }
        }
      end

      def success?
        !error?
      end

      def warn?
        result[:status] == 'WARN'
      end

      def error?
        result[:status] == 'ERROR'
      end

      protected

      def process!
        if warn?
          @status = 'WARN'

        elsif error?
          @status = 'ERROR'

        elsif success?
          @status = 'OK'

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
      @result = Result.new(self) { command(host) }
    end

    protected

    def_delegators :@result

    private

    attr_writer :port_number, :timeout_in_seconds

    def command host
      result = {
        status: 'OK',
        message: "Connected to port #{port_number}"
      }

      begin
        timeout(timeout_in_seconds) do
          TCPSocket.new(host.hostname, port_number)
        end

      rescue Timeout::Error => e
        result = {
          status: 'WARN',
          message: e.inspect,
        }

      rescue => e
        result = {
          status: 'ERROR',
          message: e.inspect,
        }
      end

      return result
    end
  end
end
