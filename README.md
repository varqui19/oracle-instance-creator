# Free 24/7 OpenCode Server on Oracle Cloud

This guide sets up a completely free, always-on OpenCode server using Oracle Cloud Free Tier.

## What You Get
- **4 ARM cores**
- **24GB RAM**
- **1TB bandwidth/month**
- **24/7 forever (free tier)**

---

## Step 1: Create Oracle Cloud Account

1. Go to https://cloud.oracle.com
2. Click **Sign Up**
3. Use your email and create a password
4. Verify your email
5. Add payment method (credit card - won't be charged for free tier)

---

## Step 2: Generate API Keys

1. Log into Oracle Cloud Console
2. Go to **Identity & Security → Domains**
3. Click **Default Domain**
4. Go to **API Keys**
5. Click **Add API Key**
6. Select **"Generate API Key Pair"**
7. Click **Download Private Key** (save as `oci_api_key.pem`)
8. Click **Download Configuration File** (save this - you'll need the values)

---

## Step 3: Fork and Set Up GitHub Repository

1. Go to: https://github.com/remmarpidong/oracle-instance-creator
2. Fork the repository to your account
3. Go to your forked repo → **Settings → Secrets and variables → Actions**
4. Click **New repository secret** and add each secret:

### Required Secrets

| Secret Name | Value |
|-------------|-------|
| `OCI_CONFIG` | Copy entire contents of your config file |
| `OCI_KEY` | Copy entire contents of `oci_api_key.pem` (private key) |
| `OCI_TENANCY` | Find in your config file: `tenancy=` |
| `OCI_USER` | Find in your config file: `user=` |
| `OCI_FINGERPRINT` | Find in your config file: `fingerprint=` |
| `OCI_REGION` | Find in your config file: `region=` (e.g., `us-ashburn-1`) |

### Optional: Telegram Notifications

To get notified when your instance is created:

1. Open Telegram and search for **@BotFather**
2. Send `/newbot`
3. Follow prompts - give your bot a name and username
4. Copy the **Bot Token** (looks like: `123456789:ABCdef...`)
5. Open **@userinfobot** on Telegram
6. Copy your **Chat ID** (number like: `123456789`)

Add these secrets:

| Secret Name | Value |
|-------------|-------|
| `TELEGRAM_BOT_TOKEN` | Your bot token from BotFather |
| `TELEGRAM_USER_ID` | Your chat ID from userinfobot |

---

## Step 4: Run the Instance Creator

1. Go to your forked repo on GitHub
2. Click the **Actions** tab
3. Click **"Oracle Cloud Instance Creator"**
4. Click **"Run workflow"**
5. Click the green **Run workflow** button

The script will:
- Automatically retry every 60 seconds
- Check for free capacity
- Create an Ubuntu instance when capacity is available
- Send you a Telegram message when done

**⚠️ Important:** If you get "Out of host capacity" errors, this is normal. Just run the workflow again. Capacity opens up frequently - the script keeps trying automatically.

---

## Step 5: Connect to Your Instance

Once your instance is created:

1. Log into Oracle Cloud Console
2. Go to **Compute → Instances**
3. Find your instance
4. Copy the **Public IP Address**

### Connect via SSH

```bash
# The script auto-generates SSH keys
# Download the private key from Oracle Console or use the auto-generated one

ssh -i /path/to/private_key ubuntu@YOUR_PUBLIC_IP
```

### Install OpenCode

Once connected:

```bash
# Install OpenCode
curl -fsSL https://opencode.ai/install | bash

# Run OpenCode
opencode
```

### For Web Access (Optional)

```bash
# Install cloudflared for tunnel
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared

# Start OpenCode serve and tunnel
opencode serve &
cloudflared tunnel --url http://localhost:3000
```

You'll get a public URL like `https://xxxx.trycloudflare.com`

---

## Step 6: Keep Your Instance Running

Oracle Free Tier instances don't auto-stop unless you exceed limits. To be safe:

1. Set up **OCI Monitoring** alerts
2. Don't exceed free tier limits:
   - 50GB block volume
   - 10TB outbound bandwidth/month

---

## Troubleshooting

### "Out of host capacity" error
- This is normal in high-demand regions
- Keep the workflow running - capacity opens up
- Try different regions by updating `OCI_REGION` in secrets

### Can't connect after instance creation
- Wait 2-3 minutes for Ubuntu to fully boot
- Check security list allows SSH (port 22)
- Verify you're using the correct SSH key

### Workflow fails
- Check GitHub Actions logs for errors
- Verify all secrets are correctly set
- Make sure API key isn't expired

---

## Cost

**$0/month forever** - Oracle Cloud Free Tier includes:
- 4 ARM cores, 24GB RAM
- 1GB RAM, 0.5 CPU micro instance (always free)
- 50GB block storage
- 10TB outbound bandwidth

---

## Quick Reference

| Resource | Link |
|----------|------|
| Oracle Cloud Signup | https://cloud.oracle.com |
| API Keys Location | Identity → Domains → Default Domain → API Keys |
| Your Repo | https://github.com/remmarpidong/oracle-instance-creator |
| OpenCode Docs | https://opencode.ai/docs |

---

## Auto-Generated SSH Keys

The automation script generates SSH keys automatically. Look for:
- `opencode_key` (private key) - save this!
- `opencode_key.pub` (public key)

These are created in the project directory after successful instance creation.
