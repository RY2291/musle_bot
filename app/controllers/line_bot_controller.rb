class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read
    signature = request.env["HTTP_X_LINE_SIGNATURE"]
    unless client.validate_signature(body, signature)
      error 400 do "Bad Request" end
    end

    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          method = reply_method(event.message['text'])
          message = {
            type: "text",
            text: method
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end
    head :ok
  end
  
  private
  def client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end


  def reply_method(keyword)
    if keyword == "ふくらはぎ"
      <<~TEXT
        ① 立位姿勢で足幅を肩幅程度に開く。
        ② 手を腰に当て胸を張る
        ③ つま先を地面につけたまま、かかとを浮かせる。
        ④ かかとを地面につくギリギリの位置まで下ろす。
      TEXT
    elsif keyword == "太もも"
      <<~TEXT
        15回２セット
        ① よつばいになり、両手は肩の真下にセットする。反り腰にならないようにおへそを引き上げる
        ② 片膝を床から浮かせ、息を吐きながら膝を曲げたまま後ろに蹴り上げる
        ③ 息を吸いながら戻る。15回1セット
        ④ ひと呼吸おいたら、片膝を床から浮かせ、後ろに蹴り上げるときに膝を伸ばす
        ⑤ 息を吸いながら戻る。
      TEXT
    elsif keyword == "お腹"
      <<~TEXT
      10回×3セット
      ①　マットなどを敷き、仰向けに寝っ転がる
      ②　膝を軽く曲げて立てる
      ③　手を開き、体を安定させる
      ④　息を吐きながらゆっくりとお尻を持ち上げる
      ⑤　膝から鎖骨まで一直線になったら、2〜3秒キープする
      ⑥　その後ゆっくりと元に戻す
      ⑦　この動作を10回繰り返す

      〜効果的なトレーニング〜
      お尻を持ち上げる時と元に戻すときは、どちらも3秒ほどを目安にして行うこと
      TEXT
    elsif keyword == "お尻"
      <<~TEXT
      20回×3セット
      ①　足を肩幅か少し広めに広げる
      ②　足先を少しだけ外側に向ける
      ③　背中を曲げずに、ゆっくりと腰を落とす
      ④　③の時、体重はかかとにかけておきましょう
      ⑤　太ももと床が平行になるまで下げ、素早く元に戻す
      ⑥　この動作を20回繰り返す

      〜効果的なトレーニング〜
      目線は前に向けて、背中を丸めないずに、正しいフォームで！！
      TEXT
    elsif keyword == "二の腕" && "肩回り"
      <<~TEXT
        15回３セット
        ①　床やマットの上にうつ伏せになる
        ②　両手を肩幅よりやや広めに開いて地面に付け、足をまっすぐに伸ばす 
        ③  体を浮かせ、つま先と両手で体重を支える
        ④　肘を曲げ、体をゆっくりと真下に落とす
        ⑤　床に付くギリギリまで落としたら、体を起こす 
      TEXT
    else
      "鍛えたい部位を送ってね
      〜〜対応部位〜〜
      ・ふくらはぎ
      ・二の腕
      ・肩回り
      ・太もも
      ・お腹
      ・お尻"
    end
  end
end
