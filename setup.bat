@echo off
chcp 65001 >nul
echo ========================================
echo   AI 水印去除工具 — 本地部署脚本
echo ========================================
echo.

:: -------------------------------------------
:: 1. 检查 Python
:: -------------------------------------------
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Python，请先安装 Python 3.11+
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)
echo [OK] Python 已安装

:: -------------------------------------------
:: 2. 检查 Node.js
:: -------------------------------------------
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Node.js，请先安装 Node.js 18+
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)
echo [OK] Node.js 已安装

:: -------------------------------------------
:: 3. 安装后端依赖
:: -------------------------------------------
echo.
echo [1/4] 安装后端 Python 依赖...
cd backend
python -m venv venv
call venv\Scripts\activate.bat
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [错误] 后端依赖安装失败
    pause
    exit /b 1
)
echo [OK] 后端依赖安装完成
cd ..

:: -------------------------------------------
:: 4. 安装前端依赖
:: -------------------------------------------
echo.
echo [2/4] 安装前端 npm 依赖...
cd frontend
call npm install
if %errorlevel% neq 0 (
    echo [错误] 前端依赖安装失败
    pause
    exit /b 1
)
echo [OK] 前端依赖安装完成
cd ..

:: -------------------------------------------
:: 5. 启动后端
:: -------------------------------------------
echo.
echo [3/4] 启动后端服务 (端口 8000)...
cd backend
start "AI-Watermark-Backend" cmd /k "call venv\Scripts\activate.bat && uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload"
cd ..
timeout /t 3 >nul
echo [OK] 后端服务已启动

:: -------------------------------------------
:: 6. 启动前端
:: -------------------------------------------
echo.
echo [4/4] 启动前端服务 (端口 3000)...
cd frontend
start "AI-Watermark-Frontend" cmd /k "npm run dev"
cd ..
timeout /t 3 >nul
echo [OK] 前端服务已启动

:: -------------------------------------------
:: 完成
:: -------------------------------------------
echo.
echo ========================================
echo   部署完成！
echo   前端地址: http://localhost:3000
echo   后端地址: http://localhost:8000
echo   健康检查: http://localhost:8000/health
echo ========================================
echo.
echo 关闭两个命令行窗口即可停止服务。
echo.
pause
