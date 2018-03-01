#! /usr/bin/env ruby

## 验证项目配置的 Ruby 脚本
## 无参数支持，Xcode 设置的环境变量都在就行

# require 'rubygems'
require 'xcodeproj'
require 'plist'

# 主目标的名称，留空尝试自动寻找
main_target_name = nil
xcode_build_configuration = ENV["CONFIGURATION"]
xcodeproj_path = ENV["PROJECT_FILE_PATH"]
proj = Xcodeproj::Project.open(xcodeproj_path)

# 找到 App target
main_target = nil
if main_target_name != nil
  proj.targets.each do |target|
    if target.name == main_target_name
      main_target = target
    end
  end
  if main_target == nil
      puts "#{proj.path}:0: 找不到名为 #{main_target_name} 的 target"
      exit false
  end
else
  proj.targets.each do |target|
    if target.product_name == "App"
      main_target = target
    end
  end
end

if main_target == nil
    puts "#{proj.path}:0: 找不到应用的 target"
    exit false
end

xcode_info_plist_path = nil
main_target.build_configurations.each do |config|
  setting_hash = config.build_settings

  if config.name == xcode_build_configuration
      xcode_info_plist_path = setting_hash["INFOPLIST_FILE"]
  end

  # CODE SIGN 应使用项目默认值，target 配置中不应包含 CODE SIGN 设置
  if setting_hash["CODE_SIGN_IDENTITY"]
    puts "#{proj.path}:0: target 配置中不应包含 CODE_SIGN_IDENTITY 设置"
  end
  
  if setting_hash["CODE_SIGN_IDENTITY[sdk=*]"]
    puts "#{proj.path}:0: target 配置中不应包含 CODE_SIGN_IDENTITY[sdk=*] 设置"
  end
end

# 验证当前 Info.plist 配置
xcode_info_plist_path = File.join(ENV["PROJECT_DIR"], xcode_info_plist_path)

info_plist = Plist::parse_xml(xcode_info_plist_path)
if info_plist == nil
    puts "#{proj.path}:0: 不能读取 Info.plist"
    exit false
end

rdc = info_plist["UIRequiredDeviceCapabilities"]
if rdc.count != 1
    puts "#{xcode_info_plist_path}:0: Required device capabilities 配置错误"
    exit false
end
