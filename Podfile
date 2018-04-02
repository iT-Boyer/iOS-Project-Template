
# Disable sending stats
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

platform :ios, '9.0'

# inhibit_all_warnings!

target 'App' do
    pod 'JSONModel', :git => 'https://github.com/Chinamobo/JSONModel.git'
    pod 'RFKit', :git => 'https://github.com/BB9z/RFKit.git', :branch => 'develop', :subspecs => [
        'Default',
        'Category/NSDate',
        'Category/NSDateFormatter',
        'Category/NSFileManager',
        'Category/NSJSONSerialization',
        'Category/NSURL',
        'Category/NSLayoutConstraint',
        'Category/UIScrollView+RFScrolling',
        'Category/UISearchBar'
    ]
    pod 'RFAPI', :git => 'https://github.com/RFUI/RFAPI.git'
    pod 'RFMessageManager', :git => 'https://github.com/RFUI/RFMessageManager.git', :subspecs => ['SVProgressHUD']
    pod 'RFSegue', :git => 'https://github.com/RFUI/RFSegue.git'
    
    pod 'MBAppKit', :path => 'MBAppKit'
    pod 'PreBuild', :path => 'PreBuild'
end
