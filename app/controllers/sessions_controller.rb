class SessionsController < ApplicationController
  before_filter :require_authentication, :except => :new

  def show
  end

  def new
  end

  def destroy
    @open_id.destroy
    session[:openid_identifier] = nil
    redirect_to root_url
  end

  private

  def require_authentication
    unless session[:openid_identifier] && (@open_id = OpenId.find_by_identifier(session[:openid_identifier]))
      redirect_to root_url
      return false
    end
  end

end
