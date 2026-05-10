# MyPersonalWebsite

一个集导航主页、下载工具、AI 模型余额查询于一体的个人网站。

---

## 目录

- [零、我是完全不懂电脑的小白，从哪开始？](#零我是完全不懂电脑的小白从哪开始)
- [一、安装 Python](#一安装-python)
- [二、下载本项目](#二下载本项目)
- [三、安装依赖](#三安装依赖)
- [四、运行项目](#四运行项目)
- [五、访问网站](#五访问网站)
- [六、常见问题](#六常见问题)

---

## 零、我是完全不懂电脑的小白，从哪开始？

**别怕，这份教程就是为你写的。** 你不需要懂编程，只需要会打字、会点击鼠标，跟着下面的步骤一步步来就行。整个过程大约需要 **15～30 分钟**。

在开始之前，先记住两个概念：

> **命令行（终端）**：一个黑乎乎的窗口，你在里面打字指挥电脑干活。别被它吓到，你只需要复制粘贴几条命令而已。
>
> **复制粘贴的快捷键**：在命令行窗口里，`Ctrl + V` 可能不管用。你需要用鼠标右键点击窗口，选择"粘贴"，或者按 `Ctrl + Shift + V`。

好，开始吧！

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

---

## 五、访问网站

1. 打开你的浏览器（Chrome、Edge、Firefox 都行）
2. 在地址栏输入：**`http://127.0.0.1:8000`**
3. 按回车

你应该能看到网站的主页了！左侧有一个悬浮的导航栏（鼠标移上去会展开），包含各种快捷链接。

### 网站功能简介

| 功能 | 位置 | 说明 |
|------|------|------|
| 导航链接 | 左侧悬浮栏 | 鼠标移到左侧边缘，导航栏会弹出，包含常用链接 |
| JMcomic 下载器 | 右侧 JM 按钮 | 点击右侧圆形按钮，输入番号即可下载 |
| AI 模型余额查询 | 右侧悬浮栏 | 鼠标移到右侧中部边缘，可查看各 AI 平台的余额 |

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

## 六、常见问题

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

### Q: 下载功能怎么配置？

A: 编辑项目根目录下的 `option.yml` 文件，根据 [jmcomic 文档](https://github.com/tonquer/jmcomic) 配置下载选项。

### Q: 我想把这个网站部署到公网上让别人访问，怎么做？

A: 这就不是"小白教程"的范畴了，简单说你需要：
1. 一台云服务器
2. 把项目传上去
3. 使用 `gunicorn` 或 `waitress` 代替 Flask 自带的开发服务器
4. 配置 Nginx 反向代理

建议搜索"Flask 部署教程"了解详情。

### Q: Windows 的杀毒软件报毒？

A: Python 和 Flask 都是开源的正规软件，不会包含病毒。这是因为杀毒软件有时会误报。如果你从 Python 官网和 GitHub 下载，请放心使用。如果实在不放心，可以把项目文件夹加入杀毒软件的"排除列表"。

---

## 项目结构

```
MyPersonalWebsite/
├── backend/             # 后端 Flask 服务
│   ├── app.py           # 主程序入口
│   └── check_balance.py # 余额查询模块
├── backend1/            # 下载文件存放目录
│   └── download/
├── common/              # 静态资源
│   ├── icon/            # 网站图标
│   └── img/             # 背景图片
├── frontend/            # 前端页面
│   └── index.html       # 网站唯一页面
├── option.yml           # jmcomic 下载配置
├── requirements.txt     # Python 依赖列表
└── .gitignore           # Git 忽略规则
```
