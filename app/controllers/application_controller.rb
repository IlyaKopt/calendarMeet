class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, unless: :home_controller?

  before_action :configure_devise_permitted_parameters, if: :devise_controller?


  private
    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end

    def after_sign_in_path_for(resource)
      request.env['omniauth.origin'] || stored_location_for(resource) || redirect_path
    end

    def after_sign_up_path_for(resource)
      request.env['omniauth.origin'] || stored_location_for(resource) || redirect_path
    end

  protected

    def configure_devise_permitted_parameters
      registration_params = [ :email, :password, :password_confirmation ]

      if params[:action] == 'update'
        devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(registration_params << :current_password) }
      elsif params[:action] == 'create'
        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(registration_params) }
      end
    end

    def home_controller?
      controller_name == 'home'
    end

end
