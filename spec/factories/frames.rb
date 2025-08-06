FactoryBot.define do
  factory :frame do
    width { 10000 }
    height { 10000 }
    x { 50 }
    y { 50 }

    transient do
      circles_count { 0 }
    end

    after(:create) do |frame, evaluator|
      create_list(:circle, evaluator.circles_count, frame: frame)
    end

    factory :frame_with_circles do
      transient do
        circles_count { 3 }
      end

      after(:create) do |frame, evaluator|
        create_list(:circle, evaluator.circles_count, frame: frame)
      end
    end
  end
end
