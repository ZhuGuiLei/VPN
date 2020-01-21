//
//  LJVPNManager.swift
//  VPN
//
//  Created by apple on 2020/1/18.
//  Copyright © 2020 layne. All rights reserved.
//

import UIKit
import NetworkExtension

public enum LJVPNProtocolType: Int {
    case IKEv2 = 0
    case L2TP = 1
}

public protocol LJVPNStatusDelegate: NSObjectProtocol {
    /// 通过代理监听状态变化
    func VPNStatusDidChangeNotification(status: NEVPNStatus)
}

public class LJVPNManager: NSObject {
    
    /// 当前连接状态
    public var status: NEVPNStatus {
        get {
            return vpnMgr.connection.statusEx()
        }
    }
    
    var vpnMgr = NEVPNManager.shared()

    public var type = LJVPNProtocolType.IKEv2
    
    /// 账户
    public var VPNName: String?
    /// 服务器地址
    public var serverAddress: String?
    /// 描述
    public var localizedDescription: String?
    /// 密码
    public var passwordReference: String?
    /// 密钥
    public var sharedSecretReference: String?
    /// 身份验证方法
    public var authenticationMethod: NEVPNIKEAuthenticationMethod = .none
    
    public weak var delegate: LJVPNStatusDelegate?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /// 初始化
    /// - Parameters:
    ///   - type: 类型
    ///   - VPNName: 账户
    ///   - serverAddress: 服务器地址
    ///   - remoteIdentifier: 描述
    ///   - passwordReference: 密码
    ///   - sharedSecretReference: 密钥
    public init(type: LJVPNProtocolType, VPNName: String?, serverAddress: String?, localizedDescription: String?, passwordReference: String?, sharedSecretReference: String?, authenticationMethod: NEVPNIKEAuthenticationMethod? = NEVPNIKEAuthenticationMethod.none) {
        super.init()
        
        self.type = type
        self.VPNName = VPNName
        self.serverAddress = serverAddress
        self.localizedDescription = localizedDescription
        self.passwordReference = passwordReference
        self.sharedSecretReference = sharedSecretReference
        self.authenticationMethod = authenticationMethod ?? .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(VPNStatusDidChangeNotification(noti:)), name: .NEVPNStatusDidChange, object: nil)
    }
    
    /// VPN是否配置
    public func checkProtocol(completion: @escaping (_: Bool) -> Void) {
        vpnMgr.loadFromPreferences { (error) in
            if let e = error {
                print("error-load:\(e)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    /// 创建VPN
    public func createVPN() {
        vpnMgr.loadFromPreferences { (error) in
            if let e = error {
                print("error-load:\(e)")
            } else {
                self.setupVPNManager()
                self.vpnMgr.saveToPreferences { (error) in
                    if let e = error {
                        print("error-save:\(e)")
                    } else {
                        print("ok-save")
                    }
                }
            }
        }
    }
    
    /// 删除VPN
    public func removeVPN() {
        vpnMgr.loadFromPreferences { (error) in
            if let e = error {
                print("error-load:\(e)")
            } else {
                self.setupVPNManager()
                self.vpnMgr.removeFromPreferences { (error) in
                    if let e = error {
                        print("error-remove:\(e)")
                    } else {
                        print("ok-remove")
                    }
                }
            }
            
            
        }
    }
    
    /// 连接VPN
    public func connectVPN() {
        vpnMgr.loadFromPreferences { (error) in
            if let e = error {
                print("error-load:\(e)")
            } else {
                self.setupVPNManager()
                do {
                    try self.vpnMgr.connection.startVPNTunnel()
                } catch {
                    print("error-connect:\(error)")
                }
                
            }
        }
    }
    
    /// 断开VPN
    public func disconnectVPN() {
        vpnMgr.loadFromPreferences { (error) in
            if let e = error {
                print("error-load:\(e)")
            } else {
                self.setupVPNManager()
                self.vpnMgr.connection.stopVPNTunnel()
            }
        }
    }
    
    func setupVPNManager() {
        if type == .IKEv2 {
            setupIKEv2()
        } else {
            setupL2TP()
        }
    }
    
    func setupIKEv2()
    {
        let vpnProtocol = NEVPNProtocolIKEv2.init()
        vpnProtocol.serverAddress = serverAddress//"vpn服务器地址"
        vpnProtocol.username = VPNName//"vpn用户名"
        KeychainWrapper.standard.set(passwordReference ?? "", forKey: "KEYCHAIN_PASSWORD_KEY")
        vpnProtocol.passwordReference = KeychainWrapper.standard.dataRef(forKey: "KEYCHAIN_PASSWORD_KEY")
        
        // 预共享密钥认证
        vpnProtocol.authenticationMethod = authenticationMethod // 认证方式 （证书 和 预共享密钥）
        KeychainWrapper.standard.set(sharedSecretReference ?? "", forKey: "kSharedSecretReference")
        vpnProtocol.sharedSecretReference = KeychainWrapper.standard.dataRef(forKey: "kSharedSecretReference")
        
        // 证书认证
        //         vpnProtocol.authenticationMethod = .certificate
        //         vpnProtocol.identityData = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "client", ofType: "p12")!))
        //         vpnProtocol.identityDataPassword = "证书导入密钥"
        
        vpnProtocol.useExtendedAuthentication = false
        vpnProtocol.disconnectOnSleep = false // 睡眠是否断开vpn连接
        
        vpnMgr.protocolConfiguration = vpnProtocol // 设置VPN协议配置
        vpnMgr.localizedDescription = localizedDescription //"风速加速器"   // VPN本地名称
        vpnMgr.isEnabled = true                    // 激活VPN
        
        let rules = [NEOnDemandRule]()              // 配置按需连接的规则
        vpnMgr.onDemandRules = rules            // 设置按需连接规则
        vpnMgr.isOnDemandEnabled = false         // 按需连接默认开关
    }
    
    func setupL2TP()
    {
        let vpnProtocol = NEVPNProtocolL2TP.init()!
        vpnProtocol.serverAddress = serverAddress//"vpn服务器地址"
        vpnProtocol.username = VPNName  //"vpn用户名"
        KeychainWrapper.standard.set(passwordReference ?? "", forKey: "KEYCHAIN_PASSWORD_KEY")
        vpnProtocol.passwordReference = KeychainWrapper.standard.dataRef(forKey: "KEYCHAIN_PASSWORD_KEY")
        
        // 预共享密钥认证
        vpnProtocol.authenticationMethod = Int64(authenticationMethod.rawValue) // 认证方式 （证书 和 预共享密钥）
        KeychainWrapper.standard.set(sharedSecretReference ?? "", forKey: "kSharedSecretReference")
        vpnProtocol.sharedSecretReference = KeychainWrapper.standard.dataRef(forKey: "kSharedSecretReference")
        
        //        vpnProtocol.useExtendedAuthentication = true
        vpnProtocol.disconnectOnSleep = false // 睡眠是否断开vpn连接
        
        vpnMgr.protocolConfiguration = vpnProtocol // 设置VPN协议配置
        vpnMgr.localizedDescription = localizedDescription //"风速加速器"   // VPN本地名称
        vpnMgr.isEnabled = true                    // 激活VPN
        
        let rules = [NEOnDemandRule]()              // 配置按需连接的规则
        vpnMgr.onDemandRules = rules            // 设置按需连接规则
        vpnMgr.isOnDemandEnabled = false         // 按需连接默认开关
    }
    
    @objc fileprivate func VPNStatusDidChangeNotification(noti: Notification) {
        if let c = noti.object as? NEVPNConnection {
            let status = c.statusEx()
            if delegate != nil {
                delegate?.VPNStatusDidChangeNotification(status: status)
            }
        }
    }
    
    
    
    static public func initializeMethod() {
        
        
        var original = #selector(NEVPNManager.isProtocolTypeValid(_:))

        var swizzled = #selector(NEVPNManager.isProtocolTypeValid2(_:))

        self.swizzlingForClass(NEVPNManager.self, originalSelector: original, swizzledSelector: swizzled)

        original = #selector(getter: NEVPNConnection.status)

        swizzled = #selector(NEVPNConnection.statusEx)

        self.swizzlingForClass(NEVPNConnection.self, originalSelector: original, swizzledSelector: swizzled)
    }
    
    fileprivate static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(forClass, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) else { return }
        
        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}


extension NEVPNManager
{
    @objc func isProtocolTypeValid2(_ arg: CLongLong) -> Bool {
        return true
    }
}

extension NEVPNConnection
{
    @objc func statusEx() -> NEVPNStatus {
        return NEVPNStatus.disconnected
    }
}
