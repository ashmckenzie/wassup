class Check

  def self.create options
    klass = options['klass']
    klass.constantize.new(options['initialize_with'])
  end
end
