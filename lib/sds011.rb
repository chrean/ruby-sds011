#!/usr/bin/ruby
require "rubygems"
require "serialport"
require "digest"
require "pp"

class SDS011
  # SDS emits this packet at 1Hz frequency
  @@reading = [
    'header',     # 0xAA
    'cmd_type',   # 0xC0
    'pm25_low',   # PM2.5, low byte
    'pm25_high',  # PM2.5, hi byte
    'pm10_low',   # PM10, low byte
    'pm10_high',  # PM10, hi byte
    'id_low',     # Sensor ID, low byte
    'id_high',    # Senbsor ID, hi byte
    'checksum',   # OR result of the 6 data bytes
    'tail'        # 0xAB
  ];

  # Commands
  @@query = {
    head:   '0xAA',
    cmd_id: '0xC0',
    data01: '0x00',
    data02: '0x00',
    data03: '0x00',
    data04: '0x00',
    data05: '0x00',
    data06: '0x00',
    data07: '0x00',
    data09: '0x00',
    data10: '0x00',
    data11: '0x00',
    data12: '0x00',
    data13: '0x00',
    data14: '0xFF', # FF: All sensors, otherwise Device ID byte 1
    data15: '0xFF', # FF: All sensors, otherwise Device ID byte 2
    checksum: '0',
    tail: '0xAB'
  };

  def reading
    @@reading
  end

  def query
    @@query
  end

  def bytes_to_int(low_byte, high_byte)
    puts "Hi byte: #{high_byte.to_i}, Low byte: #{low_byte.to_i}"
    ((high_byte.to_i << 8) + low_byte.to_i) /10
  end
  
  def calculate_checksum
    sum = 0xff + 0xff
    checksum = sum & 0xff
  end

  def send_command(cmd_hash)
    sp = SerialPort.new("/dev/ttyUSB0", "9600".to_i)
    sp.read_timeout = 100
    sp.flush()
    puts cmd_hash[:data14].to_s
    sp.close
  end

  def reading()
    # Baud, databits, stopbits, parity
    sp = SerialPort.new("/dev/ttyUSB0", 9600, 8, 1, SerialPort::NONE)
    sp.read_timeout = 100
    sp.flush()
    sds_bytes=0
    c=nil
    reading_packet = Hash.new()

    while sds_bytes < 10
      c=sp.read(1)
      reading_packet[@@reading[sds_bytes]] = c.ord.to_s(10)
      sds_bytes = sds_bytes + 1
    end

    sp.close
    {
      pm25: bytes_to_int(reading_packet['pm25_low'],reading_packet['pm25_high']),
      pm10: bytes_to_int(reading_packet['pm10_low'],reading_packet['pm10_high'])
    }
  end
end
