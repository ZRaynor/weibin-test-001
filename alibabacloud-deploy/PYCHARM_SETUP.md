# PyCharm 配置指南

本文档提供在 PyCharm 中配置和运行本项目的详细步骤。

## 前置条件

- PyCharm (Community 或 Professional 版本)
- Python 3.8 或更高版本
- Git

## 步骤 1: 打开项目

### 方法 A: 通过 File 菜单

1. 打开 PyCharm
2. 点击 **File** → **Open**
3. 导航到 `alibabacloud-deploy` 文件夹
4. 点击 **OK**

### 方法 B: 通过 Welcome 屏幕

1. 在 Welcome 屏幕点击 **Open**
2. 选择 `alibabacloud-deploy` 文件夹
3. 点击 **OK**

## 步骤 2: 创建虚拟环境

PyCharm 可以自动创建虚拟环境。

1. 打开 **File** → **Settings** (Windows/Linux) 或 **PyCharm** → **Preferences** (macOS)
2. 导航到 **Project: alibabacloud-deploy** → **Python Interpreter**
3. 点击右上角的 **⚙️** 图标
4. 选择 **Add...**
5. 在弹出窗口中选择 **New Environment...**
6. 确保 **Location** 指向项目下的 `venv` 文件夹
7. **Python Version** 选择 3.8 或更高
8. 点击 **Create**

PyCharm 将自动创建虚拟环境。

## 步骤 3: 安装依赖

依赖安装有两种方式：

### 方法 A: 通过 PyCharm 界面

1. 打开 **File** → **Settings** → **Project** → **Python Interpreter**
2. 点击项目列表下方的 **+** 按钮
3. 在弹出窗口搜索 `Flask`
4. 检查包名称和版本是否正确
5. 点击 **Install Package**
6. 重复操作安装其他依赖:
   - msal
   - requests
   - python-dotenv
   - gunicorn
   - Werkzeug

### 方法 B: 通过终端运行 pip

1. 打开 PyCharm 底部的 **Terminal**
2. 运行以下命令：
   ```bash
   pip install -r requirements.txt
   ```

## 步骤 4: 配置环境变量

### 方法 A: 创建 .env 文件

1. 在项目根目录右键 → **New** → **File**
2. 输入文件名 `.env`
3. 复制 `.env.example` 的内容到 `.env`
4. 修改 Azure AD 配置:
   ```
   AZURE_CLIENT_ID=your_client_id
   AZURE_CLIENT_SECRET=your_client_secret
   AZURE_AUTHORITY=https://login.microsoftonline.com/your_tenant_id
   FLASK_SECRET_KEY=your_secret_key
   ```

### 方法 B: 在 PyCharm 中设置环境变量

1. 打开 **Run** → **Edit Configurations...**
2. 点击 **+** 创建新配置
3. 选择 **Python**
4. 配置如下:
   - **Name**: Run Flask App
   - **Script path**: 选择 `app.py`
   - **Python interpreter**: 选择之前创建的虚拟环境
   - **Working directory**: 项目根目录

5. 在 **Environment variables** 部分添加:
   ```
   FLASK_ENV=development;
   FLASK_SECRET_KEY=your_secret_key;
   AZURE_CLIENT_ID=your_client_id;
   AZURE_CLIENT_SECRET=your_client_secret;
   AZURE_AUTHORITY=https://login.microsoftonline.com/your_tenant_id;
   REDIRECT_URI=http://localhost:5000/auth/callback
   ```

6. 点击 **OK**

## 步骤 5: 创建运行配置

### 配置 Flask 开发服务器

1. 打开 **Run** → **Edit Configurations...**
2. 点击左上角的 **+** 按钮
3. 选择 **Python**
4. 填入以下配置:

| 选项 | 值 |
|------|-----|
| **Name** | Run Flask App |
| **Script path** | `/full/path/to/app.py` |
| **Python interpreter** | 虚拟环境的 Python |
| **Working directory** | 项目根目录 |
| **Environment variables** | 如上一步所示 |
| **Emulate terminal in output console** | ✓ (勾选) |

5. 点击 **OK**

