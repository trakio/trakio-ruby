module TrakioClient
  class Score < EndPoint

    def run p = {}
      distinct_id = p[:distinct_id]
      company_id = p[:company_id]
      check_parameters distinct_id, company_id

      params = {}
      params[:distinct_id] = distinct_id unless distinct_id.nil?
      params[:company_id] = company_id unless company_id.nil?
      send_request('score', params, true)
    end

    def check_parameters distinct_id, company_id
      if distinct_id.nil? && company_id.nil?
        raise Exceptions::MissingParameter.new("Either a `company_id` or `distinct_id` parameter must be provided.")
      end
      if distinct_id && company_id
        raise Exceptions::InvalidParameter.new("Either a 'distinct_id' or 'company_id' parameter must be provided but not both")
      end
    end

  end
end