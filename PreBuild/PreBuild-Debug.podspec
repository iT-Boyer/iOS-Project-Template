Pod::Spec.new do |s|
  s.name     = 'PreBuild'
  s.version  = '0.1.0'
  s.author   = 'Feel'
  s.license  = { :type => 'private', :text => 'Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.' }
  s.homepage = 'https://github.com/zhiyun168/Feel-iOS'
  s.source   = { :path => '.' }
  s.summary  = '项目预编译'
  
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  
  s.vendored_frameworks = 'Output-Debug/*.framework'
  s.vendored_libraries = 'Output-Debug/**/*.a'
  s.source_files = 'Output-Debug/**/*.h'
  s.resource = 
  s.resources = [
    'Resource/*',
    'Output-Debug/*.framework/*.bundle'
  ]
end
