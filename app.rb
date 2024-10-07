require 'sinatra'
require 'httparty'
require 'json'
require 'date'

set :layout, :layout

# Get the API key from an environment variable
API_KEY = ENV['NASA_API_KEY']

# route to display the home page
get '/' do
  @title = "NASA's Astronomy Picture of the Day"

  # Always fetch today's APOD
  today = Date.today.strftime("%Y-%m-%d")
  @apod_data = fetch_apod(today)

  erb :index
end

# route to fetch APOD by date
get '/fetch' do
  date = params[:date]
  @apod_data = fetch_apod(date)

  if @apod_data.nil?
    @error = "Unable to fetch NASA APOD for the given date. Please try again."
  end

  @title = "NASA's Astronomy Picture of the Day for #{date}"
  erb :index
end

# route to fetch a random APOD
get '/random' do
  random_date = random_date_generator
  @apod_data = fetch_apod(random_date)

  if @apod_data.nil?
    @error = "Unable to fetch NASA APOD for a random date. Please try again."
  end

  @title = "NASA's Astronomy Picture of the Day for #{random_date}"
  erb :index
end

# helper method to fetch APOD data
def fetch_apod(date)
  response = HTTParty.get("https://api.nasa.gov/planetary/apod?api_key=#{API_KEY}&date=#{date}")
  response.code == 200 ? JSON.parse(response.body) : nil
end

# helper method to generate a random date
def random_date_generator
  start_date = Date.parse("1995-06-16") # APOD started on this date
  end_date = Date.today
  random_date = start_date + rand((end_date - start_date).to_i)
  random_date.strftime("%Y-%m-%d") # Format the date as YYYY-MM-DD
end