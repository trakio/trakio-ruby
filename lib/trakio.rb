require "trakio/version"

class Trakio

  attr_accessor :default_instance

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
