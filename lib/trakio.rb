require "trakio/version"
require "rest_client"

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

    def distinct_id=(distinct_id)
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
  attr_accessor :channel # channel is some form of category
  attr_accessor :distinct_id

  def initialize(*args)
    api_token, params = args
    api_token = Trakio.default_instance.api_token unless api_token

    @api_token = api_token or raise Trakio::Exceptions::MissingApiToken
    @https = true
    @host = 'api.trak.io/v1'

    %w{https host channel distinct_id}.each do |name|
      if params && params.has_key?(name.to_sym)
        instance_variable_set("@#{name}", params[name.to_sym])
      end
    end
  end

  def track(parameters)
    distinct_id = parameters[:distinct_id] or @distinct_id
    event = parameters[:event] or raise "No event specified"
    channel = parameters[:channel] or @channel
    properties = parameters[:properties] or {}
    params = {
      distinct_id: distinct_id,
      event: event,
      properties: properties
    }
    params[:channel] = channel if channel

    send_request('track', params)
  end

  def identify
  end

  def alias
  end

  def annotate
  end

  def page_view
  end

  def send_request(endpoint, params)
    url = "https://#{@host}/#{endpoint}"
    data = { token: @api_token, data: params }.to_json
    RestClient.post url, data, :content_type => :json, :accept => :json
  end

end
