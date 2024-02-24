## 说明
- 本脚本用于自动随机重连ExpressVPN
- 默认重连服务器区域为新加坡、台湾、香港、日本、韩国、澳门
  - 可执行`cd "C:\Program Files (x86)\ExpressVPN\services" && .\expressvpn.cli list`查看服务器列表，将你需要的服务器区域（匹配的部分字符）添加或覆盖到`RandomSwitchExpressVpn.ps1`文件的`$areas`变量中
  - 重连时间间隔为1小时
- 本脚本基于Powershell编写，适用于Windows系统
- 两个脚本（添加计划任务、执行重连）均需要管理员权限运行

## 运行要求：
- ExpressVPN已登录
- Powershell**管理员权限**执行`.\CreateScheduledTask.ps1`添加计划任务即可

## 注意事项：
- 本脚本仅供学习交流使用，严禁用于商业用途
- 请确保Powershell为最新版本，获取方法
  - [Windows PowerShell](https://aka.ms/powershell-release?tag=stable)
  - Windows应用商店搜索Powershell，点击安装
  - 启动Powershell方法：Win+X，选择Windows Powershell（管理员），或者在搜索框输入Powershell，右键选择以管理员身份运行