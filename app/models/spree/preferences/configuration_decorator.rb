module Spree
  module Preferences
    Configuration.class_eval do
      def preference_cache_key(name)
        if Spree::Tenant.table_exists?
          [Spree::Tenant.current_tenant_id, self.class.name, name].join('::').underscore
        else
          [self.class.name, name].join('::').underscore
        end
      end
    end
  end
end
