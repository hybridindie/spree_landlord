module Spree
  module Preferences
    Configuration.class_eval do
      def preference_cache_key(name)
        [Spree::Tenant.current_tenant_id, self.class.name, name].join('::').underscore
      end
    end
  end
end
