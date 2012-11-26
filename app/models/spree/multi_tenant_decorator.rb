module Spree
  Spree::Landlord.model_names.each do |model|
    model.class_eval do

      attr_protected :tenant_id
      belongs_to  :tenant
      validates :tenant_id, presence: true

      default_scope lambda { where( "#{table_name}.tenant_id = ?", Thread.current[:tenant_id] ) }

      before_validation(:on => :create) do |obj|
        obj.tenant_id = Thread.current[:tenant_id]
      end

      before_save do |obj|
        obj.tenant_id = Thread.current[:tenant_id]
      end

    end
  end
end