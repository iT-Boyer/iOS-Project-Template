//
//  Account.swift
//  App
//

/**
 管理当前用户
 */
class Account: MBUser {
    #if MBUserStringUID
    static let userIDUndetermined = "<undetermined>"
    #else
    static let userIDUndetermined = INT64_MAX
    #endif

    override var description: String {
        "<Account \(ObjectIdentifier(self)): uid = \(uid), information: \(information.description), hasLoginedThisSession: \(hasLoginedThisSession)>"
    }

    // MARK: - 状态

    /**
     用户基本信息

     不为空，操作上可以便捷一些
     */
    @objc var information: AccountEntity {
        get {
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }

            if let ret = _information { return ret }
            var account = AccountEntity(string: AppUserDefaultsShared().accountEntity, error: nil)
            if account == nil {
                AppUserDefaultsShared().accountEntity = nil
                account = AccountEntity()
            }
            _information = account
            return account!
        }
        set {
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }

            _information = newValue

            #if MBUserStringUID
            let uidChanged = newValue.uid.length > 0 && uid != newValue.uid as String
            #else
            let uidChanged = newValue.uid > 0 && uid != newValue.uid
            #endif
            if uidChanged {
                if uid != Account.userIDUndetermined {
                    DebugLog(true, "MBUserInformationIDMismatch", "用户信息 ID 不匹配")
                }
                setValue(information.uid, forKeyPath: #keyPath(MBUser.uid))
                if isCurrent {
                    AppUserDefaultsShared().lastUserID = uid
                }
            }

            // 开始对接口/数据源取回的数据处理
            // 原则是保留能从用户信息接口获取的字段
            // 如果是登录接口附加的信息则移动到 Account 上

            if isCurrent {
                AppUserDefaultsShared().accountEntity = information.toJSONString()
            }
        }
    }
    private var _information: AccountEntity?

    var token: String?

    var hasLoginedThisSession: Bool = false

    // MARK: - 挂载

    @objc private(set) var profile: NSAccountDefaults?

    // MARK: - 流程

    override func onInit() {
        super.onInit()
        let suitName = ("User\(uid)" as NSString).rf_MD5
        profile = NSAccountDefaults(suiteName: suitName)
    }

    /// 应用启动后初始流程
    class func setup() {
        if AppUser() != nil { return }
        #if MBUserStringUID
        guard let userID = AppUserDefaultsShared().lastUserID else { return }
        #else
        let userID = AppUserDefaultsShared().lastUserID
        guard userID > 0 else { return }
        #endif
        guard let token = AppUserDefaultsShared().userToken else {
            DebugLog(true, "LaunchUserNoToken", "Account has ID but no token")
            return
        }

        guard let user = Account(id: userID) else { fatalError() }
        user.token = token
        self.current = user
        user.updateInformation { c in
            c.failureCallback = APISlientFailureHandler(true)
        }
        assert(API.global != nil)
    }

    override class func onCurrentUserChanged(_ currentUser: MBUser?) {
        let user = currentUser as? Account
        let defaults = AppUserDefaultsShared()
        #if MBUserStringUID
        defaults.lastUserID = user?.uid
        #else
        defaults.lastUserID = user?.uid ?? 0
        #endif
        defaults.userToken = user?.token
        defaults.accountEntity = user?.information.toJSONString()
        if !defaults.synchronize() {
            dispatch_after_seconds(0) {
                if AppUserDefaultsShared().synchronize() { return }
                DebugLog(true, "UDSynchronizeFail", "用户信息存储失败")
                noticeDefaultsSynchronizeFail
            }
        }
        if let user = user {
            AppEnv().setFlagOn(.userHasLogged)
            if !user.hasLoginedThisSession {
                user.updateInformation { c in
                    c.failureCallback = APISlientFailureHandler(true)
                }
            }
        } else {
            AppEnv().setFlagOff(.userHasLogged)
            AppEnv().setFlagOff(.userInfoFetched)
        }
    }

    private static let noticeDefaultsSynchronizeFail: Void = {
        let alert = UIAlertController(title: "系统错误", message: "暂时不能保存您的用户信息，如果你反复遇到这个提示，建议您重启设备以解决这个问题", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .default, handler: nil))
        UIViewController.rootViewControllerWhichCanPresentModal()?.present(alert, animated: true, completion: nil)
    }()

    override func onLogin() {
        debugPrint("当前用户 ID: \(uid), token: \(token ?? "null")")
        AppAPI().defineManager.authorizationHeader["token"] = token
    }
    override func onLogout() {
        AppAPI().defineManager.authorizationHeader.removeObject(forKey: "token")
        resetCookies()
        profile?.synchronize()
    }

    /// 更新账号用户信息
    func updateInformation(requestContext context: (RFAPIRequestConext) -> Void) {
        API.requestName("AcoountInfo") { c in
            context(c)
            let inputSuccessCallback = c.successCallback
            c.success { task, rsp in
                guard let info = rsp as? AccountEntity else { fatalError() }
                if let cb = inputSuccessCallback {
                    cb(task, rsp)
                }
                self.hasLoginedThisSession = true
                self.information = info
                if self.isCurrent {
                    AppEnv().setFlagOn(.userInfoFetched)
                }
            }
        }
    }

    func resetCookies() {
        let storage = HTTPCookieStorage.shared
        storage.cookies?.forEach { storage.deleteCookie($0) }
    }
}
