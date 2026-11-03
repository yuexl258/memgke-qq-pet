# Drae 宠物乐园 2.2.1

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

- 修复新版萌卡 NT 删除 `get_node_list` 后，添加账号误报“节点尚未连接”的问题。
- 节点列表改由本地配置提供；多节点按 QQ 绑定关系分发请求。
- 仅支持 Android 宠物协议；排行榜接口在后端对 QQ 号脱敏。
- 精简页面文案，优化毛玻璃效果与手机端布局。

详细内容见 [2.2.1 更新日志](https://github.com/yuexl258/memgke-qq-pet/blob/main/CHANGELOG_2.2.1.md)。

## 下载

- [Windows x64 安装包](https://github.com/yuexl258/memgke-qq-pet/releases/download/v2.2.1/drae-pet-2.2.1-windows-amd64.zip)
- [Linux x64 安装包](https://github.com/yuexl258/memgke-qq-pet/releases/download/v2.2.1/drae-pet-2.2.1-linux-amd64.tar.gz)
- [所有版本](https://github.com/yuexl258/memgke-qq-pet/releases)

## 解压后的文件

- `drae-pet-server.exe` / `drae-pet-server`：后端服务，保存账号、配置和数据库。
- `drae-pet-frontend.exe` / `drae-pet-frontend`：内嵌网页的前端服务，将 `/api`、`/healthz` 和 `/ws` 转发给后端。
- `start-server.cmd` / `start-server.sh`：启动后端。
- `start-frontend.cmd` / `start-frontend.sh`：启动前端。
- `SHA256SUMS.txt`：解压目录内文件的校验值；Release 页面另附两个压缩包的校验值。

两个服务都要运行，且应从**解压后的文件夹**启动；不要在压缩包预览窗口里直接运行。程序不需要安装 Node.js 或 Go。首次启动会在解压目录创建 `data/qq-pet.db`，请将文件夹放在有写入权限的位置。

## Windows：首次运行

1. 下载 Windows ZIP，右键“全部解压”。打开解压后含有 `start-server.cmd` 的文件夹。
2. 双击 `start-server.cmd`。首次运行依次输入服务端口号、管理员用户名、管理员密码；端口建议填 **2345**。看到 `server started` 后保留这个窗口。
3. 双击 `start-frontend.cmd`，保留第二个窗口。看到“Frontend 2.2.1 已启动”后，在浏览器打开 <http://127.0.0.1:5173>。
4. 用刚设置的管理员账号登录。先在管理后台配置正在运行的萌卡 NT 节点，再让用户生成专属指纹并添加 QQ。

每次重启都按“后端 → 前端”的顺序运行两个脚本。后端使用已有数据库时会读取已保存的端口和管理员账号，不再重复初始化。要停止服务，可在两个命令窗口分别按 `Ctrl+C`。

## Linux：首次运行

在存放压缩包的目录执行：

```sh
tar -xzf drae-pet-2.2.1-linux-amd64.tar.gz
cd drae-pet-2.2.1-linux-amd64
./start-server.sh
```

首次运行依次输入端口号（建议 **2345**）、管理员用户名、管理员密码。看到 `server started` 后，保持这个终端运行；在**另一个终端**进入同一解压目录并启动前端：

```sh
cd drae-pet-2.2.1-linux-amd64
./start-frontend.sh
```

在服务器本机打开 <http://127.0.0.1:5173>，登录后到管理后台配置萌卡 NT 节点。启动脚本及二进制在压缩包内已设置执行权限；如果解压方式丢失权限，可运行 `chmod +x start-server.sh start-frontend.sh drae-pet-server drae-pet-frontend`。用 `Ctrl+C` 停止对应服务。

## 服务配置

前端默认监听 `127.0.0.1:5173`，代理至 `http://127.0.0.1:2345`。首次启动后端时若选择了其他端口，例如 `8080`，需要在启动前端的**同一个终端**设置 `BACKEND_URL`：

在解压目录的地址栏输入 `cmd` 打开命令提示符，再执行：

```bat
set BACKEND_URL=http://127.0.0.1:8080
start-frontend.cmd
```

Linux 对应命令：`BACKEND_URL=http://127.0.0.1:8080 ./start-frontend.sh`。远程访问时，将 `FRONTEND_HOST` 设为 `0.0.0.0`，浏览器访问 `http://服务器IP:5173`，并放通前端端口；也可以通过反向代理访问。

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
