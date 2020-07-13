/**
 首页
 */
class HomeViewController: UIViewController {
    override class func storyboardName() -> String { "Main" }

    @IBAction private func navigationPop(_ sender: Any) {
        AppHUD().showInfoStatus("主页的该按钮用于调整导航返回按钮图片位置，请删除")
    }
}
