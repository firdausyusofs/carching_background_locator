#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint carching_background_locator.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'carching_background_locator'
  s.version          = '0.0.2'
  s.summary          = 'This is a plugin for accessing background location on iOS and Android'
  s.description      = <<-DESC
This is a plugin for accessing background location on iOS and Android
                       DESC
  s.homepage         = 'http://firdausyusof.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'FY' => 'me@firdausyusof.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*',
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  # s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  # s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  # s.swift_version = '5.0'
end
