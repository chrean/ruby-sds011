require "./lib/sds011.rb"

sds = SDS011.new('/dev/ttyUSB0')
puts sds.reading()