require "trakio/end_point"
require "trakio/alias"
require "trakio/annotate"
require "trakio/company"
require "trakio/exceptions"
require "trakio/identify"
require "trakio/track"
require "trakio/version"
require "rest_client"
require "json"
require "date"


class Trakio

  attr_accessor :api_token
  attr_accessor :https
  attr_accessor :host
  attr_accessor :channel
  attr_accessor :distinct_id
  attr_accessor :company_id

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

  ['Alias', 'Annotate', 'Company', 'Identify', 'Track'].each do |method_object|
    Trakio.class_eval "
      def #{method_object.downcase} *args
        @#{method_object.downcase} ||= #{method_object}.new(self)
        @#{method_object.downcase}.run(*args)
      end
    "
  end

  def page_view *args
    @track ||= Track.new(self)
    @track.page_view(*args)
  end

  protected

    ['distinct','company'].each do |x|
      define_method :"#{x}_id_from_parameters" do |parameters|
        id = parameters[:"#{x}_id"]
        id = self.instance_variable_get("@#{x}_id") unless id
        id
      end
    end

end
