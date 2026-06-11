# QuickShow Configuration Guide

Complete configuration and setup guide for QuickShow production deployment.

---

## Environment Variables Summary

### Client Environment (`client/.env.local`)

```env
# Clerk Authentication (Required)
VITE_CLERK_PUBLISHABLE_KEY=pk_test_Z2xvd2luZy1tb25rZmlzaC01Mi5jbGVyay5hY2NvdW50cy5kZXYk

# Backend URL (Set based on environment)
VITE_BASE_URL=http://localhost:3000         # Local dev
# VITE_BASE_URL=https://backend.example.com # Production

# Optional
VITE_CURRENCY=$
VITE_TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p/original
```

### Server Environment (`server/.env`)

```env
# Required
MONGODB_URI=mongodb+srv://user:password@cluster.mongodb.net/quickshow
CLERK_SECRET_KEY=sk_test_xxx
INNGEST_EVENT_KEY=xxx
INNGEST_SIGNING_KEY=xxx
TMDB_API_KEY=xxx

# Required for Payments
RAZORPAY_KEY_ID=rzp_test_xxx
RAZORPAY_KEY_SECRET=xxx

# Optional but Recommended
CLERK_PUBLISHABLE_KEY=pk_test_xxx
SENDER_EMAIL=noreply@quickshow.app
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# Optional
NODE_ENV=development
FRONTEND_URL=http://localhost:5173
PORT=3000
```

---

## Service-by-Service Setup

### 1. **Clerk Authentication**

**What:** Passwordless authentication (email + OAuth)

**Setup:**
1. Create account: https://clerk.com
2. Create new application
3. Get **Publishable Key** and **Secret Key**
4. Enable authentication methods:
   - Email/Password (optional)
   - Google OAuth (recommended)

**Where to use:**
- Client: `VITE_CLERK_PUBLISHABLE_KEY`
- Server: `CLERK_SECRET_KEY` (optional: `CLERK_PUBLISHABLE_KEY` for forwarded metadata)

**Admin Setup:**
- Go to Users in Clerk Dashboard
- Edit user metadata
- Add: `{ "role": "admin" }`

---

### 2. **MongoDB Atlas**

**What:** Cloud database for movies, shows, bookings, users

**Setup:**
1. Create account: https://mongodb.com/cloud/atlas
2. Create M0 (free) cluster
3. Create database: `quickshow`
4. Get connection string
5. Add IP whitelist (or 0.0.0.0 for development)

**Where to use:**
- Server: `MONGODB_URI`

**Collections Created Automatically:**
- `movies` - Movie metadata
- `shows` - Show times, prices, occupied seats
- `bookings` - User bookings
- `users` - User profiles (synced from Clerk)

---

### 3. **TMDB API**

**What:** Movie database for fetching metadata

**Setup:**
1. Create account: https://www.themoviedb.org/settings/api
2. Request API key
3. Accept terms and get key

**Where to use:**
- Server: `TMDB_API_KEY`

**Used for:**
- Fetching movie data (title, poster, cast, ratings)
- Adding new shows via admin panel

---

### 4. **Razorpay (Primary Payment)**

**What:** Payment gateway for processing bookings

**Setup:**
1. Create account: https://razorpay.com
2. Go to Settings > API Keys
3. Copy Key ID and Secret (Test mode)
4. Enable webhooks (optional, but recommended)

**Where to use:**
- Server: `RAZORPAY_KEY_ID`, `RAZORPAY_KEY_SECRET`

**Test Card:**
- Card: `4111111111111111`
- CVV: Any 3 digits
- Expiry: Any future date

**Features:**
- Creates orders
- Processes payments
- Generates order links

---

### 5. **Inngest (Job Queue)**

**What:** Background job scheduler for automation

**Setup:**
1. Create account: https://app.inngest.com
2. Create new workspace
3. Get keys from Settings

**Where to use:**
- Server: `INNGEST_EVENT_KEY`, `INNGEST_SIGNING_KEY`

**Handles:**
- Seat hold expiration (10-min timeout)
- Booking cleanup
- Payment verification
- Email notifications (configured but not activated)

---

### 6. **Email Service**

**What:** Send booking confirmations and notifications

**Setup (Gmail with App Password):**
1. Enable 2FA: https://myaccount.google.com/security
2. Create App Password: https://myaccount.google.com/apppasswords
3. Select Mail + Windows Computer
4. Copy 16-character password

**Where to use:**
- Server: `SMTP_USER`, `SMTP_PASS`, `SENDER_EMAIL`

**Features:**
- Booking confirmation emails
- Payment failure notifications
- Cancellation confirmations

**Note:** Email sending is configured but optional. Leave empty to skip.

