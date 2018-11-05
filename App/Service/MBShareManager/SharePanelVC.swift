/*
 SharePanelViewController
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

/// 弹出的分享菜单
class SharePanelViewController: MBModalPresentViewController {
    @objc var item: MBEntitySharing!

    @IBAction func onTimeline(_ sender: Any) {
        share(type: .wechatTimeline)
    }
    @IBAction func onSession(_ sender: Any) {
        share(type: .wechatSession)
    }
    
    func share(type: MBShareType) {
        guard MBShareManager.isWechatEnabled else {
            AppHUD().showErrorStatus("微信未安装")
            return
        }
        item.shareLink?(with: type) { [weak self] _, _, error in
            if let e = (error as NSError?) {
                AppHUD().alertError(e, title: "分享失败")
            }
            else {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
