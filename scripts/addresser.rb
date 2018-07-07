class Addresser
  def call(env)
    query = env["QUERY_STRING"]
    return unprocessable_entity if query.empty?

    postcode = query.split("=")[1]
    return unprocessable_entity if postcode.to_i.zero?

    [200, {"content-type" => "application/json"}, [fetch(postcode)]]
  end

  private

  def unprocessable_entity
    res = "invalid request".to_json
    [422, {"content-type" => "application/json"}, [res]]
  end

  def fetch(postcode)
    url = "https://postcode-jp.appspot.com/api/postcode?general=true&office=false&postcode=#{postcode}"
    address = http_request(url).join[2].join
  end
end

Addresser.new
