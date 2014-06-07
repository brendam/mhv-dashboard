#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

# Track public available information of a twitter user like follower, follower
# and tweet count by scraping the user profile page.

# Config
# ------
twitter_username = 'makehackvoid'

tweets = 0
followers = 0
following = 0
SCHEDULER.every '1d', :first_in => 0 do |job|
  last_tweets = tweets
  last_followers = followers
  last_following = following
  doc = Nokogiri::HTML(open("https://twitter.com/#{twitter_username}"))
  tweets = doc.css('li.ProfileNav-item--tweets .ProfileNav-value').first().content
  followers = doc.css('li.ProfileNav-item--followers .ProfileNav-value').first().content
  following = doc.css('li.ProfileNav-item--following .ProfileNav-value').first().content

  send_event('twitter_user_tweets', current: tweets, last: last_tweets)
  send_event('twitter_user_followers', current: followers, last: last_followers)
  send_event('twitter_user_following', current: following, last: last_following)
end