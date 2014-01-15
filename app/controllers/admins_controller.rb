class AdminsController < ApplicationController

before_filter :authenticate_admin!

  def index
    @admins=Admin.all
    @users=User.all
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to admins_path }
      format.json { head :no_content }
    end
  end
end