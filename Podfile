# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

install! 'cocoapods',
            :warn_for_unused_master_specs_repo => false

flutter_application_path = '../../FlutterDemo/flutter_module_umbrella/'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'Swfit59' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  install_all_flutter_pods(flutter_application_path)
  # Pods for Swfit59
  pod 'CryptoSwift'
  pod 'RxSwift'
  pod 'RxCocoa'
#  pod 'ObjectMapper'
  pod 'Runtime'
  pod 'Alamofire'
  pod 'CocoaMQTT' , git: 'https://gitee.com/mirrors/CocoaMQTT.git'
  pod 'SwiftyImage'
  
  pod 'UMCommon'
  pod 'UMDevice'
  pod 'UMShare/UI'
  pod 'UMShare/Social/ReducedWeChat'
  pod 'UMShare/Social/QQ'
  pod 'UMShare/Social/Instagram'
  pod 'UMShare/Social/WhatsApp'
  pod 'UMShare/Social/Facebook'
  pod 'UMShare/Social/Twitter'
  pod 'UMShare/Social/Sina'
  
  pod 'WechatOpenSDK'

end
post_install do |installer|
    flutter_post_install(installer) if defined?(flutter_post_install)
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
