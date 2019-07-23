#!/usr/bin/env ruby

require 'slideshare_search'
require 'slack-notifier'

WEBHOOK_URL = ''
API_KEY     = ''
SECRET_KEY  = ''

notifier = Slack::Notifier.new WEBHOOK_URL
date = (Date.today - 1).to_s
client = SlideshareSearch::Client.new(API_KEY, SECRET_KEY, date)

keywords = []
keywords << { query: 'hoge', channel: 'piyo' }

keywords.each do |keyword|
  message = []
  response_objects = client.search(keyword[:query])

  response_objects.each do |obj|
    message << '-' * 30
    message << "*#{obj.title}*"
    message << "表示回数: #{obj.num_views}"
    message << "作成日: #{obj.created.strftime('%Y-%m-%d')}"
    message << obj.url
  end

  notifier.ping message.join("\n"), channel: "##{keyword[:channel]}" unless message.empty?
end