## 步骤 6: 运行应用

### 方法 A: 使用 Run 菜单

1. 点击顶部菜单 **Run** → **Run 'Run Flask App'**
2. 或使用快捷键 **Shift + F10**

### 方法 B: 从编辑器运行

1. 打开 `app.py`
2. 右键点击文件编辑区
3. 选择 **Run 'app'**

### 方法 C: 从左侧边栏运行

1. 在 Project 面板找到 `app.py`
2. 右键点击
3. 选择 **Run 'app'**

应用将启动，输出显示在底部的 Run 窗口：
```
 * Running on http://127.0.0.1:5000
```

## 步骤 7: 调试应用

### 启用调试模式

1. 打开 **Run** → **Edit Configurations...**
2. 在 **Environment variables** 中添加:
   ```
   FLASK_DEBUG=1
   ```
3. 点击 **OK**

### 设置断点

1. 打开 `app.py` 或任何其他 Python 文件
2. 点击行号左侧的空白处添加红点（断点）
3. 点击 **Run** → **Debug 'Run Flask App'** (或按 **Shift + F9**)
4. 当执行到断点时，应用会暂停

### 调试工具栏

在调试模式下，底部的调试窗口显示:
- **Variables**: 当前作用域的变量
- **Breakpoints**: 所有设置的断点
- **Console**: Python 交互式控制台

## 步骤 8: 访问应用

1. 打开浏览器
2. 访问 `http://localhost:5000`
3. 您应该看到登录页面
4. 点击 "Sign In with Azure AD" 按钮进行身份验证

## 常用快捷键

| 操作 | Windows/Linux | macOS |
|------|---------------|-------|
| 运行 | Shift + F10 | Control + R |
| 调试 | Shift + F9 | Control + D |
| 停止 | Ctrl + F2 | Cmd + F2 |
| 重新启动 | Ctrl + F5 | Cmd + F5 |
| 切换断点 | Ctrl + F8 | Cmd + F8 |
| 查看运行 | Alt + 4 | Cmd + 4 |
| 查看调试 | Alt + 5 | Cmd + 5 |

## 常见问题

### 问题: "No module named 'flask'"

**解决**:
1. 确认虚拟环境已激活
2. 检查 Python Interpreter 配置是否正确
3. 重新运行 `pip install -r requirements.txt`

### 问题: 调试器不工作

**解决**:
1. 确认 PyCharm 配置中的 Python Interpreter 正确
2. 检查断点是否被正确设置 (应显示红点)
3. 重新启动 PyCharm

### 问题: 端口 5000 已被占用

**解决**: 修改 `app.py` 最后一行:
```python
if __name__ == '__main__':
    app.run(debug=app.config['DEBUG'], host='127.0.0.1', port=5001)
```

### 问题: Azure 登录失败

**检查清单**:
1. ✓ `.env` 文件中的 Azure 配置正确
2. ✓ Azure AD 应用注册中的重定向 URI 包含 `http://localhost:5000/auth/callback`
3. ✓ 客户端 ID 和密钥正确
4. ✓ 网络连接正常

## 提示和技巧

### 热重载

PyCharm 支持 Flask 开发服务器的热重载。编辑 Python 文件后，应用会自动重启。

### 使用 Python Console

1. 打开 **View** → **Tool Windows** → **Python Console**
2. 在交互式 Python 环境中测试代码:
   ```python
   from app import app, get_msal_app
   with app.app_context():
       # 您可以在这里测试代码
   ```

### 代码检查和提示

PyCharm 提供实时代码检查:
- 黄色波浪线: 警告
- 红色波浪线: 错误
- 点击灯泡图标查看建议

### 性能监测

1. 运行应用
2. 打开 **Run** → **View Breakpoints**
3. 或使用 CPU Profiler (PyCharm Professional)

## 相关文档

- [PyCharm 官方文档](https://www.jetbrains.com/help/pycharm/)
- [Flask 文档](https://flask.palletsprojects.com/)
- [MSAL Python 文档](https://msal-python.readthedocs.io/)

---

**最后更新**: 2024-07-09
