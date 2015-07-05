Gem::Specification.new do |s|
  s.name = 'rbparser'
  s.version = '0.1.0'
  s.summary = 'Experimental gem to parse Ruby code'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/rbparser.rb']
  s.add_runtime_dependency('app-routes', '~> 0.1', '>=0.1.18') 
  s.signing_key = '../privatekeys/rbparser.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/rbparser'
end
