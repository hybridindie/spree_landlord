# based on rails-3.2/actionpack/lib/sprockets/assets.rake

require "fileutils"

namespace :tenants do
  namespace :assets do
    def tenant_ruby_rake_task(tenant, task, fork = true)
      env    = ENV['RAILS_ENV'] || 'production'
      groups = ENV['RAILS_GROUPS'] || 'assets'
      tenant_name = ENV['TENANT_NAME'] || tenant
      args   = [$0, task,"RAILS_ENV=#{env}","RAILS_GROUPS=#{groups}","TENANT_NAME=#{tenant_name}"]
      args << "--trace" if Rake.application.options.trace
      if $0 =~ /rake\.bat\Z/i
        Kernel.exec $0, *args
      else
        fork ? ruby(*args) : Kernel.exec(FileUtils::RUBY, *args)
      end
    end

    # We are currently running with no explicit bundler group
    # and/or no explicit environment - we have to reinvoke rake to
    # execute this task.
    def tenant_invoke_or_reboot_rake_task(tenant, task)
      if ENV['RAILS_GROUPS'].to_s.empty? || ENV['RAILS_ENV'].to_s.empty? || ENV['TENANT_NAME'].to_s.empty?
        tenant_ruby_rake_task(tenant, task)
      else
        Rake::Task[task].invoke
      end
    end

    desc "Compile all the assets named in config.assets.precompile"
    task :precompile do
      tenants_root = Rails.root + 'app' + 'tenants'
      unless tenants_root.exist?
        warn "There are no tenants to precompile"
        exit
      end

      tenants_root.children.select{|c| c.directory? }.each do |tenant_path|
        tenant = tenant_path.basename
        puts "Compiling assets for tenant: #{tenant}"

        tenant_invoke_or_reboot_rake_task(tenant.to_s, "tenants:assets:precompile:all")
      end
    end

    namespace :precompile do
      def tenant_internal_precompile(digest=nil)
        unless Rails.application.config.assets.enabled
          warn "Cannot precompile assets if sprockets is disabled. Please set config.assets.enabled to true"
          exit
        end

        # Ensure that action view is loaded and the appropriate
        # sprockets hooks get executed
        _ = ActionView::Base

        config = Rails.application.config
        config.assets.compile = true
        config.assets.digest  = digest unless digest.nil?
        config.assets.digests = {}

        tenant = config.current_tenant_name
        env      = Rails.application.tenants_assets[tenant]
        target   = File.join(Rails.public_path, 'tenants', tenant, config.assets.prefix)
        compiler = Sprockets::StaticCompiler.new(env,
                                                 target,
                                                 config.assets.precompile,
                                                 :manifest_path => config.assets.manifest,
                                                 :digest => config.assets.digest,
                                                 :manifest => digest.nil?)
        compiler.compile
      end

      task :all do
        Rake::Task["tenants:assets:precompile:primary"].invoke
        # We need to reinvoke in order to run the secondary digestless
        # asset compilation run - a fresh Sprockets environment is
        # required in order to compile digestless assets as the
        # environment has already cached the assets on the primary
        # run.
        tenant_ruby_rake_task(ENV['TENANT_NAME'], "tenants:assets:precompile:nondigest", false) if Rails.application.config.assets.digest
      end

      task :primary => ["tenants:assets:environment", "tmp:cache:clear"] do
        tenant_internal_precompile
      end

      task :nondigest => ["tenants:assets:environment", "tmp:cache:clear"] do
        tenant_internal_precompile(false)
      end
    end

    desc "Remove compiled assets"
    task :clean do
      tenants_root = Rails.root + 'app' + 'tenants'
      unless tenants_root.exist?
        warn "There are no tenants to precompile"
        exit
      end

      tenants_root.children.select{|c| c.directory? }.each do |tenant_path|
        tenant = tenant_path.basename
        puts "Cleaning assets for tenant: #{tenant}"

        tenant_invoke_or_reboot_rake_task(tenant.to_s, "tenants:assets:clean:all")
      end
    end

    namespace :clean do
      task :all => ["tenants:assets:environment", "tmp:cache:clear"] do
        config = Rails.application.config
        tenant = config.current_tenant_name
        public_asset_path = File.join(Rails.public_path, 'tenants', tenant, config.assets.prefix)
        rm_rf public_asset_path, :secure => true
      end
    end

    task :environment do
      if Rails.application.config.assets.initialize_on_precompile
        Rake::Task["environment"].invoke
      else
        Rails.application.initialize!(:assets)
        Spree::SpreeLandlord::Assets::Bootstrap.new(Rails.application).run
      end
    end
  end
end
