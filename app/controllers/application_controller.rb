# Andre Haas

class ApplicationController < ActionController::Base
  before_action :require_login
  layout 'household'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    def require_login
    # http://guides.rubyonrails.org/action_controller_overview.html
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path # halts request cycle
    end
  end
end
