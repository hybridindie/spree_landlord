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