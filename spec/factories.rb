FactoryGirl.define do

  sequence(:domain_sequence) { |n| "mydomain#{n}.com" }
  sequence(:shortname_sequence) { |n| "mydomain#{n}" }
  sequence(:name_sequence) { |n| "My Domain #{n}"}

  factory :tenant, :class => Spree::Tenant  do
    domain { FactoryGirl.generate :domain_sequence }
    shortname { FactoryGirl.generate :shortname_sequence }
    name { FactoryGirl.generate :name_sequence }
  end

end
