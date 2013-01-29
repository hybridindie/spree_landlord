require 'spree_core'
require 'spree_promo'

module Spree
  class Landlord

    mattr_accessor :model_names
    @@model_names =
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
