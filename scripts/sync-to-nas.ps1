#Requires -Version 5.1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ===== 配置区（⚠️ 以下均为作者环境示例值，请替换为你自己的环境）=====
$NAS_IP        = "192.168.1.100"             # NAS 局域网 IP（示例）
$SMB_SHARE     = "你的共享名"                # 在 fnOS 中设置的 SMB 共享名
$REMOTE_SUBDIR = "你的项目目录名"            # 共享目录下的子目录
$DOMAIN        = "你的局域网域名"
# ===============================

# 切换到脚本所在目录的上一级（项目根）
Set-Location (Split-Path -Parent $PSScriptRoot)

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " MyPersonalWebsite -> NAS 同步脚本"
Write-Host " NAS IP: $NAS_IP"
Write-Host " SMB 共享: $SMB_SHARE"
Write-Host " 远程目录: $REMOTE_SUBDIR"
Write-Host " 访问域名: http://$DOMAIN"
Write-Host "=========================================" -ForegroundColor Cyan

# 检查当前目录是否是项目根
if (-not (Test-Path "backend\app.py")) {
    Write-Host "[错误] 请在项目根目录运行此脚本。" -ForegroundColor Red
    Read-Host "按回车退出"
    exit 1
}

$SMB_PATH = "\\$NAS_IP\$SMB_SHARE"

# 查找可用盘符（从 Z 往前）
$driveLetter = $null
foreach ($d in 'Z','Y','X','W','V','U','T','S','R','Q','P','O','N','M','L','K','J','I','H','G','F','E','D') {
    if (-not (Test-Path "$d`:\")) {
        $driveLetter = $d
        break
    }
}
if (-not $driveLetter) {
    Write-Host "[错误] 找不到可用盘符。" -ForegroundColor Red
    Read-Host "按回车退出"
    exit 1
}

$drive = "$driveLetter`:"
Write-Host "[信息] 使用临时盘符 $drive"

# 挂载 SMB（使用 net use，确保 robocopy 等原生程序可见）
function Mount-Smb {
    param([string]$User, [string]$Pass)
    if ($User) {
        $netCmd = "net use $drive `"$SMB_PATH`" `"$Pass`" /user:`"$User`" /persistent:no"
    } else {
        $netCmd = "net use $drive `"$SMB_PATH`" /persistent:no"
    }
    $result = Invoke-Expression $netCmd 2>&1
    return @{ ExitCode = $LASTEXITCODE; Output = $result }
}

$mountResult = Mount-Smb
if ($mountResult.ExitCode -ne 0) {
    Write-Host "[信息] 需要输入 SMB 凭据..." -ForegroundColor Yellow
    try {
        $cred = Get-Credential -Message "请输入 NAS 的 SMB 用户名和密码"
        $user = $cred.UserName
        $pass = $cred.GetNetworkCredential().Password
        $mountResult = Mount-Smb -User $user -Pass $pass
        if ($mountResult.ExitCode -ne 0) {
            throw ($mountResult.Output -join "`n")
        }
    } catch {
        Write-Host "[错误] SMB 挂载失败: $_" -ForegroundColor Red
        Write-Host "请检查：" -ForegroundColor Yellow
        Write-Host "  1. NAS IP 和共享名是否正确"
        Write-Host "  2. 是否有访问权限（用户名/密码）"
        Write-Host "  3. SMB 服务是否已开启"
        Read-Host "按回车退出"
        exit 1
    }
}

$target = Join-Path $drive $REMOTE_SUBDIR
if (-not (Test-Path $target)) {
    New-Item -ItemType Directory -Path $target -Force | Out-Null
}

# 同步文件到 NAS
# /MIR 会镜像两边内容：NAS 上多出来的文件会被删除，请确认配置正确
Write-Host "[信息] 开始同步到 $target ..."
$excludeDirs  = @('.venv', '.git', '__pycache__', 'backend1', 'scripts', 'docker', '.agents', '.kimi-code', 'deploy\caddy', 'deploy\dnsmasq', 'deploy\secret', 'deploy\backup')
$excludeFiles = @('*.pyc', '.gitignore', '.dockerignore')

$robocopyArgs = @(
    '.',
    $target,
    '/MIR', '/E', '/R:3', '/W:5', '/NDL', '/NFL'
) + ($excludeDirs | ForEach-Object { '/XD', $_ }) + ($excludeFiles | ForEach-Object { '/XF', $_ })

& robocopy.exe @robocopyArgs
$robocode = $LASTEXITCODE

# 卸载 SMB
Write-Host "[信息] 正在卸载 $drive ..."
& net use $drive /delete /y 2>&1 | Out-Null

# robocopy 退出码 0~7 都属于正常或警告，8 及以上才表示错误
if ($robocode -ge 8) {
    Write-Host "[错误] 同步失败，robocopy 退出码: $robocode" -ForegroundColor Red
    Read-Host "按回车退出"
    exit 1
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host " [成功] 同步完成！"
Write-Host " 请前往 fnOS Docker 面板重启 holy-web 容器"
Write-Host " 以应用最新代码。"
Write-Host "========================================="
Write-Host " 访问地址: http://$DOMAIN"
Write-Host ""
Read-Host "按回车退出"