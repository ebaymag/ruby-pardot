module Pardot

  class Client

    include HTTParty
    base_uri 'https://pi.pardot.com'
    format :xml

    include Authentication
    include Http

    include Objects::Emails
    include Objects::Lists
    include Objects::ListMemberships
    include Objects::Opportunities
    include Objects::Prospects
    include Objects::ProspectAccounts
    include Objects::Users
    include Objects::Visitors
    include Objects::Visits
    include Objects::VisitorActivities

    attr_accessor :access_token, :client_id, :client_secret, :username, :password, :business_unit_id, :version, :format

    def initialize client_id, client_secret, username, password, business_unit_id, version = 3
      @client_id = client_id
      @client_secret = client_secret
      @username = username
      @password = password
      @business_unit_id = business_unit_id
      @version = version

      @format = "simple"
    end

  end
end
