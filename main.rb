require "./emotion-server.rb"

DEFAULT_ARDUINO_SERIAL_PORTS = ["COM3"]

begin
  arduino_serial_ports = ARGV.size > 0 ? ARGV : DEFAULT_ARDUINO_SERIAL_PORTS
  server = EmotionServer.new(arduino_serial_ports)
  server.start()
rescue => ex
  puts ex.message
  puts ex.backtrace
end
