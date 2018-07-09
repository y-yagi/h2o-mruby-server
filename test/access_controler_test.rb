require "../scripts/access_controler"

class AccessControllerTest < MTest::Unit::TestCase
  def test_call
    result = AccessController.new.call({"REMOTE_ADDR" => "172.17.0.1"})
    assert_equal [399, {}, []], result

    result = AccessController.new.call({"REMOTE_ADDR" => "127.0.0.1"})
    assert_equal [403, {'content-type' => 'text/plain'}, ["access forbidden\n"]], result
  end
end

MTest::Unit.new.run
