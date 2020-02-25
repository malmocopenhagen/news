require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "date"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

#Pull in APIs
ForecastIO.api_key = "01f449814d30b3055a15ee705aa6f4a5"
news = HTTParty.get("https://newsapi.org/v2/top-headlines?country=us&apiKey=355e47f0870940428fb699c299873dcf").parsed_response.to_hash



get "/" do
 view "app"
end

get "/news" do

#DATES
    #LOCATION
    @location = params["location"]
    @results = Geocoder.search(params["location"])
    @lat_long = @results.first.coordinates
    @lat = @lat_long[0]
    @long = @lat_long[1]

    #CURRENT WEATHER
    @forecast = ForecastIO.forecast(@lat,@long).to_hash
    @curr_temp = @forecast["currently"]["temperature"]
    @curr_summ = @forecast["currently"]["summary"]

    #FORECAST WEATHER
    @forecast_array = @forecast["daily"]["data"] 

    #TOP STORIES
    @articles = news["articles"]
    view "app_news"

end
