<<<<<<< HEAD
platform :ios, '12.0'
=======
platform :ios, '12.3'
>>>>>>> clean code expression
inhibit_all_warnings!

workspace 'eXo'
project 'eXo.xcodeproj'

use_frameworks!

target "eXo" do
    pod 'SVProgressHUD', '~> 2.2'
    pod 'SwiftyJSON', '~> 4.0'
    pod 'UICKeyChainStore', '~> 2.1'
    pod 'HTMLKit', '~> 3.1'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'

	target "eXoTests" do
		inherit! :search_paths
	end
	target "eXoUITests" do
		inherit! :search_paths
	end

end

target "share-extension" do
    pod 'UICKeyChainStore', '~> 2.1'
    pod 'HTMLKit', '~> 3.1'
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
