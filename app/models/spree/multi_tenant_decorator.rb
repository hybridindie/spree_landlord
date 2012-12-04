module Spree
  Landlord.model_names.each do |model|
    model.class_eval do

      attr_protected :tenant_id
      belongs_to  :tenant
      validates :tenant_id, presence: true

      default_scope lambda {
        if model.attribute_names.include?('tenant_id')
          where( "#{table_name}.tenant_id = ?", Thread.current[:tenant_id] )
        end
      }

      before_validation(:on => :create) do |obj|
        obj.tenant_id = Thread.current[:tenant_id]
      end

      def tenant
        tenant_attribute = read_attribute(:tenant_id)
        unless tenant_attribute.present?
          write_attribute(:tenant_id, Spree::Tenant.current_tenant_id)
        end

        super
      end
    end
  end
end