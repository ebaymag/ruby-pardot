require 'fakeweb'
FakeWeb.allow_net_connect = false

def fake_post path, response, headers: {}
  FakeWeb.register_uri(:post, "https://pi.pardot.com#{path}", :body => response)
end

def fake_get path, response, headers: {}
  FakeWeb.register_uri(:get, "https://pi.pardot.com#{path}", :body => response)
end

def fake_auth_post(path, response, headers: {})
  FakeWeb.register_uri(:post, "https://login.salesforce.com/services/oauth2/token", :body => response)
end

def fake_authenticate client, access_token
  client.access_token = access_token
end
