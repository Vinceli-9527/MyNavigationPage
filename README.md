# MyPersonalWebsite

> 🌏 English version: [README-en.md](README-en.md) | 中文

一个集导航主页、零落盘漫画下载工具、AI 模型余额查询于一体的个人网站。

> 它既可以跑在你自己的电脑上，也可以部署到家里的 NAS（以飞牛 fnOS系统为例）上长期运行：
> **局域网内**用 <示例>`http://VinceNavigation.local` 访问（不用记 IP、不用带端口），**公网**用 `https://your-nas.ts.net` 访问（自带 HTTPS 加密）。

> 📌 **关于示例值（重要）**：本文档里出现的 IP、域名、路径都是**作者自己设备的示例值**，请务必替换为你自己的环境：
>
> | 示例值 | 含义 | 你需要替换为 |
> |--------|------|--------------|
> | `192.168.31.172` | 作者的 NAS 局域网 IP | 你 NAS 的实际局域网 IP |
> | `192.168.31.1` | 作者的路由器 IP | 你路由器的实际 IP |
> | `VinceNavigation.local` | 作者自选的局域网域名 | 你喜欢的域名（如 `mynas.local`） |
> | `your-nas.ts.net` | 作者的 Tailscale 公网域名 | 你自己的 Tailscale 设备域名 |
> | `你的NAS项目目录` | 作者 NAS 上的项目目录 | 你 NAS 上的任意项目目录 |
>
> 凡是出现以上值的地方都只是示例；含真实值的配置只存在于你自己的 NAS 上，不会出现在公开仓库里。

---

## 目录

