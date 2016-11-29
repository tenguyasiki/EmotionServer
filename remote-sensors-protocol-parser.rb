# Remote Sensors Protocol - Scratch Wiki
# https://wiki.scratch.mit.edu/wiki/Remote_Sensors_Protocol

class RemoteSensorsProtocolParser

  def parse(message)
    # 先頭の4バイトはメッセージ長なのでカットする
    message = message[4..message.size]
    messages = Array.new

    tokens = message.split

    until tokens.empty? do
      type = tokens.shift
      if (type.downcase.end_with? "broadcast") then
        match_data = tokens.shift.match(/"(.+?)"/i)
        (messages.push ["broadcast", match_data[1].force_encoding("utf-8")]) unless match_data.nil?
      elsif (type.downcase.end_with? "sensor-update") then
        until tokens.empty? or tokens[0].match(/"(.+?)"/i).nil? do
          messages.push ["sensor-update",
                         tokens.shift.match(/"(.+?)"/i)[1].force_encoding("utf-8"),
                         tokens.shift.force_encoding("utf-8")]
        end
      else
        puts "ILLEGAL COMMAND"
      end
    end

    return messages
  end

end
