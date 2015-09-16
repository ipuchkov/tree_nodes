FactoryGirl.define do
  factory :node do
    sequence(:value) { |i| "node#{i}" }
    deleted_at nil
    parent nil
  end
end
