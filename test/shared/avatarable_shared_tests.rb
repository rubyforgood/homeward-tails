module AvatarableSharedTests
  def self.included spec
    spec.class_eval do
      context "avatarable" do
        should "behave as avatarable" do
          assert_includes User.included_modules, Avatarable

          assert subject, respond_to?(:avatar=)
        end

        context "validations" do
          should "append error if avatar is too big" do
            fixture_file.stubs(:size).returns(2.megabytes)

            subject.avatar.attach(io: fixture_file, filename: "test.png")

            refute subject.valid?
            assert_includes subject.errors[:avatar], "file size must be less than 1 MB (current size is 2 MB)"
          end
        end
      end
    end
  end
end
