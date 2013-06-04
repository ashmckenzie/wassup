NullGoferResponse = Naught.build do |config|
  config.mimic Gofer::Response

  def exit_status
    -1
  end
end
