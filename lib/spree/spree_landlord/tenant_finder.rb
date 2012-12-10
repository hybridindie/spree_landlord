module Spree
  module SpreeLandlord
    class TenantNotFound < StandardError; end

    class TenantFinder
      def find_target_tenant(request)
        domain_tenant = Spree::Tenant.find_by_domain(request.domain)

        subdomain_tenant = nil
        shortname = request.subdomains.first
        if shortname.present?
          subdomain_tenant = Spree::Tenant.find_by_shortname(shortname.downcase)
        end

        if subdomain_tenant.present? && domain_tenant.present? && Spree::Tenant.master == domain_tenant
          subdomain_tenant
        elsif domain_tenant.present?
          domain_tenant
        elsif subdomain_tenant.present?
          subdomain_tenant
        else
          full_domain = request.domain
          if shortname.present?
            full_domain = shortname + '.' + full_domain
          end
          raise TenantNotFound, "No tenant could be found for '#{full_domain}'"
        end
      end
    end
  end
end
