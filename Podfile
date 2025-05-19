# Uncomment the next line to define a global platform for your project

 
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'

target 'ADSuyiSDKDemo-iOS-Swift' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ADSuyiSDKDemo-iOS-Swift
  pod 'ADSuyiSDK','~> 4.0.0.04221' # 主SDK 必选
pod 'ADSuyiSDK/ADSuyiSDKPlatforms/tianmu' # 天目  #必选
#pod 'ADSuyiSDK/ADSuyiSDKPlatforms/gdt'   # 优量汇(广点通）
#pod 'ADSuyiSDK/ADSuyiSDKPlatforms/baidu' # 百度
#pod 'ADSuyiSDK/ADSuyiSDKPlatforms/ks'    # 快手
#pod 'ADSuyiSDK/ADSuyiSDKPlatforms/jad'   # 京媒，白名单需添加京东
#pod 'ADSuyiSDK/ADSuyiSDKPlatforms/iqy'   # 爱奇艺

# ab二选一
# a.不需要gromore
#pod 'ADSuyiSDK/ADSuyiSDKPlatforms/bu' # 穿山甲(头条)
# b.需要gromore
# pod 'ADSuyiSDK/ADSuyiSDKPlatforms/bu-without' # 穿山甲(头条)
# pod 'ADSuyiSDK/ADSuyiSDKPlatforms/gromore' # gromore

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
