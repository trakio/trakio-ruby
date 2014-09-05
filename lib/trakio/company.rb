class Trakio
  class Company < EndPoint

    def run p = {}
      properties = p[:properties] || {}
      company_id = p[:company_id] || self.company_id
      check_parameters company_id, properties, (p[:people_distinct_ids] || [])

      params = {
        company_id: company_id,
        properties: properties,
      }
      distinct_ids = distinct_ids_from_params p
      params[:people_distinct_ids] = distinct_ids unless distinct_ids.empty?

      send_request 'company', params
    end

    def distinct_ids_from_params p
      ids = p[:people_distinct_ids] || []
      distinct_id = p[:distinct_id] || self.distinct_id
      ids << distinct_id if distinct_id
      ids.reject!(&:nil?)
      ids.map!(&:to_s)
      ids
    end

    def check_parameters company_id, properties, distinct_ids
      if !company_id
        raise Trakio::Exceptions::MissingParameter.new('The `company_id` parameter must be provided.')
      end
      if !properties.is_a?(Hash)
        raise Trakio::Exceptions::InvalidParameter.new("The `properties` parameter must be a hash.")
      end
      if !distinct_ids.is_a?(Array)
        raise Trakio::Exceptions::InvalidParameter.new('The `people_distinct_ids` parameter must be an array.')
      end
    end

  end
end
