module Spree
  module SpreeLandlord
    module TenantHelpers
      extend ActiveSupport::Concern

      included do
        before_filter :set_current_tenant
      end

      def set_current_tenant
        finder = TenantFinder.new
        tenant = finder.find_target_tenant(request)
        Spree::Tenant.set_current_tenant(tenant)
      end
    end
  end
end
