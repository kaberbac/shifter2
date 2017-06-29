class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :sign_in_if_not_logged, :set_locale

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end


  private

  def sign_in_if_not_logged
    (redirect_to signin_path, :flash => { :error => "You must signin first"}) unless signed_in?
  end

  def set_locale
    if cookies[:educator_locale] && I18n.available_locales.include?(cookies[:educator_locale].to_sym)
      l = cookies[:educator_locale].to_sym
    else
      l = I18n.default_locale
      cookies.permanent[:educator_locale] = l
    end
    I18n.locale = l
  end

end
