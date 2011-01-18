class OpenIdsController < ApplicationController

  def index
    if using_open_id?
      authenticate_with_open_id(
        params[:openid_identifier],
        OpenId.extention_fields_for(
          params[:openid_identifier],
          :ax => params[:ax],
          :ui => params[:ui],
          :oauth => params[:oauth]
        ).merge(
          :return_to => open_ids_url(:_method => :get)
        )
      ) do |result, identifier, display_identifier, ax_response, oauth_response|
        if result.successful?
          open_id = OpenId.find_or_initialize_by_identifier(identifier)
          open_id.display_identifier = display_identifier
          open_id.ax_response = ax_response
          open_id.oauth_response = oauth_response
          open_id.save!
          session[:openid_identifier] = identifier
        else
          render :text => "OpenID Authentication Failed", :status => 401
        end
      end
    end
    @redirect_uri = session_path
  end

  def show
    redirect_to open_ids_url(
      :openid_identifier => OpenId.op_identifier_for(params[:id]),
      :ax => params[:ax],
      :ui => params[:ui],
      :oauth => params[:oauth]
    )
  end

end
