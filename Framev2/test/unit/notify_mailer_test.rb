require 'test_helper'

class NotifyMailerTest < ActionMailer::TestCase
  test "send" do
    @expected.subject = 'NotifyMailer#send'
    @expected.body    = read_fixture('send')
    @expected.date    = Time.now

    assert_equal @expected.encoded, NotifyMailer.create_send(@expected.date).encoded
  end

end
