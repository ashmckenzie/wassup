require 'forwardable'

class BaseCheck

  extend Forwardable

  attr_reader :result

  def initialize attributes={}
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def self.create options
    klass = options['klass']
    klass.constantize.new(options['initialize_with'])
  end

  def result_as_json
    result.for_json
  end

  protected

  attr_writer :result

  def_delegators :@result, :success?, :warn?, :error?

  def check_type
    raise NotImplementedError
  end

end
