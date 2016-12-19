module Errors
  class Error < StandardError
    attr_reader :extra

    def initialize(extra = {})
      @extra = extra
    end
  end

  # Add custom errors here:
  # CustomError = Class.new Error
  TooManyVideosError = Class.new Error
  NoVideosGivenError = Class.new Error
  InvalidVideoUrlError = Class.new Error
  AuthenticationError = Class.new Error
  AuthorizationError = Class.new Error
  UnapprovedUserError = Class.new Error
end
