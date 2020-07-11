//
//  MoreVC.swift
//  App
//

/**
 更多 tab 页
 */
class MoreViewController: UIViewController {
    override class func storyboardName() -> String { "Main" }

    @IBAction private func onLogout(_ sender: Any) {
        let alert = UIAlertController(title: "确定要登出么", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "登出", style: .default, handler: { _ in
            Account.current = nil
        }))
        rfPresent(alert, animated: true, completion: nil)
    }
}
