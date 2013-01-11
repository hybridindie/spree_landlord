Spree::Admin::UsersController.class_eval do
  before_filter :check_authorization

  update.before :check_authorization_for_grant_super_admin

  protected

  def check_authorization
    load_resource
    resource = @user || Spree::User.new
    action = params[:action].to_sym

    authorize! action, resource
  end

  def check_authorization_for_grant_super_admin
    if params[:user][:super_admin]
      authorize! :grant_super_admin, @user
    end
  end
end
