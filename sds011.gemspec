Gem::Specification.new do |s|
  s.name        = "sds011"
  s.version     = "0.0.2"
  s.summary     = "SDS011 gem"
  s.description = "A simple gem to interact with SDS011 sensors via serial/USB"
  s.authors     = ["Gabriel Sambarino"]
  s.email       = "gabriel.sambarino@gmail.com"
  s.files       = ["lib/sds011.rb"]
  s.homepage    = "https://github.com/chrean/ruby-sds011"
  s.license     = "MIT"

  s.add_dependency "serialport", "~> 1.3.2"
end
