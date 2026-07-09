# Alibaba Cloud Deployment Platform

一个完整的 Python Flask 项目，用于 Alibaba Cloud 部署平台。集成了 Azure AD SSO (MSAL)，采用 AWS 控制台风格的界面布局。

## 功能特性

- ✅ **Azure AD SSO 集成**: 使用 MSAL 库实现企业级 Azure Active Directory 认证
- ✅ **安全会话管理**: 1 小时会话超时，令牌隐藏在 URL 之外
- ✅ **AWS 控制台风格界面**: 左侧导航栏 + 右侧内容区域
- ✅ **四个功能模块**:
  - A (Alpha α): 配置管理面板
  - B (Beta β): 部署管理面板
  - C (Gamma γ): 监控仪表板
  - D (Delta δ): 日志分析面板
- ✅ **实时会话计时**: 显示剩余会话时间并提前警告
- ✅ **完整的错误处理**: 404 和 500 错误页面
- ✅ **响应式设计**: 适配各种屏幕尺寸

## 项目结构

```
alibabacloud-deploy/
├── app.py                    # 主应用程序文件
├── config.py                 # 配置文件
├── requirements.txt          # Python 依赖
├── .env.example             # 环境变量示例
├── templates/               # Jinja2 模板
│   ├── base.html           # 基础模板（布局）
│   ├── login.html          # 登录页面
│   ├── dashboard.html      # 仪表板
│   ├── page_a.html         # Alpha 配置面板
│   ├── page_b.html         # Beta 部署面板
│   ├── page_c.html         # Gamma 监控面板
│   ├── page_d.html         # Delta 分析面板
│   ├── 404.html            # 404 错误页面
│   └── 500.html            # 500 错误页面
└── static/                  # 静态文件
    ├── css/
    │   ├── style.css       # 主样式表
    │   └── login.css       # 登录页面样式
    └── js/
        └── session.js      # 会话管理脚本
```

## 安装和配置

### 1. 前置要求

- Python 3.8+
- pip (Python 包管理器)
- Azure AD 租户和应用注册

### 2. 克隆项目

```bash
cd alibabacloud-deploy
```

### 3. 创建 Python 虚拟环境

```bash
# Windows
python -m venv venv
venv\Scripts\activate

# macOS/Linux
python3 -m venv venv
source venv/bin/activate
```

### 4. 安装依赖

```bash
pip install -r requirements.txt
```

### 5. 配置环境变量

复制 `.env.example` 到 `.env`:

```bash
cp .env.example .env
```

编辑 `.env` 文件并填入 Azure AD 配置:

```
# Azure AD Configuration
AZURE_CLIENT_ID=your_client_id_here
AZURE_CLIENT_SECRET=your_client_secret_here
AZURE_AUTHORITY=https://login.microsoftonline.com/your_tenant_id_here

# Flask Configuration
FLASK_ENV=development
FLASK_SECRET_KEY=your_secret_key_here
SESSION_TIMEOUT=3600

# Redirect URI
REDIRECT_URI=http://localhost:5000/auth/callback
```

### 6. Azure AD 应用注册指南

#### 步骤 1: 在 Azure Portal 中注册应用

