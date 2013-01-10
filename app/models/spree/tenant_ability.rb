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

      cannot do |action, subject_class, subject|
        if subject_class == Spree::User
          if [:manage, :admin, :edit, :update, :delete].include?(action)
            if subject.super_admin?
              !user.super_admin
            end
          end
        end
      end
    end

    Spree::Ability.register_ability(Spree::TenantAbility)
  end
end