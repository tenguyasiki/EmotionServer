require "./emotion-server.rb"
require 'rbconfig'
require 'win32ole'

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

def usage
  puts "# ruby main.rb [serialport]"

  ostype = os()
  comlist = {}
  
  if ostype == :windows then
    comlist = comlist_windows()
  end

  puts ostype
  puts comlist
  
end

def comlist_windows
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
  
  return comlist
end


begin
  if ARGV.size == 0 then
    usage()
    exit
  end
  
  arduino_serial_ports = ARGV.size > 0 ? ARGV : DEFAULT_ARDUINO_SERIAL_PORTS
  server = EmotionServer.new(arduino_serial_ports)
  server.start()
rescue => ex
  puts ex.message
  puts ex.backtrace
end