1. 访问 [Azure Portal](https://portal.azure.com)
2. 导航到 **Azure Active Directory** → **应用注册**
3. 点击 **新注册**
4. 填入应用名称: `Alibaba Cloud Deployment`
5. 选择支持的账户类型（通常选择 `仅限此组织目录中的账户`）

#### 步骤 2: 配置重定向 URI

1. 在应用页面，选择 **身份验证**
2. 添加平台: 选择 **Web**
3. 输入重定向 URI: `http://localhost:5000/auth/callback`
4. 点击 **配置**

#### 步骤 3: 创建客户端密钥

1. 选择 **证书和密钥**
2. 点击 **新客户端密钥**
3. 设置过期时间并复制密钥值

#### 步骤 4: 配置 API 权限

1. 选择 **API 权限**
2. 点击 **添加权限**
3. 选择 **Microsoft Graph**
4. 选择 **委托权限** → 搜索 `User.Read`
5. 点击 **添加权限**

#### 步骤 5: 获取必要信息

- **Client ID**: 在应用概览页面
- **Client Secret**: 在证书和密钥页面
- **Tenant ID**: 在 Azure Active Directory 概览页面

## 运行应用

### 开发环境

```bash
# 激活虚拟环境
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# 运行 Flask 应用
python app.py
```

应用将在 `http://localhost:5000` 启动

### PyCharm 配置

1. **打开项目**
   - File → Open → 选择 `alibabacloud-deploy` 文件夹

2. **配置 Python 解释器**
   - File → Settings → Project → Python Interpreter
   - 点击齿轮图标 → Add
   - 选择 Existing Environment → 选择虚拟环境中的 python.exe
     - Windows: `alibabacloud-deploy\venv\Scripts\python.exe`
     - macOS/Linux: `alibabacloud-deploy/venv/bin/python`

3. **设置运行配置**
   - Run → Edit Configurations
   - 点击 + → Python
   - 名称: `Run Flask App`
   - Script path: 选择 `app.py`
   - Python interpreter: 选择虚�uted 环境
   - 点击 OK

4. **运行应用**
   - Run → Run 'Run Flask App'
   - 或按 Shift + F10

5. **调试**
   - Run → Debug 'Run Flask App'
   - 或按 Shift + F9

## 功能说明

### 登录流程

1. 用户访问 `/login`
2. 点击 "Sign In with Azure AD" 按钮
3. 被重定向到 Azure 登录页面
4. 输入 Azure AD 凭证
5. Azure 重定向回 `/auth/callback` 并返回授权码
6. 应用交换授权码获得令牌
7. 用户信息存储在服务器端 session 中
8. 重定向到仪表板

### 会话管理

- **会话超时**: 1 小时 (3600 秒)
- **令牌存储**: 所有令牌存储在服务器端 session 中，不在 URL 中暴露
- **会话刷新**: 用户活动时会话自动刷新
- **超时警告**: 剩余时间少于 5 分钟时显示警告
- **实时计时器**: 客户端显示剩余会话时间

### 四个功能模块

#### A - Alpha 配置面板 (α)
- 资源配置管理
- 安全设置
- 环境配置

#### B - Beta 部署面板 (β)
- 部署历史
- 部署管道
- 环境状态管理

#### C - Gamma 监控面板 (γ)
- 系统性能指标 (CPU、内存、磁盘、网络)
- 系统健康状态
- 实时告警

#### D - Delta 日志分析 (δ)
- 日志查询和过滤
- 日志条目浏览
- 使用统计
- 错误追踪

## 安全特性

### 认证和授权

- Azure AD 集成: 企业级身份验证
- MSAL 库: 安全的令牌管理
- 登录要求装饰器: 保护受限路由

### 会话安全

- 服务器端 session: 令牌不存储在 cookies 中
- HTTPONLY cookies: 防止 XSS 攻击
- Secure cookie: HTTPS 传输 (生产环境)
- SameSite: 防止 CSRF 攻击
- 会话超时: 1 小时自动过期

### API 安全

- CORS 保护
- 隐藏会话令牌
- HTTPS 强制 (生产环境)

## 生产部署

### 使用 Gunicorn

```bash
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

### 环境变量更新

生产环境中编辑 `.env`:

```
FLASK_ENV=production
FLASK_SECRET_KEY=your_very_secure_secret_key
SESSION_COOKIE_SECURE=True
REDIRECT_URI=https://yourdomain.com/auth/callback
```

### 配置 HTTPS

在生产环境中：
1. 获取 SSL 证书
2. 配置 nginx/Apache 反向代理
3. 更新 Azure AD 重定向 URI 为 HTTPS

### Docker 部署

创建 `Dockerfile`:

```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
```

构建和运行:

```bash
docker build -t alibaba-cloud-deploy .
docker run -p 5000:5000 --env-file .env alibaba-cloud-deploy
```

## 故障排除

### 问题: "No module named 'msal'"

**解决**: 确保安装了依赖
```bash
pip install -r requirements.txt
```

### 问题: Azure 登录失败

检查项目:
1. 验证 Azure AD 配置正确
2. 确认重定向 URI 与 Azure AD 应用注册一致
3. 检查客户端 ID 和密钥是否正确

### 问题: 会话超时不工作

检查 `.env` 中 `SESSION_TIMEOUT` 值设置是否正确

### 问题: CSRF 错误

确保 `FLASK_SECRET_KEY` 已在 `.env` 中设置且足够复杂

## API 端点

| 端点 | 方法 | 描述 | 需要认证 |
|------|------|------|---------|
| `/` | GET | 首页重定向 | 是 |
| `/login` | GET | 登录页面 | 否 |
| `/auth/callback` | GET | Azure AD 回调 | 否 |
| `/dashboard` | GET | 仪表板 | 是 |
| `/page_a` | GET | Alpha 配置面板 | 是 |
| `/page_b` | GET | Beta 部署面板 | 是 |
| `/page_c` | GET | Gamma 监控面板 | 是 |
| `/page_d` | GET | Delta 分析面板 | 是 |
| `/logout` | POST | 退出登录 | 是 |
| `/api/session-info` | GET | 会话信息 (JSON) | 是 |

## 文件说明

### app.py (主应用程序)

核心应用文件，包含：
- Flask 应用初始化
- MSAL 配置
- 所有路由处理
- 身份验证装饰器
- 会话管理

### config.py (配置文件)

配置管理：
- 环境变量加载
- Flask 配置
- Azure AD 配置
- Session 配置
- 开发和生产环境差异

### 模板文件

所有 HTML 模板使用 Jinja2 模板引擎：
- 继承基础模板
- CSRF 保护
- 用户信息显示
- 响应式设计

### 静态文件

#### style.css
- 全局样式
- 侧边栏导航
- 内容区域
- 响应式布局
- 深色主题

#### login.css
- 登录页面专用样式
- 渐变背景
- 动画效果
- 响应式登录框

#### session.js
- 会话计时器
- 活动检测
- 超时警告
- 会话过期处理
- API 调用管理

## 技术栈

| 组件 | 版本 | 用途 |
|------|------|------|
| Flask | 3.0.0 | Web 框架 |
| MSAL | 1.24.1 | Azure AD 认证 |
| Requests | 2.31.0 | HTTP 请求库 |
| python-dotenv | 1.0.0 | 环境变量管理 |
| Gunicorn | 21.2.0 | WSGI 服务器 |
| Werkzeug | 3.0.1 | WSGI 实用工具 |

## 开发指南

### 添加新页面

1. 在 `app.py` 中创建新路由:
```python
@app.route('/page_new')
@login_required
def page_new():
    return render_template('page_new.html', 
                         page_title='New Page',
                         page_content='Your content here')
```

2. 创建 `templates/page_new.html`:
```html
{% extends "base.html" %}
{% block page_title %}New Page{% endblock %}
{% block content %}
<!-- Your HTML content -->
{% endblock %}
```

3. 在 `base.html` 中添加导航链接

### 自定义样式

编辑 `static/css/style.css` 修改全局样式，或创建新的 CSS 文件并在模板中链接

### 添加新 API 端点

在 `app.py` 中添加新路由，使用 `@login_required` 装饰器保护:

```python
@app.route('/api/new-endpoint')
@login_required
def new_endpoint():
    return jsonify({'status': 'success', 'data': {}})
```

## 许可证

该项目为内部使用项目。

## 作者

Copilot AI Assistant

## 支持

遇到问题? 检查以下内容:
1. 所有依赖已安装
2. `.env` 文件配置正确
3. Azure AD 应用注册完成
4. Python 版本为 3.8 或更高

---

**最后更新**: 2024-07-09
