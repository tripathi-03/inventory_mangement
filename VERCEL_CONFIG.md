# Vercel Configuration for CORS Fix

## Required Environment Variable

You need to set the following environment variable in your Vercel project:

### Environment Variable:
- **Name**: `VITE_API_URL`
- **Value**: `https://inventory-mangement-0dro.onrender.com/api`
- **Environment**: Production, Preview, and Development (if you want to test)

### How to Set in Vercel:
1. Go to your Vercel project dashboard
2. Navigate to **Settings** → **Environment Variables**
3. Click **Add New**
4. Enter:
   - **Key**: `VITE_API_URL`
   - **Value**: `https://inventory-mangement-0dro.onrender.com/api`
   - Select all environments (Production, Preview, Development)
5. Click **Save**
6. **Redeploy** your application for the changes to take effect

### Verify:
After setting the environment variable and redeploying, check the browser console. The frontend should now be making requests to:
`https://inventory-mangement-0dro.onrender.com/api/items`

Instead of:
`http://localhost:4000/api/items`

