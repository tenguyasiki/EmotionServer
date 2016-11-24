# Remote Sensors Protocol - Scratch Wiki
# https://wiki.scratch.mit.edu/wiki/Remote_Sensors_Protocol

class RemoteSensorsProtocolParser
  
  def parse(message)
    # 先頭の4バイトはメッセージ長なのでカットする
    message = message[4..message.size]
    
    # 「broadcast 」以降の「"」で囲われた部分を取得（「broadcast」の大文字小文字は問わない）
    match_data = message.match(/broadcast "(.+?)"/i)
    
    if match_data.nil?
      return nil
    else
      # エンコーディングが「ASCII-8BIT」なので「UTF-8」に変換しておく
      return match_data[1].force_encoding("utf-8")
    end
  end
  
end
