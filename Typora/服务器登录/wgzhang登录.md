

#### 一、登录作重服务器

因为校园网络限制，需要以作重服务器作为跳板来连接我们的服务器

##### 1 提前安装手机身份验证app

```
在安卓的应用商店输入"身份验证器"或"google authenticator"，IOS应用商店内输入"google authenticator"以搜索安装google authenticator身份验证软件。
```

扫码以生成动态口令

<img src=[key] style="zoom:25%;" />

##### 2 以keyboard-interactive身份验证方式登录作重集群

以xshell为例，IP地址、端口、用户名和密码信息如下

```
IP：211.69.141.140
端口：33322
用户名：qtyao
密码：qtyao_120028
```

- 新建xshell会话，填写"会话名称"以及"IP地址"

  [![Google_authenticator-1](http://hpc.ncpgr.cn/pic/Google_authenticator-7.png)](http://hpc.ncpgr.cn/pic/Google_authenticator-7.png)

- 点击右侧的"用户身份验证"，身份方法选择"Keyboard Interactive"，不勾选"password"，用户名填写服务器用户名，密码可以空着不填写，点击确定。

  [![Google_authenticator-1](http://hpc.ncpgr.cn/pic/Google_authenticator-8.png)](http://hpc.ncpgr.cn/pic/Google_authenticator-8.png)

- 尝试连接服务器，弹出"Verification code"窗口，填写手机身份验证app显示的6位数动态口令，点击确定。

  [![Google_authenticator-1](http://hpc.ncpgr.cn/pic/Google_authenticator-9.png)](http://hpc.ncpgr.cn/pic/Google_authenticator-9.png)

- 在弹出的"Password"窗口内填写服务器用户密码，点击"确定"即可登录到服务器。[![Google_authenticator-1](http://hpc.ncpgr.cn/pic/Google_authenticator-10.png)](http://hpc.ncpgr.cn/pic/Google_authenticator-10.png)

  

#### 二、登录课题组服务器

```
ssh wgzhang@122.205.95.212
```

输入密码后就能登入课题服务器了

```
IP：122.205.95.212
端口：22
用户名：wgzhang
初始密码：wg_zhang_123456
```

