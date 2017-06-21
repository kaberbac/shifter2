class Admin::UserRolesController < Admin::BaseController

  before_filter :set_user

  def create
    selected_role = params[:user_role][:role_name]

    @user_role = @user.user_roles.new(role_name: selected_role)
    if @user_role.save
      flash[:success] = "#{selected_role} role is given to user : #{@user.full_name} successfuly"
    else
      flash[:error] = @user_role.errors.full_messages.join('. ')
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