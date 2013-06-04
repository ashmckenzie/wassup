class Result
  include Mongoid::Document
  include Mongoid::Timestamps

  field :host_id, type: Integer
  field :checked_on, type: String
  field :outcome, type: Hash

  belongs_to :host

  DEFAULT_STATUS = 'PENDING'

  def outcome
    Hashie::Mash.new(attributes['outcome'])
  end

  def response
    outcome.response
  end

  def status
    outcome.fetch('status', DEFAULT_STATUS)
  end

  def to_s
    response
  end
end
