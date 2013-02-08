require 'spree_core'
require 'spree/core'
require 'spree_promo'

module Spree
  module SpreeLandlord

    def self.model_names
      default_spree_models + @@model_names
    end

    def self.register_tenanted_model!(klass)
      @@model_names.push klass
    end
    
    @@model_names = []

    def self.default_spree_models
      [ Spree::Activator,
        Spree::Address,
        Spree::Adjustment,
        Spree::Asset,
        Spree::Calculator,
        Spree::Configuration,
        Spree::Country,
        Spree::Gateway,
        Spree::InventoryUnit,
        Spree::LineItem,
        Spree::LogEntry,
        Spree::MailMethod,
        Spree::OptionType,
        Spree::OptionValue,
        Spree::Order,
        Spree::PaymentMethod,
        Spree::Payment,
        Spree::Preference,
        Spree::ProductOptionType,
        Spree::ProductProperty,
        Spree::Product,
        Spree::PromotionActionLineItem,
        Spree::PromotionAction,
        Spree::PromotionRule,
        Spree::Property,
        Spree::Prototype,
        Spree::ReturnAuthorization,
        Spree::Role,
        Spree::Shipment,
        Spree::ShippingCategory,
        Spree::ShippingMethod,
        Spree::StateChange,
        Spree::State,
        Spree::TaxCategory,
        Spree::TaxRate,
        Spree::Taxonomy,
        Spree::Taxon,
        Spree::TokenizedPermission,
        Spree::Tracker,
        Spree.user_class,
        Spree::Variant,
        Spree::ZoneMember,
        Spree::Zone ]
    end
    

    def self.decorate_model(model)
        model.class_eval do

          attr_protected :tenant_id
          belongs_to  :tenant, class_name: "Spree::Tenant"

          if model.table_exists? && model.column_names.include?('tenant_id')
            validates :tenant_id, presence: true
          end

          default_scope lambda {
            if Spree::Tenant.table_exists? && column_names.include?('tenant_id')
              where( "#{table_name}.tenant_id = ?", Spree::Tenant.current_tenant_id )
            end
          }

          before_validation(:on => :create) do |obj|
            if obj.class.column_names.include?('tenant_id')
              obj.tenant_id ||= Spree::Tenant.current_tenant_id
            end
          end

          def tenant
            tenant_attribute = read_attribute(:tenant_id)
            unless tenant_attribute.present?
              write_attribute(:tenant_id, Spree::Tenant.current_tenant_id)
            end

            super
          end

          def preference_cache_key(name)
            return unless id
            if self.class.column_names.include?('tenant_id')
              [tenant_id, self.class.name, name, id].join('::').underscore
            else
              [self.class.name, name, id].join('::').underscore
            end
          end
        end
    end

    # This is the default way to configure spree_landlord. Create an initializer in 
    # your app and define a setup like this:
    #
    # Spree::SpreeLandlord.setup do |config|
    #   yada.. yada..
    # end
    def self.setup
      yield self
    end
  end
end

require "spree/spree_landlord/landlord"
require 'spree/spree_landlord/engine'
