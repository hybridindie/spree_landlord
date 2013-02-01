module Spree
  Landlord.model_names.each do |model|
    Spree::SpreeLandlord.decorate_model(model)
  end
end
