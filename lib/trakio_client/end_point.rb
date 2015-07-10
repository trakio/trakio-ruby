module TrakioClient
  class EndPoint

    extend Forwardable

    attr_accessor :trakio
    def_delegator :@trakio, :api_token
    def_delegator :@trakio, :api_secret_key
    def_delegator :@trakio, :https
    def_delegator :@trakio, :host
    def_delegator :@trakio, :channel
    def_delegator :@trakio, :distinct_id
    def_delegator :@trakio, :company_id

    def initialize trakio
      self.trakio ||= trakio
    end

    protected

      def send_request endpoint, params, use_key=false
        protocol = https ? "https" : "http"
        url = "#{protocol}://#{host}/#{endpoint}"

        if use_key
          params_url = "?#{params.keys.first}=#{params.values.first}"
          resp = RestClient.get url + params_url, key: api_secret_key
        else
          data = { token: api_token, data: params }.to_json
          resp = RestClient.post url, data, :content_type => :json, :accept => :json
        end

        result = JSON.parse(resp.body, :symbolize_names => true)
        return result if result[:status] == 'success'

        # status must be error
        # here we will raise the required exception as in the API
        exception = constantize("TrakioClient::Exceptions::#{result[:exception]}") # name of the class
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


  end
end