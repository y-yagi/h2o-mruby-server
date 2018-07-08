class AccessController
  def call(env)
    if /\A172\.17\./.match(env["REMOTE_ADDR"])
      [399, {}, []]
    else
      [403, {'content-type' => 'text/plain'}, ["access forbidden\n"]]
    end
  end
end

AccessController.new
