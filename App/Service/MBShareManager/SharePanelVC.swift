/*
 SharePanelViewController
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */

/// 弹出的分享菜单
class SharePanelViewController: MBModalPresentViewController {
    @objc var item: MBEntitySharing!

    @IBAction func onTimeline(_ sender: Any) {
        guard MBShareManager.isWechatEnabled else {
            AppHUD().showErrorStatus("微信未安装")
            return
        }
        share(type: .wechatTimeline)
    }
    @IBAction func onSession(_ sender: Any) {
        guard MBShareManager.isWechatEnabled else {
            AppHUD().showErrorStatus("微信未安装")
            return
        }
        share(type: .wechatSession)
    }
    @IBAction func onQQ(_ sender: Any) {
        share(type: .qqSession)
    }
    @IBAction func onWeibo(_ sender: Any) {
        share(type: .sinaWeibo)
    }
    
    func share(type: MBShareType) {
        item.shareLink?(with: type) { [weak self] s, _, error in
            let sf = self
            if s {
                AppHUD().showSuccessStatus("分享成功")
                sf?.dismissSelf(animated: true, completion: nil)
            }
            if let e = (error as NSError?) {
                AppHUD().alertError(e, title: "分享失败", fallbackMessage: nil)
            }
        }
    }
}
