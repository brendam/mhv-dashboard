require 'instagram'

require 'dotenv'
Dotenv.load

# Instagram Client ID from http://instagram.com/developer
Instagram.configure do |config|
  config.client_id = ENV['INSTAGRAM_CLIENT_ID'] 
end

location_id = 264518388 # makehackvoid

SCHEDULER.every '10m', :first_in => 0 do |job|
  photos = Instagram.location_recent_media(location_id)
  if photos
    photos.map! do |photo|
      { photo: "#{photo.images.standard_resolution.url}" }
    end    
  end
  send_event('instadash', photos: photos)
end