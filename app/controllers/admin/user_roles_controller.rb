class Admin::UserRolesController < Admin::BaseController

  before_filter :set_user

  def create
    selected_role = params[:user_role][:role_name]
    if @user.has_role?(selected_role)
      flash[:error] = "#{selected_role} role is already given to user : #{@user.full_name}"
    else
      @user.user_roles.create!(role_name: selected_role) if Role.all.include? selected_role
      flash[:success] = "#{selected_role} role is given to user : #{@user.full_name} successfuly"
    end

    redirect_to admin_user_user_roles_path(@user.id)
  end

  def index
    @roles = Role.all - @user.user_roles.map{|u| u[:role_name]}
  end

  def destroy

    if @user.user_roles.destroy(params[:id])
      flash[:success] = "role has been removed from user : #{@user.full_name} successfuly"
    end

    redirect_to admin_user_user_roles_path(@user.id)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end