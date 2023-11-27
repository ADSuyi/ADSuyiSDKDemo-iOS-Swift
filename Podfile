# Uncomment the next line to define a global platform for your project

 
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'

target 'ADSuyiSDKDemo-iOS-Swift' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ADSuyiSDKDemo-iOS-Swift
  pod 'ADSuyiSDK','~> 3.7.9.10301' # 主SDK 必选
pod 'ADSuyiSDK/ADSuyiSDKPlatforms/tianmu' # 天目  #必选
pod 'ADSuyiSDK/ADSuyiSDKPlatforms/gdt' # 优量汇(广点通）
pod 'ADSuyiSDK/ADSuyiSDKPlatforms/baidu' # 百度
pod 'ADSuyiSDK/ADSuyiSDKPlatforms/ks' # 快手
pod 'ADSuyiSDK/ADSuyiSDKPlatforms/mtg'     # Mobvista(汇量)
pod 'ADSuyiSDK/ADSuyiSDKPlatforms/jad'     # 京媒

# ab二选一
# a.不需要gromore
pod 'ADSuyiSDK/ADSuyiSDKPlatforms/bu' # 穿山甲(头条)
# b.需要gromore
# pod 'ADSuyiSDK/ADSuyiSDKPlatforms/bu-without' # 穿山甲(头条)
# pod 'ADSuyiSDK/ADSuyiSDKPlatforms/gromore' # gromore

# 以下为gromore的三方适配器，按需导入（优量汇已导入，无需额外导入）
# pod 'CSJMAdmobAdapter',      '10.0.0.0'
# pod 'CSJMKsAdapter',         '3.3.51.1.0'
# pod 'CSJMUnityAdapter',      '4.3.0.0'
# pod 'CSJMBaiduAdapter',      '5.322.0'
# pod 'CSJMMintegralAdapter',  '7.3.6.0.2'
# pod 'CSJMKlevinAdapter',     '2.11.0.211.1'
# pod 'CSJMSigmobAdapter',     '4.9.4.0'

  pod 'MJRefresh'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end
