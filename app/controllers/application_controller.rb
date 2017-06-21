class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :sign_in_if_not_logged

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end


  private

    def sign_in_if_not_logged
      (redirect_to signin_path, :flash => { :error => "You must signin first"}) unless signed_in?
    end

end
