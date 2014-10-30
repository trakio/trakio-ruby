module TrakioClient
  class Annotate < EndPoint

    def run p = {}
      event = p[:event]
      properties = p[:properties] || {}
      channel = p[:channel] || self.channel
      check_parameters event, properties

      params = {
        event: event
      }
      params[:channel] = channel if channel
      params[:properties] = properties if properties

      send_request('annotate', params)
    end

    def check_parameters event, properties
      unless event
        raise Exceptions::MissingParameter.new("The `event` parameter must be provided.")
      end
      unless properties.is_a?(Hash)
        raise Exceptions::InvalidParameter.new("The `properties` parameter must be a hash.")
      end
    end

  end
end
