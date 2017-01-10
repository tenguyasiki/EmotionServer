require "./emotion-server.rb"
require 'rbconfig'

DEFAULT_ARDUINO_SERIAL_PORTS = ["COM3"]


def os
  @os ||= (
    host_os = RbConfig::CONFIG['host_os']
    case host_os
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      :windows
    when /darwin|mac os/
      :macosx
    when /linux/
      :linux
    when /solaris|bsd/
      :unix
    else
      :unknown
    end
  )
end

def getComportList
  ostype = os()
  comlist = {}
  
  if ostype == :windows then
    comlist = comlist_windows()
  elsif ostype == :linux then
    comlist = comlist_linux()
  end
  
  return comlist
end

def usage
  puts "# ruby main.rb [serialport]"

  comlist = getComportList()
  comlist.each_with_index do | dev, index |
    puts "[#{index}] #{dev}"
  end
end

# linux環境でシリアルポートを一覧する
def comlist_linux
  comlist = Dir.glob("/dev/ttyUSB*")
  comlist.concat(Dir.glob("/dev/ttyACM*"))
  return comlist
end


# Windows環境でシリアルポートを一覧する
def comlist_windows
  require 'win32ole'
  locator = WIN32OLE.new("WbemScripting.SWbemLocator")
  services = locator.ConnectServer()
  comlist = {}
  # 内蔵シリアルポート一覧を取得
  services.ExecQuery("SELECT * FROM Win32_SerialPort").each do |item|
    comlist[item.DeviceID] = item.Name
  end

  # PnPシリアルポート一覧を取得
  services.ExecQuery("SELECT * FROM Win32_PnPEntity").each do |item|
    comlist[$1] = item.Description if item.Name =~ /\((COM\d+)\)/
  end
  
  return comlist.keys
end


begin
  if ARGV.size == 0 then
    usage()
    exit
  else
    argv = ARGV[0]
    if argv =~ /^\d+$/ then  # シリアルポート指定が数値の場合
      comlist = getComportList()
      index = argv.to_i
      if index < comlist.size then
        arduino_serial_ports = comlist[index]
      else
        raise "illegular argument [#{argv}]"
      end
    else   #シリアルポート指定が文字列の場合
      arduino_serial_ports = ARGV[0]
    end
  end
  
  puts arduino_serial_ports
  exit
  server = EmotionServer.new(arduino_serial_ports)
  server.start()
rescue => ex
  puts ex.message
  puts ex.backtrace
end

