
Pod::Spec.new do |s|
  s.name          = "Inquire"
  s.version       = "0.1.1"
  s.summary       = "Form creation framework for iOS"
  s.description   = "A simple framework for easily creating forms in iOS apps."
  s.homepage      = "https://github.com/wess/inquire"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = "Wess Cope"
  s.platform      = :ios, '9.0'
  s.source        = { :git => "https://github.com/wess/inquire.git", :tag => "0.1.1" }
  s.source_files  = "Sources/*.*"
end
