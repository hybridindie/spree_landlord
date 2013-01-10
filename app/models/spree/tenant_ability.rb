module Spree
  class TenantAbility
    include CanCan::Ability

    def initialize(user)
      if user.super_admin? && user.has_spree_role?(:admin)
        can :manage, Spree::Tenant
        can :grant_super_admin, Spree::User
      else
        cannot :grant_super_admin, Spree::User
      end
    end

    Spree::Ability.register_ability(Spree::TenantAbility)
  end
end