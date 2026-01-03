# Deployment Checklist - CORS Configuration

## ✅ Code Changes (Already Done)
- [x] Custom CORS headers implementation in `backend/lib/backend_web/endpoint.ex`
- [x] Vercel domain explicitly allowed: `https://inventory-mangement-inky.vercel.app`
- [x] Production fallback to allow all `vercel.app` domains
- [x] Frontend API client configured to use `VITE_API_URL` environment variable

## 🔧 Vercel Configuration (REQUIRED)

### Step 1: Set Environment Variable
1. Go to your Vercel project: https://vercel.com/dashboard
2. Select your project: `inventory-mangement-inky`
3. Go to **Settings** → **Environment Variables**
4. Click **Add New**
5. Add:
   ```
   Key: VITE_API_URL
   Value: https://inventory-mangement-0dro.onrender.com/api
   ```
6. Select all environments (Production, Preview, Development)
7. Click **Save**

### Step 2: Redeploy
1. Go to **Deployments** tab
2. Click **Redeploy** on the latest deployment
3. Or push a new commit to trigger a new deployment

### Step 3: Verify
After deployment, check:
- Open browser DevTools → Network tab
- Make a request (e.g., load items)
- Verify the request goes to: `https://inventory-mangement-0dro.onrender.com/api/items`
- NOT to: `http://localhost:4000/api/items`

## 🔧 Render Configuration (Verify)

### Required Environment Variables
Check that these are set in your Render service:

1. **DATABASE_URL** (usually auto-set by Render)
   - Should be your PostgreSQL connection string

2. **SECRET_KEY_BASE** (REQUIRED)
   - Generate: `mix phx.gen.secret` or `openssl rand -base64 48`
   - Set in Render: **Environment** → **Environment Variables**

3. **PORT** (usually auto-set by Render)
   - Render automatically sets this

4. **RENDER_EXTERNAL_HOSTNAME** (usually auto-set by Render)
   - Should be: `inventory-mangement-0dro.onrender.com`

### Verify Render Service
1. Check **Logs** tab - service should start without errors
2. Test API directly:
   ```bash
   curl https://inventory-mangement-0dro.onrender.com/api/items
   ```
3. Check response headers include CORS headers:
   ```bash
   curl -I -H "Origin: https://inventory-mangement-inky.vercel.app" \
        https://inventory-mangement-0dro.onrender.com/api/items
   ```
   Should see: `access-control-allow-origin: https://inventory-mangement-inky.vercel.app`

## 🐛 Troubleshooting

### Issue: Still getting CORS error
1. **Check Vercel environment variable is set correctly**
   - Go to Vercel → Settings → Environment Variables
   - Verify `VITE_API_URL` is set to: `https://inventory-mangement-0dro.onrender.com/api`
   - Make sure you redeployed after setting it

2. **Check browser console**
   - Open DevTools → Console
   - Look for the actual URL being requested
   - Should be `https://inventory-mangement-0dro.onrender.com/api/...`

3. **Check Network tab**
   - Open DevTools → Network
   - Find the failed request
   - Check the **Request URL** and **Request Headers** → **Origin**
   - Verify the Origin matches what the backend expects

4. **Check Render logs**
   - Go to Render → Your Service → Logs
   - Look for any errors or CORS-related messages
   - Verify the service is running

### Issue: 500 Internal Server Error
- Check Render logs for detailed error
- Verify `DATABASE_URL` is correct
- Verify `SECRET_KEY_BASE` is set
- Ensure database migrations are run

### Issue: Works locally but not in production
- **Most common cause**: `VITE_API_URL` not set in Vercel
- **Solution**: Set the environment variable and redeploy

## 📝 Quick Reference

### Vercel Environment Variable
```
VITE_API_URL=https://inventory-mangement-0dro.onrender.com/api
```

### Render Environment Variables (Verify)
```
DATABASE_URL=<your-postgres-url>
SECRET_KEY_BASE=<generated-secret>
PORT=<auto-set-by-render>
RENDER_EXTERNAL_HOSTNAME=inventory-mangement-0dro.onrender.com
```

### Test Commands

**Test API directly:**
```bash
curl https://inventory-mangement-0dro.onrender.com/api/items
```

**Test CORS headers:**
```bash
curl -I -H "Origin: https://inventory-mangement-inky.vercel.app" \
     https://inventory-mangement-0dro.onrender.com/api/items
```

**Expected CORS headers in response:**
```
access-control-allow-origin: https://inventory-mangement-inky.vercel.app
access-control-allow-methods: GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD
access-control-allow-headers: Content-Type, Authorization, Accept, ...
```

