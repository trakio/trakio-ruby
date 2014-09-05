require "trakio/version"
require "rest_client"
require "json"
require "date"


class Trakio

  class Exceptions
    class Uninitiated < StandardError; end
    class NoDistinctIdForDefaultInstance < StandardError; end
    class NoCompanyIdForDefaultInstance < StandardError; end
    class DataObjectInvalidJson < StandardError; end
    class DataObjectInvalidBase64 < StandardError; end
    class DataObjectInvalidType < StandardError; end
    class InvalidToken < StandardError; end
    class MissingParameter < StandardError; end
    class InvalidParameter < StandardError; end
    class RouteNotFound < StandardError; end
    class PropertiesObjectInvalid < StandardError; end
    class RequestInvalidJson < StandardError; end
    class RevenuePropertyInvalid < StandardError; end
    class InternalServiceError < StandardError; end
  end

  class << self

    def init(*args)
      api_token, params = args
      raise Trakio::Exceptions::InvalidToken.new('Missing API Token') unless api_token
      raise Trakio::Exceptions::NoDistinctIdForDefaultInstance if params and params.has_key?(:distinct_id)
      raise Trakio::Exceptions::NoCompanyIdForDefaultInstance if params and params.has_key?(:company_id)
      @default_instance = Trakio.new(*args)
    end

    def default_instance
      raise Trakio::Exceptions::Uninitiated unless @default_instance
      @default_instance
    end

    def default_instance=(instance)
      @default_instance = instance
    end

    def distinct_id value=nil
      raise Trakio::Exceptions::NoDistinctIdForDefaultInstance
    end
    alias :distinct_id= :distinct_id

    def company_id value=nil
      raise Trakio::Exceptions::NoCompanyIdForDefaultInstance
    end
    alias :company_id= :company_id

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
  attr_accessor :company_id

  def initialize(*args)
    api_token, params = args
    api_token = Trakio.default_instance.api_token unless api_token

    @api_token = api_token or raise Trakio::Exceptions::InvalidToken.new('Missing API Token')
    @https = true
    @host = 'api.trak.io/v1'

    %w{https host channel distinct_id company_id}.each do |name|
      instance_variable_set("@#{name}", params[name.to_sym]) if params && params.has_key?(name.to_sym)
    end
  end

  def track parameters
    parameters.default = nil

    event = parameters[:event] || (raise Trakio::Exceptions::MissingParameter.new("event must be specified"))
    distinct_id = parameters[:distinct_id] || @distinct_id
    company_id = parameters[:company_id] || @company_id
    distinct_id || company_id || (raise Trakio::Exceptions::MissingParameter.new('One of company_id or distinct_id must be specified'))

    channel = parameters[:channel]
    channel = @channel unless channel

    properties = parameters[:properties]

    params = {
      event: event
    }

    if parameters[:time] # if specified
      params[:time] = parameters[:time]
      params[:time] = params[:time].iso8601 unless params[:time].is_a? String
    else # if nots specified default to now
      params[:time] = DateTime.now.iso8601
    end
    params[:channel] = channel if channel
    params[:properties] = properties if properties
    params[:company_id] = company_id if company_id
    params[:distinct_id] = distinct_id if distinct_id

    send_request('track', params)
  end

  def identify parameters
    parameters.default = nil

    properties = parameters[:properties]
    raise Trakio::Exceptions::MissingParameter.new("properties must be specified") unless properties and properties.length > 0
    distinct_id = parameters[:distinct_id] || @distinct_id || (raise Trakio::Exceptions::MissingParameter.new('distinct_id must be specified'))

    params = {
      distinct_id: distinct_id,
      properties: properties,
    }
    send_request 'identify', params
  end

  def company p
    p.default = nil

    properties = p[:properties]
    raise "Properties must be specified" unless properties and properties.length > 0
    raise Trakio::Exceptions::InvalidParameter.new('The `people_distinct_ids` parameter must be an array.') if p[:people_distinct_ids] && !p[:people_distinct_ids].is_a?(Array)
    company_id = p[:company_id] || @company_id || (raise Trakio::Exceptions::MissingParameter.new('company_id must be specified'))

    params = {
      company_id: company_id,
      properties: properties,
    }

    ids = p[:people_distinct_ids] || []
    (ids) << (p[:distinct_id] || distinct_id)
    ids.reject!(&:nil?)
    ids.map!(&:to_s)
    params[:people_distinct_ids] = ids unless ids.empty?

    send_request 'company', params

  end

  def alias parameters
    parameters.default = nil

    alias_ = parameters[:alias]
    raise Trakio::Exceptions::MissingParameter.new("alias must be specified") unless alias_
    raise "alias must be string or array" unless alias_.is_a?(String) or alias_.is_a?(Array)
    distinct_id = parameters[:distinct_id] || @distinct_id || (raise Trakio::Exceptions::MissingParameter.new('distinct_id must be specified'))

    params = {
      distinct_id: distinct_id,
      alias: alias_,
    }
    send_request('alias', params)
  end

  def annotate parameters
    parameters.default = nil

    event = parameters[:event]
    raise "No event specified" unless event

    properties = parameters[:properties]
    properties = {} unless properties

    channel = parameters[:channel]
    channel = @channel unless channel

    params = {
      event: event
    }
    params[:channel] = channel if channel
    params[:properties] = properties if properties
    send_request('annotate', params)
  end

  def page_view parameters
    parameters.default = nil
    args = {
      event: 'Page view'
    }

    distinct_id = distinct_id_from_parameters(parameters)
    args[:distinct_id] = distinct_id if distinct_id

    raise "Must specify URL" unless parameters.has_key?(:url)
    raise "Must specify Title" unless parameters.has_key?(:title)

    properties = {
      url: parameters[:url],
      title: parameters[:title],
    }
    args[:properties] = properties

    track args  # right now page_view is an alias of track
  end

  protected

  def send_request endpoint, params
    protocol = @https ? "https" : "http"
    url = "#{protocol}://#{@host}/#{endpoint}"
    data = { token: @api_token, data: params }.to_json
    resp = RestClient.post url, data, :content_type => :json, :accept => :json
    result = JSON.parse(resp.body, :symbolize_names => true)
    return result if result[:status] == 'success'

    # status must be error
    # here we will raise the required exception as in the API
    exception = constantize(result[:exception].sub! 'TrakioAPI::', 'Trakio::') # name of the class
    message = result[:message] # extra information for the exception
    raise exception.new(message)
  end

  def constantize camel_cased_word # Taken from ActiveSupport
    names = camel_cased_word.split('::')

    # Trigger a builtin NameError exception including the ill-formed constant in the message.
    Object.const_get(camel_cased_word) if names.empty?

    # Remove the first blank element in case of '::ClassName' notation.
    names.shift if names.size > 1 && names.first.empty?

    names.inject(Object) do |constant, name|
      if constant == Object
        constant.const_get(name)
      else
        candidate = constant.const_get(name)
        next candidate if constant.const_defined?(name, false)
        next candidate unless Object.const_defined?(name)

        # Go down the ancestors to check it it's owned
        # directly before we reach Object or the end of ancestors.
        constant = constant.ancestors.inject do |const, ancestor|
          break const    if ancestor == Object
          break ancestor if ancestor.const_defined?(name, false)
          const
        end

        # owner is in Object, so raise
        constant.const_get(name, false)
      end
    end
  end

  ['distinct','company'].each do |x|
    define_method :"#{x}_id_from_parameters" do |parameters|
      id = parameters[:"#{x}_id"]
      id = self.instance_variable_get("@#{x}_id") unless id
      id
    end
  end

end
