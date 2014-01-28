require "trakio/version"

class Trakio

  class Exceptions
    class UnInitiated < RuntimeError; end
  end

  class << self

    def init(*args)
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