---

## Deployment Platforms

### Frontend (Vercel)

```
GitHub Repository → Vercel Project
Root Directory: /client
Build Command: npm run build
Output: dist
```

**Environment Variables:**
```
VITE_CLERK_PUBLISHABLE_KEY
VITE_BASE_URL=https://backend-url.com
VITE_CURRENCY
VITE_TMDB_IMAGE_BASE_URL
```

### Backend (Render)

```
GitHub Repository → Render Service
Root Directory: /server
Start Command: node server.js
```

**Environment Variables:** All `server/.env` variables

---

## Security Checklist

- ✅ Environment variables never committed to git
- ✅ `.env` files added to `.gitignore`
- ✅ Clerk keys properly rotated regularly
- ✅ MongoDB IP whitelist configured
- ✅ Payment keys in TEST mode for development
- ✅ CORS configured for specific origins
- ✅ Rate limiting enabled on all endpoints
- ✅ SQL injection prevention (MongoDB)
- ✅ XSS protection headers enabled
- ✅ HTTPS enforced in production

---

## Environment-Specific Configurations

### Development

```env
NODE_ENV=development
VITE_BASE_URL=http://localhost:3000
VITE_CLERK_PUBLISHABLE_KEY=your-test-key
CLERK_SECRET_KEY=your-test-secret
RAZORPAY_KEY_ID=rzp_test_xxx  # Test mode
```

### Production

```env
NODE_ENV=production
VITE_BASE_URL=https://your-backend-url.com
FRONTEND_URL=https://your-frontend-url.com
VITE_CLERK_PUBLISHABLE_KEY=your-prod-key
CLERK_SECRET_KEY=your-prod-secret
RAZORPAY_KEY_ID=rzp_live_xxx  # Live mode
```

---

## Validation & Testing

### Startup Validation

Server validates all required environment variables on startup:
```bash
# Server will log:
# ✅ Environment variables validated successfully
# or
# 🔴 CRITICAL ERRORS - Application will not start:
#    ❌ Missing required environment variable: MONGODB_URI
```

### Local Testing

```bash
# Test Clerk authentication
npm run dev  # Frontend should show login

# Test API endpoints
curl http://localhost:3000/api/show/all

# Test database
# Check MongoDB Atlas dashboard

# Test payments (if configured)
# Use test card: 4111111111111111
```

### Production Testing

1. Visit frontend URL
2. Sign in with email or Google
3. Browse movies
4. Book seats
5. Complete payment with test card
6. Check booking confirmation email
7. Access admin dashboard (if admin)

---

## Troubleshooting

### "Missing required environment variable"

**Check:**
1. All required vars in `.env` file
2. No typos in variable names
3. Values are not empty
4. File saved before running server

### "Clerk authentication unavailable"

**Check:**
1. `VITE_CLERK_PUBLISHABLE_KEY` is set
2. Key format matches Clerk Dashboard
3. No `your-` placeholders in production
4. Key is not expired or revoked

### "Cannot connect to MongoDB"

**Check:**
1. Connection string format is correct
2. Username and password are URL-encoded
3. IP whitelist includes your IP
4. Cluster is running (Atlas dashboard)
5. Database name matches

### "Payment failed"

**Check:**
1. Razorpay keys are correct
2. Using test card (4111111111111111)
3. Test mode is enabled
4. No trailing spaces in keys

### "Emails not sending"

**Check:**
1. Gmail 2FA is enabled
2. App Password is 16 characters
3. SMTP_USER matches Gmail address
4. Password is copied exactly

---

## Monitoring & Logs

### Vercel Logs
- Dashboard: https://vercel.com/dashboard
- Logs → Frontend errors, build logs

### Render Logs
- Dashboard: https://dashboard.render.com
- Logs → Backend errors, startup logs

### MongoDB Logs
- Atlas Dashboard → Logs → Diagnostics

### Clerk Logs
- Dashboard → Logs → Authentication events

---

## Regular Maintenance

**Weekly:**
- Check error logs on Vercel and Render
- Monitor booking success rate
- Review payment failures

**Monthly:**
- Rotate Clerk keys (optional)
- Check MongoDB storage usage
- Review API rate limiting stats

**Quarterly:**
- Update dependencies (npm update)
- Security audit
- Backup database (MongoDB Atlas)

---

## Support Resources

- **Clerk Docs:** https://clerk.com/docs
- **MongoDB Docs:** https://docs.mongodb.com
- **Razorpay Docs:** https://razorpay.com/docs
- **Inngest Docs:** https://www.inngest.com/docs
- **Vercel Docs:** https://vercel.com/docs
- **Render Docs:** https://render.com/docs

---

**Last Updated:** June 2026
