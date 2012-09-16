class ApplicationController < ActionController::Base

  helper_method :logged_in?

  def welcome; end

  private

  def logged_in?
    true
  end

end
