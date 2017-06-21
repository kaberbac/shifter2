class Admin::UsersController < Admin::BaseController
  before_filter :set_user, :except=>[:index, :new, :create]
  skip_before_filter :sign_in_if_not_logged, :all

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "user created successfuly"
      redirect_to admin_user_path(@user)
    else
      render 'new'
    end
  end

  def update
    user_update(params[:user], "Update succeeded!", 'edit' )
  end

  def edit
  end

  def destroy
    @user.destroy

    redirect_to admin_users_path
  end

  def show
  end


  # TODO create UserRolesController and remove those actions from this controller
  # (add_role, edit_role and delete_role should be transferred to their own controller)
  def add_role
    role = Role.find_by_name params[:role]
    @user.roles.push role if role
    redisplay_roles
  end

  def edit_role
    @roles = Role.all
  end

  def delete_role
    @user.roles.delete(Role.find params[:role])
    redisplay_roles
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_update(params, msg, goto )
    if @user.update_attributes(params)
      # cookies.permanent[:remember_token] = @user.remember_token
      flash[:success] = msg
      redirect_to admin_user_path(@user)
    else
      render goto
    end
  end

  def redisplay_roles
    respond_to do |format|
      format.html { redirect_to [:admin, @user] }
      format.js { render :redisplay_roles }
    end
  end
end
