Proc.new do |env|
  [200, {'content-type' => 'text/plain'}, ["Hello world\n"]]
end
