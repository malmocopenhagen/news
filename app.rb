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


get "/" do
 view "app"
end

get "/news" do

#DATES

@day1 = Date.today + 1
@day2 = Date.today + 2
@day3 = Date.today + 3
@day4 = Date.today + 4
@day5 = Date.today + 5

#COUNTRY CODE

    #LOCATION
    @location = params["location"]
    @results = Geocoder.search(params["location"])
    @lat_long = @results.first.coordinates
    @lat = @lat_long[0]
    @long = @lat_long[1]
    country = HTTParty.get("http://api.geonames.org/countryCodeJSON?lat=#{@lat}&lng=#{@long}&username=mctest").parsed_response.to_hash
    @ccode = country["countryCode"]
    @cname = country["countryName"]

    #CURRENT WEATHER
    @forecast = ForecastIO.forecast(@lat,@long).to_hash
    @curr_temp = @forecast["currently"]["temperature"].round(0)
    @curr_summ = @forecast["currently"]["summary"]

    #FORECAST WEATHER
    @forecast_array = @forecast["daily"]["data"] 

    #TOP STORIES
    news = HTTParty.get("https://newsapi.org/v2/top-headlines?country=#{@ccode}&apiKey=355e47f0870940428fb699c299873dcf").parsed_response.to_hash
    @articles = news["articles"]
        view "app_news"

end
