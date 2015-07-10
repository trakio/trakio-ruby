module TrakioClient

  class Exceptions
    class Uninitiated < StandardError; end
    class NoDistinctIdForDefaultInstance < StandardError; end
    class NoCompanyIdForDefaultInstance < StandardError; end
    class DataObjectInvalidJson < StandardError; end
    class DataObjectInvalidBase64 < StandardError; end
    class DataObjectInvalidType < StandardError; end
    class InvalidToken < StandardError; end
    class InvalidKey < StandardError; end
    class MissingParameter < StandardError; end
    class InvalidParameter < StandardError; end
    class MissingProperty < StandardError; end
    class InvalidProperty < StandardError; end
    class RouteNotFound < StandardError; end
    class PropertiesObjectInvalid < StandardError; end
    class RequestInvalidJson < StandardError; end
    class RevenuePropertyInvalid < StandardError; end
    class TrialExpired < StandardError; end
    class InternalServiceError < StandardError; end
  end

end
