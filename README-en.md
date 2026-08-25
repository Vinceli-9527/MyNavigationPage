# MyPersonalWebsite

> 🌏 中文版: [README.md](README.md) | English

A personal website that combines a navigation homepage, a **zero-storage comic downloader**, and an AI model balance checker.

> It can run on your own computer, or be deployed to your home NAS (fnOS) for 24/7 use:
> On the **LAN**, visit `http://VinceNavigation.local` (no IP to memorize, no port to type); from the **public internet**, visit `https://your-nas.ts.net` (with HTTPS encryption built in).

> 📌 **Important: about the example values in this document** — every IP, domain, and path shown below is an **example value from the author's own devices**. Replace them with values from **your own environment**:
>
> | Example | Meaning | Replace with |
> |---------|---------|--------------|
> | `192.168.31.172` | The author's NAS LAN IP | Your NAS's actual LAN IP |
> | `192.168.31.1` | The author's router IP | Your router's actual IP |
> | `VinceNavigation.local` | The LAN domain the author chose | A domain you like (e.g. `mynas.local`) |
> | `your-nas.ts.net` | The author's Tailscale public domain | Your own Tailscale device domain |
> | `YOUR_NAS_PROJECT_DIR` | The author's project directory on the NAS | Any directory on your NAS |
>
> Everywhere you see the values above, they are examples only; the real values live only on your own NAS and never appear in this public repository.

---

## Table of Contents

