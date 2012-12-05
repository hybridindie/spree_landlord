module Spree
  module SpreeLandlord
    class MasterTenantMissing < StandardError; end
  end

  class Tenant < ActiveRecord::Base
    attr_accessible :domain, :shortname

    before_validation :downcase_shortname

    ['domain', 'shortname'].each do |attrib|
      validates attrib.to_sym, uniqueness: true, presence: true
    end

    class << self
      def current_tenant
        find(current_tenant_id)
      end

      def current_tenant_id
        result = Thread.current[:tenant_id] || Spree::Tenant.first.try(:id)
        if result.nil?
          raise SpreeLandlord::MasterTenantMissing, 'At least one tenant is required at all times'
        end
        result
      end

      def set_current_tenant( tenant )
        # able to handle tenant obj or tenant_id
        case tenant
          when Tenant then tenant_id = tenant.id
          when Integer then
            tenant_id = tenant
            unless Spree::Tenant.exists?(tenant_id)
              raise Spree::SpreeLandlord::TenantNotFound, "No tenant found with id = #{tenant_id}"
            end
          else
            raise ArgumentError, "invalid tenant object or id"
        end  # case

        Thread.current[:tenant_id] = tenant_id
      end
    end

    private

    def downcase_shortname
      self.shortname = self.shortname.downcase if self.shortname.present?
    end
  end
end
