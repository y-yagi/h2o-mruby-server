class Addresser
  def call(env)
    query = env["QUERY_STRING"]
    return unprocessable_entity if query.empty?

    postalcode = query.split("=")[1]
    return unprocessable_entity if postalcode.nil?

    url = "https://postcode-jp.appspot.com/api/postcode?general=true&office=false&postcode=#{postalcode}"
    address = http_request(url).join[2].join
    [200, {"content-type" => "application/json"}, [address]]
  end

  private

  def unprocessable_entity
    res = "invalid request".to_json
    [422, {"content-type" => "application/json"}, [res]]
  end
end

Addresser.new
