module Spree
  class Tenant < ActiveRecord::Base
    attr_accessible :domain, :shortname

    before_validation :downcase_shortname

    ['domain', 'shortname'].each do |attrib|
      validates attrib.to_sym, uniqueness: true, presence: true
    end

    class << self
      def current_tenant
        find( Thread.current[:tenant_id] )
      end

      def current_tenant_id
        Thread.current[:tenant_id]
      end

      def set_current_tenant( tenant )
        # able to handle tenant obj or tenant_id
        case tenant
          when Tenant then tenant_id = tenant.id
          when Integer then tenant_id = tenant
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
