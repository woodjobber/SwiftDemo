# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

install! 'cocoapods',
            :warn_for_unused_master_specs_repo => false
target 'Swfit59' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Swfit59
  pod 'CryptoSwift'
  pod 'RxSwift'
  pod 'RxCocoa'
#  pod 'ObjectMapper'
  pod 'Runtime'
  pod 'Alamofire'
  pod 'CocoaMQTT' , git: 'https://gitee.com/mirrors/CocoaMQTT.git'
  pod 'SwiftyImage'
end
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
               end
          end
   end
end
