//
//  ViewController.swift
//  VPN
//
//  Created by apple on 2020/1/14.
//  Copyright © 2020 layne. All rights reserved.
//

import UIKit
import VPNIKEv2

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var typeSelectControl: UISegmentedControl!
    
    @IBOutlet weak var remoteIdentifierText: UITextField!
    @IBOutlet weak var serverAddressText: UITextField!
    @IBOutlet weak var VPNNameText: UITextField!
    @IBOutlet weak var passwordReferenceText: UITextField!
    @IBOutlet weak var sharedSecretReferenceText: UITextField!
    
    var vpnMgr: VPNManager?
    
    
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
        
        
        VPNManager.initializeMethod()

        typeChange(typeSelectControl)
        
        self.setupVPNManager()
    }
    
    
    @IBAction func typeChange(_ sender: UISegmentedControl) {
        remoteIdentifierText.text = UserDefaults.standard.object(forKey: "remoteIdentifier\(typeSelectControl.selectedSegmentIndex)") as? String
        serverAddressText.text = UserDefaults.standard.object(forKey: "serverAddress\(typeSelectControl.selectedSegmentIndex)") as? String
        VPNNameText.text = UserDefaults.standard.object(forKey: "VPNName\(typeSelectControl.selectedSegmentIndex)") as? String
        passwordReferenceText.text = UserDefaults.standard.object(forKey: "passwordReference\(typeSelectControl.selectedSegmentIndex)") as? String
        sharedSecretReferenceText.text = UserDefaults.standard.object(forKey: "sharedSecretReference\(typeSelectControl.selectedSegmentIndex)") as? String
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
            vpnMgr = VPNManager.init(type: .L2TP,
                                     VPNName: VPNNameText.text,
                                     serverAddress: serverAddressText.text,
                                     remoteIdentifier: remoteIdentifierText.text,
                                     passwordReference: passwordReferenceText.text,
                                     sharedSecretReference: sharedSecretReferenceText.text)
        } else {
            vpnMgr = VPNManager.init(type: .IKEv2,
                                     VPNName: VPNNameText.text,
                                     serverAddress: serverAddressText.text,
                                     remoteIdentifier: remoteIdentifierText.text,
                                     passwordReference: passwordReferenceText.text,
                                     sharedSecretReference: sharedSecretReferenceText.text)
        }
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
        vpnMgr?.disconnectVPN()
    }
    
    
    
    
    
}

