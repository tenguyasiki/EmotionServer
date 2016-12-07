require "thread"
require "socket"
require "./remote-sensors-protocol-parser.rb"
require "./message-handler.rb"

class EmotionServer

  TCP_PORT_NO = 42001

  def initialize(arduino_serial_ports)
    @arduino_serial_ports = arduino_serial_ports
  end

  def start()
    @socket = TCPSocket.open("localhost", TCP_PORT_NO)
    @parser = RemoteSensorsProtocolParser.new()
    @message_handler = MessageHandler.new(@arduino_serial_ports)
    @message_queue = Queue.new

    puts("ready.")

    #sleepしてもメッセージを取りこぼさないようにスレッドを導入
    Thread.start do
      loop do
        @message_queue.pop.call
      end
    end

    loop do
      # 十分な長さのメッセージを読み取る
      message = @socket.recv(400);
      @message_queue.push Proc.new {
        messages = @parser.parse(message)

        messages.each do |msg|
          send_sensor_update_message("msg", "run")
          @message_handler.handle(msg)
          send_sensor_update_message("msg","return")
        end
      }
    end
  end

  private

    def send_sensor_update_message(key, value)
      message = sprintf("sensor-update \"%s\" \"%s\"", key, value)
      send_message(message)
    end

    def send_message(message)
      # 命令の文字数(=バイト数)の16進数
      bytes = [message.length].pack("N")

      # 命令の文字数（16進数）と命令をつなげたものをスクラッチに送る
      @socket.write(bytes + message)
    end

end
