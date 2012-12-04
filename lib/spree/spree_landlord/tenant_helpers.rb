module Spree
  module SpreeLandlord
    class TenantNotFound < StandardError; end

    module TenantHelpers
      extend ActiveSupport::Concern

      included do
        before_filter :set_current_tenant
      end

      def set_current_tenant
        tenant = Spree::Tenant.find_by_domain(request.domain)

        unless tenant.present?
          shortname = request.subdomains.first
          if shortname.present?
            tenant = Spree::Tenant.find_by_shortname(shortname.downcase)
          end
        end

        if tenant.present?
          Spree::Tenant.set_current_tenant(tenant)
        else
          raise TenantNotFound, "No tenant could be found with shortname #{shortname.inspect}"
        end
      end
    end
  end
end
