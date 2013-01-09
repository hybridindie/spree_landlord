Spree::User.class_eval do
  # ugly hack to remove the uniqueness validator on email
  _validate_callbacks.reject! do |callback|
    callback.raw_filter.kind_of?(ActiveRecord::Validations::UniquenessValidator) &&
      callback.raw_filter.attributes == [:email]
  end

  validates :email, :uniqueness => { :scope => :tenant_id, :allow_blank => true, :if => :email_changed? }
end
