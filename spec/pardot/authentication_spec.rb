require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pardot::Authentication do
  
  def create_client
    @client = Pardot::Client.new "client_id", "client_secret", "username", "password", "business_unit_id"
  end
  
  describe "authenticate" do
    
    before do
      @client = create_client

      fake_auth_post "/api/login/version/3", '{ access_token: "access_token" }'
    end
    
    def authenticate
      @client.authenticate
    end

    def verifyBody
      FakeWeb.last_request.body.should == 'grant_type=password&client_id=client_id&client_secret=client_secret&username=username&password=password'
    end
    
    it "should return the api key" do
      authenticate.should == "access_token"
    end
    
    it "should set the api key" do
      authenticate
      @client.access_token.should == "access_token"
      verifyBody
    end
    
    it "should make authenticated? true" do
      authenticate
      @client.authenticated?.should == true
      verifyBody
    end

    it "should use version 3" do
      authenticate
      @client.version.to_i.should == 3
      verifyBody
    end
  end
end