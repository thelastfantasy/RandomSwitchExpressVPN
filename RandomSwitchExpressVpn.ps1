# Author: Lyoat
# Email: i@lyoat.com
# Encoding: UTF-8 with BOM

# 该脚本用于在 Windows 上随机切换 ExpressVPN 的 VPN 位置
# 该脚本需要在 PowerShell 中运行，且需要以管理员权限运行
# 默认切换的 VPN 位置为：新加坡、台湾、香港、日本、韩国、澳门
# 执行脚本前请确保已安装 ExpressVPN Windows程序 并登录账号

$areas = @("Singapore", "Taiwan", "Hong Kong", "Japan", "Korea", "Macau")

# 进入 ExpressVPN 安装目录
Set-Location "C:\Program Files (x86)\ExpressVPN\services"

# 收集 VPN 位置名称到数组
$vpnLocations = .\expressvpn.cli list | Where-Object { $_ -match ($areas -join "|") } | ForEach-Object { $_ -replace " \d+$", "" } | ForEach-Object { $_.Trim() }

# 从数组中随机选择一个 VPN 位置
$selectedLocation = Get-Random -InputObject $vpnLocations

# 使用选中的位置名称执行 ExpressVPN 连接命令
.\ExpressVPN.CLI disconnect
.\ExpressVPN.CLI connect $selectedLocation
Clear-DnsClientCache

# 打印所选的 VPN 位置名称，以确认已选择的位置
Write-Output "Connecting to: $selectedLocation"

# 打印当前时间，以确认脚本执行时间
Get-Date

# 查看VPN连接状态，以确认 VPN 是否已连接
.\ExpressVPN.CLI status
