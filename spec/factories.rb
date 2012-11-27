FactoryGirl.define do

  sequence(:domain_sequence) { |n| "mydomain#{n}.com" }
  sequence(:shortname_sequence) { |n| "mydomain#{n}" }

  factory :tenant, :class => Spree::Tenant  do
    domain { FactoryGirl.generate :domain_sequence }
    shortname { FactoryGirl.generate :shortname_sequence }
  end

end
