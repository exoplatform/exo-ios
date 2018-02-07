platform :ios, '8.0'
inhibit_all_warnings!

workspace 'eXo'
project 'eXo.xcodeproj'

use_frameworks!

target "eXo" do
    pod 'SVProgressHUD', '~> 1.1'
    pod 'SwiftyJSON', '~> 3.0.0'
    pod 'UICKeyChainStore', '~> 2.1'
    pod 'HTMLKit', '~> 2.0.0'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
end

target "share-extension" do
    pod 'UICKeyChainStore', '~> 2.1'
    pod 'HTMLKit', '~> 2.0.0'
end

target "eXoTests" do
    pod 'Firebase/Core'
end

# Fix xcode Warning for Release config
# https://github.com/CocoaPods/CocoaPods/issues/4439
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    if config.name == 'Release'
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
    else
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
    end    
  end
end
