module Spree
  module SpreeLandlord
    class Engine < Rails::Engine
      require 'spree/core'
      isolate_namespace Spree
      engine_name 'spree_landlord'

      config.autoload_paths += %W(#{config.root}/lib)

      # use rspec for tests
      config.generators do |g|
        g.test_framework :rspec
      end

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), '../../../app/**/*_decorator*.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
        Spree::Ability.register_ability(Spree::TenantAbility)

        ActiveSupport.on_load(:action_controller) do
          include Spree::SpreeLandlord::TenantHelpers
        end
      end

      config.to_prepare &method(:activate).to_proc

      # based on `initializer "sprockets.environment"` in rails-3.2/actionpack/lib/sprockets/railtie.rb
      initializer "landlord.assets.environment", :group => :all do |app|
        Rails::Application.class_eval do
          attr_accessor :tenants_assets
        end

        Sprockets::Helpers::RailsHelper.class_eval do
          def asset_prefix
            "/tenants/#{Spree::Tenant.current_tenant.shortname}#{Rails.application.config.assets.prefix}"
          end

          def asset_environment
            Rails.application.tenants_assets[Spree::Tenant.current_tenant.shortname]
          end
        end

        config = app.config
        next unless config.assets.enabled

        tenants_root = app.root + 'app' + 'tenants'
        next unless tenants_root.exist?

        tenants_root.children(false).each do |tenant_name|
          tenant_root = tenants_root + tenant_name
          if tenant_root.directory?
            require 'sprockets'

            app.tenants_assets ||= {}
            app.tenants_assets[tenant_name] = Sprockets::Environment.new(tenant_root.to_s) do |env|
              env.version = ::Rails.env + "-#{config.assets.version}"

              if config.assets.logger != false
                env.logger  = config.assets.logger || ::Rails.logger
              end

              if config.assets.cache_store != false
                env.cache = ActiveSupport::Cache.lookup_store(config.assets.cache_store) || ::Rails.cache
              end
            end

            if config.assets.manifest
              path = File.join(config.assets.manifest, "manifest.yml")
            else
              path = File.join(Rails.public_path, 'tenants', tenant_name, config.assets.prefix, "manifest.yml")
            end

            if File.exist?(path)
              config.assets.digests = YAML.load_file(path)
            end
          end
        end
      end

      config.after_initialize do |app|
        Spree::SpreeLandlord::Assets::Bootstrap.new(app).run
      end
    end
  end
end
