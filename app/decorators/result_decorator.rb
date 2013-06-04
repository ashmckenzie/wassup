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

  # https://www.google.com/calendar/event?action=VIEW&eid=XzZoMTQyYzIxNmdyazRiOWc3NTBqYWI5azZnczQyYjlwNzUzM2liYTQ3NHFrNmM5ZzZvcDMwZDI1NjQgYXNoQGFzaG1ja2VuemllLm9yZw&tok=MjYjYWxpc29ubWNrZW56aWU3OUBnbWFpbC5jb202MGJjMTE4NjRiNjRmYjc0ZmMxMWZkMzY4YzUxY2IwZjc2ZjdhY2Jj&ctz=Australia/Sydney&hl=en&response_updated=1
end
