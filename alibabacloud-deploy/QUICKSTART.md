# 快速开始指南

## 5 分钟快速启动

### 1. 克隆或下载项目
```bash
cd alibabacloud-deploy
```

### 2. 创建虚拟环境
```bash
# Windows
python -m venv venv
venv\Scripts\activate

# macOS/Linux
python3 -m venv venv
source venv/bin/activate
```

### 3. 安装依赖
```bash
pip install -r requirements.txt
```

### 4. 配置环境
复制 `.env.example` 到 `.env` 并编辑：
```bash
cp .env.example .env
```

编辑 `.env` 文件，填入 Azure AD 配置：
```
AZURE_CLIENT_ID=your_id_here
AZURE_CLIENT_SECRET=your_secret_here
AZURE_AUTHORITY=https://login.microsoftonline.com/your_tenant_id
FLASK_SECRET_KEY=your_random_secret_key
```

### 5. 运行应用
```bash
python app.py
```

### 6. 打开浏览器
访问: `http://localhost:5000`

---

## 项目文件概览

```
alibabacloud-deploy/
├── app.py                   # 核心应用 (150+ 行)
├── config.py               # 配置管理 (40+ 行)
├── requirements.txt        # Python 依赖
├── .env.example            # 环境变量示例
├── README.md               # 详细文档
├── PYCHARM_SETUP.md        # PyCharm 配置指南
├── QUICKSTART.md           # 本文件
├── templates/              # HTML 模板
│   ├── base.html          # 主布局 (AWS 风格)
│   ├── login.html         # 登录页面
│   ├── dashboard.html     # 仪表板
│   ├── page_a.html        # Alpha 配置 (α)
│   ├── page_b.html        # Beta 部署 (β)
│   ├── page_c.html        # Gamma 监控 (γ)
│   ├── page_d.html        # Delta 分析 (δ)
│   ├── 404.html           # 404 页面
│   └── 500.html           # 500 页面
└── static/
    ├── css/
    │   ├── style.css      # 主样式表
    │   └── login.css      # 登录样式
    └── js/
        └── session.js     # 会话管理脚本
```

---

## 主要功能

### ✅ Azure AD SSO
- 企业级认证
- MSAL 库支持
- 令牌服务器端存储

### ✅ 安全会话
- 1 小时自动过期
- 令牌隐藏在 URL 之外
- HTTPONLY 和 Secure cookies

### ✅ 现代 UI
- AWS 控制台风格
- 左侧导航栏
- 实时会话计时
- 响应式设计

### ✅ 四个功能模块
- **A (Alpha α)**: 配置管理
- **B (Beta β)**: 部署管理
- **C (Gamma γ)**: 性能监控
- **D (Delta δ)**: 日志分析

---

## 路由表

| URL | 描述 | 认证 |
|-----|------|------|
| `/` | 首页 | ✓ |
| `/login` | 登录页面 | ✗ |
| `/auth/callback` | Azure 回调 | ✗ |
| `/dashboard` | 主仪表板 | ✓ |
| `/page_a` | Alpha 配置 | ✓ |
| `/page_b` | Beta 部署 | ✓ |
| `/page_c` | Gamma 监控 | ✓ |
| `/page_d` | Delta 分析 | ✓ |
| `/logout` | 退出登录 | ✓ |
| `/api/session-info` | 会话 API | ✓ |

---

## Azure AD 配置

### 获取配置信息

