require "test_helper"

class ContactsMailerTest < ActionMailer::TestCase
  test "contacts mailer" do
    org_name = ActsAsTenant.current_tenant.slug
    sender = create(:user)
    message = "this is a test message"
    default_email = "default@email.com"
    contact_email = "contact@email.com"

    assert_emails 1 do
      @contact_email = ContactsMailer.with(name: sender.first_name,
        email: sender.email,
        message: message)
        .send_message(org_name).deliver_now
    end

    assert_equal [contact_email], @contact_email.to
    assert_equal [default_email], @contact_email.from
    assert_match(/#{sender.first_name}/, @contact_email.body.encoded)
    assert_match(/#{sender.email}/, @contact_email.body.encoded)
    assert_match(/#{message}/, @contact_email.body.encoded)
  end
end
