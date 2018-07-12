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
    redis = H2O::Redis.new(host: 'redis', port: 16379)
    redis.connect
    cached = redis.get(postcode.to_s).join

    if cached.nil?
      url = "https://postcode-jp.appspot.com/api/postcode?general=true&office=false&postcode=#{postcode}"
      status, _, body = http_request(url).join
      cached = body.join

      if status == 200
        redis.set(postcode, cached, { ex: 3600 }).join
      end
    end

    cached
  end
end

Addresser.new
