require 'spec_helper'

describe Spree::Admin::UsersController do
  it 'prevents admin users from granting super admin'
  it 'prevents customer users from granting super admin'
  it 'prevents admin users from editing super admin'
  it 'prevents customer users from editing super admin'
end