- [零、我是完全不懂电脑的小白，从哪开始？](#零我是完全不懂电脑的小白从哪开始)
- [一、安装 Python](#一安装-python)
- [二、下载本项目](#二下载本项目)
- [三、安装依赖](#三安装依赖)
- [四、运行项目](#四运行项目)
- [五、访问网站](#五访问网站)
- [六、常见问题（本地运行）](#六常见问题本地运行)
- [七、NAS 部署指南（推荐，长期运行）](#七nas-部署指南推荐长期运行)
- [项目结构](#项目结构)

---

## 零、我是完全不懂电脑的小白，从哪开始？

**别怕，这份教程就是为你写的。** 你不需要懂编程，只需要会打字、会点击鼠标，跟着下面的步骤一步步来就行。整个过程大约需要 **15～30 分钟**。

在开始之前，先记住两个概念：

> **命令行（终端）**：一个黑乎乎的窗口，你在里面打字指挥电脑干活。别被它吓到，你只需要复制粘贴几条命令而已。
>
> **复制粘贴的快捷键**：在命令行窗口里，`Ctrl + V` 可能不管用。你需要用鼠标右键点击窗口，选择"粘贴"，或者按 `Ctrl + Shift + V`。

好，开始吧！如果你只想在自己电脑上体验一下，看第一～六章；如果你家里有 NAS 想长期部署（局域网域名 + 公网 HTTPS），直接看第七章。

---

## 一、安装 Python

本项目是用 Python 语言写的，所以你的电脑需要安装 Python。

### 1. 下载 Python

打开浏览器，访问 Python 官网下载页面：

```
https://www.python.org/downloads/
```

页面会自动识别你的操作系统。你会看到一个黄色的大按钮，上面写着类似 **"Download Python 3.12.x"** 的字样。点击它下载。

> **注意**：版本号可能略有不同，只要是 3.10 或更新的版本都行。

### 2. 安装 Python

找到你刚下载的文件（通常在"下载"文件夹里），双击打开它。

> **这一步非常关键！**

在安装界面的**最底部**，有一个勾选框写着：

```
☐ Add Python 3.x to PATH
```

**一定要勾上这个框！** 勾上之后，框里会显示一个对勾。然后再点击上面的 **"Install Now"**（立即安装）。

等进度条走完，Python 就装好了。

### 3. 验证安装

我们来确认一下 Python 是否装好了。

**Windows 系统**：按键盘上的 `Win` 键（就是在 `Ctrl` 和 `Alt` 之间的那个 Windows 图标键），然后输入 `cmd`，按回车。一个黑底白字的窗口会弹出来，这就是**命令行**。

**macOS 系统**：按 `Command + 空格`，输入 `Terminal`（终端），按回车。

在这个黑窗口里输入以下命令，然后按回车：

```bash
python --version
```

如果看到类似 `Python 3.12.x` 这样的输出，说明安装成功了！

> 如果提示 "python 不是内部或外部命令"，说明安装时没有勾选 "Add Python to PATH"。请回到第 2 步重新安装，**这次记得勾上那个框**。

---

## 二、下载本项目

### 方式一：通过 GitHub 下载（推荐）

1. 打开本项目的 GitHub 页面
2. 找到一个绿色的 **"<> Code"** 按钮，点击它
3. 在弹出的菜单里选择 **"Download ZIP"**
4. 下载完成后，找到这个 ZIP 文件，**右键 → 全部解压缩**，把它解压到一个你方便找到的位置（比如桌面或 D 盘根目录）

### 方式二：用 Git 克隆（如果你会用的话）

```bash
git clone <本项目 GitHub 地址>
```

---

## 三、安装依赖

"依赖"就是本项目运行所需要的其他软件包。就好比你要吃泡面，除了面饼还需要调料包——这里就是在安装"调料包"。

### 1. 打开项目文件夹

先在命令行里进入你刚才解压的项目文件夹。

**简单方法**：在文件管理器里打开项目文件夹，在文件夹的地址栏里直接输入 `cmd` 然后按回车，命令行就会自动定位到这个文件夹。

或者手动输入（以下路径仅作示例，请替换成你实际解压的位置）：

```bash
cd C:\Users\你的用户名\Desktop\MyPersonalWebsite
```

> 提示：输入路径时，可以先输入前几个字母，然后按 `Tab` 键自动补全。

### 2. 创建虚拟环境

"虚拟环境"相当于给本项目划出一块独立的干净区域，不会跟你电脑上其他 Python 项目打架。

在命令行里输入：

```bash
python -m venv .venv
```

这个命令会创建一个叫 `.venv` 的文件夹。**这一步需要几十秒，请耐心等待。** 执行完后不会有任何提示，这是正常的。

### 3. 激活虚拟环境

**Windows**：

```bash
.venv\Scripts\activate
```

**macOS / Linux**：

```bash
source .venv/bin/activate
```

执行后，你会看到命令行的最前面多了一个 `(.venv)` 的标志，像这样：

```
(.venv) C:\Users\...\MyPersonalWebsite>
```

这说明虚拟环境激活成功了！

### 4. 安装依赖

确保命令行前面有 `(.venv)` 标志，然后输入：

```bash
pip install -r requirements.txt
```

你会看到很多文字刷刷地滚过去，这是 pip 在下载和安装依赖。**这一步可能需要几分钟，取决于你的网络速度。**

看到最后一行出现 **"Successfully installed ..."** 就说明安装成功了。

---

## 四、运行项目

### 1. 启动后端服务

确保命令行前面有 `(.venv)` 标志，然后输入：

```bash
python backend/app.py
```

你会看到类似以下的输出：

```
 * Serving Flask app 'app'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://127.0.0.1:8000
```

看到 **"Running on http://127.0.0.1:8000"** 这一行，说明后端已经成功启动了！

> **注意**：这个命令行窗口**不要关掉**。关了后端就停了，网站就用不了了。

### 2. 如果启动报错

如果你看到类似以下错误：

```
ModuleNotFoundError: No module named 'jmcomic'
```

说明虚拟环境没有激活或依赖没有装好。请回到[第三步第 3 小步](#3-激活虚拟环境)，确认命令行前面有 `(.venv)`，然后重新执行第 4 小步的安装命令。

> 说明：**漫画下载功能是为 NAS 部署场景设计的**（需要域名路由 + 下载服务），在自己电脑上本地运行时，你主要用到的是导航链接和 AI 余额查询。想体验完整下载功能，请部署到 NAS（第七章）。

---

## 五、访问网站

1. 打开你的浏览器（Chrome、Edge、Firefox 都行）
2. 在地址栏输入：**`http://127.0.0.1:8000`**
3. 按回车

你应该能看到网站的主页了！左侧有一个悬浮的导航栏（鼠标移上去会展开），包含各种快捷链接。

### 网站功能简介

| 功能 | 位置 | 说明 |
|------|------|------|
| 导航链接 | 左侧悬浮栏 | 鼠标移到左侧边缘，导航栏会弹出，包含常用链接，可自己增删排序 |
| JMcomic 下载器 | 右侧 JM 按钮 | 输入番号即可下载，**零落盘**（漫画直接进你浏览器的下载目录，NAS 硬盘不留任何文件） |
| AI 模型余额查询 | 右侧悬浮栏 | 鼠标移到右侧中部边缘，可查看各 AI 平台的余额 |

### 使用下载功能（NAS 部署后）

下载功能有两条访问通道，规则不同：

| 访问方式 | 地址 | 是否需要下载令牌 |
|----------|------|------------------|
| 局域网 | <示例>`http://VinceNavigation.local` | ❌ 不需要，直接输番号点"启程" |
| 公网 | `https://your-nas.ts.net` | ✅ 需要，在面板的"下载令牌"框里填一次（自动记住） |

1. 在右侧圆形 **JM** 按钮处点击，打开下载面板
2. 输入番号（纯数字，比如 `422866`），如果页面提示需要令牌就填入下载令牌
3. 点 **"启程"**，等待进度显示，下载完成后浏览器会自动保存 `JM-番号.zip`
4. 解压 ZIP 即可看到漫画图片

> **关于零落盘**：下载的图片字节会像"水流"一样经过 NAS 内存直接打包成 ZIP 推给你的浏览器，**NAS 硬盘上不会产生任何文件**，也不用担心把 NAS 空间撑爆。
>
> **关于限制**：局域网访问没有任何限制；公网访问需要令牌（防止陌生人滥用），并且有并发和频率限制（防刷）。这些限制都可以在 NAS 上的 `deploy/secret/dl.env` 里调整。

### 使用余额查询功能

1. 鼠标移到页面右侧中部，余额面板会展开
2. 点击每个模型旁的 **"绑定"** 按钮
3. 在弹出的窗口中粘贴你的 **API Key**（需要先去对应的平台获取）
4. 点击 **"保存并查询"**，余额就会显示出来

**各平台获取 API Key 的地址**：

| 平台 | 获取地址 |
|------|----------|
| DeepSeek | https://platform.deepseek.com/api_keys |
| Claude / Anthropic | https://console.anthropic.com/settings/keys |
| GPT / OpenAI | https://platform.openai.com/api-keys |
| MiMo / 小米 | https://platform.xiaomimimo.com |
| Gemini / Google | https://aistudio.google.com/app/apikey |

> **关于安全性**：你输入的 API Key 只保存在你自己的浏览器里（localStorage），不会上传到服务器或写入任何文件。每次查询余额时，Key 仅用于当次请求。

---

## 六、常见问题（本地运行）

### Q: 运行 `python backend/app.py` 时提示 "No module named 'flask'"

A: 虚拟环境没有激活。先执行：

- Windows: `.venv\Scripts\activate`
- macOS: `source .venv/bin/activate`

确认命令行前面显示了 `(.venv)`，再执行 `pip install -r requirements.txt`。

### Q: 浏览器打开 `http://127.0.0.1:8000` 显示"无法访问"

A: 检查一下那个命令行窗口还在不在、有没有报错信息。如果关了，重新执行 `python backend/app.py`。

### Q: 怎么停止后端？

A: 在运行后端的命令行窗口里按 `Ctrl + C`，后端就会停止。

### Q: 我想换一个端口（默认是 8000），怎么办？

A: 打开 `backend/app.py`，找到最后一行 `app.run(debug=True, port=8000)`，把 `8000` 改成你想要的端口号，比如 `8080`：

```python
app.run(debug=True, port=8080)
```

然后重启后端，访问 `http://127.0.0.1:8080` 即可。

### Q: Windows 的杀毒软件报毒？

A: Python 和 Flask 都是开源的正规软件，不会包含病毒。这是因为杀毒软件有时会误报。如果你从 Python 官网和 GitHub 下载，请放心使用。如果实在不放心，可以把项目文件夹加入杀毒软件的"排除列表"。

---

## 七、NAS 部署指南（推荐，长期运行）

如果你有一台**飞牛 fnOS**（或其他 Linux NAS）并装了 Docker，想把本项目放上去 24 小时运行，让**局域网所有设备**用域名访问、**公网也能 HTTPS 访问**，按本章操作。

> 本方案不需要公网 IP、不需要买域名、不需要路由器端口映射，全部免费。

### 7.0 最终效果（先看结果再动手）

| 场景 | 访问地址 | 说明 |
|------|----------|------|
| 局域网（家里所有设备） |<示例> `http://VinceNavigation.local` | 不用记 IP、不用带端口 |
| 公网（在外面，手机流量） | `https://your-nas.ts.net` | 自带 HTTPS 加密 |
| fnOS 管理界面 | `http://你的NAS局域网IP:5666` | NAS 系统界面，保持不变 |

### 7.1 部署架构（五个容器，各司其职）

| 容器名 | 作用 | 端口 |
|--------|------|------|
| `holy-web` | 网站本体（Flask：导航页 + 余额查询） | 8080 |
| `holy-dl` | 零落盘漫画下载服务（FastAPI） | 8001 |
| `holy-proxy` | Caddy 反向代理，按域名分流（网页 / 下载接口） | 80 |
| `holy-dns` | dnsmasq 局域网 DNS，把 `VinceNavigation.local` 解析到 NAS | 53 |
| `holy-ts` | Tailscale，提供公网 HTTPS（Funnel 穿透运营商大内网） | — |

> **为什么需要动 fnOS 的 80 端口？** 飞牛系统自己占用了 80/443 端口做跳转，而且它的 nginx 配置是"生成物"（每次重启都会从自己的配置库重建，手工改的文件会被清掉）。所以要用一个**官方留下的开关**让系统让出 80/443，把端口交给我们的 Caddy（详见 7.5 节）。

### 7.2 前置条件

1. NAS 是飞牛 fnOS（或其他 Linux），已安装 **Docker**。
2. NAS 局域网 IP **固定**（本文默认 `192.168.31.172`，请改成你自己的）。
3. NAS 已开启 **SMB 共享**，Windows 电脑能访问（用来传文件）。
4. NAS 已开启 **SSH**（飞牛设置 → 系统 → SSH → 开启，勾选允许账号登录）。后面大部分命令要在 SSH 里执行。
5. 一台能上网的 Windows 电脑。

> **记住**：SSH 登录的密码就是你 NAS 的登录密码；执行 `sudo` 命令时也要输这个密码。
>
> 🏷️ **局域网节点提示**：本教程中的 `192.168.31.172` 是**作者 NAS 的示例局域网 IP**，`192.168.31.1` 是**作者路由器的示例 IP**——请全部替换为你自己环境里对应设备的实际 IP（NAS 的 IP 在 fnOS「设置 → 网络」里查看，路由器管理 IP 通常是 `192.168.x.1`）。

### 7.3 第一步：把项目放到 NAS

NAS 上的项目目录（后面所有命令都围绕它）：

```
你的NAS项目目录
```

> 注意：项目目录名可自行命名，只要与同步脚本里的 `REMOTE_SUBDIR`、以及后续命令中的路径保持一致即可。

**方式 A：Windows 一键同步（推荐）**

在项目根目录双击运行 `scripts/sync-to-nas.bat`（或 PowerShell 执行 `scripts/sync-to-nas.ps1`），脚本会自动：

1. 挂载 NAS 的 SMB 共享（首次会弹框让你输 NAS 账号密码）
2. 用 `robocopy /MIR` 把项目同步到 NAS
3. 自动跳过 `.venv`、`.git`、下载缓存等大文件/敏感文件
4. 同步完自动断开挂载

> 如果 NAS IP、共享名、目录名和你实际不同，先编辑脚本顶部的配置：
> ```batch
> set NAS_IP=192.168.1.100
> set SMB_SHARE=你的共享名
> set REMOTE_SUBDIR=你的项目目录名
> ```

**方式 B：手动复制**

Windows 文件管理器地址栏输入 `\\你的NAS局域网IP\你的共享名`，登录后把整个项目文件夹复制到 NAS（去掉 `.venv`、`backend1` 等大目录）。

**方式 C：NAS 上 Git 克隆（如果 NAS 能联网）**

SSH 登录 NAS 后：

```bash
sudo mkdir -p 你的项目父目录
cd 你的项目父目录
sudo git clone <本项目 GitHub 地址> 你的项目目录名
```

### 7.4 第二步：登录 NAS（SSH）

在 Windows 命令行（cmd）里执行：

```bash
ssh root@192.168.31.172
```

输入密码登录。看到类似 `你的主机名:~#` 的提示符就成功了。

> 以后本章出现的所有命令，默认都在这个 SSH 窗口里执行（前面有 `#` 或 `$` 提示符的就是）。
>
> 🏷️ **局域网节点提示**：上面 `ssh root@192.168.31.172` 中的 IP 请换成你 NAS 的实际局域网 IP；用户名 `root` 也换成你 NAS 实际的登录用户名（如果不是 root）。

### 7.5 第三步：让 fnOS 让出 80/443 端口（关键！）

1. 查看当前的网关跳转开关：

```bash
cat /usr/trim/etc/network_gateway_setting.conf
```

会看到类似：

```json
{"schema":{"http":{"port":5666},"https":{"port":5667}},"force_https":false,"redirect":true}
```

2. 把 `"redirect":true` 改成 `"redirect":false`：

```bash
sudo sed -i 's/"redirect":true/"redirect":false/' /usr/trim/etc/network_gateway_setting.conf
```

3. 重启 fnOS 的 nginx 让设置生效：

```bash
sudo systemctl restart trim_nginx
```

4. 确认 80 端口已经空出来（看不到 `:80` 的监听就对了）：

```bash
ss -tln | grep ':80 ' || echo "80 端口已释放"
```

> 这一步的含义：关闭"输入 NAS 的 IP 自动跳转到管理界面"这个功能，把 80/443 交给我们的 Caddy。fnOS 管理界面仍然通过 `http://你的NAS局域网IP:5666` 访问，不受影响。想还原时把 `redirect` 改回 `true` 再重启即可。

### 7.6 第四步：配置下载令牌（仅公网下载需要）

公网下载需要令牌鉴权（局域网不需要）。操作：

1. 进入项目目录：

```bash
cd 你的NAS项目目录
mkdir -p deploy/secret
```

2. 生成一个随机令牌（复制输出的那串字符备用）：

```bash
head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n'
```

3. 创建环境文件（把下面 `你的令牌` 换成上一步生成的字符串）：

```bash
cat > deploy/secret/dl.env <<EOF
DOWNLOAD_TOKEN=你的令牌
DL_MAX_PAGES=500
DL_MAX_BYTES=2147483648
DL_CONCURRENCY=2
DL_RATE_REQUESTS=6
DL_RATE_WINDOW=60
EOF
```

> - `DL_CONCURRENCY`：同时最多几个下载任务（默认 2）
> - `DL_RATE_REQUESTS`：公网每个 IP 每分钟最多请求次数（默认 6）
> - `DL_MAX_PAGES` / `DL_MAX_BYTES`：单个漫画的页数/体积上限
> - `deploy/secret/` 已被 .gitignore 排除，令牌不会上传到 GitHub

### 7.7 第五步：构建镜像并启动全部容器

1. 构建镜像（第一次会比较久，取决于 NAS 网速；看到 `Successfully tagged` 即成功）：

```bash
cd 你的NAS项目目录
sudo docker build -t mypersonalwebsite-web .
```

2. 启动全部服务（一条命令）：

```bash
sudo docker compose up -d
```

3. 确认五个容器都在运行：

```bash
sudo docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

应该看到 `holy-web`、`holy-dl`、`holy-proxy`、`holy-dns`、`holy-ts` 五个 `Up`。

> **手动启动（备选）**：如果 fnOS 的 Docker 面板不方便用 compose，也可以用面板手动创建容器，参数照抄根目录 `docker-compose.yml` 里每个服务的配置即可（compose 里已是相对路径，不依赖具体部署位置）。

### 7.8 第六步：让局域网所有设备都能用域名

现在 DNS 服务（holy-dns）已经在 NAS 上跑起来了，但家里的设备默认还在用路由器分配的 DNS，不知道 `VinceNavigation.local` 是谁。需要让路由器告诉所有设备："查 DNS 请找 NAS"。

> 🏷️ **局域网节点提示**：`192.168.31.1` 是作者路由器的示例 IP，请换成你路由器的实际管理地址；下面要填的 DNS 服务器 `192.168.31.172` 也请换成你 NAS 的实际局域网 IP。

1. 浏览器打开路由器后台：`http://192.168.31.1`，登录
2. 找到 **DHCP 服务器 / 局域网设置**
3. 把**首选 DNS 服务器**改成 NAS 的 IP：`192.168.31.172`
4. 保存后让设备重新获取 IP：
   - Windows 电脑：命令行执行 `ipconfig /release` 再 `ipconfig /renew`
   - 手机：关闭再打开 Wi-Fi
5. 验证（Windows cmd）：

```bash
nslookup VinceNavigation.local
```
注：该域名为示例，实际以你自己设定的域名为准

应返回 `192.168.31.172`。然后浏览器打开：

```
http://VinceNavigation.local
```
注：该域名为示例，实际以你自己设定的域名为准

看到你的网站就成功了！

> **打不开？多半是代理软件（Clash / v2rayN 等）抢走了这个域名**。给代理加一条绕过规则：`DOMAIN-SUFFIX,local,DIRECT`（Clash），或在系统代理的"例外"里加<示例> `VinceNavigation.local`。或者用<示例> `curl.exe -I http://VinceNavigation.local` 验证（Windows 自带 curl，不走代理）。
>
> 想换域名？改 `deploy/dnsmasq/dnsmasq.conf` 和 `deploy/caddy/Caddyfile` 里的域名，然后重启 `holy-dns`、`holy-proxy` 容器。

### 7.9 第七步：公网 HTTPS 访问（Tailscale Funnel）

Tailscale 是一个免费的组网工具，它的 **Funnel** 功能可以把你家里的服务直接暴露到公网，自动配好 HTTPS 证书，**不需要公网 IP、不需要路由器端口映射**（运营商大内网也能用）。

1. 启动 Tailscale 并拿到登录链接：

```bash
sudo docker exec -d holy-ts tailscale up --reset --hostname=your-nas --accept-dns=false
sleep 6
sudo docker exec holy-ts tailscale status
```

会输出一行 `Log in at: https://login.tailscale.com/a/xxxx`。

2. 用浏览器打开这个链接，登录/注册 Tailscale（免费，支持谷歌/GitHub/邮箱），点**授权**，把节点 `your-nas` 加入你的账户。

3. 确认已登录（看到 `100.x.x.x your-nas` 之类就对了）：

```bash
sudo docker exec holy-ts tailscale status
```

4. **启用 Funnel**：打开下面这个链接，找到节点 `your-nas`，点启用：

```
https://login.tailscale.com/f/funnel
```

5. 把公网流量指向本机 80 端口（我们的 Caddy）：

```bash
sudo docker exec -d holy-ts tailscale funnel 80
sleep 10
sudo docker exec holy-ts tailscale funnel status
```

6. 看到类似下面这样，就成功了：

```
https://your-nas.xxx.ts.net (Funnel on)
|-- / proxy http://127.0.0.1:80
```

现在全世界都能通过 **`https://your-nas.xxx.ts.net`** 访问你的网站了（把 `xxx` 换成你实际看到的尾缀）。

> 公网访问你的网站时，下载功能会要求输入**下载令牌**（7.6 节生成的那个）；局域网（VinceNavigation.local）不需要。

### 7.10 第八步：以后更新代码

1. 在 Windows 上改完代码后，重新运行 `scripts/sync-to-nas.bat` 同步到 NAS
2. SSH 登录 NAS，重启相关容器让新代码生效：

```bash
cd 你的NAS项目目录
sudo docker compose up -d --build
```

> 改 `frontend`、`backend` 代码后重启 `holy-web` / `holy-dl` 即可；改 Caddyfile 重启 `holy-proxy`；改 dnsmasq 配置重启 `holy-dns`。
>
> 注意：`deploy/caddy`、`deploy/dnsmasq`、`deploy/secret`、`deploy/backup` 已在同步脚本中排除（它们包含你环境的真实配置，避免被仓库里的示例模板覆盖）；需要更新这些配置时请手动复制到 NAS。

### 7.11 验证清单（全部 ✓ 才算部署完成）

| 检查项 | 方法 | 期望结果 |
|--------|------|----------|
| 容器状态 | `sudo docker ps` | 5 个 holy-* 容器 `Up` |
| 局域网域名 | <示例>浏览器开 `http://VinceNavigation.local` | 看到网站首页 |
| 局域网下载 | 面板输番号点启程（免令牌） | 浏览器下载到 `JM-番号.zip` |
| 公网 HTTPS | 手机流量开 `https://your-nas.xxx.ts.net` | 看到网站首页 |
| 公网下载 | 填令牌后下载 | 浏览器下载到 ZIP |
| 公网防滥用 | 不填令牌下载 | 提示"无效的下载令牌" |
| 零落盘 | 下载后 `ls 你的NAS项目目录` | 没有新增番号文件夹 |

### 7.12 NAS 常见问题

#### Q: 同步脚本提示 SMB 挂载失败

A: 检查：NAS IP 和共享名是否一致；SMB 共享是否开启；账号密码是否正确；Windows 是否启用了 SMB 客户端（控制面板 → 程序 → 启用或关闭 Windows 功能 → SMB 支持）。

#### Q: `docker build` 很慢 / 上下文有几十 GB

A: 把项目里的大目录排除在构建之外（根目录 `.dockerignore` 已默认排除 `backend1/`、`HACKING*`、`wheels/` 等）。如果以前用旧版下载功能在项目根目录留下了 `HACKING_GHOST*` 文件夹，可以删掉腾空间（新版本下载功能不会在 NAS 上产生任何文件）。

#### Q: 局域网域名打不开，但 `nslookup` 能解析出 NAS 的 IP

A: 几乎可以肯定是**代理软件**问题（Clash / v2rayN / ikuuu 等）。给代理加绕过规则 `DOMAIN-SUFFIX,local,DIRECT`，或直接在浏览器里用 `curl.exe -I http://VinceNavigation.local` 验证（curl 不走代理）。

#### Q: `nslookup VinceNavigation.local` 解析不出来

A: 路由器 DHCP 的 DNS 没生效。检查路由器里"首选 DNS"是不是你的 NAS 局域网 IP；保存后 `ipconfig /renew` 或重启路由器；手机重连 Wi-Fi。

#### Q: 公网打不开 `https://your-nas.xxx.ts.net`

A: 依次检查：`sudo docker exec holy-ts tailscale status` 是否已登录；是否在 `login.tailscale.com/f/funnel` 启用了 Funnel；`tailscale funnel status` 是否显示 `proxy http://127.0.0.1:80`；`holy-proxy` 容器是否在运行。

#### Q: 下载提示"无效的下载令牌"（401）

A: 令牌填错了。令牌在 NAS 的 `你的NAS项目目录/deploy/secret/dl.env` 里的 `DOWNLOAD_TOKEN=` 后面，或者本机 `deploy/secret/dl-token.txt`。局域网访问不需要令牌。

#### Q: 下载提示"请求过于频繁"（429）

A: 公网每分钟请求次数超了（默认 6 次），等 1 分钟再试，或调大 `dl.env` 里的 `DL_RATE_REQUESTS` 后重启 `holy-dl`。

#### Q: 下载的漫画存在哪里？

A: 直接保存在**你浏览器的下载目录**里（一个 ZIP）。NAS 硬盘上不会出现任何文件——这是"零落盘"设计，不用担心把 NAS 撑爆。

#### Q: 下载服务能同时跑几个任务？

A: 默认全局同时 2 个（`DL_CONCURRENCY`），超出会排队；这是为了防止 NAS 被压垮。局域网与公网共用这个限制。

#### Q: 想改域名（比如不用 VinceNavigation.local）？

A: 改两处：`deploy/dnsmasq/dnsmasq.conf`（DNS 解析）和 `deploy/caddy/Caddyfile`（反代路由），然后重启 `holy-dns` 和 `holy-proxy` 容器。

### 7.13 安全提示

- **公网下载有令牌保护 + 限流**；但网站的其它功能（导航、余额查询）没有登录鉴权，公网任何人能看到你的导航页（看不到你的 API Key——Key 只存在你自己浏览器里）。介意的话可以在 Tailscale 后台关闭 Funnel。
- `deploy/secret/`（含下载令牌）已被 .gitignore 排除，**不要**把它提交到 GitHub。
- 建议路由器给 NAS 绑定静态 DHCP，确保 IP 不会变。
- fnOS 管理界面请用 `http://你的NAS局域网IP:5666` 访问（80/443 已被我们接管）。

---

## 项目结构

```
MyPersonalWebsite/
├── backend/                  # 后端服务
│   ├── app.py                # Flask 网站主程序（导航页 + 余额查询）
│   ├── check_balance.py      # AI 余额查询模块
│   └── downloader/           # 零落盘下载服务（FastAPI）
│       └── main.py           # 流式 ZIP 下载 + 令牌/限流/防注入
├── frontend/index.html       # 网站唯一页面（导航/下载/余额一体）
├── common/                   # 静态资源（图标、背景图）
├── deploy/
│   ├── caddy/Caddyfile       # Caddy 反代路由（局域网/公网分流 + 访问域标记）
│   ├── dnsmasq/dnsmasq.conf  # 局域网 DNS（示例域名解析）
│   ├── avahi/                # 旧版 mDNS 配置（已弃用，仅作参考）
│   ├── backup/               # 系统配置备份（不提交）
│   └── secret/               # 下载令牌等敏感配置（已被 .gitignore 排除）
├── scripts/                  # 运维脚本
│   ├── sync-to-nas.bat       # Windows 一键同步到 NAS
│   ├── sync-to-nas.ps1
│   └── *.sh                  # 部署/诊断脚本（含示例值，供参考）
├── docker/                   # 旧版 docker-compose（仅作参考）
├── docker-compose.yml        # NAS 部署：web / dl / proxy / dns / ts 五服务（相对路径）
├── Dockerfile                # 网站镜像（Flask + FastAPI 共用）
├── option.yml                # jmcomic 下载选项配置
├── requirements.txt          # Python 依赖
├── .dockerignore             # Docker 构建排除规则（大目录/敏感文件）
└── .gitignore                # Git 忽略规则
```