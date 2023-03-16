class EntriesController < ApplicationController

  PAGINATION_AMOUNT = 5

  def index
    check_auth
    @pagination_amount = PAGINATION_AMOUNT

    unless params[:pagination]
      params[:pagination] = 0
    end

    @entries = Entry.all
    handle_filtering
    @entries = @entries.sort_by { |e| e.title.downcase }
    handle_pagination
  end

  def new
    check_auth
    if helpers.logged_in?
      @entry = Entry.new
      @is_new = true
      render :edit
    end
  end

  def create
    check_auth
    @entry = Entry.new(entry_params)
    @is_new = true
    if @entry.save
      redirect_to root_url
    else
      render :edit
    end
  end

  def show
    check_auth
    @entry = Entry.find(params[:id])
  end

  def edit
    check_auth
    @entry = Entry.find(params[:id])
    if helpers.logged_in?
      render :edit
    end
  end

  def update
    check_auth
    @entry = Entry.find(params[:id])
    if @entry.update(entry_params)
      flash[:success] =
      redirect_to entry_url(@entry)
    elsif helpers.logged_in?
      flash.now[:error] =
      render :edit
    end
  end

  def destroy
    check_auth
    EntryTagging.where("entry_id = #{params[:id]}").each do |e|
      e.destroy
    end

    Entry.find(params[:id]).destroy
    redirect_to root_url
  end

  private

  def check_auth
    unless helpers.logged_in?
      redirect_to "/login"
    end
  end

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