class Result
  attr_reader :success, :errors, :data, :message

  def initialize(success:, message: nil, errors: nil, data: nil)
    @success = success
    @message = message
    @errors = errors
    @data = data
  end

  def success?
    @success
  end

  def failure?
    !@success
  end
end
