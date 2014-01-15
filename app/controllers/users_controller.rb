class UsersController < ApplicationController

before_filter :authenticate_admin!

  def index
    @users=User.page(params[:page]).per_page(50)
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

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