/**
 MessageManager.swift
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

class MessageManager: RFSVProgressMessageManager {
    
    /**
     显示加载状态
     */
    @objc func showActivityIndicator(withIdentifier identifier: String, groupIdentifier group: String?, model: Bool, message: String?) {
        guard let msg = try? RFNetworkActivityIndicatorMessage(configuration: { cm in
            guard let m = cm as? RFNetworkActivityIndicatorMessage else { return }
            m.identifier = identifier
            m.groupIdentifier = group
            m.title = nil
            m.message = message
            m.modal = model
            m.status = .loading
        }) else { return }
        show(msg)
    }
    
    /**
     显示一个操作成功的信息，显示一段时间后自动隐藏
     */
    @objc func showSuccessStatus(_ message: String?) {
        guard let msg = try? RFNetworkActivityIndicatorMessage(configuration: { cm in
            guard let m = cm as? RFNetworkActivityIndicatorMessage else { return }
            m.identifier = ""
            m.message = message
            m.status = .success
            m.priority = .high
        }) else { return }
        show(msg)
    }
    
    
    /**
     显示一个错误提醒，一段时间后自动隐藏
     */
    @objc func showErrorStatus(_ message: String?) {
        guard let msg = try? RFNetworkActivityIndicatorMessage(configuration: { cm in
            guard let m = cm as? RFNetworkActivityIndicatorMessage else { return }
            m.identifier = ""
            m.message = message
            m.status = .fail
            m.priority = .high
        }) else { return }
        show(msg)
    }
    
    /**
     显示一个操作失败的错误消息，显示一段时间后自动隐藏
     */
    @objc func alertError(_ error: NSError?, title: String?) {
        let ep = NSMutableArray(capacity: 3)
        ep.rf_add(error?.localizedDescription)
        ep.rf_add(error?.localizedFailureReason)
        ep.rf_add(error?.localizedRecoverySuggestion)
        let message = ep.componentsJoined(by: "\n")
        
        if let e = error {
            debugPrint("Error: \(e.domain) (\(e.code), URL:\(String(describing: e.userInfo[NSURLErrorFailingURLErrorKey]))")
        }
        
        guard let msg = try? RFNetworkActivityIndicatorMessage(configuration: { cm in
            guard let m = cm as? RFNetworkActivityIndicatorMessage else { return }
            m.identifier = ""
            m.message = message
            m.status = .fail
            m.priority = .high
        }) else { return }
        show(msg)
    }
}
