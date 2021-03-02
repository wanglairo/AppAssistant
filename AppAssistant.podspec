#
# Be sure to run `pod lib lint AppAssistant.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AppAssistant'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AppAssistant.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wanglai/AppAssistant'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wanglai' => 'wanglai@ccclubs.com' }
  s.source           = { :git => 'https://github.com/wanglai/AppAssistant.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'
  s.swift_version    = '5.0'

  s.source_files = 'AppAssistant/Src/**/**/*.{h,m,c,mm,swift}'

  s.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '-lObjC'
  }

  s.resource_bundles = {
    'AppAssistant' => 'AppAssistant/Resource/**/*'
  }

  s.frameworks = 'QuartzCore', 'UIKit'

  s.vendored_frameworks = 'framework/*.framework'

  s.dependency 'FBRetainCycleDetector'
  s.dependency 'SnapKit'
end
