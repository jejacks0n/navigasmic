class ApplicationController < ActionController::Base
  layout "application"

  helper_method :logged_in?

  def welcome; end
  def index; end
  def show; end

  private

    def logged_in?
      true
    end
end
