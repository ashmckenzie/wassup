class Result
  include Mongoid::Document
  include Mongoid::Timestamps

  field :host_id, type: Integer
  field :outcome, type: Hash

  belongs_to :host

  def outcome
    Hashie::Mash.new(attributes['outcome'])
  end
end
