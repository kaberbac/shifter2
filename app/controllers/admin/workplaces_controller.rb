class Admin::WorkplacesController < Admin::BaseController

  before_filter :require_admin
  before_filter :set_workplace, :except=>[:index, :new, :create]

  def new
    @workplace = Workplace.new
  end

  def create
    @workplace = Workplace.new(params[:workplace])
    if @workplace.save
      flash[:success] = 'workplace created successfuly'
      redirect_to admin_workplaces_path
    else
      render 'new'
    end
  end

  def index
    @workplaces = Workplace.paginate(page: params[:workplaces_page])
  end

  def destroy
    if @workplace.destroy
      flash[:success] = 'Deleted successfuly'
    else
      flash[:error] = 'Failed to delete!'
    end
    redirect_to admin_workplaces_path
  end

  def update
    if @workplace.update_attributes(params[:workplace])
      flash[:success] = 'Update succeeded!'
      redirect_to admin_workplace_path(@workplace)
    else
      render 'edit'
    end
  end

  def edit
  end

  private

  def set_workplace
    @workplace = Workplace.find(params[:id])
  end

  def require_admin
    if !current_user.is_admin?
      flash[:error] = 'only admin can manage workplaces'
      redirect_to admin_users_path
      return false
    end
  end

end