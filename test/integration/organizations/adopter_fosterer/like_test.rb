require "test_helper"

class Organizations::AdopterFosterer::LikeTest < ActionDispatch::IntegrationTest
  setup do
    @pet = create(:pet)
    @user = create(:adopter)
    sign_in @user
  end

  test "adopter can like a pet" do
    assert_difference "Like.count", 1 do
      post adopter_fosterer_likes_path,
        params: {like: {pet_id: @pet.id}},
        headers: {"HTTP_REFERER" => "http://www.example.com/"}
    end
  end

  test "adopter can unlike a pet" do
    @like = create(:like, adopter_foster_account_id: @user.adopter_foster_account.id, pet_id: @pet.id)
    assert_difference "Like.count", -1 do
      delete adopter_fosterer_like_path(@like), headers: {"HTTP_REFERER" => "http://www.example.com/"}
    end
  end
end
