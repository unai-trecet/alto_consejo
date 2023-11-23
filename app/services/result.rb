class Result
  attr_reader :success, :error, :data

  def initialize(success:, error: nil, data: nil)
    @success = success
    @error = error
    @data = data
  end

  def success?
    @success
  end

  def failure?
    !@success
  end
end
