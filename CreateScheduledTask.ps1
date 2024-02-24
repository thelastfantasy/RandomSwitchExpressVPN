# Author: Lyoat
# Email: i@lyoat.com

# 该脚本需要在管理员权限下运行
# 该脚本用于创建一个 Windows 计划任务，用于在用户登录时每隔1小时执行 RandomSwitchExpressVpn.ps1 脚本，并在运行1分钟后停止
# 任务将被创建在 "ExpressVPN" 文件夹内

$ScriptName = "RandomSwitchExpressVpn.ps1"
$TaskName = "重连ExpressVPN"
$TaskFolderName = "ExpressVPN"
$ScriptPath = Join-Path -Path (Get-Location) -ChildPath $ScriptName

# 创建触发器：用户登录时触发
$TriggerAtLogon = New-ScheduledTaskTrigger -AtLogon
$TriggerHourly = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 60) -RepetitionDuration (New-TimeSpan -Days 99)

# 创建操作：执行 PowerShell 脚本
$Action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-File `"$ScriptPath`""

# 设置任务主体，使用最高权限运行
$Principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Highest

# 设置任务选项
$Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 1) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

# 检查并获取或创建任务文件夹
$TaskService = New-Object -ComObject Schedule.Service
$TaskService.Connect()
try {
    $TaskFolder = $TaskService.GetFolder("\$TaskFolderName")
}
catch {
    $TaskFolder = $TaskService.GetFolder("\").CreateFolder($TaskFolderName)
}

# 检查同名任务是否已存在
$ExistingTask = $null
try {
    $ExistingTask = $TaskFolder.GetTasks(0) | Where-Object { $_.Name -eq $TaskName }
}
catch {
    Write-Error "检查任务时出错: $_"
}

if ($ExistingTask) {
    Write-Output "任务 $TaskName 已存在于 $TaskFolderName 文件夹内，将更新任务信息。"
}
else {
    Write-Output "任务 $TaskName 不存在，继续创建。"
}

# 注册计划任务
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger @($TriggerAtLogon, $TriggerHourly) -Principal $Principal -Settings $Settings -TaskPath "\$TaskFolderName" -Force

Write-Output "计划任务 $TaskName 在 $TaskFolderName 文件夹内创建成功。"
