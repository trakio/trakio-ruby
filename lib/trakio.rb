require "trakio/version"

class Trakio

  class Exceptions
    class UnInitiated < RuntimeError; end
    class MissingApiToken < RuntimeError; end
    class NoDistinctIdForDefaultInstance < RuntimeError; end
  end

  class << self

    def init(*args)
      api_token, params = args
      raise Trakio::Exceptions::MissingApiToken unless api_token
      if params and params.has_key?(:distinct_id)
        raise Trakio::Exceptions::NoDistinctIdForDefaultInstance
      end
      @default_instance = Trakio.new(*args)
    end

    def default_instance
      if @default_instance
        @default_instance
      else
        raise Trakio::Exceptions::UnInitiated
      end
    end

    def default_instance=(instance)
      @default_instance = instance
    end

    def distinct_id
      raise Trakio::Exceptions::NoDistinctIdForDefaultInstance
    end

    def method_missing(method, *args, &block)
      # passes to the default_instance so that
      # Trakio.channel returns Trakio.default_instance.channel
      @default_instance.send(method, *args, &block)
    end

  end

  attr_accessor :api_token

  # the following are set via params
  attr_accessor :https
  attr_accessor :host
  attr_accessor :channel
  attr_accessor :distinct_id

  def initialize(*args)
    api_token, params = args
    api_token = Trakio.default_instance.api_token unless api_token

    @api_token = api_token
    @https = true
    @host = 'api.trak.io/v1'

    %w{https host channel distinct_id}.each do |name|
      if params && params.has_key?(:"#{name}")
        instance_variable_set("@#{name}", params[:"#{name}"])
      end
    end
  end

end
