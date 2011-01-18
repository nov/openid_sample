class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :discoverable

  def discoverable(format = :xrds)
    response.headers["X-XRDS-Location"] = discovery_url(:format => format)
  end

end
