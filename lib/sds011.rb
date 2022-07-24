#!/usr/bin/ruby
require "rubygems"
require "serialport"
require "pp"

def bytes_to_int(low_byte, high_byte)
  ((high_byte.to_i << 8) + low_byte.to_i) /10
end

sds_reading = [
  'header',     # 0xAA
  'cmd_type',   # 0xC0
  'pm25_low',   # PM2.5, low byte
  'pm25_hi',    # PM2.5, hi byte
  'pm10_low',   # PM10, low byte
  'pm10_high',  # PM10, hi byte
  'id_low',     # Sensor ID, low byte
  'id_high',    # Senbsor ID, hi byte
  'checksum',   # OR result of the 6 data bytes
  'tail'        # 0xAB
];

sp = SerialPort.new("/dev/ttyUSB0", "9600".to_i)
sp.read_timeout = 100
sp.flush()
printf("# R : reading ...\n")
sds_bytes=0
c=nil
reading_packet = Hash.new()
while sds_bytes < 10
	c=sp.read(1)
  printf("# R : 0x%02x\n", c.ord)
  reading_packet[sds_reading[sds_bytes]] = c.ord.to_s(10)
  sds_bytes = sds_bytes + 1
end

p "PM2.5: #{bytes_to_int(reading_packet['pm25_low'],reading_packet['pm25_high'])}"
p "PM10: #{bytes_to_int(reading_packet['pm10_low'],reading_packet['pm10_high'])}"
sp.close