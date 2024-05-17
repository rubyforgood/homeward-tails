orga_location = Location.create!(
  country: "US",
  province_state: "NY",
  city_town: "AltaCity",
  zipcode: "12345"
)

@organization = Organization.create!(
  name: "Alta Pet Rescue",
  slug: "alta",
  profile: OrganizationProfile.new(email: "alta@email.com", phone_number: "250 816 8212", location: orga_location),
  page_text: PageText.new(hero: "Where every paw finds a hom", about: "Alta was founded by an incredible group of ladies in April of 2020. Our initial goal was to have both a rescue and a spay/neuter clinic, however, we quickly realized that it would be more efficient to separate into two organizations.")
)

ActsAsTenant.with_tenant(@organization) do
  @user_staff_one = User.create!(
    email: "staff@alta.com",
    first_name: "Andy",
    last_name: "Peters",
    password: "123456",
    password_confirmation: "123456",
    tos_agreement: 1
  )

  @staff_account_one = StaffAccount.create!(
    user_id: @user_staff_one.id
  )

  @user_staff_one.add_role(:admin, @organization)

  @user_staff_two = User.create!(
    email: "staff2@alta.com",
    first_name: "Randy",
    last_name: "Peterson",
    password: "123456",
    password_confirmation: "123456",
    tos_agreement: 1
  )

  @staff_account_two = StaffAccount.create!(
    user_id: @user_staff_two.id
  )

  @user_staff_two.add_role(:admin, @organization)

  @user_adopter_one = User.create!(
    email: "adopter1@alta.com",
    first_name: "Joe",
    last_name: "Brando",
    password: "123456",
    password_confirmation: "123456",
    tos_agreement: 1
  )

  @adopter_foster_account_one = AdopterFosterAccount.create!(user_id: @user_adopter_one.id)

  @user_adopter_one.add_role(:adopter, @organization)

  @user_adopter_two = User.create!(
    email: "adopter2@alta.com",
    first_name: "Kamala",
    last_name: "Lolsworth",
    password: "123456",
    password_confirmation: "123456",
    tos_agreement: 1
  )

  @adopter_foster_account_two = AdopterFosterAccount.create!(user_id: @user_adopter_two.id)

  @user_adopter_two.add_role(:adopter, @organization)

  @user_adopter_three = User.create!(
    email: "adopter3@alta.com",
    first_name: "Bad",
    last_name: "Address",
    password: "123456",
    password_confirmation: "123456",
    tos_agreement: 1
  )

  @adopter_foster_account_three = AdopterFosterAccount.create!(user_id: @user_adopter_three.id)

  @user_adopter_three.add_role(:adopter, @organization)

  @user_fosterer_one = User.create!(
    email: "fosterer1@alta.com",
    first_name: "Simon",
    last_name: "Petrikov",
    password: "123456",
    password_confirmation: "123456",
    tos_agreement: 1
  )

  @user_fosterer_one.create_adopter_foster_account!

  @user_fosterer_one.add_role(:adopter, @organization)
  @user_fosterer_one.add_role(:fosterer, @organization)

  @user_fosterer_two = User.create!(
    email: "fosterer2@alta.com",
    first_name: "Finn",
    last_name: "Mertens",
    password: "123456",
    password_confirmation: "123456",
    tos_agreement: 1
  )

  @user_fosterer_two.create_adopter_foster_account!

  @user_fosterer_two.add_role(:adopter, @organization)
  @user_fosterer_two.add_role(:fosterer, @organization)

  @location_one = Location.create!(
    country: "Canada",
    province_state: "Alberta",
    city_town: "Canmore",
    zipcode: "12345"
  )

  user_profile_params = ->(adopter_foster_account) {
    {
      location_id: @location_one.id,
      adopter_foster_account_id: adopter_foster_account.id,
      phone_number: "250 548 7721",
      contact_method: "phone",
      ideal_pet: 'I love a pet with energy and a gentle spirit.
                One that snuggles on the couch in the evening.',
      lifestyle_fit: 'I work from home during the week and am always
                    at home. On weekends I do a lot of hiking.',
      activities: 'We will go to the pet park, daily walks x 2, and
                see friends with pets regularly',
      alone_weekday: 2,
      alone_weekend: 1,
      experience: 'I have owned many pets an currently have three rescue
                pets and one foster pet',
      contingency_plan: 'My neighbour is a good friend and has looked after
                      my pets multiple times and they get along very well',
      shared_ownership: true,
      shared_owner: 'My brother is often taking my pets when his kids are over
                  for the weekend as they just love the pets',
      housing_type: "Detached",
      fenced_access: true,
      location_day: "In the house",
      location_night: "In the house",
      do_you_rent: false,
      adults_in_home: 2,
      kids_in_home: 1,
      other_pets: true,
      describe_pets: "I have one cat that does not mind pets at all",
      checked_shelter: true,
      surrendered_pet: true,
      describe_surrender: "I had to surrender a cat when I was 19 because of university",
      annual_cost: "$2,000",
      visit_laventana: false,
      referral_source: "my friends friend"
    }
  }

  @adopter_foster_profile_one = AdopterFosterProfile.create!(
    user_profile_params.call(@adopter_foster_account_one)
  )

  @user_fosterer_profile_one = AdopterFosterProfile.create!(
    user_profile_params.call(@user_fosterer_one.adopter_foster_account)
  )

  @user_fosterer_profile_two = AdopterFosterProfile.create!(
    user_profile_params.call(@user_fosterer_two.adopter_foster_account)
  )

  @location_two = Location.create!(
    country: "USA",
    province_state: "Nevada",
    city_town: "Reno",
    zipcode: "12345"
  )

  @adopter_foster_profile_two = AdopterFosterProfile.create!(
    location_id: @location_two.id,
    adopter_foster_account_id: @adopter_foster_account_two.id,
    phone_number: "250 548 7721",
    contact_method: "phone",
    ideal_pet: 'I love a pet with energy and a gentle spirit.
              One that snuggles on the couch in the evening.',
    lifestyle_fit: 'I work from home during the week and am always
                  at home. On weekends I do a lot of hiking.',
    activities: 'We will go to the pet park, daily walks x 2, and
              see friends with pets regularly',
    alone_weekday: 2,
    alone_weekend: 1,
    experience: 'I have owned many pets an currently have three rescue
              pets and one foster pet',
    contingency_plan: 'My neighbour is a good friend and has looked after
                    my pets multiple times and they get along very well',
    shared_ownership: true,
    shared_owner: 'My brother is often taking my pets when his kids are over
                for the weekend as they just love the pets',
    housing_type: "Detached",
    fenced_access: false,
    fenced_alternative: "I plan to always be outside with my pet and walk them at the local park",
    location_day: "In the house",
    location_night: "In the house",
    do_you_rent: true,
    pets_allowed: true,
    adults_in_home: 2,
    kids_in_home: 1,
    other_pets: true,
    describe_pets: "I have one cat that does not mind pets at all",
    checked_shelter: true,
    surrendered_pet: true,
    describe_surrender: "I had to surrender a cat when I was 19 because of university",
    annual_cost: "$2,000",
    visit_laventana: true,
    visit_dates: "April 2 to May 7 2023",
    referral_source: "my friends friend"
  )

  @location_three = Location.create!(
    country: "Nonsense",
    province_state: "Nonsense",
    city_town: "Nonsense",
    zipcode: "12345"
  )

  @adopter_foster_profile_three = AdopterFosterProfile.create!(
    location_id: @location_three.id,
    adopter_foster_account_id: @adopter_foster_account_three.id,
    phone_number: "250 548 7721",
    contact_method: "phone",
    ideal_pet: 'I love a pet with energy and a gentle spirit.
              One that snuggles on the couch in the evening.',
    lifestyle_fit: 'I work from home during the week and am always
                  at home. On weekends I do a lot of hiking.',
    activities: 'We will go to the pet park, daily walks x 2, and
              see friends with pets regularly',
    alone_weekday: 2,
    alone_weekend: 1,
    experience: 'I have owned many pets an currently have three rescue
              pets and one foster pet',
    contingency_plan: 'My neighbour is a good friend and has looked after
                    my pets multiple times and they get along very well',
    shared_ownership: true,
    shared_owner: 'My brother is often taking my pets when his kids are over
                for the weekend as they just love the pets',
    housing_type: "Detached",
    fenced_access: false,
    fenced_alternative: "I plan to always be outside with my pet and walk them at the local park",
    location_day: "In the house",
    location_night: "In the house",
    do_you_rent: true,
    pets_allowed: true,
    adults_in_home: 2,
    kids_in_home: 1,
    other_pets: true,
    describe_pets: "I have one cat that does not mind pets at all",
    checked_shelter: true,
    surrendered_pet: true,
    describe_surrender: "I had to surrender a cat when I was 19 because of university",
    annual_cost: "$2,000",
    visit_laventana: true,
    visit_dates: "April 2 to May 7 2023",
    referral_source: "my friends friend"
  )

  5.times do
    DefaultPetTask.create!(
      name: Faker::Lorem.word.capitalize,
      description: Faker::Lorem.sentence
    )
  end

  @lifestyle_form = Form.create!(
    name: "Lifestyle",
    description: "Questions regarding the applicant's lifestyle.",
    title: "Lifestyle",
    instructions: "Please answer these questions about your lifestyle as they pertain to your ability to care for a pet.",
    organization: @organization
  )

  FormProfile.create!(
    form: @lifestyle_form,
    profile_type: "adopter",
    sort_order: 0
  )

  @ideal_pet_question = Question.create!(
    name: "Ideal pet",
    description: "Brief description of the applicant's ideal pet.",
    label: "Your ideal pet",
    help_text: "Briefly describe your ideal pet.",
    required: true,
    input_type: "short",
    sort_order: 0,
    form: @lifestyle_form
  )

  @lifestyle_question = Question.create!(
    name: "General lifestyle",
    description: "Brief description of the applicant's lifestyle.",
    label: "Your lifestyle",
    help_text: "Briefly describe your lifestyle.",
    required: true,
    input_type: "short",
    sort_order: 1,
    form: @lifestyle_form
  )

  @activities_question = Question.create!(
    name: "Activities",
    description: "Brief description of the applicant's activities.",
    label: "Your activities",
    help_text: "Briefly describe activities you will do with your pet.",
    required: true,
    input_type: "short",
    sort_order: 2,
    form: @lifestyle_form
  )

  path = Rails.root.join("app", "assets", "images", "hero.jpg")
  50.times do
    from_weight = [5, 10, 20, 30, 40, 50, 60].sample
    pet = Pet.create!(
      name: Faker::Creature::Dog.name,
      birth_date: Faker::Date.birthday(min_age: 0, max_age: 3),
      sex: Faker::Creature::Dog.gender,
      weight_from: from_weight,
      weight_to: from_weight + 15,
      weight_unit: Pet::WEIGHT_UNITS.sample,
      breed: Faker::Creature::Dog.breed,
      description: "He just loves a run and a bum scratch at the end of the day",
      species: 0,
      placement_type: 0,
      published: true
    )
    pet.images.attach(io: File.open(path), filename: "hero.jpg")

    due_dates = [Date.today - 1.day, Date.today, Date.today + 30.days]
    DefaultPetTask.all.each_with_index do |task, index|
      Task.create!(
        pet_id: pet.id,
        name: task.name,
        description: task.description,
        due_date: due_dates[index]
      )
    end
  end

  @match = Match.create!(
    pet_id: Pet.first.id,
    adopter_foster_account_id: @adopter_foster_account_one.id,
    match_type: :adoption
  )

  10.times do
    adopter_application = AdopterApplication.new(
      notes: Faker::Lorem.paragraph,
      profile_show: true,
      status: rand(0..4),
      adopter_foster_account: AdopterFosterAccount.all.sample,
      pet: Pet.all.sample
    )

    # Prevent duplicate adopter applications.
    redo if AdopterApplication.where(pet_id: adopter_application.pet_id,
      adopter_foster_account_id: adopter_application.adopter_foster_account_id).exists?

    if adopter_application.valid?
      adopter_application.save!
    else
      redo
    end
  end

  5.times do
    Faq.create!(
      question: Faker::Lorem.question(word_count: 4, random_words_to_add: 10),
      answer: Faker::Lorem.sentence(word_count: 1, random_words_to_add: 50)
    )
  end
end
