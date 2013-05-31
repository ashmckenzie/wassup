require 'forwardable'
require 'awesome_print'

class BaseCheck

  extend Forwardable

  attr_reader :result

  def initialize attributes={}
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def self.create options
    klass = "Checks::#{options['type'].camelize}"
    klass.constantize.new(options['config'])
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
