class ApplicationController < ActionController::Base
  include Clearance::Controller

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, notice: exception.message }
    end
  end

  private

  def admin_user
    @admin_user = User.joins(:role).where(role: {name: :admin}).first
  end
end
