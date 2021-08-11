require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pardot::Http do
  
  before do
    @client = create_client
    fake_authenticate @client, "my_api_key"
  end
  
  def create_client
    @client = Pardot::Client.new "client_id", "client_secret", "username", "password", "business_unit_id"
  end
  
  describe "get" do
    
    def get object = "foo", path = "/bar", params = {}
      @client.get object, path, params
    end
    
    it "should notice errors and raise them as Pardot::ResponseError" do
      fake_get "/api/foo/version/3/bar?format=simple",
               %(?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="fail" version="1.0">\n   <err code="15">Login failed</err>\n</rsp>\n)
      
      lambda { get }.should raise_error(Pardot::ResponseError)
    end
    
    it "should catch and reraise SocketErrors as Pardot::NetError" do
      Pardot::Client.should_receive(:get).and_raise(SocketError)
      
      lambda { get }.should raise_error(Pardot::NetError)
    end

    it "should raise ExceededRequestLimitError" do
      fake_get "/api/foo/version/3/bar?format=simple",
               %(?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="fail" version="1.0">\n   <err code="66">You have exceeded your concurrent request limit. Please wait, before trying again</err>\n</rsp>\n)

      lambda { get }.should raise_error(Pardot::ExceededRequestLimitError)
    end
  end
  
  describe "post" do
    
    def post object = "foo", path = "/bar", params = {}
      @client.post object, path, params
    end
    
    it "should notice errors and raise them as Pardot::ResponseError" do
      fake_post "/api/foo/version/3/bar?format=simple",
                %(?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="fail" version="1.0">\n   <err code="15">Login failed</err>\n</rsp>\n)
      
      lambda { post }.should raise_error(Pardot::ResponseError)
    end
    
    it "should catch and reraise SocketErrors as Pardot::NetError" do
      Pardot::Client.should_receive(:post).and_raise(SocketError)

      lambda { post }.should raise_error(Pardot::NetError)
    end
    
    it "should call handle_expired_api_key when the api key expires" do
      fake_post "/api/foo/version/3/bar?format=simple",
                %(?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="fail" version="1.0">\n   <err code="184">access_token is invalid, unknown, or malformed</err>\n</rsp>\n)
      
      @client.should_receive(:handle_expired_access_token)
      post
    end

    it "should raise ExceededRequestLimitError" do
      fake_post "/api/foo/version/3/bar?format=simple",
                %(?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="fail" version="1.0">\n   <err code="66">You have exceeded your concurrent request limit. Please wait, before trying again</err>\n</rsp>\n)

      lambda { post }.should raise_error(Pardot::ExceededRequestLimitError)
    end
  end

  describe "getV4" do

    def get object = "foo", path = "/bar", params = {}
      @client.version = "4"
      @client.get object, path, params
    end

    it "should notice errors and raise them as Pardot::ResponseError" do
      fake_get "/api/foo/version/4/bar?format=simple",
               %(?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="fail" version="1.0">\n   <err code="15">Login failed</err>\n</rsp>\n)

      lambda { get }.should raise_error(Pardot::ResponseError)
    end

    it "should catch and reraise SocketErrors as Pardot::NetError" do
      Pardot::Client.should_receive(:get).and_raise(SocketError)

      lambda { get }.should raise_error(Pardot::NetError)
    end

    it "should call handle_expired_api_key when the api key expires" do
      fake_get "/api/foo/version/4/bar?format=simple",
               %(?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="fail" version="1.0">\n   <err code="184">access_token is invalid, unknown, or malformed</err>\n</rsp>\n)

      @client.should_receive(:handle_expired_access_token)
      get
    end

    it "should raise ExceededRequestLimitError" do
      fake_get "/api/foo/version/4/bar?format=simple",
                %(?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="fail" version="1.0">\n   <err code="66">You have exceeded your concurrent request limit. Please wait, before trying again</err>\n</rsp>\n)

      lambda { get }.should raise_error(Pardot::ExceededRequestLimitError)
    end
  end

  describe "postV4" do

    def post object = "foo", path = "/bar", params = {}
      @client.version = "4"
      @client.post object, path, params
    end

    it "should notice errors and raise them as Pardot::ResponseError" do
      fake_post "/api/foo/version/4/bar?format=simple",
                %(?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="fail" version="1.0">\n   <err code="15">Login failed</err>\n</rsp>\n)

      lambda { post }.should raise_error(Pardot::ResponseError)
    end

    it "should catch and reraise SocketErrors as Pardot::NetError" do
      Pardot::Client.should_receive(:post).and_raise(SocketError)

      lambda { post }.should raise_error(Pardot::NetError)
    end

    it "should call handle_expired_api_key when the api key expires" do
      fake_post "/api/foo/version/4/bar?format=simple",
                %(?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="fail" version="1.0">\n   <err code="184">access_token is invalid, unknown, or malformed</err>\n</rsp>\n)

      @client.should_receive(:handle_expired_access_token)
      post
    end

    it "should raise ExceededRequestLimitError" do
      fake_post "/api/foo/version/4/bar?format=simple",
                %(?xml version="1.0" encoding="UTF-8"?>\n<rsp stat="fail" version="1.0">\n   <err code="66">You have exceeded your concurrent request limit. Please wait, before trying again</err>\n</rsp>\n)

      lambda { post }.should raise_error(Pardot::ExceededRequestLimitError)
    end
  end
end