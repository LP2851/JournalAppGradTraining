class EntriesController < ApplicationController
  def index
    @entries = Entry.all
  end

  def new
    @entry = Entry.new()
  end

  def create
    @entry = Entry.new(entry_params)
    @is_new = true
    if @entry.save
      redirect_to root_url
    else
      render :edit
    end
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def edit
    @entry = Entry.find(params[:id])
    @is_new = false
    render :edit
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.update(params.require(:entry).permit(:title, :url))
      flash[:success] = "To-do item successfully updated!"
      redirect_to entry_url(@entry)
    else
      flash.now[:error] = "To-do item update failed"
      render :edit
    end
  end

  def destroy
    Entry.find(params[:id]).destroy
    redirect_to root_url
  end

  private

  def entry_params
    params.require(:entry).permit(:title, :url)
  end

end