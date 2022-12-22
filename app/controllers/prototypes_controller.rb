class PrototypesController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :move_to_index, except: [:index, :show]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototypes = Prototype.new(prototype_params)
    if @prototypes.save
      redirect_to prototypes_path(@prototypes)
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end  

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototypes = Prototype.find(params[:id])
    @prototypes.update(prototype_params)
    if @prototypes.save
      redirect_to prototype_path(@prototypes)
    else
      render :edit
    end
  end

  def destroy
    @prototypes = Prototype.find(params[:id])
    @prototypes.destroy
    redirect_to prototypes_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept).merge(user_id: current_user.id)
  end
  
  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end
