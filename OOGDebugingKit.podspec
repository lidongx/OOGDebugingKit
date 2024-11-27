
Pod::Spec.new do |s|
  s.name             = 'OOGDebugingKit'
  s.version          = '1.0.0'
  s.summary          = 'this is a util OOGDebugingKit for company'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://www.baidu.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lidong@smalltreemedia.com' => 'lidong@smalltreemedia.com' }
  s.source           = { :git => 'https://github.com/lidongx/OOGDebugingKit.git', :tag => s.version.to_s }

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'

  s.source_files = 'Source/Classes/**/*'
  s.static_framework = true
  
  s.platform  = :ios, "15.0"
  
  s.swift_version = '5.0'
  
  s.resource_bundles = {
      'OOGDebugingKit' => ['Source/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'


   s.dependency 'Alamofire'
   s.dependency 'Components','~> 0.1.10'
   s.dependency 'FIREvents/Core'
   s.dependency 'IAPManager/Core'
   
end
