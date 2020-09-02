class Api::V1::FeedsController < ApplicationController
  def sort
  end

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
        # :image => item.image.url,
        :title => item.title,
        :url => item.url,
        :summary => item.summary,
        :published => item.published.to_time.strftime("%Y-%m-%d %H:%M:%S")
      ]
    end

    # if !obj.image.url?
    #   imageUrl = obj.image.url
    # end

    render :json => {
      feed: {
        id: params[:id],
        url: obj.url,
        title: obj.title,
        # image: obj.image.url,
        items: items
      }
    }
  end

  def index
    user = User.find(1)
    feeds = user.feeds.all
    render :json => { status: 'success', data: feeds }
  end

  private

  def feed_params
    params.require(:feed).permit(:url)
  end
end
