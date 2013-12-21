Pod::Spec.new do |s|
  s.name         = "AFQiniuClient"
  s.version      = "0.0.1"
  s.summary      = "AFNetworking for Qiniu"
  s.homepage     = "https://github.com/aelam/AFNetworking-Qiniu"
  s.license      = 'Apache License, Version 2.0'
  s.author       = "Ryan Wang => ryanwang@me.com"
  s.source       = { :git => 'https://github.com/aelam/AFNetworking-Qiniu.git', :tag => '0.0.1' }
  s.platform     = :ios, 5.0
  s.source_files = 'AFQiniuClient/**/*.{h,m}'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~>1.3'

end
