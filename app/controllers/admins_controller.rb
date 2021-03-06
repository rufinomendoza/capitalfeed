class AdminsController < ApplicationController

before_filter :authenticate_admin!

  def index
    @admins=Admin.page(params[:page]).per_page(50)
    @users=User.page(params[:page]).per_page(50)
  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { 
        if current_admin.god_mode?
          redirect_to admins_path
        else
          redirect_to root_path
        end
      }
      format.json { head :no_content }
    end
  end
end