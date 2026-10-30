# Drae 宠物乐园 2.0.0 验证记录

验证日期：2026-10-30。

## 构建与通过的检查

- `npm run build`：TypeScript 检查和 Vite 生产构建成功。
- `npm test`：15 项前端 API 解析测试通过。
- 前端目录 `go test ./...`：独立前端服务与 API 代理测试通过。
- 后端目录 `go test ./internal/mokant -run 'TestCoinBag|TestParseOwnCoinBag' -count=1`：福袋解析及请求编码测试通过。
- 后端目录 `go test ./cmd/server -count=1`：首次初始化端口及重启读取已有端口的测试通过。
- Windows amd64、Linux amd64 的前端和后端均使用 `CGO_ENABLED=0` 交叉编译成功；构建启用 `-trimpath`，二进制版本设为 `2.0.0`。

## Windows 发布包启动实测

使用全新的临时 SQLite 数据库和独立端口验证，不连接当前运行账号或萌卡节点。

- 后端首次初始化成功，`/api/version` 返回 `2.0.0`。
- 独立前端启动成功，`/api/version` 代理返回 `2.0.0`。
- `/pet` 页面及 JavaScript 资源与当前 Vite 构建逐字节一致，包含本次福袋入口。
- 通过前端代理登录临时管理员成功，会话 Cookie 正常；新安装的账号列表为空。
- 前端代理 `/healthz` 正常。
- Linux 包完成交叉编译及归档检查，未在 Linux 主机启动验证。

## 完整后端测试的未通过项目

`go test ./...` 本轮未全部通过。失败包包括：

- `internal/mokant`：食物、洗护、活动及资料测试仍存在旧 action、字段和业务结果断言；资料测试出现 panic。
- `internal/server`：账号资料、PK 路由及好友战力测试仍期望旧 action。
- `internal/autopk`：战力响应校验、挑战与护理顺序、补货测试失败。
- `internal/autocontrol`：活动状态、时长、召回与计划恢复、回踩及冒险行为测试失败。

这些失败尚未全部修复，不能将完整测试套件视为通过，也不能仅凭构建成功保证所有自动控制场景正常。

## 福袋链路限制

此前联调的好友福袋扫描和自家地面福袋查询均返回 OIDB `236 / cmd not found`。旧 `qqpet_get_coin_bag_detail` 返回 OIDB `135090`，没有获得可用福袋列表或验证领取成功。当前前端仅在领取请求提交后提示提交结果，不代表金币已实际入账。

## 发布包范围

每包包含前后端程序、对应系统启动脚本、README、更新日志、本验证记录、LICENSE 和包内文件校验清单。归档按文件白名单生成，不包含运行数据库、QQ 账号、节点 Token、Cookie、源码或调试日志。
