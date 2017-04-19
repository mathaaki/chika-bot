require 'slack-ruby-client'

Slack.configure do |conf|
  # 先ほど控えておいたAPI Tokenをセット
  conf.token = ENV['SLACK_TOKEN']
end

# RTM Clientのインスタンスを生成
client = Slack::RealTime::Client.new

HelpMessage = <<-HELP
  ping                        chika-botが仕事しているか聞いてくるコマンド。主にBotが生きているかの確認に使う。
  for_newcomers               新人諸君に是非読んでほしい記事群。
  -h                          help機能ぞ。
  「帰」を含む文字列          打刻したか聞いてくる。雑機能。
  「# + 5桁数字」を含む文字列 Nacl開発組が用いてるRedmineのチケットURLを表示。存在しないチケットの場合も表示する。雑。
HELP

# message eventを受け取った時の処理
client.on :message do |data|
  case data['text']
  when '<@U3F9CMFHA> ping' then
    client.message channel: data['channel'], text: "<@#{data['user']}> 仕事してるか？"
  when '<@U3F9CMFHA> -h' then
    client.message channel: data['channel'], text: HelpMessage
  when /帰/ then
    client.message channel: data['channel'], text: "<@#{data['user']}> 打刻したか？"
  when /#(\d{5})/ then
    client.message channel: data['channel'], text: ENV['REDMINE_URL'] + "issues/#{$1}"
  when '<@U3F9CMFHA> for_newcomers' then
    client.message channel: data['channel'], text: "http://qiita.com/Mic-U/items/f9de1c08c47c50620905"
    client.message channel: data['channel'], text: "http://qiita.com/STEEL_PLUS/items/c3f8d0d7d9588094686d"
    client.message channel: data['channel'], text: "http://qiita.com/advent-calendar/2016/freshman_engineer"
    client.message channel: data['channel'], text: "↑新人諸君読んでおくように！"
  end
end

# Slackに接続
client.start!
