require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pardot::Client do
  describe "client" do
    after do
      @client.client_id.should == "client_id"
      @client.client_secret.should == "client_secret"
      @client.username.should == "username"
      @client.password.should == "password"
      @client.business_unit_id.should == "business_unit_id"
    end

    it "should set variables without version" do
      @client = Pardot::Client.new "client_id", "client_secret", "username", "password", "business_unit_id"
      @client.version.should == 3
    end
    
    it "should set variables with version" do
      @client = Pardot::Client.new "client_id", "client_secret", "username", "password", "business_unit_id", 4
      @client.version.should == 4
    end
  end
end
