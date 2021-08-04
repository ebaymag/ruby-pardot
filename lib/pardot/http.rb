module Pardot
  module Http
    
    def get object, path, params = {}, num_retries = 0
      smooth_params object, params
      full_path = fullpath object, path
      check_response self.class.get(full_path, :query => params, :headers => auth_headers)

    rescue Pardot::AccessTokenExpiredError => e
      handle_expired_access_token :post, object, path, params, num_retries, e
      
    rescue SocketError, Interrupt, EOFError, SystemCallError, Timeout::Error, MultiXml::ParseError => e
      raise Pardot::NetError.new(e)
    end
    
    def post object, path, params = {}, num_retries = 0, bodyParams = {}
      smooth_params object, params
      full_path = fullpath object, path
      check_response self.class.post(full_path, :query => params, :body => bodyParams, :headers => auth_headers)
      
    rescue Pardot::AccessTokenExpiredError => e
      handle_expired_access_token :post, object, path, params, num_retries, e
      
    rescue SocketError, Interrupt, EOFError, SystemCallError, Timeout::Error, MultiXml::ParseError => e
      raise Pardot::NetError.new(e)
    end

    protected

    def handle_expired_access_token(method, object, path, params, num_retries, e)
      raise e unless num_retries == 0

      reauthenticate

      send(method, object, path, params, 1)
    end

    def auth_headers
      {
        Authorization: "Bearer #{@access_token}",
        "Pardot-Business-Unit-Id": @business_unit_id,
      }
    end
    
    def smooth_params object, params
      return if object == "login"
      
      authenticate unless authenticated?
      params.merge! :format => @format
    end
    
    def check_response http_response
      rsp = http_response["rsp"]
      
      error = rsp["err"] if rsp
      error ||= "Unknown Failure: #{rsp.inspect}" if rsp && rsp["stat"] == "fail"
      code = error['code'] if error.is_a?(Hash)

      if code == "184"
        raise AccessTokenExpiredError.new "Failed to get access token by your credentials. See https://developer.salesforce.com/docs/atlas.en-us.mobile_sdk.meta/mobile_sdk/oauth_refresh_token_flow.htm for more information about auth flow."
      end

      raise ResponseError.new error if error
      
      rsp
    end
    
    def fullpath object, path
      full = File.join("/api", object, "version", @version.to_s)
      unless path.nil?
        full = File.join(full, path)
      end
      full
    end
    
  end
end
