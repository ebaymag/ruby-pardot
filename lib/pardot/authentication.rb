module Pardot
  module Authentication
    AUTH_URL = "https://login.salesforce.com/services/oauth2/token".freeze

    def authenticate
      resp = HTTParty.post(AUTH_URL, body: auth_params)

      update_version(resp["version"]) if resp && resp["version"]
      @access_token = resp && resp["access_token"]
    end
    
    def authenticated?
      @access_token != nil
    end
    
    def reauthenticate
      @access_token = nil
      authenticate
    end

    private

    def auth_params
      {
        grant_type: "password",
        client_id: @client_id,
        client_secret: @client_secret,
        username: @username,
        password: @password,
      }
    end

    def update_version version
      if version.is_a? Array
        version = version.last
      end
      @version = version if version.to_i > 3
    end

  end
end
