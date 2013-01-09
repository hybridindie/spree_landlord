namespace :spree_landlord do
  namespace :tenant do
    task :create => :environment do
      require 'highline/import'

      def prompt_for_shortname
        ask('Tenant Short Name: ') do |q|
          q.validate = lambda { |a| a.present? }
          q.responses[:not_valid] = 'The short name must be provided'
          q.whitespace = :strip
        end
      end

      def prompt_for_domain
        ask('Tenant Domain: ') do |q|
          q.validate = lambda { |a| a.present? }
          q.responses[:not_valid] = 'The domain must be provided'
          q.whitespace = :strip
        end
      end

      shortname = prompt_for_shortname
      domain = prompt_for_domain

      Spree::Tenant.create!(:shortname => shortname, :domain => domain)
    end
  end
end

namespace :db do
  task :load_file => :reset_column_information do
    Spree::SpreeLandlord::TenantMigrator.new.move_unassigned_to_master
  end

  task :migrate => :reset_column_information

  task :reset_column_information do
    ActiveRecord::Base.send(:subclasses).each do |model|
      model.connection.schema_cache.clear!
      model.reset_column_information
    end
  end
end
