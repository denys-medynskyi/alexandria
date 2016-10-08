FactoryGirl.define do
  factory :api_key do
    key 'RandomKey'
    active true

    trait :disabled do
      active false
    end

  end
end