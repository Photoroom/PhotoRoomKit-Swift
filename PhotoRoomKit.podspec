Pod::Spec.new do |s|
  s.name             = "PhotoRoomKit"
  s.summary          = "Fast background removal API."
  s.version          = "0.0.1"
  s.homepage         = "https://github.com/PhotoRoom/PhotoRoomKit"
  s.license          = 'MIT'
  s.author           = { "PhotoRoom" => "ios@photoroom.com" }
  s.source           = {
    :git => "https://github.com/PhotoRoom/PhotoRoomKit.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/PhotoRoom'

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.2'
  s.watchos.deployment_target = "3.0"

  s.requires_arc = true
  s.resource_bundles = { 'PhotoRoomKit' => ['Sources/Shared/**/*.{xcassets,pdf,json}'] }
  s.ios.source_files = 'Sources/{iOS,Shared}/**/*.{swift}'
  s.tvos.source_files = 'Sources/{iOS,tvOS,Shared}/**/*'
  s.osx.source_files = 'Sources/{macOS,Shared}/**/*'
  s.watchos.source_files = 'Sources/{watchOS,Shared}/**/*'

  # s.ios.frameworks = 'UIKit', 'Foundation'
  # s.osx.frameworks = 'Cocoa', 'Foundation'
  # s.dependency 'Whisper', '~> 1.0'
  # s.watchos.exclude_files = ["Sources/AnimatedImageView.swift"] 

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
end
