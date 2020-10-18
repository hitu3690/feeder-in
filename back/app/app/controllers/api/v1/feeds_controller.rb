
class Api::V1::FeedsController < ApplicationController
  before_action :valid_url, only: [:create]
  # require 'nokogiri'
  # require 'open-uri'

  def create
    if @feed.save
      render :json => { status: 'success', id: @feed.id }
    else
      render :json => { status: 'error' }
    end
  end

  # 1URLの記事たち
  def show
    feed = Feed.find_by(id: params[:id])
    xml = HTTParty.get(feed.url).body
    logger.debug("~~~~~~~~~~~~~~~")
    logger.debug("~~~~~~~~~~~~~~~")
    logger.debug(xml)
    logger.debug("---------------")
    logger.debug("---------------")
    obj = Feedjira.parse(xml)

    # doc = Nokogiri::HTML.parse(obj)
    # doc.css('img').each do |src|
    # end

    # img_tags = obj.entries.map do |entry|
    #   Nokogiri::HTML.parse(entry.summary).css('img').to_html
    # end
    img = []
    obj.entries.each do |entry|
      Nokogiri::HTML.parse(entry.summary).css('img').each do |src|
        img = src[:src]
      end
    end

    # logger.debug(img_tags[:src])

    # doc = Nokogiri::XML.parse(open("http://www.webcreatorbox.com/feed/").read)
    # doc.xpath('//channel/item').map do |item|
    #   Nokogiri::HTML.parse(item.xpath('description').text).css('img').to_html
    # end

    items = []
    obj.entries.each do |item|
      items += [
        :title => item.title,
        :url => item.url,
        :summary => item.summary,
        :published => item.published.to_time.strftime("%Y-%m-%d %H:%M:%S")
      ]
    end

    render json: {
      feed: {
        id: params[:id],
        url: obj.url,
        title: obj.title,
        items: items,
        image: img,
        show: false,
      },
    }
    # feeds = Feed.where(user_id: params[:user_id]).order(sort_id: :ASC)
    # feeds.each do |feed|
    #   xml = HTTParty.get(feed.url).body
    #   obj = Feedjira.parse(xml)
    #   items = []
    #   obj.entries.each do |item|
    #     items += [
    #       :title => item.title,
    #       :url => item.url,
    #       :summary => item.summary,
    #       :published => item.published.to_time.strftime("%Y-%m-%d %H:%M:%S")
    #     ]
    #   end
    #
    #   render :json => {
    #     feed: {
    #       id: params[:id],
    #       url: obj.url,
    #       title: obj.title,
    #       items: items
    #     }
    #   }
    # end
  end

  def sort
    current_user = User.find(1)
    params[:feed].each_with_index do |item, i|
      feed = current_user.feeds.find(item[:id])
      feed.update(sort_id: i)
    end
    render :json => { status: 'success' }
  end

  def index
    # user = User.find(1)
    # current_user = User.find_by(id: session[:user_id])
    # feeds = current_user.feeds.order(sort_id: :ASC)
    current_user = User.find_by(id: 1)
    if current_user
      feeds = current_user.feeds.order(sort_id: :ASC)
      render :json => { status: 'success', data: feeds }
    else
      render :json => { status: 'error', data: "ログインしてください" }
    end
  end

  def destroy
    current_user = User.find(1)
    feed = current_user.feeds.find_by(id: params[:id])
    # feed = current_current_user.feeds.find_by(id: params[:id])
    if feed.destroy
      render :json => { status: 'sccess' }
    else
      render :json => { status: 'error' }
    end
  end

  private

  def feed_params
    params.require(:feed).permit(:url, :user_id)
  end

  def valid_url
    # RSS URLかどうかの判別
    begin
      # feed = current_current_user.feeds.build(feed_params)
      current_user = User.find(1)
      @feed = current_user.feeds.build(feed_params)
      xml = HTTParty.get(@feed.url).body
      obj = Feedjira.parse(xml)
    rescue => error
      return render :json => { status: error }
    end
  end

end
