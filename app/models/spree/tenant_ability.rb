module Spree
  class TenantAbility
    include CanCan::Ability

    def initialize(user)
      if user.has_role?( :admin )
        can :manage, Spree::Tenant
      end
    end

    Spree::Ability.register_ability(Spree::TenantAbility)
  end
end