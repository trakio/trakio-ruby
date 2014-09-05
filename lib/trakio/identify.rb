class Trakio
  class Identify < EndPoint

    def run p = {}
      properties = p[:properties] || {}
      distinct_id = p[:distinct_id] || self.distinct_id
      company_id = p[:company_id] || self.company_id
      check_parameters distinct_id, properties
      properties = process_companies company_id, properties

      params = {
        distinct_id: distinct_id,
        properties: properties
      }

      send_request 'identify', params
    end

    def process_companies company_id, properties

      # String company should be moved to company_name
      if properties[:company].is_a? String
        properties[:company_name] = properties.delete :company
      end

      # Company must be an array
      properties[:company] ||= []
      unless properties[:company].is_a?(Array)
        properties[:company] = [properties[:company]]
      end

      # Merge companies and company
      properties[:company] += properties.delete(:companies) || []

      check_companies properties[:company]

      # Inject current company
      if company_id && properties[:company].none?{ |x| x[:company_id] == company_id }
        properties[:company] << { company_id: company_id }
      end

      # Clean up company
      properties.delete(:company) if properties[:company].empty?

      properties
    end

    def check_parameters distinct_id, properties
      unless properties.is_a?(Hash)
        raise Trakio::Exceptions::InvalidParameter.new("The `properties` parameter must be a hash.")
      end
      unless distinct_id
        raise Trakio::Exceptions::MissingParameter.new('The `distinct_id` parameter must be provided.')
      end
    end

    def check_companies companies
      unless companies.all?{ |x| x.is_a?(Hash) } && companies.all?{ |x| x.include? :company_id }
        raise Trakio::Exceptions::InvalidProperty.new('The `companies` property must be an array of hashes each with a value for `company_id`')
      end
    end

  end
end
