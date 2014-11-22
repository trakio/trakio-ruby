require "trakio_client/end_point"
require "trakio_client/alias"
require "trakio_client/annotate"
require "trakio_client/company"
require "trakio_client/exceptions"
require "trakio_client/identify"
require "trakio_client/track"
require "trakio_client/version"
require "rest_client"
require "json"
require "date"


module TrakioClient

  def self.included base
    base.extend ClassMethods
    base.send :attr_accessor, :api_token
    base.send :attr_accessor, :https
    base.send :attr_accessor, :host
    base.send :attr_accessor, :channel
    base.send :attr_accessor, :distinct_id
    base.send :attr_accessor, :company_id
  end

  module ClassMethods

    def init(*args)
      api_token, params = args
      raise Exceptions::InvalidToken.new('Missing API Token') unless api_token
      raise Exceptions::NoDistinctIdForDefaultInstance if params and params.has_key?(:distinct_id)
      raise Exceptions::NoCompanyIdForDefaultInstance if params and params.has_key?(:company_id)
      @default_instance = self.new(*args)
    end

    def default_instance
      raise Exceptions::Uninitiated unless @default_instance
      @default_instance
    end

    def default_instance=(instance)
      @default_instance = instance
    end

    def distinct_id value=nil
      raise Exceptions::NoDistinctIdForDefaultInstance
    end
    alias :distinct_id= :distinct_id

    def company_id value=nil
      raise Exceptions::NoCompanyIdForDefaultInstance
    end
    alias :company_id= :company_id

    def method_missing(method, *args, &block)
      # passes to the default_instance so that
      # Trakio.channel returns Trakio.default_instance.channel
      self.default_instance.send(method, *args, &block)
    end

  end

  def initialize(*args)
    api_token, params = args
    api_token = self.class.default_instance.api_token unless api_token

    @api_token = api_token or raise Exceptions::InvalidToken.new('Missing API Token')
    @https = true
    @host = 'api.trak.io/v1'

    %w{https host channel distinct_id company_id}.each do |name|
      instance_variable_set("@#{name}", params[name.to_sym]) if params && params.has_key?(name.to_sym)
    end
  end

  ['Alias', 'Annotate', 'Company', 'Identify', 'Track'].each do |method_object|
    TrakioClient.module_eval "
      def #{method_object.downcase} *args
        @#{method_object.downcase} ||= TrakioClient::#{method_object}.new(self)
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
