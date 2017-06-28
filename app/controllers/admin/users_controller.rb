class Admin::UsersController < Admin::BaseController
  before_filter :set_user, :except=>[:index, :new, :create]

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
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
      if @user == current_user
        cookies.permanent[:remember_token] = @user.remember_token
      end
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

end
