source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

target 'Zoetis -Feathers' do
    pod 'Charts', :inhibit_warnings => true
    pod 'MBProgressHUD', :inhibit_warnings => true
    pod 'iOS-Slide-Menu', :inhibit_warnings => true
    pod 'Alamofire', :inhibit_warnings => true
    pod 'ReachabilitySwift', :inhibit_warnings => true
    pod 'IQKeyboardManagerSwift', :inhibit_warnings => true
    pod 'Siren', :inhibit_warnings => true
    pod 'SwiftyJSON', :inhibit_warnings => true
    pod 'Firebase/Analytics', :inhibit_warnings => true
    pod 'Firebase/Crashlytics', :inhibit_warnings => true
    pod 'Firebase/Messaging', :inhibit_warnings => true
    pod 'JNKeychain', :inhibit_warnings => true
    pod 'CryptoSwift', :inhibit_warnings => true
    pod 'SwiftReorder', :inhibit_warnings => true
    pod 'RSSelectionMenu', '~> 7.1.2', :inhibit_warnings => true
    pod 'Gigya' , :inhibit_warnings => true
    pod 'GigyaTfa' , :inhibit_warnings => true
    pod 'GigyaAuth' , :inhibit_warnings => true
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
