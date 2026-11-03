# Drae 宠物乐园 2.2.0

QQ 宠物资料、日常照料、好友互动、PK 与自动托管的 Web 乐园。

![Drae 宠物乐园](icon.png)

> ## ☁️ 服务器赞助商：鸿梦云
>
> **[点击访问鸿梦云，获取云服务器支持](https://hmyun.com.cn/?i93d950)**
>
> 感谢鸿梦云对 Drae 宠物乐园的服务器赞助。

交流群：**1130029070**

由于二开版本过多，所以采用闭源方式发布，但是允许运营。

## 本版更新

- 自动控制各模块独立开关、分页及日志，运行状态更直观。
- WS 每分钟重连，完善心跳检测；账号恢复在线后自动恢复因掉线暂停的功能。
- 自动福袋改为每 5 分钟扫描，修复自动踩一踩，优化宠物资料加载。
- 适配最新 NTLogin / WTLogin 登录与离线编辑，删除 QQ 同步删除框架账号。
- 新增个人专属设备指纹：每位用户最多 5 个，支持独立生成、绑定时自动生成及重命名，不允许移除。
- 支持自己与指定好友宠物的阈值照料，用品不足自动购买。
- 手动及计划打工支持随机、指定雇佣，雇佣优先发包，失败后自动普通打工。

详细内容见 [2.2.0 更新日志](CHANGELOG_2.2.0.md)。

## 下载

- [Windows x64 安装包](https://github.com/yuexl258/memgke-qq-pet/releases/download/v2.2.0/drae-pet-2.2.0-windows-amd64.zip)
- [Linux x64 安装包](https://github.com/yuexl258/memgke-qq-pet/releases/download/v2.2.0/drae-pet-2.2.0-linux-amd64.tar.gz)
- [所有版本](https://github.com/yuexl258/memgke-qq-pet/releases)

## 文件说明

- `drae-pet-server`：后端 API 服务，Windows 下以 `.exe` 结尾。
- `drae-pet-frontend`：内嵌网页的独立前端服务，代理 `/api`、`/healthz` 和 `/ws` 请求至后端。
- `start-server` / `start-frontend`：对应平台的启动脚本。
- `SHA256SUMS.txt`：文件校验值。

程序不依赖 Node.js 或 Go 开发环境，发行包不包含运行数据库或预置账号。

## Windows 启动

1. 将 ZIP 完整解压至可写目录。
2. 双击 `start-server.cmd`，首次启动按提示设置端口、管理员用户名与密码；建议端口 `2345`。
3. 双击 `start-frontend.cmd`，浏览器访问 <http://127.0.0.1:5173>。
4. 在管理端配置萌卡 NT 节点；用户先生成专属指纹，或在绑定 QQ 时选择自动生成。

## Linux 启动

```sh
tar -xzf drae-pet-2.2.0-linux-amd64.tar.gz
cd drae-pet-2.2.0-linux-amd64
sh start-server.sh
# 另一个终端进入同一目录
sh start-frontend.sh
```

首次启动后端时按提示设置端口及管理员凭据。二进制及脚本已设置执行权限，也可直接使用 `./start-server.sh` 和 `./start-frontend.sh`。

## 服务配置

前端默认监听 `127.0.0.1:5173`，代理至 `http://127.0.0.1:2345`。后端使用其他端口时设置 `BACKEND_URL`；服务器部署可设置 `FRONTEND_HOST=0.0.0.0`，或通过反向代理访问。

| 环境变量 | 作用 |
| --- | --- |
| `BACKEND_URL` | 后端地址，默认 `http://127.0.0.1:2345` |
| `FRONTEND_HOST` | 前端监听地址，默认 `127.0.0.1` |
| `FRONTEND_PORT` | 前端端口，默认 `5173` |
| `NO_OPEN` | 设为 `0` 时尝试自动打开浏览器 |
| `DATABASE_PATH` | 数据库位置，默认 `./data/qq-pet.db` |
| `APP_ADDR` | 空数据库首次初始化的后端地址，如 `:2345` |
| `ADMIN_USERNAME` / `ADMIN_PASSWORD` | 首次创建管理员使用，未设置则终端提示输入 |

启动脚本将工作目录固定在解压目录。后续启动读取数据库内保存的监听地址和账号配置。

## 从旧版升级

1. 停止旧版前后端，备份整个 `data` 目录。
2. 将新版本解压到独立目录，把原服务端实际使用的 `data` 目录复制到新目录。
3. 启动新版后端，数据库迁移自动执行；随后启动新版前端并刷新浏览器。
4. 核对自动控制开关、每日计划和照料设置。选择打工雇佣方式或修改每日计划后，点击保存计划。
5. 原来使用共享指纹的 QQ，再次登录前先生成自己的专属指纹，下线后通过“修改账号”选择指纹并完整填写配置。已在线账号不会自动更换指纹。

需要回退时同时恢复旧程序和升级前备份的数据库。
