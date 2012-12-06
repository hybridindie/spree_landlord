module Spree
  ShippingMethod.class_eval do
    # We need to redefine the default_scope to include the tenant_id
    default_scope lambda {
      if ShippingMethod.column_names.include?(:tenant_id)
        where( tenant_id: Tenant.current_tenant_id, deleted_at: nil )
      end
    }
  end
end