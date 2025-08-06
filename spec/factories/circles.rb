FactoryBot.define do
  factory :circle do
    sequence(:x) { |n| n * 10 }
    sequence(:y) { |n| n * 10 }
    diameter { 5 }

    association :frame
  end
end
