class Admin::UserRolesController < Admin::BaseController

  before_filter :set_user, :require_admin
  before_filter :set_user_role_manager, only: [:create_workplace, :index]

  def create_workplace
    selected_workplace = params[:user_role][:workplace_id]
    @user_role_manager = UserRole.new(user_id: @user.id, role_name: Role.get_manager!, workplace_id: selected_workplace)
    if @user_role_manager.save
      flash[:success] = "#{selected_workplace} workplace is given to manager : #{@user.full_name} successfuly"
    else
      flash[:error] = @user_role_manager.errors.full_messages.join('. ')
    end

    redirect_to admin_user_user_roles_path(@user.id)
  end

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
    @user_role_workplaces_assigned = UserRole.where('workplace_id IS NOT NULL AND user_id=?', @user.id)
    if @user_role_workplaces_assigned.present?
      @user_workplaces_not_assigned = Workplace.where('id NOT IN (?)',@user_role_workplaces_assigned.pluck(:workplace_id))
    else
      @user_workplaces_not_assigned = Workplace.all
    end
    @roles = Role.all - @user.user_roles.map{|u| u[:role_name]}

  end

  def destroy

    user_role = @user.user_roles.find(params[:id])
    if user_role.is_last_admin?
      user_role.destroy
      flash[:success] = "role has been removed from user : #{@user.full_name} successfuly"
    else
      flash[:error] = user_role.errors.full_messages.join('. ')
    end

    redirect_to admin_user_user_roles_path(@user.id)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_role_manager
    @user_role_manager = @user.user_roles.find_by_role_name('manager')
  end


  def require_admin
    if !current_user.is_admin?
      flash[:error] = 'only admin can manage roles'
      redirect_to admin_users_path
      return false
    end
  end

end