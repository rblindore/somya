FactoryGirl.define do
  factory :fee_discount do |e|
    e.sequence(:name) { |n| "Group #{n}" }
    e.discount 10
    e.type 'FinanceFeeCategory'
    finance_fee_category
  end
end