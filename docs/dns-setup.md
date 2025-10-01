# DNS Setup for .test Domains

This Docker environment uses the `.test` TLD for local development. To make this work seamlessly, you need to configure your operating system to query our local DNS server for `.test` domains.

---

## Why We Switched from .localhost to .test

Modern versions of CURL (used by PHP, WordPress, Laravel, etc.) **hardcode** `.localhost` to always resolve to `127.0.0.1` per RFC 6761. This breaks container-to-container communication.

The `.test` TLD is also reserved by RFC 6761 **specifically for testing**, but CURL respects DNS for it. This allows our split-horizon DNS setup to work perfectly.

---

## How It Works

We run **two DNS servers** in Docker using the [`dockurr/dnsmasq`](https://hub.docker.com/r/dockurr/dnsmasq) image:

1. **dnsmasq-external** (port 53) - For your host machine
   - Resolves `*.test` → `127.0.0.1` (maps to Docker's published ports)

2. **dnsmasq-internal** (internal only) - For PHP containers
   - Resolves `*.test` → `192.168.103.100` (Apache's internal Docker IP)
   - Allows PHP to make HTTP requests to other local sites

This setup enables:
- ✅ **Browser access**: `https://myproject.test` works in your browser
- ✅ **Loopback requests**: WordPress cron, Laravel queues, API callbacks all work
- ✅ **Inter-site requests**: One local site can call another
- ✅ **No manual hosts file edits** when adding new projects

---

## Setup Instructions by OS

### macOS Setup

macOS has built-in support for custom DNS resolvers per domain. We'll use [Homebrew](https://brew.sh/) to install dnsmasq locally.

> **Prerequisites:** You must have [Homebrew](https://brew.sh/) installed before continuing. If you haven't installed it yet, visit [brew.sh](https://brew.sh/) for installation instructions.

#### Step 1: Install dnsmasq

```bash
brew install dnsmasq
```

#### Step 2: Configure dnsmasq

```bash
# Create config directory (if it doesn't exist)
mkdir -pv $(brew --prefix)/etc/

# Configure *.test domains to resolve to 127.0.0.1
echo 'address=/.test/127.0.0.1' >> $(brew --prefix)/etc/dnsmasq.conf

# Set port to 53
echo 'port=53' >> $(brew --prefix)/etc/dnsmasq.conf
```

#### Step 3: Start dnsmasq service

```bash
# Start now and automatically after reboot
sudo brew services start dnsmasq
```

#### Step 4: Configure macOS resolver

```bash
# Create resolver directory (if it doesn't exist)
sudo mkdir -pv /etc/resolver

# Add nameserver for .test domains
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'
```

#### Step 5: Verify setup

```bash
# Show all DNS resolvers (should see .test resolver)
scutil --dns | grep -A 3 "resolver #.*test"

# Test DNS resolution
ping -c 1 myproject.test
# Should resolve to 127.0.0.1
```

**To remove:**
```bash
# Stop and remove dnsmasq service
sudo brew services stop dnsmasq
brew uninstall dnsmasq

# Remove resolver configuration
sudo rm /etc/resolver/test

# Remove config directory (optional)
rm -rf $(brew --prefix)/etc/dnsmasq.conf
```

> **Note:** This setup uses Homebrew's dnsmasq instead of Docker's dnsmasq for your host machine. This is more reliable and doesn't require Docker to be running for DNS to work.

---

### Linux Setup

Linux setup varies by distribution. Choose the method that matches your system.

#### Option A: systemd-resolved (Ubuntu 20.04+, Debian 11+, Fedora, Arch)

```bash
# Create systemd-resolved config for .test domain
sudo mkdir -p /etc/systemd/resolved.conf.d
sudo tee /etc/systemd/resolved.conf.d/test-domain.conf > /dev/null <<EOF
[Resolve]
DNS=127.0.0.1
Domains=~test
EOF

# Restart systemd-resolved
sudo systemctl restart systemd-resolved

# Verify configuration
resolvectl status | grep -A 5 "test"
```

**Test it:**
```bash
resolvectl query myproject.test
# Should resolve to 127.0.0.1
```

**To remove:**
```bash
sudo rm /etc/systemd/resolved.conf.d/test-domain.conf
sudo systemctl restart systemd-resolved
```

#### Option B: NetworkManager (Older Ubuntu/Debian/RHEL)

```bash
# Find your connection name
nmcli connection show

# Configure DNS for .test (replace "Your Connection" with actual name)
sudo nmcli connection modify "Your Connection" +ipv4.dns "127.0.0.1"
sudo nmcli connection modify "Your Connection" +ipv4.dns-search "~test"
sudo nmcli connection up "Your Connection"
```

**To remove:**
```bash
sudo nmcli connection modify "Your Connection" -ipv4.dns "127.0.0.1"
sudo nmcli connection modify "Your Connection" -ipv4.dns-search "~test"
sudo nmcli connection up "Your Connection"
```

#### Option C: Manual /etc/resolv.conf (Last Resort)

Only use if the above options don't work. This may be overwritten by network managers.

```bash
# Add to /etc/resolv.conf
echo "nameserver 127.0.0.1" | sudo tee -a /etc/resolv.conf
```

---

### Windows Setup

Windows doesn't natively support per-domain DNS resolution. We have **three options**:

#### Option A: Acrylic DNS Proxy (Recommended)

[Acrylic DNS Proxy](https://mayakron.altervista.org/support/acrylic/Home.htm) is a free DNS proxy for Windows that supports domain-specific forwarding.

1. **Download & Install** Acrylic DNS Proxy (free version is fine)

2. **Configure Acrylic** (in `C:\Program Files (x86)\Acrylic DNS Proxy\AcrylicConfiguration.ini`):
   ```ini
   [GlobalSection]
   PrimaryServerAddress=1.1.1.1
   SecondaryServerAddress=1.0.0.1

   [LocalHostSection]
   127.0.0.1;localhost

   [CustomHostsSection]
   *.test;127.0.0.1
   ```

3. **Restart Acrylic** service from the Acrylic Control Panel

4. **Set Windows DNS** to use Acrylic:
   - Open Network & Internet Settings
   - Change adapter options → Right-click your network → Properties
   - Select "Internet Protocol Version 4 (TCP/IPv4)" → Properties
   - Choose "Use the following DNS server addresses"
   - Preferred DNS: `127.0.0.1`
   - Alternate DNS: `1.1.1.1`
   - Click OK

**Test it:**
```powershell
# In PowerShell
nslookup myproject.test
# Should resolve to 127.0.0.1
```

#### Option B: System-wide DNS (Simple but affects all DNS)

**Warning:** This routes ALL DNS through Docker. Your internet will stop working when Docker is stopped.

1. Open Control Panel → Network and Internet → Network Connections
2. Right-click your active connection → Properties
3. Select "Internet Protocol Version 4 (TCP/IPv4)" → Properties
4. Choose "Use the following DNS server addresses"
   - Preferred DNS: `127.0.0.1`
   - Alternate DNS: `1.1.1.1`
5. Click OK

**To revert:** Set DNS back to "Obtain DNS server address automatically"

#### Option C: Manual Hosts File (Not Recommended)

You can manually add entries to `C:\Windows\System32\drivers\etc\hosts`:
```
127.0.0.1 myproject.test
127.0.0.1 another-project.test
```

**Downside:** You must manually add each project. Not automatic.

---

## Troubleshooting

### DNS not resolving

1. **Ensure Docker is running:**
   ```bash
   docker compose ps
   # Should show dnsmasq-external running
   ```

2. **Check dnsmasq logs:**
   ```bash
   docker compose logs dnsmasq-external
   ```

3. **Test DNS directly:**
   ```bash
   # macOS/Linux
   nslookup myproject.test 127.0.0.1

   # Windows PowerShell
   nslookup myproject.test 127.0.0.1
   ```

4. **Port 53 already in use:**
   ```bash
   # macOS/Linux: Check what's using port 53
   sudo lsof -i :53

   # Windows PowerShell: Check what's using port 53
   netstat -ano | findstr :53
   ```

   Common conflicts:
   - **macOS**: May need to disable mDNSResponder temporarily
   - **Linux**: systemd-resolved might be binding to port 53
   - **Windows**: DNS Client service or other DNS software

### PHP containers can't resolve .test domains

1. **Check container DNS config:**
   ```bash
   docker compose exec php84 cat /etc/resolv.conf
   # Should show: nameserver 192.168.103.3
   ```

2. **Test DNS from inside container:**
   ```bash
   docker compose exec php84 nslookup myproject.test
   # Should resolve to 192.168.103.100 (not 127.0.0.1!)
   ```

3. **Check dnsmasq-internal logs:**
   ```bash
   docker compose logs dnsmasq-internal
   ```

### Switching from .localhost to .test

If you're migrating from `.localhost` domains:

1. Update your Apache virtual host configs (see migration guide)
2. Update any hardcoded URLs in your projects
3. Clear browser cache and DNS cache:
   ```bash
   # macOS
   sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder

   # Linux
   sudo systemd-resolve --flush-caches

   # Windows (PowerShell as Admin)
   ipconfig /flushdns
   ```

---

## Advanced Configuration

### Changing DNS servers

Edit `dns/dnsmasq-external.conf` and `dns/dnsmasq-internal.conf`:

```conf
# Use different upstream DNS (e.g., Google DNS)
server=8.8.8.8
server=8.8.4.4
```

**Note:** We currently use Cloudflare DNS (1.1.1.1 / 1.0.0.1) by default.

Then restart:
```bash
docker compose restart dnsmasq-external dnsmasq-internal
```

### Disabling DNS logging

In production/daily use, you may want to disable query logging:

Edit `dns/dnsmasq-*.conf` and remove:
```conf
log-queries
log-facility=/dev/stdout
```
