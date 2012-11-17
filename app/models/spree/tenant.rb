module Spree
  class Tenant < ActiveRecord::Base
    attr_accessible :domain, :shortname

    ['domain', 'shortname'].each do |attrib|
      validates attrib.to_sym, uniqueness: true, presence: true
    end

  end
end
