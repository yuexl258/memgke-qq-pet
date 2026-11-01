# Drae 宠物乐园 2.1.0 验证记录

验证日期：2026-11-01。

## 通过的检查

- 前端 `npm test`：15 项测试通过。
- 前端 `npm run build`：TypeScript 检查及 Vite 生产构建通过。构建有资源体积提示，不影响产物生成。
- 独立前端启动器 `go test ./...`：静态资源、页面回退与 API 代理测试通过。
- 后端 `go test ./cmd/server ./internal/coinbag ./internal/database`：首次启动、数据库迁移及福袋领取账本测试通过。
- 后端 `go test ./internal/mokant ./internal/autocontrol -run 'Coin[Bb]ag|ProcessCoinbag' -count=1`：福袋协议、配置保存、先查询并领取自家再扫描好友、自家查询失败后继续扫描好友的测试通过。
- 后端 `go build ./...`：全部包编译通过。
- Windows amd64 和 Linux amd64 前后端二进制均构建成功，关闭 CGO。
- Windows 发行程序在隔离临时数据库与动态端口启动成功；后端健康检查、版本接口、首次管理员创建、登录会话及前端 API 代理检查通过。
- Windows 独立前端版本为 2.1.0；`/pet` 页面及所有静态资源的 SHA256 与本次 Vite 构建一致。

## 完整后端测试未通过

本次执行了 `go test ./...`，结果未全部通过，与 2.0.1 记录一致，以下四个包仍存在失败，不能据此认为自动控制和 PK 全链路已经通过回归：

| 包 | 失败范围 |
| --- | --- |
| `internal/autocontrol` | 活动状态与时长解析、召回、计划推进、串门及冒险测试 |
| `internal/autopk` | 战力解析、对手轮换、结算与照料补货测试 |
| `internal/mokant` | 仍断言旧 action 的喂食、洗护、活动请求与响应测试；`TestPetResponseAndStatusRequestUseCurrentSchema` 发生空字段类型转换 panic |
| `internal/server` | 仍断言旧 action 的宠物列表、PK 路由及好友战力测试 |

以上失败没有计入通过项，也没有通过跳过断言修改测试结果；本次发布仅整理当前功能和版本包，未修复这些历史回归项。

## 在线接口与平台范围

- 本轮打包验证未对真实宠物发起领取、购买、喂食或 PK 操作。
- 此前按用户指定的账号与目标测试 `friend.visit`，框架返回 `submitted: true`、`effect_verified: false`；仅确认请求已提交，未确认实际访问效果。
- Linux 程序在 Windows 上交叉编译完成，未在 Linux 主机执行启动验证。
- 现有开发服务未被本次冒烟测试替换或停止。

## 发布包

两套发布包均包含独立前端与后端程序、启动脚本、README、更新日志、验证记录、品牌图标、LICENSE 和文件 SHA256 校验清单。包内不含源码、运行数据库、QQ 账号、节点 Token 或会话凭据。

升级前停止旧版前后端并备份原服务端的整个 `data` 目录；将该目录复制到新版目录后启动。若回退，同时恢复旧程序和升级前的数据库备份。
