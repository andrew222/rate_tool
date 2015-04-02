FactoryGirl.define do
  factory :rate do
    bid_fx Faker::Commerce.price
    bid_cash Faker::Commerce.price
    so_cash Faker::Commerce.price
    so_fix Faker::Commerce.price
    mid Faker::Commerce.price
    published_at Faker::Date.forward(1)
  end
end