1. 访问 [Azure Portal](https://portal.azure.com)
2. 转到 **Azure Active Directory**
3. 选择 **应用注册**
4. 创建新应用或选择现有应用
5. 记录以下信息:

```
Client ID (应用程序 ID): xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Client Secret (客户端密码): your_secret_value
Tenant ID (目录 ID): xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### 配置重定向 URI

1. 在应用中选择 **身份验证**
2. 添加平台: **Web**
3. 重定向 URI: `http://localhost:5000/auth/callback`
4. (生产环境: `https://yourdomain.com/auth/callback`)

### 配置权限

1. 选择 **API 权限**
2. 添加权限 → Microsoft Graph → User.Read

---

## 环境变量说明

| 变量 | 说明 | 示例 |
|------|------|------|
| `AZURE_CLIENT_ID` | Azure App ID | `12345678-abcd-...` |
| `AZURE_CLIENT_SECRET` | Azure 客户端密钥 | `your_secret_value` |
| `AZURE_AUTHORITY` | Azure 登录 URL | `https://login.microsoftonline.com/tenant_id` |
| `FLASK_ENV` | 环境类型 | `development` 或 `production` |
| `FLASK_SECRET_KEY` | Flask 加密密钥 | `any_random_string` |
| `SESSION_TIMEOUT` | 会话超时秒数 | `3600` (1小时) |
| `REDIRECT_URI` | 登录回调地址 | `http://localhost:5000/auth/callback` |

---

## 测试应用

### 登录测试
1. 访问 `http://localhost:5000`
2. 自动重定向到 `/login`
3. 点击 "Sign In with Azure AD"
4. 使用 Azure AD 账户登录
5. 重定向到仪表板

### 导航测试
在仪表板中:
- 点击侧边栏 **A** → Alpha 配置
- 点击侧边栏 **B** → Beta 部署
- 点击侧边栏 **C** → Gamma 监控
- 点击侧边栏 **D** → Delta 分析

### 会话测试
- 观察右侧会话计时器
- 不活动 5 分钟后查看警告
- 1 小时后会话自动过期

### 错误页面测试
- 访问不存在的路由: `http://localhost:5000/nonexistent`
- 应显示 404 页面

---

## 常见问题

### Q: 怎样停止应用?
A: 在终端按 `Ctrl + C`

### Q: 怎样修改会话超时?
A: 编辑 `.env` 修改 `SESSION_TIMEOUT` 值 (秒数)

### Q: 怎样修改监听端口?
A: 编辑 `app.py` 最后的 `app.run()` 调用:
```python
app.run(debug=True, port=8080)  # 改为 8080 端口
```

### Q: 应用无法启动怎么办?
A: 检查:
1. 虚拟环境已激活
2. 所有依赖已安装
3. `.env` 文件存在且配置正确
4. 没有其他进程占用 5000 端口

### Q: 登录失败怎么办?
A: 检查:
1. Azure 配置信息正确
2. 重定向 URI 与 Azure 应用配置一致
3. 网络连接正常

---

## 下一步

### 开发
- 查看 `README.md` 了解详细信息
- 查看 `PYCHARM_SETUP.md` 配置 PyCharm
- 修改 `templates/` 中的 HTML
- 编辑 `static/css/` 中的样式

### 部署
- 更新 `.env` 为生产配置
- 使用 Gunicorn: `gunicorn -w 4 -b 0.0.0.0:5000 app:app`
- 配置 HTTPS
- 配置反向代理 (nginx/Apache)

### 扩展
- 添加数据库支持 (SQLAlchemy)
- 添加更多页面
- 集成更多功能
- 添加 API 端点

---

## 文件说明

### app.py (核心应用)
- Flask 应用初始化
- 路由定义
- Azure 认证处理
- 会话管理

### config.py (配置)
- 环境变量加载
- Flask 配置
- Azure 配置
- Session 配置

### base.html (主模板)
- 页面布局
- 侧边栏导航
- 用户信息显示
- 会话计时器

### style.css (样式)
- 整体设计
- 侧边栏样式
- 响应式布局
- 深色主题

### session.js (会话管理)
- 实时计时
- 超时警告
- 活动检测
- 会话过期处理

---

## 更新和支持

### 获取更新
```bash
git pull origin main
pip install -r requirements.txt --upgrade
```

### 报告问题
在 GitHub Issues 中报告任何问题或建议

### 获取帮助
查看 `README.md` 中的故障排除部分

---

**祝您使用愉快！** 🚀

最后更新: 2024-07-09
