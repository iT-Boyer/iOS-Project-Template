
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
    pod 'RFAlpha', :path => 'Frameworks/RFUI/Alpha', :subspecs => [
        'RFBlockSelectorPerform',
        'RFButton',
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
        'RFSwizzle',
        'RFSynthesize',
        'RFTabController',
        'RFTableViewPullToFetchPlugin',
        'RFTimer',
        'RFViewApperance/RFLine',
        'RFViewApperance/RFLayerApperance',
        'RFWindow'
    ]
    pod 'RFAPI', :git => 'https://github.com/RFUI/RFAPI.git'
    pod 'RFKeyboard', :git => 'https://github.com/RFUI/RFKeyboard.git'
    pod 'RFMessageManager', :git => 'https://github.com/RFUI/RFMessageManager.git', :subspecs => ['SVProgressHUD']
    pod 'RFSegue', :git => 'https://github.com/RFUI/RFSegue.git'
    pod 'MBAppKit', :path => 'MBAppKit'

    pod 'PreBuild', :path => 'PreBuild'

    # target "Test" do
    #     inherit! :search_paths
    # end
end
