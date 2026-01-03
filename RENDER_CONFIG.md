# Render Configuration for CORS Fix

## Required Environment Variables

Make sure these environment variables are set in your Render service:

### 1. Database Configuration
- **DATABASE_URL**: Should be automatically set by Render if you have a PostgreSQL database attached
- If not set, add it manually with your database connection string

### 2. Phoenix Configuration
- **SECRET_KEY_BASE**: Required for Phoenix sessions and signing
  - Generate one using: `mix phx.gen.secret`
  - Or use: `openssl rand -base64 48`
  - Set this in Render: **Environment** → **Environment Variables**

### 3. Port and Host (Usually Auto-Set)
- **PORT**: Usually set automatically by Render
- **RENDER_EXTERNAL_HOSTNAME**: Usually set automatically by Render
- **HOST**: Optional fallback if RENDER_EXTERNAL_HOSTNAME is not set

### 4. Optional Configuration
- **POOL_SIZE**: Database connection pool size (default: 10)
- **MIX_ENV**: Should be `prod` (usually set automatically)

## Verify CORS Configuration

The backend code already includes CORS configuration that:
- ✅ Allows `https://inventory-mangement-inky.vercel.app`
- ✅ Allows all `vercel.app` domains in production
- ✅ Allows all HTTPS origins in production (permissive for now)

## After Setting Environment Variables

1. **Redeploy** your Render service
2. Check the **Logs** tab to ensure the service starts correctly
3. Test the API endpoint directly:
   ```bash
   curl https://inventory-mangement-0dro.onrender.com/api/items
   ```
4. Verify CORS headers are present in the response

## Common Issues

### Issue: 500 Internal Server Error
- Check Render logs for detailed error messages
- Verify DATABASE_URL is correct
- Verify SECRET_KEY_BASE is set
- Ensure database migrations have been run

### Issue: CORS still not working
- Verify the frontend is using the correct API URL
- Check browser console for the actual origin being sent
- Verify the backend logs show the request origin

