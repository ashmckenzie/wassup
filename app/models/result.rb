class Result
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_STATUS = 'PENDING'

  field :host_id, type: Integer
  field :status, type: String, default: DEFAULT_STATUS
  field :message, type: String
  field :check, type: Hash
  field :checked_on, type: String
  field :checked_at, type: DateTime
  field :response, type: Hash

  belongs_to :host

  def check
    Hashie::Mash.new(attributes['check'])
  end

  def response
    Hashie::Mash.new(attributes['response'])
  end
end
