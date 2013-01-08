Spree::Product.class_eval do
  # ugly hack to remove the uniqueness validator on permalink
  _validate_callbacks.reject! do |callback|
    callback.raw_filter.kind_of?(ActiveRecord::Validations::UniquenessValidator) &&
      callback.raw_filter.attributes == [:permalink]
  end

  validates :permalink, :uniqueness => { :scope => :tenant_id }
end
