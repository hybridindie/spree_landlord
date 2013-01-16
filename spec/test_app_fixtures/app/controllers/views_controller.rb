class ViewsController < ApplicationController
  def show
    render params[:view_name]
  end
end
