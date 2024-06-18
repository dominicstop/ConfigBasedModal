
Pod::Spec.new do |s|
  s.name             = 'ConfigBasedModal'
  s.version          = '0.1.0'
  s.summary          = 'Config-based UIViewController modal presentation.'

  s.description      = <<-DESC
    TBA
  DESC

  s.homepage         = 'https://github.com/dominicstop/adaptive-modal'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dominic Go' => 'dominic@dominicgo.dev' }
  s.source           = { :git => 'https://github.com/dominicstop/ConfigBasedModal.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/GoDominic'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/**/*'
  s.frameworks = 'UIKit'
  
  s.dependency 'ComputableLayout', '~> 0.7'
  s.dependency 'DGSwiftUtilities', '~> 0.22'
  
end
