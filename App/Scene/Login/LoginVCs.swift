//
//  LoginVCs.swift
//  App
//

/**
 未登入用户欢迎页
 */
class WelcomeViewController: UIViewController {
    override class func storyboardName() -> String {
        return "Login"
    }

    @IBAction func onSubmit(_ sender: Any) {
        let user = Account(id: Account.userIDUndetermined)
        user?.token = "fake"
        Account.current = user
    }
}
