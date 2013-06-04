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

  def check! host
    begin
      message = nil
      run_response = host.run!(command)
    rescue => e
      message = e.inspect
      run_response = NullGoferResponse.new
    end

    @result = result_klass.new(self, run_response, message)
  end

  protected

  attr_writer :result

  def_delegators :@result, :success?, :warn?, :error?

  def check_type
    raise NotImplementedError
  end

  def result_klass
    "#{self.class}::Result".constantize
  end
end
