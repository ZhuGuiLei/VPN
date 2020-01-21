## VPN-L2TP

###
在App里控制VPN　L2TP的配置与连接断开

### 第一步 　

设置项目支持VPN

![Screenshot](https://raw.githubusercontent.com/ZhuGuiLei/VPN/master/img/01.png)

![Screenshot](https://raw.githubusercontent.com/ZhuGuiLei/VPN/master/img/02.png)


### 第二步 　

添加LJVPN.framework

![Screenshot](https://raw.githubusercontent.com/ZhuGuiLei/VPN/master/img/03.png)

### 第三步  VPN控制

初始化
```
// 只调用一次，做方法替换
VPNManager.initializeMethod()

// 初始化
let vpnMgr = VPNManager.init(type: .L2TP, VPNName: "账户", serverAddress: "服务器地址", remoteIdentifier: "描述", passwordReference: "密码", sharedSecretReference: "密钥", authenticationMethod: "验证方法")

// 设置代理
vpnMgr.delegate = self

// 当前连接状态
let status = vpnMgr.status
```
```
// 代理监听状态变化，类型为L2TP时监听状态总是无效
func VPNStatusDidChangeNotification(status: NEVPNStatus) {
}
```

VPN是否配置
```
vpnMgr?.checkProtocol(completion: { (b: Bool) in
    // b == true 是已经配置
})
```

创建VPN
```
vpnMgr.createVPN()
```

删除VPN
```
vpnMgr.removeVPN()
```

连接VPN
```
vpnMgr.connectVPN()
```

断开VPN
```
vpnMgr.disconnectVPN()
```
　
