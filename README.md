## VPN-IKEv2

###
在App里控制VPN　IKEv2的配置与连接断开

### 第一步 　

设置项目支持VPN

![Screenshot](https://raw.githubusercontent.com/ZhuGuiLei/VPN/master/img/1.png)


### 第二步 　

添加VPNIKEv2.framework

![Screenshot](https://raw.githubusercontent.com/ZhuGuiLei/VPN/master/img/2.png)

### 第三步  VPN控制

    初始化
```
let vpnMgr = VPNManager.init(type: .IKEv2, VPNName: "账户", serverAddress: "服务器地址", remoteIdentifier: "描述", passwordReference: "密码", sharedSecretReference: "密钥")
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
　
