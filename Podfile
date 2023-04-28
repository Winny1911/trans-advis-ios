# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TA' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TA

pod 'SDWebImage', '~> 5.8'
pod 'IQKeyboardManagerSwift', '6.3.0'
pod 'Alamofire', '~> 5.4'
pod 'MBProgressHUD'
pod 'SwiftMessages', '~> 9.0.2'
pod "SMFloatingLabelTextField"
pod 'SKPhotoBrowser', '~> 6.1.0'
pod 'GBFloatingTextField'
pod 'Firebase/Analytics'
pod 'Firebase/Core'
pod 'Firebase/Crashlytics'
pod 'Firebase/Messaging'
pod 'GoogleMaps', '4.2.0'
pod 'Google-Maps-iOS-Utils'
pod 'GooglePlaces'
pod 'GrowingTextView'
pod 'Nantes'

pod 'Firebase/Messaging'
pod 'Firebase/Database'
pod 'Firebase/Storage'

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end


