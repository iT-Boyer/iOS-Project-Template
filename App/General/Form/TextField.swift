/**
 应用级别的 text field 定制
 */

/**
 定义样式名
 
 一般在 Interface Builder 中通过 styleName 设置
 */
enum TextFieldStyle: String {
    case std
    case frame
}

enum TextFieldContentType: String {
    case mobile     // 手机号
    case code       // 验证码
    case password   // 密码，不验证长度，只验证非空
    case password2  // 密码验证，严格验证
    case name       // 姓名
    case required   // 非空，为空时用 placeholder 提示
}

class TextField: MBTextField {
    override func setupAppearance() {
        guard let style = styleName else {
            return
        }
        switch style {
        case TextFieldStyle.std.rawValue:
            textEdgeInsets = UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 16)
            
        case TextFieldStyle.frame.rawValue:
            var left = CGFloat(6)
            if iconImageView != nil {
                left = textEdgeInsets.left
            }
            textEdgeInsets = UIEdgeInsets(top: 7, left: left, bottom: 7, right: 12)

        default:
            assert(false, "TextField: unrecognized style \(style)")
        }
    }
    
    override var formContentType: String? {
        didSet {
            guard let type = TextFieldContentType(rawValue: formContentType ?? "") else {
                return
            }
            switch type {
            case .mobile:
                keyboardType = .phonePad
                if #available(iOS 10.0, *) {
                    textContentType = .telephoneNumber
                }
            case .password, .password2:
                if #available(iOS 11.0, *) {
                    textContentType = .password
                }
                
            case .code:
                keyboardType = .numberPad
                
            case .name:
                keyboardType = .namePhonePad
                if #available(iOS 10.0, *) {
                    textContentType = .name
                }
            case .required: break
            } // END: switch
        }
    }
    
    override var isFieldVaild: Bool {
        let vtext = _vaildFieldText().0
        return vtext?.isNotEmpty == true
    }
    
    private func _vaildFieldText() -> (String?, String?) {
        guard let type = TextFieldContentType(rawValue: formContentType ?? "") else {
            return (text, nil)
        }
        switch type {
        case .mobile:
            guard let str = text?.trimmed() else {
                return (nil, "请输入手机号")
            }
            guard str.isValidPhoneNumber() else {
                return (nil, "手机号格式错误")
            }
            return (str, nil)
        case .code:
            guard let str = text?.trimmed() else {
                return (nil, "请输入验证码")
            }
            return (str, nil)
        case .password:
            guard let str = text, str.isNotEmpty else {
                return (nil, "请输入密码")
            }
            return (str, nil)
        case .password2:
            guard let str = text, str.isNotEmpty else {
                return (nil, "请输入确认密码")
            }
            guard str.count >= 8 else {
                return (nil, "密码长度至少8位")
            }
            guard str.count <= 30 else {
                return (nil, "密码长度不能超过30位")
            }
            return (str, nil)
        case .name:
            guard let str = text, str.isNotEmpty else {
                return (nil, "请输入姓名")
            }
            return (str, nil)
        case .required:
            guard let str = text?.trimmed(), str.isNotEmpty else {
                return (nil, placeholder)
            }
            return (str, nil)
        } // END: switch
    }
    
    /// 自动验证、提示并返回合法值
    ///
    /// - Parameters:
    ///   - noticeWhenInvaild: 内容非法时弹出报错提示
    ///   - becomeFirstResponderWhenInvaild: 内容非法时获取键盘焦点
    /// - Returns: 合法值
    func vaildFieldText(noticeWhenInvaild: Bool = true, becomeFirstResponderWhenInvaild: Bool = true) -> String? {
        let (vaildText, errorMessage) = _vaildFieldText()
        if let e = errorMessage {
            if noticeWhenInvaild {
                AppHUD().showErrorStatus(e)
            }
            if becomeFirstResponderWhenInvaild {
                becomeFirstResponder()
            }
        }
        return vaildText
    }
    
    override var iconImageView: UIImageView? {
        didSet {
            if let iv = iconImageView {
                let ivFrame = iv.convert(iv.bounds, to: self)
                var inset = textEdgeInsets
                inset.left = ivFrame.maxX + 14
                textEdgeInsets = inset
            }
        }
    }
}

/**
 搜索输入框，搜索时显示菊花进度
 */
class SearchTextField: MBSearchTextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16 + 16 + 12, height: 44))
        self.leftView = leftView
        self.leftViewMode = .always
        leftView.addSubview(iconView)
        iconView.frame = CGRect(x: 16, y: (leftView.height - 16) / 2, width: 16, height: 16)
        leftView.addSubview(loadingView)
        loadingView.move(xOffset: 2, yOffset: 0)
        loadingView.isHidden = true
    }
    
    lazy var iconView: UIImageView = {
        let icon = UIImageView(image: #imageLiteral(resourceName: "search_24"))
        icon.tintColor = .tint
        icon.contentMode = .center
        return icon
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView(style: .gray)
        a.center = CGPointOfRectCenter(self.leftView!.bounds)
        a.startAnimating()
        a.hidesWhenStopped = false
        return a
    }()
    
    override var isSearching: Bool {
        didSet {
            iconView.isHidden = isSearching
            loadingView.isHidden = !isSearching
        }
    }
}
