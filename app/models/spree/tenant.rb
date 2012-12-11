module Spree
  class Tenant < ActiveRecord::Base
    attr_accessible :domain, :shortname, :name

    before_validation :downcase_shortname
    before_validation :ensure_name_is_present

    ['domain', 'shortname'].each do |attrib|
      validates attrib.to_sym, uniqueness: true, presence: true
    end

    class << self
      def master
        result = Spree::Tenant.first
        unless result.present?
          result = Spree::Tenant.create!(:shortname => 'master', :domain => 'example.com', :name => 'Master')
        end
        result
      end

      def current_tenant
        find(current_tenant_id)
      end

      def current_tenant_id
        if Spree::Tenant.table_exists?
          Thread.current[:tenant_id] || master.id
        end
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

    def ensure_name_is_present
      if attribute_names.include?('name')
        self.name ||= self.shortname
      end
    end
  end
end
