@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: ===== 配置区（⚠️ 以下均为作者环境示例值，请替换为你自己的环境）=====
set NAS_IP=192.168.1.100
set SMB_SHARE=你的共享名
set REMOTE_SUBDIR=你的项目目录名
set DOMAIN=你的局域网域名
:: ===============================

:: 切换到脚本所在目录的上一级（项目根）
cd /d "%~dp0\.."

echo =========================================
echo  MyPersonalWebsite -^> NAS 同步脚本
echo  NAS IP: %NAS_IP%
echo  SMB 共享: %SMB_SHARE%
echo  远程目录: %REMOTE_SUBDIR%
echo  访问域名: http://%DOMAIN%
echo =========================================

:: 检查当前目录是否是项目根
if not exist "backend\app.py" (
    echo [错误] 请在项目根目录运行此脚本。
    pause
    exit /b 1
)

set NAS_PATH=\\%NAS_IP%\%SMB_SHARE%

:: 查找可用盘符（从 Z 往前）
for %%d in (Z Y X W V U T S R Q P O N M L K J I H G F E D) do (
    if not exist %%d:\ (
        set DRIVE=%%d:
        goto :found_drive
    )
)
echo [错误] 找不到可用盘符。
pause
exit /b 1

:found_drive
echo [信息] 使用临时盘符 %DRIVE%
set TARGET=%DRIVE%\%REMOTE_SUBDIR%

:: 挂载 SMB（若未保存凭据会自动弹出输入框）
echo [信息] 正在挂载 %NAS_PATH% 到 %DRIVE% ...
net use %DRIVE% %NAS_PATH% /persistent:no
if errorlevel 1 (
    echo [错误] SMB 挂载失败。请检查：
    echo   1. NAS IP 和共享名是否正确
    echo   2. 是否有访问权限（用户名/密码）
    echo   3. SMB 服务是否已开启
    pause
    exit /b 1
)

:: 确保目标目录存在
if not exist "%TARGET%" mkdir "%TARGET%"

:: 同步文件到 NAS
:: /MIR 会镜像两边内容：NAS 上多出来的文件会被删除，请确认配置正确
echo [信息] 开始同步到 %TARGET% ...
robocopy . "%TARGET%" /MIR /E /R:3 /W:5 /NDL /NFL ^
    /XD .venv .git __pycache__ backend1 scripts docker .agents .kimi-code ^
        deploy\caddy deploy\dnsmasq deploy\secret deploy\backup ^
    /XF *.pyc .gitignore .dockerignore

set ROBOCOPY_CODE=%ERRORLEVEL%

:: 卸载 SMB
echo [信息] 正在卸载 %DRIVE% ...
net use %DRIVE% /delete /y >nul 2>&1

:: robocopy 退出码 0~7 都属于正常或警告，8 及以上才表示错误
if %ROBOCOPY_CODE% GEQ 8 (
    echo [错误] 同步失败，robocopy 退出码: %ROBOCOPY_CODE%
    pause
    exit /b 1
)

echo.
echo =========================================
echo  [成功] 同步完成！
echo  请前往 fnOS Docker 面板重启 holy-web 容器
echo  以应用最新代码。
echo =========================================
echo  访问地址: http://%DOMAIN%
echo.
pause