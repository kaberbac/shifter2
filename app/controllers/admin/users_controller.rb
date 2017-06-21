class Admin::UsersController < Admin::BaseController
  before_filter :set_user, :except=>[:index, :new, :create]

  def index
    @users = User.all
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
    user_update(params[:user], 'Update succeeded!', 'edit' )
  end

  def edit
  end

  def destroy
    @user.destroy

    redirect_to admin_users_path
  end

  def show
  end


  private

  def set_user
    @user = User.find params[:id]
  end

  def user_update(params, msg, goto )
    if @user.update_attributes(params)
      if @user == current_user
        cookies.permanent[:remember_token] = @user.remember_token
      end
      flash[:success] = msg
      redirect_to admin_user_path(@user)
    else
      render goto
    end
  end

end
