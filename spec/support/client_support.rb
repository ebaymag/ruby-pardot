
def create_client
  @client = Pardot::Client.new "client_id", "client_secret", "username", "password", "business_unit_id"
  @client.access_token = "access_token"
  @client
end
