class BaseResult

  def initialize check, blk
    @status = 'NOTOK'   # default

    @check = check
    @result = yield(blk)

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
  attr_accessor :status

  def process!
    raise NotImplementedError
  end

end
