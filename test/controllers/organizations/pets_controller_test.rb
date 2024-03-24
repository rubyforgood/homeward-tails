require "test_helper"
require "action_policy/test_helper"

class Organizations::PetsControllerTest < ActionDispatch::IntegrationTest
  context "authorization" do
    include ActionPolicy::TestHelper

    setup do
      @organization = ActsAsTenant.current_tenant
      @pet = create(:pet)

      user = create(:staff)
      sign_in user
    end

    context "#index" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, Pet,
          context: {organization: @organization},
          with: Organizations::PetPolicy
        ) do
          get pets_url
        end
      end

      should "have authorized scope" do
        assert_have_authorized_scope(
          type: :active_record_relation, with: Organizations::PetPolicy
        ) do
          get pets_url
        end
      end
    end

    context "#new" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, Pet,
          context: {organization: @organization},
          with: Organizations::PetPolicy
        ) do
          get new_pet_url
        end
      end
    end

    context "#create" do
      setup do
        @params = {
          pet: {name: "Ein"}
        }
      end

      should "be authorized" do
        assert_authorized_to(
          :manage?, Pet,
          context: {organization: @organization},
          with: Organizations::PetPolicy
        ) do
          post pets_url, params: @params
        end
      end
    end

    context "#show" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, @pet, with: Organizations::PetPolicy
        ) do
          get pet_url(@pet)
        end
      end
    end

    context "#edit" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, @pet, with: Organizations::PetPolicy
        ) do
          get edit_pet_url(@pet)
        end
      end
    end

    context "#update" do
      setup do
        @params = {pet: {weight_to: 25}}
      end

      should "be authorized" do
        assert_authorized_to(
          :manage?, @pet, with: Organizations::PetPolicy
        ) do
          patch pet_url(@pet), params: @params
        end
      end
    end

    context "#destroy" do
      should "be authorized" do
        assert_authorized_to(
          :manage?, @pet, with: Organizations::PetPolicy
        ) do
          delete pet_url(@pet)
        end
      end
    end

    context "#attach_images" do
      setup do
        image = fixture_file_upload("test.png", "image/png")
        @params = {
          pet: {images: [image]}
        }
      end

      should "be authorized" do
        assert_authorized_to(
          :manage?, @pet, with: Organizations::PetPolicy
        ) do
          post attach_images_pet_url(@pet), params: @params
        end
      end
    end

    context "#attach_files" do
      setup do
        file = fixture_file_upload("test.png", "image/png")
        @params = {
          pet: {files: [file]}
        }
      end

      should "be authorized" do
        assert_authorized_to(
          :manage?, @pet, with: Organizations::PetPolicy
        ) do
          post attach_files_pet_url(@pet), params: @params
        end
      end
    end
  end

  context "controller" do
    setup do
      @user = create(:staff)
      @pet = create(:pet)
      @default_pet_tasks = create(:default_pet_task)
      sign_in @user
    end

    teardown do
      :after_teardown
    end

    context "POST #attach_images" do
      should "attaches an image and redirects to pet photos tab with success flash" do
        image = fixture_file_upload("test.png", "image/png")

        assert_difference("@pet.images.count", 1) do
          post attach_images_pet_path(@pet),
            params: {pet: {images: [image]}}
        end

        assert_response :redirect
        follow_redirect!
        assert_equal flash.notice, "Upload successful."
        assert_equal URI.decode_www_form(URI.parse(request.url).query).join("="), "active_tab=photos"
      end
    end

    context "POST #attach_files" do
      should "attaches a record and redirects to pet files tab with success flash" do
        file = fixture_file_upload("test.png", "image/png")

        assert_difference("@pet.files.count", 1) do
          post attach_files_pet_path(@pet),
            params: {pet: {files: [file]}}
        end

        assert_response :redirect
        follow_redirect!
        assert_equal flash.notice, "Upload successful."
        assert_equal URI.decode_www_form(URI.parse(request.url).query).join("="), "active_tab=files"
      end
    end

    should "update application paused should respond with turbo_stream when toggled on pets page" do
      patch url_for(@pet), params: {pet: {application_paused: true, toggle: "true"}}, as: :turbo_stream

      assert_equal Mime[:turbo_stream], response.media_type
      assert_response :success
    end

    should "update application paused should respond with html when not on pets page" do
      patch url_for(@pet), params: {pet: {application_paused: true}}, as: :turbo_stream

      assert_equal Mime[:html], response.media_type
      assert_response :redirect
    end

    should "POST default pet tasks are created when pet is created" do
      assert_difference "Pet.count", 1 do
        post pets_path, params:
        {
          "pet" => {
            "organization_id" => @user.organization.id.to_s,
            "name" => "Test",
            "birth_date(1i)" => "2023",
            "birth_date(2i)" => "12",
            "birth_date(3i)" => "27",
            "sex" => "male",
            "species" => "Cat",
            "breed" => "Anything",
            "weight_from" => "44",
            "weight_to" => "45",
            "weight_unit" => "lb",
            "placement_type" => "Adoptable",
            "description" => "sd",
            "application_paused" => "false",
            "published" => "false"
          }
        }
      end
      assert_equal Pet.last.tasks.count, 1
    end
  end
end
