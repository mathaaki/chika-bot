require 'slack-ruby-client'

Slack.configure do |conf|
  # 先ほど控えておいたAPI Tokenをセット
  conf.token = ENV['SLACK_TOKEN']
end

# RTM Clientのインスタンスを生成
client = Slack::RealTime::Client.new

# message eventを受け取った時の処理
client.on :message do |data|
  case data['text']
  when '<@U3F9CMFHA> ping' then
    client.message channel: data['channel'], text: "<@#{data['user']}> 仕事してるか？"
  when /帰/ then
    client.message channel: data['channel'], text: "<@#{data['user']}> 打刻したか？"
  end
end

# Slackに接続
client.start!