- [0. I'm a complete beginner — where do I start?](#0-im-a-complete-beginner--where-do-i-start)
- [1. Install Python](#1-install-python)
- [2. Download this project](#2-download-this-project)
- [3. Install dependencies](#3-install-dependencies)
- [4. Run the project](#4-run-the-project)
- [5. Visit the website](#5-visit-the-website)
- [6. FAQ (running locally)](#6-faq-running-locally)
- [7. NAS deployment guide (recommended, for 24/7 use)](#7-nas-deployment-guide-recommended-for-247-use)
- [Project structure](#project-structure)

---

## 0. I'm a complete beginner — where do I start?

**Don't worry — this tutorial was written for you.** You don't need to know how to program. You only need to be able to type and click. Just follow the steps below one by one. The whole process takes about **15–30 minutes**.

Before you start, remember two things:

> **Command line (terminal)**: a black window where you type commands to control your computer. Don't be scared — you only need to copy and paste a few commands.
>
> **Copy & paste shortcuts**: in the command line, `Ctrl + V` may not work. Use the right mouse button → "Paste", or press `Ctrl + Shift + V`.

OK, let's begin! If you just want to try it on your own computer, read chapters 1–6. If you have a NAS at home and want to deploy it long-term (LAN domain + public HTTPS), jump straight to chapter 7.

---

## 1. Install Python

This project is written in Python, so your computer needs Python installed.

### 1.1 Download Python

Open your browser and go to the official Python download page:

```
https://www.python.org/downloads/
```

The page automatically detects your operating system. You will see a big yellow button that says something like **"Download Python 3.12.x"**. Click it to download.

> **Note**: the version number may differ slightly — anything 3.10 or newer is fine.

### 1.2 Install Python

Find the file you just downloaded (usually in your "Downloads" folder) and double-click it.

> **This step is critical!**

At the **very bottom** of the installer, there is a checkbox:

```
☐ Add Python 3.x to PATH
```

**Make sure you check this box!** Once checked, you will see a checkmark. Then click **"Install Now"** above.

Wait for the progress bar to finish — Python is now installed.

### 1.3 Verify the installation

Let's confirm Python is installed properly.

**On Windows**: press the `Win` key (the Windows logo key between `Ctrl` and `Alt`), type `cmd`, and press Enter. A black-and-white window opens — this is the **command line**.

**On macOS**: press `Command + Space`, type `Terminal`, and press Enter.

In this black window, type the following and press Enter:

```bash
python --version
```

If you see something like `Python 3.12.x`, the installation succeeded!

> If it says "python is not recognized as an internal or external command", you didn't check "Add Python to PATH" during installation. Go back to step 1.2 and reinstall — **this time check that box**.

---

## 2. Download this project

### Method 1: Download from GitHub (recommended)

1. Open this project's GitHub page
2. Find the green **"<> Code"** button and click it
3. Choose **"Download ZIP"** from the menu
4. Once downloaded, find the ZIP file and **right-click → Extract All**, then extract it to a convenient location (e.g. your Desktop or D: root)

### Method 2: Clone with Git (if you know how)

```bash
git clone <this project's GitHub URL>
```

---

## 3. Install dependencies

"Dependencies" are the other software packages this project needs to run. Think of it like instant noodles: besides the noodles you also need the seasoning packet — this step installs the "seasoning packets".

### 3.1 Open the project folder

First, use the command line to enter the project folder you just extracted.

**Easy way**: open the project folder in File Explorer, click into the address bar, type `cmd`, and press Enter — the command line opens already inside the folder.

Or type it manually (the path below is just an example — replace it with your actual location):

```bash
cd C:\Users\YOUR_USERNAME\Desktop\MyPersonalWebsite
```

> Tip: when typing a path, type the first few letters and press `Tab` for auto-completion.

### 3.2 Create a virtual environment

A "virtual environment" is a clean, isolated area for this project so it doesn't conflict with your other Python projects.

```bash
python -m venv .venv
```

This creates a folder named `.venv`. **This takes a few tens of seconds — please be patient.** No message will appear when it finishes — that's normal.

### 3.3 Activate the virtual environment

**Windows**:

```bash
.venv\Scripts\activate
```

**macOS / Linux**:

```bash
source .venv/bin/activate
```

After activation, you'll see `(.venv)` at the start of the prompt, like this:

```
(.venv) C:\Users\...\MyPersonalWebsite>
```

That means the virtual environment is active!

### 3.4 Install dependencies

Make sure the prompt starts with `(.venv)`, then type:

```bash
pip install -r requirements.txt
```

Lots of text will scroll by as pip downloads and installs dependencies. **This may take a few minutes depending on your network speed.**

When you see **"Successfully installed ..."** at the end, it's done.

---

## 4. Run the project

### 4.1 Start the backend server

Make sure the prompt starts with `(.venv)`, then type:

```bash
python backend/app.py
```

You will see output similar to:

```
 * Serving Flask app 'app'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://127.0.0.1:8000
```

When you see **"Running on http://127.0.0.1:8000"**, the backend has started successfully!

> **Note**: **do not close** this command-line window. If you close it, the backend stops and the website won't work.

### 4.2 If startup fails

If you see an error like:

```
ModuleNotFoundError: No module named 'jmcomic'
```

The virtual environment isn't activated or the dependencies aren't installed. Go back to [step 3.3](#33-activate-the-virtual-environment), make sure the prompt starts with `(.venv)`, then run step 3.4 again.

> Note: the **comic downloader is designed for the NAS deployment** (it needs domain routing + the download service). When running locally on your own computer, you'll mainly use the navigation links and the AI balance checker. For the full download experience, deploy to a NAS (chapter 7).

---

## 5. Visit the website

1. Open your browser (Chrome, Edge, Firefox — any works)
2. Type **`http://127.0.0.1:8000`** in the address bar
3. Press Enter

You should see the homepage! There's a floating navigation sidebar on the left (it expands when you hover over the left edge) with quick links.

### Feature overview

| Feature | Where | Description |
|---------|-------|-------------|
| Navigation links | Left floating sidebar | Hover over the left edge to expand; add / delete / reorder links freely |
| JM comic downloader | "JM" round button on the right | Enter an album number to download — **zero storage** (the comic goes straight to your browser's download folder, nothing is saved on the NAS disk) |
| AI model balance | Right floating sidebar | Hover over the middle-right edge to see balances for each AI platform |

### Using the downloader (after NAS deployment)

The downloader has two access channels with different rules:

| Access | URL | Download token required? |
|--------|-----|--------------------------|
| LAN | `http://VinceNavigation.local` | ❌ No — just enter the album number and click "Go" |
| Public internet | `https://your-nas.ts.net` | ✅ Yes — enter the token in the "Download token" field once (it's remembered automatically) |

1. Click the round **JM** button on the right to open the download panel
2. Enter the album number (digits only, e.g. `422866`); if prompted, enter the download token
3. Click **"Go"** and wait — when finished, the browser automatically saves `JM-ALBUM_NUMBER.zip`
4. Unzip to see the comic images

> **About zero storage**: the image bytes flow through the NAS memory and are packed into a ZIP streamed straight to your browser. **Nothing is ever written to the NAS disk**, so you never have to worry about filling up the NAS.
>
> **About limits**: LAN access has no restrictions at all; public access requires a token (to prevent strangers from abusing it) plus concurrency and rate limits (anti-flooding). All limits can be tuned in `deploy/secret/dl.env` on the NAS.

### Using the balance checker

1. Hover over the middle-right edge of the page to expand the balance panel
2. Click the **"Bind"** button next to each model
3. Paste your **API Key** in the popup (get one from the corresponding platform first)
4. Click **"Save & Query"** to see the balance

**Where to get API Keys**:

| Platform | URL |
|----------|-----|
| DeepSeek | https://platform.deepseek.com/api_keys |
| Claude / Anthropic | https://console.anthropic.com/settings/keys |
| GPT / OpenAI | https://platform.openai.com/api-keys |
| MiMo / Xiaomi | https://platform.xiaomimimo.com |
| Gemini / Google | https://aistudio.google.com/app/apikey |

> **Security note**: your API Keys are stored only in your own browser (localStorage). They are never uploaded to the server or written to any file. Each balance query uses the key only for that single request.

---

## 6. FAQ (running locally)

### Q: Running `python backend/app.py` says "No module named 'flask'"

A: The virtual environment isn't activated. Run:

- Windows: `.venv\Scripts\activate`
- macOS: `source .venv/bin/activate`

Make sure the prompt starts with `(.venv)`, then run `pip install -r requirements.txt`.

### Q: `http://127.0.0.1:8000` shows "can't connect" in the browser

A: Check whether that command-line window is still open and whether it shows an error. If it was closed, run `python backend/app.py` again.

### Q: How do I stop the backend?

A: Press `Ctrl + C` in the window running the backend.

### Q: I want a different port (default is 8000)?

A: Open `backend/app.py`, find the last line `app.run(debug=True, port=8000)`, and change `8000` to whatever you want, e.g. `8080`:

```python
app.run(debug=True, port=8080)
```

Restart the backend and visit `http://127.0.0.1:8080`.

### Q: Windows antivirus reports a virus?

A: Python and Flask are legitimate open-source software — they don't contain viruses. Antivirus sometimes gives false positives. If you downloaded from the official Python site and GitHub, feel free to use it. If you're still worried, add the project folder to your antivirus exclusion list.

---

## 7. NAS deployment guide (recommended, for 24/7 use)

If you have a **fnOS NAS** (or any Linux NAS) with Docker installed, and you want this project running 24/7 — with **every LAN device** accessing it via a domain and **public HTTPS** access from anywhere — follow this chapter.

> This solution needs **no public IP, no purchased domain, and no router port forwarding**. It's all free.

### 7.0 The end result (look before you leap)

| Scenario | URL | Description |
|----------|-----|-------------|
| LAN (all devices at home) | `http://VinceNavigation.local` | No IP to memorize, no port to type |
| Public internet (outside, on mobile data) | `https://your-nas.ts.net` | HTTPS encryption built in |
| fnOS admin UI | `http://YOUR_NAS_LAN_IP:5666` | The NAS system UI, unchanged |

### 7.1 Architecture (five containers, each with a job)

| Container | Job | Port |
|-----------|-----|------|
| `holy-web` | The website itself (Flask: navigation page + balance checker) | 8080 |
| `holy-dl` | Zero-storage comic download service (FastAPI) | 8001 |
| `holy-proxy` | Caddy reverse proxy; routes by domain (web / download API) | 80 |
| `holy-dns` | dnsmasq LAN DNS; resolves `VinceNavigation.local` to the NAS | 53 |
| `holy-ts` | Tailscale; provides public HTTPS (Funnel punches through carrier CGNAT) | — |

> **Why do we touch fnOS's port 80?** fnOS itself occupies ports 80/443 for redirects, and its nginx config is "generated" (it rebuilds everything from its own config store on every restart — hand-edited files get wiped). So we use an **official switch** to make fnOS give up 80/443 and hand them to our Caddy (see 7.5).

### 7.2 Prerequisites

1. Your NAS is fnOS (or another Linux) with **Docker** installed.
2. The NAS has a **fixed LAN IP** (this guide uses `192.168.31.172` — change it to yours).
3. **SMB sharing** is enabled on the NAS and your Windows PC can access it (for transferring files).
4. **SSH** is enabled on the NAS (fnOS: Settings → System → SSH → enable, allow account login). Most commands below run over SSH.
5. A Windows PC with internet access.

> **Remember**: the SSH login password is the same as your NAS login password; you'll also need it for `sudo` commands.
>
> 🏷️ **LAN node note**: `192.168.31.172` in this guide is the **author's NAS example LAN IP**, and `192.168.31.1` is the **author's router example IP** — replace them with the actual IPs of your own devices (find the NAS IP in fnOS "Settings → Network"; router admin IPs are usually `192.168.x.1`).

### 7.3 Step 1: put the project on the NAS

The project directory on the NAS (all commands below revolve around it):

```
YOUR_NAS_PROJECT_DIR
```

> Note: you can name the project directory anything you like — just keep it consistent with `REMOTE_SUBDIR` in the sync script and with the paths in the commands below.

**Method A: one-click sync from Windows (recommended)**

Double-click `scripts/sync-to-nas.bat` (or run `scripts/sync-to-nas.ps1` in PowerShell) in the project root. The script will:

1. Mount the NAS SMB share (the first time it asks for your NAS username/password)
2. Sync the project to the NAS with `robocopy /MIR`
3. Automatically skip `.venv`, `.git`, download caches and other large/sensitive files
4. Unmount the share when done

> If your NAS IP, share name, or directory name differs, edit the config at the top of the script first:
> ```batch
> set NAS_IP=192.168.1.100
> set SMB_SHARE=YOUR_SMB_SHARE_NAME
> set REMOTE_SUBDIR=YOUR_PROJECT_FOLDER_NAME
> ```

**Method B: copy manually**

In Windows File Explorer, type `\\YOUR_NAS_LAN_IP\\YOUR_SMB_SHARE_NAME` in the address bar, log in, and copy the whole project folder to the NAS (skip big directories like `.venv` and `backend1`).

**Method C: git clone on the NAS (if your NAS has internet)**

After SSH-ing into the NAS:

```bash
sudo mkdir -p YOUR_NAS_PARENT_DIR
cd YOUR_NAS_PARENT_DIR
sudo git clone <this project's GitHub URL> YOUR_PROJECT_FOLDER_NAME
```

### 7.4 Step 2: log into the NAS (SSH)

In Windows cmd:

```bash
ssh root@192.168.31.172
```

Enter the password. You're in when you see a prompt like `your-hostname:~#`.

> From here on, all commands in this chapter are executed in this SSH window (lines starting with `#` or `$` are the prompts).
>
> 🏷️ **LAN node note**: replace the IP in `ssh root@192.168.31.172` with your NAS's actual LAN IP, and the username `root` with your actual NAS login username (if it isn't root).

### 7.5 Step 3: make fnOS give up ports 80/443 (critical!)

1. Check the current gateway redirect switch:

```bash
cat /usr/trim/etc/network_gateway_setting.conf
```

You'll see something like:

```json
{"schema":{"http":{"port":5666},"https":{"port":5667}},"force_https":false,"redirect":true}
```

2. Change `"redirect":true` to `"redirect":false`:

```bash
sudo sed -i 's/"redirect":true/"redirect":false/' /usr/trim/etc/network_gateway_setting.conf
```

3. Restart fnOS's nginx to apply:

```bash
sudo systemctl restart trim_nginx
```

4. Confirm port 80 is free (no `:80` listener is what we want):

```bash
ss -tln | grep ':80 ' || echo "Port 80 released"
```

> What this does: it disables the "auto-redirect to the admin UI when you type the NAS IP" feature and hands ports 80/443 to our Caddy. The fnOS admin UI is still available at `http://YOUR_NAS_LAN_IP:5666`. To undo, change `redirect` back to `true` and restart.

### 7.6 Step 4: configure the download token (only needed for public downloads)

Public downloads need a token; LAN downloads don't. Steps:

1. Enter the project directory:

```bash
cd YOUR_NAS_PROJECT_DIR
mkdir -p deploy/secret
```

2. Generate a random token (copy the output string):

```bash
head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n'
```

3. Create the environment file (replace `YOUR_TOKEN` with the string from the previous step):

```bash
cat > deploy/secret/dl.env <<EOF
DOWNLOAD_TOKEN=YOUR_TOKEN
DL_MAX_PAGES=500
DL_MAX_BYTES=2147483648
DL_CONCURRENCY=2
DL_RATE_REQUESTS=6
DL_RATE_WINDOW=60
EOF
```

> - `DL_CONCURRENCY`: how many downloads can run at once (default 2)
> - `DL_RATE_REQUESTS`: max requests per minute per public IP (default 6)
> - `DL_MAX_PAGES` / `DL_MAX_BYTES`: max pages / max size per album
> - `deploy/secret/` is excluded by .gitignore — the token will never be pushed to GitHub

### 7.7 Step 5: build the image and start all containers

1. Build the image (the first build takes a while depending on NAS network speed; you're done when you see `Successfully tagged`):

```bash
cd YOUR_NAS_PROJECT_DIR
sudo docker build -t mypersonalwebsite-web .
```

2. Start everything (one command):

```bash
sudo docker compose up -d
```

3. Confirm all five containers are running:

```bash
sudo docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

You should see `holy-web`, `holy-dl`, `holy-proxy`, `holy-dns` and `holy-ts` all `Up`.

> **Manual start (alternative)**: if fnOS's Docker panel makes compose awkward, create the containers manually in the panel using the exact settings from the `docker-compose.yml` file (the compose file uses relative paths, so it doesn't depend on where it's deployed).

### 7.8 Step 6: make every LAN device able to use the domain

The DNS service (holy-dns) is now running on the NAS, but your home devices are still using the router-assigned DNS and don't know who `VinceNavigation.local` is. We need the router to tell every device: "ask the NAS for DNS".

> 🏷️ **LAN node note**: `192.168.31.1` is the author's router example IP — replace it with your router's actual admin address; the DNS server you set below (`192.168.31.172`) should also be your NAS's actual LAN IP.

1. Open the router admin page: `http://192.168.31.1`, log in
2. Find **DHCP server / LAN settings**
3. Change the **primary DNS server** to the NAS IP: `192.168.31.172`
4. Save, then make devices get a new IP:
   - Windows PC: run `ipconfig /release` then `ipconfig /renew`
   - Phone: toggle Wi-Fi off and on
5. Verify (Windows cmd):

```bash
nslookup VinceNavigation.local
```

It should return `192.168.31.172`. Then open:

```
http://VinceNavigation.local
```

If you see your website, it worked!

> **Can't open it? It's almost certainly a proxy tool (Clash / v2rayN, etc.) hijacking the domain.** Add a bypass rule: `DOMAIN-SUFFIX,local,DIRECT` (Clash), or add `VinceNavigation.local` to the "exceptions" list of your system proxy. Or verify with `curl.exe -I http://VinceNavigation.local` (Windows ships curl, which ignores the proxy).
>
> Want a different domain? Edit the domain in `deploy/dnsmasq/dnsmasq.conf` and `deploy/caddy/Caddyfile`, then restart the `holy-dns` and `holy-proxy` containers.

### 7.9 Step 7: public HTTPS access (Tailscale Funnel)

Tailscale is a free networking tool. Its **Funnel** feature exposes your home service to the public internet with an automatically-issued HTTPS certificate — **no public IP, no router port forwarding** (it works even behind carrier CGNAT).

1. Start Tailscale and get the login link:

```bash
sudo docker exec -d holy-ts tailscale up --reset --hostname=your-nas --accept-dns=false
sleep 6
sudo docker exec holy-ts tailscale status
```

It prints a line like `Log in at: https://login.tailscale.com/a/xxxx`.

2. Open that link in a browser, sign up / sign in to Tailscale (free; Google/GitHub/email all work), and click **Authorize** to add the node `your-nas` to your account.

3. Confirm you're logged in (you should see something like `100.x.x.x your-nas`):

```bash
sudo docker exec holy-ts tailscale status
```

4. **Enable Funnel**: open the link below, find the node `your-nas`, and enable it:

```
https://login.tailscale.com/f/funnel
```

5. Point public traffic at local port 80 (our Caddy):

```bash
sudo docker exec -d holy-ts tailscale funnel 80
sleep 10
sudo docker exec holy-ts tailscale funnel status
```

6. Success looks like this:

```
https://your-nas.xxx.ts.net (Funnel on)
|-- / proxy http://127.0.0.1:80
```

Now anyone in the world can reach your site at **`https://your-nas.xxx.ts.net`** (replace `xxx` with the suffix you actually see).

> On the public URL, the downloader will ask for the **download token** (generated in 7.6); on the LAN (VinceNavigation.local) it doesn't.

### 7.10 Step 8: updating the code later

1. After changing code on Windows, re-run `scripts/sync-to-nas.bat` to sync to the NAS
2. SSH into the NAS and restart the affected containers:

```bash
cd YOUR_NAS_PROJECT_DIR
sudo docker compose up -d --build
```

> After changing `frontend` / `backend` code, restart `holy-web` / `holy-dl`; after changing the Caddyfile, restart `holy-proxy`; after changing dnsmasq config, restart `holy-dns`.
>
> Note: `deploy/caddy`, `deploy/dnsmasq`, `deploy/secret` and `deploy/backup` are excluded from the sync script (they contain your environment's real config — the exclusion prevents the repo's example templates from overwriting them); when you need to update those configs, copy them to the NAS manually.

### 7.11 Verification checklist (deployment is done only when all pass)

| Check | How | Expected |
|-------|-----|----------|
| Containers | `sudo docker ps` | All 5 holy-* containers `Up` |
| LAN domain | Open `http://VinceNavigation.local` | See the homepage |
| LAN download | Enter an album number, click Go (no token) | Browser downloads `JM-ALBUM_NUMBER.zip` |
| Public HTTPS | Open `https://your-nas.xxx.ts.net` on mobile data | See the homepage |
| Public download | Download after entering the token | Browser downloads the ZIP |
| Public anti-abuse | Download without a token | "Invalid download token" message |
| Zero storage | After downloading, `ls YOUR_NAS_PROJECT_DIR` | No new album-number folder |

### 7.12 NAS FAQ

#### Q: The sync script says SMB mount failed

A: Check: is the NAS IP and share name correct? Is SMB sharing enabled? Is the username/password correct? Is the SMB client enabled on Windows (Control Panel → Programs → Turn Windows features on or off → SMB support)?

#### Q: `docker build` is slow / the context is tens of GB

A: Exclude big directories from the build (the root `.dockerignore` already excludes `backend1/`, `HACKING*`, `wheels/`, etc.). If the old downloader left `HACKING_GHOST*` folders in the project root, you can delete them to reclaim space (the new downloader never writes files on the NAS).

#### Q: The LAN domain won't open, but `nslookup` resolves the NAS IP

A: It's almost certainly a **proxy tool** problem (Clash / v2rayN / ikuuu, etc.). Add a bypass rule `DOMAIN-SUFFIX,local,DIRECT`, or verify directly in the browser with `curl.exe -I http://VinceNavigation.local` (curl ignores the proxy).

#### Q: `nslookup VinceNavigation.local` doesn't resolve

A: The router's DHCP DNS didn't take effect. Check that the router's "primary DNS" is your NAS LAN IP; after saving, run `ipconfig /renew` or reboot the router; rejoin Wi-Fi on phones.

#### Q: Can't open `https://your-nas.xxx.ts.net` from outside

A: Check in order: is `sudo docker exec holy-ts tailscale status` logged in? Is Funnel enabled at `login.tailscale.com/f/funnel`? Does `tailscale funnel status` show `proxy http://127.0.0.1:80`? Is the `holy-proxy` container running?

#### Q: Download says "Invalid download token" (401)

A: The token is wrong. It's after `DOWNLOAD_TOKEN=` in `YOUR_NAS_PROJECT_DIR/deploy/secret/dl.env` on the NAS, or in `deploy/secret/dl-token.txt` on your PC. LAN access doesn't need the token.

#### Q: Download says "too many requests" (429)

A: You exceeded the per-minute request limit on the public URL (default 6). Wait a minute, or raise `DL_RATE_REQUESTS` in `dl.env` and restart `holy-dl`.

#### Q: Where are the downloaded comics stored?

A: Directly in **your browser's download folder** (one ZIP). Nothing ever appears on the NAS disk — that's the "zero storage" design, so you never have to worry about filling the NAS.

#### Q: How many downloads can run at once?

A: Two at a time globally by default (`DL_CONCURRENCY`); extra requests queue up. This protects the NAS from being overwhelmed, and applies to both LAN and public traffic.

#### Q: I want a different domain (e.g. not VinceNavigation.local)?

A: Change two places: `deploy/dnsmasq/dnsmasq.conf` (DNS) and `deploy/caddy/Caddyfile` (reverse proxy), then restart the `holy-dns` and `holy-proxy` containers.

### 7.13 Security notes

- **Public downloads are protected by a token + rate limits**; however the site's other features (navigation, balance checker) have no login — anyone on the public internet can see your navigation page (but not your API keys — they live only in your own browser). If you care, disable Funnel in the Tailscale admin console.
- `deploy/secret/` (containing the download token) is excluded by .gitignore — **never** commit it to GitHub.
- Give the NAS a static DHCP reservation on the router so its IP never changes.
- Access the fnOS admin UI via `http://YOUR_NAS_LAN_IP:5666` (ports 80/443 are now ours).

---

## Project structure

```
MyPersonalWebsite/
├── backend/                  # Backend services
│   ├── app.py                # Flask website (navigation page + balance checker)
│   ├── check_balance.py      # AI balance checking module
│   └── downloader/           # Zero-storage download service (FastAPI)
│       └── main.py           # Streaming ZIP download + token / rate limit / injection protection
├── frontend/index.html       # The single website page (navigation / download / balance)
├── common/                   # Static assets (icons, background image)
├── deploy/
│   ├── caddy/Caddyfile       # Caddy reverse proxy routing (LAN/public split + access-scope marker)
│   ├── dnsmasq/dnsmasq.conf  # LAN DNS (example domain resolution)
│   ├── avahi/                # Legacy mDNS config (deprecated, reference only)
│   ├── backup/               # System config backups (not committed)
│   └── secret/               # Download token etc. (excluded by .gitignore)
├── scripts/                  # Ops scripts
│   ├── sync-to-nas.bat       # Windows one-click sync to NAS
│   ├── sync-to-nas.ps1
│   └── *.sh                  # One-off deploy/diagnostic scripts (contain example values, for reference)
├── docker/                   # Legacy docker-compose (reference only)
├── docker-compose.yml        # NAS deployment: web / dl / proxy / dns / ts (relative paths)
├── Dockerfile                # Website image (shared by Flask + FastAPI)
├── option.yml                # jmcomic download options
├── requirements.txt          # Python dependencies
├── .dockerignore             # Docker build exclusions (big dirs / sensitive files)
└── .gitignore                # Git ignore rules
```

---

> This is the English translation of the project README. The Chinese original is `README.md`.