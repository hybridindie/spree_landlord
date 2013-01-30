Spree::Admin::VariantsController.class_eval do

  protected

    def new_before
      @object.attributes = @object.product.master.attributes.except('id', 'created_at', 'deleted_at',
                                                                    'sku', 'is_master', 'count_on_hand', 
                                                                    'tenant_id')
    end

end