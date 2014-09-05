class Trakio
  class Track < EndPoint

    def run p = {}
      event = p[:event]
      distinct_id = p[:distinct_id] || self.distinct_id
      company_id = p[:company_id] || self.company_id
      channel = p[:channel] || self.channel
      properties = p[:properties] || {}
      check_parameters event, distinct_id, company_id, properties

      params = {
        event: event
      }
      params[:time] = process_time p[:time]
      params[:channel] = channel if channel
      params[:properties] = properties if properties && !properties.empty?
      params[:company_id] = company_id if company_id
      params[:distinct_id] = distinct_id if distinct_id

      send_request('track', params)
    end

    def page_view p
      args = { event: 'Page view' }
      distinct_id = p[:distinct_id] || self.distinct_id
      url = p[:url]
      title = p[:title]
      check_page_view_parameters url

      properties = {
        url: url,
      }
      properties[:title] = title if title
      args[:properties] = properties
      args[:distinct_id] = distinct_id if distinct_id

      run args  # right now page_view is an alias of track
    end

    def process_time time
      if time
        if !time.is_a? String
          time.iso8601
        else
          time
        end
      else
        DateTime.now.iso8601
      end
    end

    def check_parameters event, distinct_id, company_id, properties
      unless event
        raise Trakio::Exceptions::MissingParameter.new("The `event` parameter must be provided.")
      end
      unless distinct_id || company_id
        raise Trakio::Exceptions::MissingParameter.new('Either a `company_id` or `distinct_id` parameter must be provided.')
      end
      unless properties.is_a?(Hash)
        raise Trakio::Exceptions::InvalidParameter.new("The `properties` parameter must be a hash.")
      end
    end

    def check_page_view_parameters url
      unless url
        raise Trakio::Exceptions::InvalidParameter.new("The `url` parameter must be provided.")
      end
    end

  end
end
