//
//  LoginVCs.swift
//  App
//

/// 用于登入后移除导航中的登入页
@objc protocol LoginVCs {
}

/// 登入注册 vc 基类
class LoginFormBaseViewController: UIViewController, LoginVCs {
    override class func storyboardName() -> String {
        return "Login"
    }
}

/**
 未登入用户欢迎页
 */
class WelcomeViewController: LoginFormBaseViewController {
    var form: LoginMobileVerifyCodeScene {
        children.first as! LoginMobileVerifyCodeScene
    }

    @IBAction func onSendCode(_ sender: Any) {
        guard let mobile = form.mobileField?.vaildFieldText() else {
            return
        }
        form.sendCodeButton?.markSending(message: nil)
        API.requestName("RegisterMobileCode") { c in
            c.parameters = ["phone": mobile]
            c.loadMessage = ""
            c.groupIdentifier = apiGroupIdentifier
            c.success { [weak self] _, _ in
                self?.form.sendCodeButton?.froze()
            }
            c.finished { [weak self] _, success in
                if !success {
                    self?.form.sendCodeButton?.isEnabled = true
                }
            }
        }

    }

    @IBAction func onSubmit(_ sender: Any) {
        let user = Account(id: Account.userIDUndetermined)
        user?.token = "fake"
        Account.current = user
        AppHUD().showInfoStatus("演示模式\n直接登入")
    }

    #if DEBUG
    @objc func debugCommands() -> [UIBarButtonItem] {
        return [
            DebugMenuItem2("测试用户", {
                let user = Account(id: Account.userIDUndetermined)
                user?.token = "token"
                Account.current = user
            })
        ]
    }
    #endif
}

