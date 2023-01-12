platform :ios, '12.0'
inhibit_all_warnings!

workspace 'eXo'
project 'eXo.xcodeproj'

use_frameworks!

target "eXo" do
    pod 'SVProgressHUD'
    pod 'SwiftyJSON'
    pod 'UICKeyChainStore', '~> 2.2.1'
    pod 'HTMLKit', '~> 4.2.0'
    pod 'Firebase/Crashlytics'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod 'Kingfisher'

	target "eXoTests" do
		inherit! :search_paths
	end
	target "eXoUITests" do
		inherit! :search_paths
	end

end

target "share-extension" do
    pod 'UICKeyChainStore', '~> 2.2.1'
    pod 'HTMLKit', '~> 4.2.0'
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
  installer.pods_project.targets.each do |target|
   target.build_configurations.each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
   end
  end
end
