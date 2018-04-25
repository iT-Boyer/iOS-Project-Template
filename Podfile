
# Disable sending stats
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

platform :ios, '9.0'

# inhibit_all_warnings!

target 'App' do
    pod 'RFKit', :subspecs => [
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
    pod 'RFKeyboard', :git => 'https://github.com/RFUI/RFKeyboard.git'
    pod 'RFMessageManager', :subspecs => ['SVProgressHUD']
    pod 'RFSegue', :subspecs => ['Async']
    pod 'MBAppKit', :path => 'MBAppKit'

    pod 'PreBuild', :path => 'PreBuild'

    # target "Test" do
    #     inherit! :search_paths
    # end
end
