
# Disable sending stats
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

# inhibit_all_warnings!

source 'https://github.com/PBPods/PBFlex.git'
source 'https://cdn.cocoapods.org/'

target 'App' do
    platform :ios, '11.0'

    pod 'RFKit', :subspecs => [
        'Category/UIScrollView+RFScrolling',
        'Category/UISearchBar',
    ]
    pod 'RFAlpha', :git => 'https://github.com/RFUI/Alpha.git', :subspecs => [
        'RFBlockSelectorPerform',
        'RFButton',
        'RFCallbackControl',
        'RFContainerView',
        'RFDelegateChain/UICollectionViewDelegateFlowLayout',
        'RFDelegateChain/UICollectionViewDataSource',
        'RFDelegateChain/UISearchBarDelegate',
        'RFDelegateChain/UITextFieldDelegate',
        'RFDelegateChain/UITextViewDelegate',
        'RFDrawImage',
        'RFImageCropper',
        'RFNavigationController',
        'RFRefreshButton',
        'RFRefreshControl',
        'RFTabController',
        'RFTableViewPullToFetchPlugin',
        'RFTimer',
        'RFViewApperance/RFLine',
        'RFViewApperance/RFLayerApperance',
        'RFWindow',
    ]
    pod 'RFAPI', :git => 'https://github.com/RFUI/RFAPI.git'
    pod 'RFKeyboard', :git => 'https://github.com/RFUI/RFKeyboard.git'
    pod 'RFMessageManager', :subspecs => ['SVProgressHUD']
    pod 'RFSegue', :subspecs => ['Async']
    pod 'MBAppKit', :git => 'https://github.com/RFUI/MBAppKit.git', :subspecs => [
        'Button',
        'Environment',
        'Input',
        'Navigation',
        'Worker',
    ]

    pod 'SDWebImage'
    pod 'PBFlex', :configurations => ['Debug']

    # target "Test" do
    #     inherit! :search_paths
    # end
end

post_install do |pi|
    # 临时修正 deployment target 不支持的问题，并且让 Pod 跟随 App 支持的版本进行编译
    # https://github.com/CocoaPods/CocoaPods/issues/7314
    fix_deployment_target(pi)
end

def fix_deployment_target(pod_installer)
    if !pod_installer
        return
    end
    puts "Make the pods deployment target version the same as our target"
    
    project = pod_installer.pods_project
    deploymentMap = {}
    project.build_configurations.each do |config|
        deploymentMap[config.name] = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
    end
    # p deploymentMap
    
    project.targets.each do |t|
        puts "  #{t.name}"
        t.build_configurations.each do |config|
            oldTarget = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
            newTarget = deploymentMap[config.name]
            if oldTarget == newTarget
                next
            end
            puts "    #{config.name} deployment target: #{oldTarget} => #{newTarget}"
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = newTarget
        end
    end
end
