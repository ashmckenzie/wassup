class ResultDecorator < Draper::Decorator
  delegate_all

  def css_class
    'test'
  end

  def check_type
    check.type
  end

  def check_detail
    check.each.reject { |k, v| k == 'type' }.map do |k, v|
      "#{k}: #{v}"
    end.join(', ')
  end

  def response_detail
    response.map do |k, v|
      "#{k}: #{v}"
    end.join(', ')
  end

  def created_at
    better_time(object)
  end

  def checked_at
    better_time(object)
  end

  private

  def better_time object
    object.created_at.strftime("%d/%m/%y %H:%M:%S")
  end
end
