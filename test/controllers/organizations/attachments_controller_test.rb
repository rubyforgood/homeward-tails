require "test_helper"
require "action_policy/test_helper"

class Organizations::AttachmentsControllerTest < ActionDispatch::IntegrationTest
  context "authorization" do
    include ActionPolicy::TestHelper

    setup do
      pet = create(:pet, :with_image)
      @attachment = pet.images.last
    end

    context "#purge" do
      should "be authorized" do
        user = create(:person, :admin).user
        sign_in user
        assert_authorized_to(
          :purge?, @attachment,
          with: ActiveStorage::AttachmentPolicy
        ) do
          delete staff_purge_attachment_url(@attachment),
            headers: {"HTTP_REFERER" => "http://www.example.com/"}
        end
      end
    end

    context "#adopter_purge_avatar" do
      should "be authorized" do
        user = create(:user, :with_avatar)
        create(:person, :adopter, user: user)
        sign_in user
        assert_authorized_to(
          :purge_avatar?, user.avatar_attachment,
          with: ActiveStorage::AttachmentPolicy
        ) do
          delete purge_avatar_url(user.avatar_attachment),
            headers: {"HTTP_REFERER" => "http://www.example.com/"}
        end
      end
    end

    context "#fosterer_purge_avatar" do
      should "be authorized" do
        user = create(:user, :with_avatar)
        create(:person, :fosterer, user: user)
        sign_in user
        assert_authorized_to(
          :purge_avatar?, user.avatar_attachment,
          with: ActiveStorage::AttachmentPolicy
        ) do
          delete purge_avatar_url(user.avatar_attachment),
            headers: {"HTTP_REFERER" => "http://www.example.com/"}
        end
      end
    end

    context "#staff_purge_avatar" do
      should "be authorized" do
        user = create(:user, :with_avatar)
        create(:person, :admin, user: user)
        sign_in user
        assert_authorized_to(
          :purge_avatar?, user.avatar_attachment,
          with: ActiveStorage::AttachmentPolicy
        ) do
          delete purge_avatar_url(user.avatar_attachment),
            headers: {"HTTP_REFERER" => "http://www.example.com/"}
        end
      end
    end
  end

  teardown do
    :after_teardown
  end

  context "DELETE #purge" do
    setup do
      @user = create(:person, :admin).user
      @pet = create(:pet)

      sign_in @user
    end

    should "deletes the attachment and redirects to request referrer with flash" do
      image = fixture_file_upload("test.png", "image/png")

      assert_difference("@pet.images.count", 1) do
        post attach_images_staff_pet_path(@pet),
          params: {pet: {images: [image]}}
      end

      @pet.reload
      attachment_id = @pet.images.first.id

      assert_difference("@pet.images.count", -1) do
        delete staff_purge_attachment_path(attachment_id),
          headers: {"HTTP_REFERER" => "http://www.example.com/"}
      end

      assert_response :redirect
      follow_redirect!
      assert_equal "Attachment removed", flash[:notice]
    end
  end

  context "#purge_avatar" do
    setup do
      @user1 = create(:user, :with_avatar)
      create(:person, :adopter, user: @user1)

      @user2 = create(:user, :with_avatar)
      create(:person, :adopter, user: @user2)

      sign_in @user1
    end

    should "delete the avatar and redirects to request referrer with flash" do
      delete purge_avatar_path(@user1.avatar_attachment),
        headers: {"HTTP_REFERER" => "http://www.example.com/"}
      @user1.reload
      assert_nil(@user1.avatar_attachment)

      assert_response :redirect
      follow_redirect!
      assert_equal "Avatar removed", flash[:notice]
    end

    should "prevent user from deleting avatar that is not theirs" do
      delete purge_avatar_path(@user2.avatar_attachment),
        headers: {"HTTP_REFERER" => "http://www.example.com/"}
      assert_not_nil(@user2.avatar_attachment)

      assert_response :redirect
      follow_redirect!
      assert_equal I18n.t("errors.authorization_error"), flash[:alert]
    end
  end
end
