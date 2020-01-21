//
//  ViewController.swift
//  VPN
//
//  Created by apple on 2020/1/14.
//  Copyright © 2020 layne. All rights reserved.
//

import UIKit
import LJVPN

class ViewController: UIViewController, UITextFieldDelegate, LJVPNStatusDelegate {
    
    

    @IBOutlet weak var typeSelectControl: UISegmentedControl!
    
    @IBOutlet weak var remoteIdentifierText: UITextField!
    @IBOutlet weak var serverAddressText: UITextField!
    @IBOutlet weak var VPNNameText: UITextField!
    @IBOutlet weak var passwordReferenceText: UITextField!
    @IBOutlet weak var sharedSecretReferenceText: UITextField!
    
    var vpnMgr: LJVPNManager?
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == remoteIdentifierText {
            serverAddressText.becomeFirstResponder()
        } else if textField == serverAddressText {
            VPNNameText.becomeFirstResponder()
        } else if textField == VPNNameText {
            passwordReferenceText.becomeFirstResponder()
        } else if textField == passwordReferenceText {
            sharedSecretReferenceText.becomeFirstResponder()
        } else if textField == sharedSecretReferenceText {
            sharedSecretReferenceText.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        LJVPNManager.initializeMethod()

        typeChange(typeSelectControl)
        
        self.setupVPNManager()
    }
    
    
    @IBAction func typeChange(_ sender: UISegmentedControl) {
        remoteIdentifierText.text = UserDefaults.standard.object(forKey: "remoteIdentifier\(typeSelectControl.selectedSegmentIndex)") as? String ?? "vpn后台"
        serverAddressText.text = UserDefaults.standard.object(forKey: "serverAddress\(typeSelectControl.selectedSegmentIndex)") as? String ?? "10.3.178.178"
        VPNNameText.text = UserDefaults.standard.object(forKey: "VPNName\(typeSelectControl.selectedSegmentIndex)") as? String ?? "zhuguilei"
        passwordReferenceText.text = UserDefaults.standard.object(forKey: "passwordReference\(typeSelectControl.selectedSegmentIndex)") as? String ?? "zhuguilei.@af$"
        sharedSecretReferenceText.text = UserDefaults.standard.object(forKey: "sharedSecretReference\(typeSelectControl.selectedSegmentIndex)") as? String ?? "zhima123"
    } 
    
    @IBAction func saveAction(_ sender: UIButton) {
        UserDefaults.standard.set(remoteIdentifierText.text, forKey: "remoteIdentifier\(typeSelectControl.selectedSegmentIndex)")
        UserDefaults.standard.set(serverAddressText.text, forKey: "serverAddress\(typeSelectControl.selectedSegmentIndex)")
        UserDefaults.standard.set(VPNNameText.text, forKey: "VPNName\(typeSelectControl.selectedSegmentIndex)")
        UserDefaults.standard.set(passwordReferenceText.text, forKey: "passwordReference\(typeSelectControl.selectedSegmentIndex)")
        UserDefaults.standard.set(sharedSecretReferenceText.text, forKey: "sharedSecretReference\(typeSelectControl.selectedSegmentIndex)")
        
        setupVPNManager()
        
        SVProgressHUD.showSuccess(withStatus: "保存成功")
    }
    
    func setupVPNManager()
    {
        if typeSelectControl.selectedSegmentIndex == 0 {
            vpnMgr = LJVPNManager.init(type: .L2TP,
                                       VPNName: VPNNameText.text,
                                       serverAddress: serverAddressText.text,
                                       localizedDescription: remoteIdentifierText.text,
                                       passwordReference: passwordReferenceText.text,
                                       sharedSecretReference: sharedSecretReferenceText.text,
                                       authenticationMethod: .certificate)
        } else {
            vpnMgr = LJVPNManager.init(type: .IKEv2,
                                       VPNName: VPNNameText.text,
                                       serverAddress: serverAddressText.text,
                                       localizedDescription: remoteIdentifierText.text,
                                       passwordReference: passwordReferenceText.text,
                                       sharedSecretReference: sharedSecretReferenceText.text,
                                       authenticationMethod: .sharedSecret)
        }
        vpnMgr?.delegate = self
    }
    
   
    
    @IBAction func createAction(_ sender: UIButton) {
        vpnMgr?.createVPN()
    }
    
    @IBAction func removeAction(_ sender: UIButton) {
        vpnMgr?.removeVPN()
    }
    
    @IBAction func connectAction(_ sender: UIButton) {
        vpnMgr?.connectVPN()
    }
    
    
    @IBAction func disconnectAction(_ sender: UIButton) {
        print("\(vpnMgr!.status.rawValue)")
        vpnMgr?.disconnectVPN()
    }
    
    
    func VPNStatusDidChangeNotification(status: NEVPNStatus) {
        switch status {
            /// 0
            case .invalid:
                print("无效")
            case .disconnected:
                print("未连接")
            case .connecting:
                print("正在连接...")
            case .connected:
                print("已连接")
            case .reasserting:
                print("重复...")
            case .disconnecting:
                print("断开连接")
            default:
                break
        }
    }
    
    
}

