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

        shortname = request.subdomains.first
        unless tenant.present?
          if shortname.present?
            tenant = Spree::Tenant.find_by_shortname(shortname.downcase)
          end
        end

        if tenant.present?
          Spree::Tenant.set_current_tenant(tenant)
        elsif shortname.nil?
          Spree::Tenant.set_current_tenant(Spree::Tenant.master)
        else
          raise TenantNotFound, "No tenant could be found with shortname #{shortname.inspect}"
        end
      end
    end
  end
end
