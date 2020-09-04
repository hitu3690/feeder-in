class Api::V1::FeedsController < ApplicationController
  def create
    begin
      # feed = current_user.feeds.build(feed_params)
      user = User.find(1)
      feed = user.feeds.build(feed_params)
      xml = HTTParty.get(feed.url).body
      obj = Feedjira.parse(xml)
    rescue => error
      return render :json => { status: error }
    end

    if feed.save
      render :json => { status: 'success', id: feed.id }
    else
      render :json => { status: 'error' }
    end
  end

  # 1URLの記事たち
  def show
    feed = Feed.find_by(id: params[:id])
    xml = HTTParty.get(feed.url).body
    obj = Feedjira.parse(xml)
    items = []
    obj.entries.each do |item|
      items += [
        :title => item.title,
        :url => item.url,
        :summary => item.summary,
        :published => item.published.to_time.strftime("%Y-%m-%d %H:%M:%S")
      ]
    end

    render :json => {
      feed: {
        id: params[:id],
        url: obj.url,
        title: obj.title,
        items: items
      }
    }
  end

  def sort
    user = User.find(1)
    params[:feed].each_with_index do |item, i|
      feed = user.feeds.find(item[:id])
      feed.update(sort_id: i)
    end
    render :json => { status: 'success' }
  end

  def index
    user = User.find(1)
    feeds = user.feeds.order(sort_id: :ASC)
    render :json => { status: 'success', data: feeds }
  end

  def destroy
    user = User.find(1)
    feed = user.feeds.find_by(id: params[:id])
    if feed.destroy
      render :json => { status: 'sccess' }
    else
      render :json => { status: 'error' }
    end
  end

  private

  def feed_params
    params.require(:feed).permit(:url)
  end

end
