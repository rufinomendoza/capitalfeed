class PagesController < ApplicationController
  def splash
    if signed_in? || admin_signed_in?
      redirect_to musings_url
    end
  end
end
