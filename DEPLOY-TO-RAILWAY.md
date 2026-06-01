# PSCMA Portal — Deploy to Railway (Free)

**Time needed:** ~15 minutes  
**Cost:** Free (Railway Hobby plan gives $5/month free credit — enough for this app)  
**Your domain:** Point `portal.theislamiceducatorsschool.com` to Railway after setup

---

## STEP 1 — Create a GitHub Account & Repository

> If you already have GitHub, skip to Step 1c.

### 1a. Create GitHub account
1. Go to **[github.com](https://github.com)**
2. Click **Sign up** → create a free account

### 1b. Upload files to a new repository
1. After signing in, click the **+** icon (top right) → **New repository**
2. Name it: `pscma-portal`
3. Set it to **Private** (recommended)
4. Click **Create repository**
5. On the next page, click **uploading an existing file**
6. Drag and drop ALL files from this ZIP (extract first):
   - `index.mjs`
   - `pino-file.mjs`
   - `pino-worker.mjs`
   - `pino-pretty.mjs`
   - `package.json`
   - `railway.toml`
   - `setup-database.sql`
   - The entire `public/` folder
7. Click **Commit changes**

### 1c. Your repository is ready ✅

---

## STEP 2 — Create Railway Account

1. Go to **[railway.app](https://railway.app)**
2. Click **Login** → **Login with GitHub** (use the same GitHub account)
3. Authorize Railway to access your GitHub
4. Railway will show you the dashboard

---

## STEP 3 — Create New Railway Project

1. In Railway dashboard, click **New Project**
2. Select **Deploy from GitHub repo**
3. Find and select `pscma-portal`
4. Railway will start deploying — wait for it to show **Building...**

---

## STEP 4 — Add PostgreSQL Database

1. In your Railway project, click **+ New** (or the **Add Service** button)
2. Select **Database** → **Add PostgreSQL**
3. Railway creates a free PostgreSQL database in ~30 seconds
4. Click on the PostgreSQL service → go to **Variables** tab
5. You will see `DATABASE_URL` — copy this value (you'll need it in Step 5)

---

## STEP 5 — Set Environment Variables

1. Click on your **pscma-portal** service (not the database)
2. Go to **Variables** tab
3. Add these variables one by one:

| Variable | Value |
|----------|-------|
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` (Railway auto-links this — just type it exactly as shown) |
| `SESSION_SECRET` | `pscma-super-secret-key-theislamiceducatorsschool-2024` |
| `NODE_ENV` | `production` |

4. Click **Deploy** to apply

---

## STEP 6 — Run the Database Setup

1. Click on the **PostgreSQL** service in Railway
2. Go to **Query** tab (or **Data** tab)
3. Click **New Query**
4. Open the `setup-database.sql` file (from this package) in any text editor
5. Copy the **entire contents** and paste into Railway's query editor
6. Click **Run Query**
7. You should see: all tables created + demo accounts inserted ✅

---

## STEP 7 — Get Your Railway URL

1. Click on your **pscma-portal** service
2. Go to **Settings** tab → **Networking** section
3. Click **Generate Domain**
4. Railway gives you a URL like: `pscma-portal-production.up.railway.app`
5. Open that URL in your browser — PSCMA portal should load! 🎉

**Test login:**
- Email: `admin@pscma.org`
- Password: `Password123!`

---

## STEP 8 — Connect Your Own Subdomain

Point `portal.theislamiceducatorsschool.com` to Railway:

### In Railway:
1. Service → Settings → Networking → **Custom Domain**
2. Enter: `portal.theislamiceducatorsschool.com`
3. Railway shows you a **CNAME value** (something like `pscma-portal-production.up.railway.app`)

### In Hostinger hPanel:
1. Go to **Domains** → `theislamiceducatorsschool.com` → **DNS / Nameservers**
2. Click **Add Record**
3. Set:
   - Type: `CNAME`
   - Name: `portal`
   - Points to: *(the Railway CNAME value)*
   - TTL: 3600
4. Click Save
5. Wait 5–30 minutes for DNS to update

After DNS updates, your app is live at:
**`https://portal.theislamiceducatorsschool.com`** ✅

---

## STEP 9 — Update Android APK with Your Real URL

Once the portal is live, update `capacitor.config.json`:

```json
{
  "appId": "org.pscma.portal",
  "appName": "PSCMA",
  "webDir": "dist/public",
  "server": {
    "url": "https://portal.theislamiceducatorsschool.com",
    "cleartext": false
  }
}
```

Then rebuild APK in Android Studio → **Build → Generate Signed Bundle/APK**

---

## TROUBLESHOOTING

| Problem | Solution |
|---------|----------|
| Build fails on Railway | Check that all `.mjs` files were uploaded to GitHub |
| App crashes on start | Make sure `DATABASE_URL` variable is set in Railway |
| Login not working | Run `setup-database.sql` in Railway's Query tab |
| Subdomain not loading | DNS can take up to 30 min — wait and try again |
| 502 Bad Gateway | Railway service is still starting — wait 1 minute |

---

## Railway Free Tier Limits

- **$5/month free credit** (auto-applied to Hobby plan)
- Enough for: 1 Node.js app + 1 PostgreSQL database running 24/7
- No credit card required for first deployment
- If you exceed free credit, Railway will notify you before charging

---

## Demo Accounts

| Email | Password | Role |
|-------|----------|------|
| admin@pscma.org | Password123! | Super Admin (full access) |
| executive@pscma.org | Password123! | Executive Body |
| member@pscma.org | Password123! | General Member |
| member23@pscma.org | Password123! | Pending (needs approval) |
