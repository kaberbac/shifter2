class Admin::UsersController < Admin::BaseController
  before_filter :set_user, :except=>[:index, :new, :create]

  def activate
    change_state('active')
  end

  def inactivate
    change_state('inactive')
  end

  def index
    @users = User.paginate(page: params[:users_page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = 'user created successfuly'
      redirect_to admin_user_path(@user)
    else
      render 'new'
    end
  end

  def update
    if @user.update_attributes(params[:user])
      remember_token_refresh
      flash[:success] = 'Update succeeded!'
      redirect_to admin_user_path(@user)
    else
      render 'edit'
    end
  end

  def edit
  end

  def destroy
    @user.destroy

    redirect_to admin_users_path
  end

  def show
    redirect_to admin_user_user_roles_path(@user.id)
  end


  private

  def set_user
    @user = User.find params[:id]
  end

  def change_state(state)
    if current_user.is_admin?
      if @user.update_attributes(state: state)
        remember_token_refresh
        flash[:success] = 'user state updated successfully'
      else
        flash[:error] = 'failed to update user state'
      end
    else
      flash[:error] = 'Only admin can change user state'
    end

    redirect_to admin_users_path
  end

  def remember_token_refresh
    if @user == current_user
      cookies.permanent[:remember_token] = @user.remember_token
    end
  end

end
