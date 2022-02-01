namespace :push_line do
  desc "LINE_BOT: 筋トレの通知"
  task push_line_message_musle: :environment do
    message = {
      type: "text",
      text: "今日もしっかり筋トレした？"
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    User.all.each{ |user| client.push_message(user.uid, message)}
  end
end
