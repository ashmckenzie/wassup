class Result
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_STATUS = 'PENDING'

  field :host_id, type: Integer
  field :status, type: String, default: DEFAULT_STATUS
  field :message, type: String
  field :checked_on, type: String
  field :outcome, type: Hash

  belongs_to :host

  def outcome
    Hashie::Mash.new(attributes['outcome'])
  end

  def response
    outcome.response
  end

  def to_s
    outcome
  end
end
