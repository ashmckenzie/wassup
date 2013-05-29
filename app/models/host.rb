class Host
  include Mongoid::Document

  field :label, type: String
  field :hostname, type: String
  field :user, type: String
  field :keys, type: Array

  has_many :results

  def connection
    @connection ||= Gofer::Host.new(hostname, user, :keys => keys)
  end

  def run! command
    begin
      connection.run(command, quiet: true, quiet_stderr: true, capture_exit_status: true)
    rescue => e
      Rails.logger.error "Exception raised - #{e.inspect}"
    end
  end

end
