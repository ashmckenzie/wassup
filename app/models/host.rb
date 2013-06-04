class Host
  include Mongoid::Document
  include Mongoid::Timestamps

  field :label, type: String
  field :hostname, type: String
  field :user, type: String
  field :keys, type: Array
  field :checks, type: Array

  has_many :results

  def results_newest_first
    results.order_by('created_at DESC')
  end

  def connection
    @connection ||= Gofer::Host.new(hostname, user, :keys => keys)
  end

  def run! command
    connection.run(command, quiet: true, quiet_stderr: true, capture_exit_status: true)
  end
end
