Pod::Spec.new do |s|
  s.name             = "PhotoRoomKit"
  s.summary          = "Fast background removal API."
  s.version          = "0.0.3"
  s.homepage         = "https://github.com/PhotoRoom/PhotoRoomKit-Swift"
  s.license          = { :type => 'MIT' }
  s.author           = { "PhotoRoom" => "ios@photoroom.com" }
  s.source           = {
    :git => "https://github.com/PhotoRoom/PhotoRoomKit-Swift.git",
    :tag => s.version.to_s
  }
  s.swift_version = '5.0'
  s.social_media_url = 'https://twitter.com/photoroom_app'

  s.ios.deployment_target = '13.0'

  s.requires_arc = true
  s.resource_bundles = { 'PhotoRoomKit' => ['Sources/Shared/**/*.{xcassets,pdf,json}'] }
  s.ios.source_files = 'Sources/{iOS,Shared}/**/*.{swift}'

  # s.ios.frameworks = 'UIKit', 'Foundation'
  # s.osx.frameworks = 'Cocoa', 'Foundation'
  # s.dependency 'Whisper', '~> 1.0'
  # s.watchos.exclude_files = ["Sources/AnimatedImageView.swift"]
end
