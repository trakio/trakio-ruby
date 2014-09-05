class Trakio
  class Alias < EndPoint

    def run p = {}
      alias_ = p[:alias]
      distinct_id = p[:distinct_id] || self.distinct_id
      check_parameters alias_, distinct_id

      params = {
        distinct_id: distinct_id,
        alias: alias_,
      }
      
      send_request('alias', params)
    end

    def check_parameters alias_, distinct_id
      unless distinct_id
        raise Trakio::Exceptions::MissingParameter.new('The `distinct_id` parameter must be provided.')
      end
      unless alias_
        raise Trakio::Exceptions::MissingParameter.new('The `alias` parameter must be provided.')
      end
      unless alias_.is_a?(String) or alias_.is_a?(Array)
        raise Trakio::Exceptions::InvalidParameter.new('The `alias` parameter must be a string or an array.')
      end
    end

  end
end
