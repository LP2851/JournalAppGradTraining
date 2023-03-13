class EntriesController < ApplicationController
  def index
    @entries = Entry.all.sort_by { |e| e.title }
    if params[:search_by_title] && params[:search_by_title] != ""
      @entries = @entries.where("LOWER(title) LIKE ?", "%#{params[:search_by_title].downcase}%")
    end

    p params[:search_by_tags]
    if params[:search_by_tags] && params[:search_by_tags] != ""
      @filter_tags = params[:search_by_tags].split(',')
      @entries = @entries.select { |e| !(e.tag_list_a & @filter_tags).empty? }
    end
  end

  def new
    @entry = Entry.new()
    @is_new = true
    render :edit
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
    render :edit
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.update(entry_params)
      flash[:success] =
      redirect_to entry_url(@entry)
    else
      flash.now[:error] =
      render :edit
    end
  end

  def destroy
    Entry.find(params[:id]).destroy
    redirect_to root_url
  end

  private

  def entry_params
    params.require(:entry).permit(:title, :tag_list, :notes)
  end
end