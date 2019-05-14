json.extract! news, :id, :postdate, :posttime, :title, :body, :tab, :picture, :created_at, :updated_at
json.url news_url(news, format: :json)
