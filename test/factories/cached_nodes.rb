FactoryGirl.define do
  factory :cached_node do
    sequence(:value) {|i| "node_#{i}"}
    sequence(:id) {|i| i}
  end

end
