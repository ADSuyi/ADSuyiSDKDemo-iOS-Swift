# Uncomment the next line to define a global platform for your project

 
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'

target 'ADSuyiSDKDemo-iOS-Swift' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ADSuyiSDKDemo-iOS-Swift
  pod 'ADSuyiSDK', '~> 3.7.8.08141'#必选
  pod 'ADSuyiSDK/ADSuyiSDKPlatforms/tianmu' # 天目  #必选
  pod 'ADSuyiSDK/ADSuyiSDKPlatforms/bu' # 穿山甲(头条)
  pod 'ADSuyiSDK/ADSuyiSDKPlatforms/gdt' # 优量汇(广点通）
  pod 'ADSuyiSDK/ADSuyiSDKPlatforms/baidu' # 百度
  pod 'ADSuyiSDK/ADSuyiSDKPlatforms/ks' # 快手(非内容版本，内容与非内容版本不可同时导入)
  pod 'ADSuyiSDK/ADSuyiSDKPlatforms/mtg'     # Mobvista(汇量)
  pod 'ADSuyiSDK/ADSuyiSDKPlatforms/gromore' # gromore
  pod 'ADSuyiSDK/ADSuyiSDKPlatforms/inmobi' # Inmobi
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
