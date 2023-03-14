class EntriesController < ApplicationController

  PAGINATION_AMOUNT = 5

  def index
    @pagination_amount = PAGINATION_AMOUNT

    unless params[:pagination]
      params[:pagination] = 0
    end

    @entries = Entry.all
    handle_filtering
    @entries = @entries.sort_by { |e| e.title }
    handle_pagination
  end

  def new
    @entry = Entry.new
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
    params.require(:entry).permit(:title, :url, :tag_list, :notes)
  end

  def handle_filtering
    filter_title
    filter_tags
  end

  def filter_title
    if params[:search_by_title] && params[:search_by_title] != ""
      @entries = @entries.where("LOWER(title) LIKE ?", "%#{params[:search_by_title].downcase}%")
    end
  end

  def filter_tags
    if params[:search_by_tags] && params[:search_by_tags] != ""
      @filter_tags = params[:search_by_tags].split(',')
      @entries = @entries.select { |e| !(e.tag_list_a & @filter_tags).empty? }
    end
  end

  def handle_pagination
    if params[:pagination]
      unless params[:pagination] == "all"
        current = params[:pagination].to_i
        @max_pagination = (@entries.length.to_f / PAGINATION_AMOUNT).ceil
        @paginate_left = current > 0 ? current -1 : nil
        @paginate_right = current < @max_pagination - 1 ? current + 1 : nil
        @current_page = current + 1
        @entries = @entries.slice(PAGINATION_AMOUNT * current, PAGINATION_AMOUNT).to_a
      end
    end
  end
end