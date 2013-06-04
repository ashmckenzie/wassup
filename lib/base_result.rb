class BaseResult

  attr_accessor :status, :message

  def initialize check, result, message
    @check = check
    @result = result
    @message = message

    @status = 'NOTOK'   # default

    process!
  end

  def success?
    result.exit_status == 0
  end

  def warn?
    raise NotImplementedError
  end

  def error?
    raise NotImplementedError
  end

  protected

  attr_reader :check, :host, :result

  def process!
    raise NotImplementedError
  end

end
