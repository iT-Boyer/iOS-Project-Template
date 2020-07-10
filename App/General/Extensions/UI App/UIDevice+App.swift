import CoreTelephony
import SystemConfiguration.CaptiveNetwork

/**
 应用级别的便捷方法
 */
extension UIDevice {

    // @MBDependency:2
    /// 用户网络是否是移动数据
    @objc var isUsingMobileNetwork: Bool {
        #if targetEnvironment(macCatalyst)
        return false
        #else
        return CTTelephonyNetworkInfo().currentRadioAccessTechnology != nil
        #endif
    }

    // @MBDependency:2
    /// 用户网络是否是高速移动网络
    @objc var isUsingHighSpeedMobileNetwork: Bool {
        #if targetEnvironment(macCatalyst)
        return false
        #else
        guard let type = CTTelephonyNetworkInfo().currentRadioAccessTechnology else {
            return false
        }
        // 只列出旧类型，因为新出的应该是更快的技术
        switch type {
        case
        // REF: https://en.wikipedia.org/wiki/Template:Cellular_network_standards
        // 3G 早起技术，不能算高速网络
        CTRadioAccessTechnologyCDMAEVDORev0,

        // 属于 3G 家族，但 2G 速率
        CTRadioAccessTechnologyCDMA1x,

        // CT 里特指早期 3G 技术，被 HSDPA、HSUPA 取代，速率不能算高速
        CTRadioAccessTechnologyWCDMA,
        CTRadioAccessTechnologyGPRS,
        CTRadioAccessTechnologyEdge:
            return false
        default:
            return true
        }
        #endif
    }

    // @MBDependency:1
    /// 获取当前加入 Wi-Fi 的 SSID
    /// iOS 12 需要在 Capabilities 选项卡中打开 Access WiFi Information
    // swiftlint:disable:next identifier_name
    @objc var WiFiSSID: String? {
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else { return nil }
        let key = kCNNetworkInfoKeySSID as String
        for interface in interfaces {
            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? else { continue }
            return interfaceInfo[key] as? String
        }
        return nil
    }
}
