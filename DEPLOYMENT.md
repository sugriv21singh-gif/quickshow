# QuickShow Production Deployment Guide

A comprehensive guide to deploy QuickShow to production with Clerk authentication, MongoDB, Razorpay payments, and email notifications.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Setup](#local-setup)
3. [Clerk Configuration](#clerk-configuration)
4. [MongoDB Atlas Setup](#mongodb-atlas-setup)
5. [Payment Gateway Setup](#payment-gateway-setup)
6. [Email Service Setup](#email-service-setup)
7. [Frontend Deployment (Vercel)](#frontend-deployment-vercel)
8. [Backend Deployment (Render)](#backend-deployment-render)
9. [Testing Production Setup](#testing-production-setup)
10. [Troubleshooting](#troubleshooting)

---

## Prerequisites

- Node.js 18+ and npm
- Git account
- GitHub repository (forked QuickShow)
- Credit card for cloud services (Vercel, MongoDB Atlas, Render are mostly free tier eligible)

---

## Local Setup

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/QuickShow.git
cd QuickShow
```

### 2. Install Dependencies

```bash
npm run install-all
```

### 3. Create Environment Files

**Client:** `client/.env.local`
```bash
VITE_CLERK_PUBLISHABLE_KEY=your-key-here
VITE_BASE_URL=http://localhost:3000
VITE_CURRENCY=$
VITE_TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p/original
```

**Server:** `server/.env`
```bash
MONGODB_URI=mongodb://localhost:27017/quickshow
CLERK_PUBLISHABLE_KEY=your-key
CLERK_SECRET_KEY=your-secret-key
INNGEST_EVENT_KEY=your-inngest-event-key
INNGEST_SIGNING_KEY=your-inngest-signing-key
TMDB_API_KEY=your-tmdb-api-key
RAZORPAY_KEY_ID=your-razorpay-key-id
RAZORPAY_KEY_SECRET=your-razorpay-key-secret
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
SENDER_EMAIL=your-email@gmail.com
NODE_ENV=development
```

### 4. Run Locally

```bash
npm run dev
```

Visit: `http://localhost:5173` (Frontend) and `http://localhost:3000` (Backend)

---

## Clerk Configuration

Clerk provides passwordless authentication (email + OAuth).

### Step 1: Create Clerk Account

1. Go to https://clerk.com
2. Sign up for free
3. Create a new application

### Step 2: Get API Keys

1. In Clerk Dashboard, go to **API Keys**
2. Copy **Publishable Key** → Add to both `client/.env.local` and `server/.env.example`
3. Copy **Secret Key** → Add to `server/.env`

Example:
```
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_Z2xvd2luZy1tb25rZmlzaC01Mi5jbGVyay5hY2NvdW50cy5kZXYk
CLERK_SECRET_KEY=sk_test_MMe44ki9YPmfklSkUrEHYo2RMcvGpFqFhgfgOtY16J
```

### Step 3: Configure Allowed Redirects

1. Go to **Clerk Dashboard > Instances > Paths**
2. Add redirect URIs:
   - Development: `http://localhost:5173`
   - Production: `https://your-frontend-domain.com`

### Step 4: Enable Sign In Methods

1. Go to **Authentication > Password**
   - ✅ **Disabled** (optional - keep for security)
2. Go to **Authentication > OAuth Applications**
   - ✅ **Google** (recommended)

### Step 5: Set Up Admin Role (Important!)

In Clerk Dashboard:
1. Go to **Users** → Select a user
2. Scroll to **User metadata**
3. Add custom metadata:
```json
{
  "role": "admin"
}
```

---

## MongoDB Atlas Setup

MongoDB Atlas is a cloud database service with a free tier.

### Step 1: Create Atlas Account

1. Go to https://www.mongodb.com/cloud/atlas
2. Sign up for free
3. Create a new project called "QuickShow"

### Step 2: Create Cluster

1. Click **Create Deployment**
2. Select **M0 (Free)** tier
3. Region: Choose closest to your users
4. Click **Create**

### Step 3: Get Connection String

1. Once cluster is created, click **Connect**
2. Choose **Drivers** → **Node.js** → Version 5.x
3. Copy connection string: `mongodb+srv://username:password@cluster.mongodb.net/quickshow?retryWrites=true&w=majority`
4. Replace `<username>`, `<password>`, `<cluster>`

### Step 4: Create Database

1. Go to **Databases**
2. Click your cluster
3. Go to **Collections** and create database:
   - **Database name:** `quickshow`
   - **Collection name:** `shows`
4. Click **Create**

### Step 5: Set MongoDB URI

In `server/.env`:
```
MONGODB_URI=mongodb+srv://user:password@cluster.mongodb.net/quickshow?retryWrites=true&w=majority
```

---

## Payment Gateway Setup

### Razorpay Configuration

1. **Create Account:** https://razorpay.com
2. **Get Test Keys:**
   - Go to **Settings > API Keys**
   - Copy **Key ID** and **Key Secret**
   - Use Test mode for development

3. **Set Environment Variables:**
```
RAZORPAY_KEY_ID=rzp_test_abc123
RAZORPAY_KEY_SECRET=yoursecretkey
```

4. **Test Payment:**
   - Use card: `4111111111111111`
   - CVV: Any 3 digits
   - Expiry: Future date

### Optional: Stripe Configuration

1. **Create Account:** https://stripe.com
2. **Get Test Keys:**
   - Go to **Developers > API Keys**
   - Copy **Publishable** and **Secret** keys

3. **Set Environment Variables:**
```
STRIPE_SECRET_KEY=sk_test_abc123
STRIPE_WEBHOOK_SECRET=whsec_abc123
```

---

## Email Service Setup

Email notifications for booking confirmations.

### Using Gmail

1. **Enable 2-Factor Authentication:**
   - Go to https://myaccount.google.com/security
   - Enable 2-Step Verification

2. **Create App Password:**
   - Go to https://myaccount.google.com/apppasswords
   - Select **Mail** and **Windows Computer**
   - Google generates a 16-character password

3. **Set Environment Variables:**
```
SENDER_EMAIL=your-email@gmail.com
SMTP_USER=your-email@gmail.com
SMTP_PASS=16-character-app-password
```

### Using Other Email Providers

Update [emailService.js](server/utils/emailService.js) transporter settings:
```javascript
transporter = nodemailer.createTransport({
  host: "smtp.your-provider.com",
  port: 587,
  auth: { user: "...", pass: "..." }
});
```

---

## Frontend Deployment (Vercel)

Vercel is optimized for React/Vite and integrates with Clerk.

### Step 1: Push to GitHub

```bash
git add .
git commit -m "Deploy to production"
git push origin main
```

### Step 2: Create Vercel Project

1. Go to https://vercel.com
2. Sign up and connect GitHub
3. Select your QuickShow repository
4. **Import**

### Step 3: Configure Build Settings

1. **Framework:** Vite
2. **Root Directory:** `./client`
3. **Build Command:** `npm run build`
4. **Output Directory:** `dist`

### Step 4: Add Environment Variables

Go to **Settings > Environment Variables** and add:

```
VITE_CLERK_PUBLISHABLE_KEY=pk_test_xxx
VITE_BASE_URL=https://quickshow-backend-render.com
VITE_CURRENCY=$
VITE_TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p/original
```

### Step 5: Deploy

Click **Deploy** - your frontend will be live at `https://your-project.vercel.app`

### Step 6: Update Clerk Allowed Redirects

In Clerk Dashboard, add your Vercel domain:
- `https://your-project.vercel.app`

---

## Backend Deployment (Render)

Render is ideal for Node.js backends with auto-deployment from GitHub.

### Step 1: Create Render Account

1. Go to https://render.com
2. Sign up with GitHub
3. Connect your GitHub account

### Step 2: Create New Web Service

1. Click **New** → **Web Service**
2. Select your QuickShow repository
3. **Connect**

### Step 3: Configure Service

- **Name:** `quickshow-backend`
- **Root Directory:** `server`
- **Runtime:** `Node`
- **Build Command:** `npm install`
- **Start Command:** `node server.js`

### Step 4: Add Environment Variables

Go to **Environment** and add all variables from `server/.env`:

```
MONGODB_URI=mongodb+srv://...
CLERK_PUBLISHABLE_KEY=pk_test_xxx
CLERK_SECRET_KEY=sk_test_xxx
INNGEST_EVENT_KEY=...
INNGEST_SIGNING_KEY=...
TMDB_API_KEY=...
RAZORPAY_KEY_ID=...
RAZORPAY_KEY_SECRET=...
SMTP_USER=...
SMTP_PASS=...
SENDER_EMAIL=...
NODE_ENV=production
FRONTEND_URL=https://your-project.vercel.app
```

### Step 5: Deploy

- Click **Create Web Service**
- Render will auto-deploy from your repository
- Your backend will be live at `https://quickshow-backend.onrender.com`

### Step 6: Update Frontend Base URL

In Vercel, update `VITE_BASE_URL`:
```
VITE_BASE_URL=https://quickshow-backend.onrender.com
```

---

## Testing Production Setup

### 1. Test Frontend

1. Visit `https://your-project.vercel.app`
2. Click **Login**
3. Sign in with email or Google
4. Should redirect to home page

### 2. Test Movie Listing

1. Home page should show movies
2. Click on a movie
3. Should display show times and seats

### 3. Test Booking Flow

1. Select show time
2. Click on seats
3. Click **Book Tickets**
4. Should show payment page

### 4. Test Payment

1. Enter test card: `4111111111111111`
2. Click **Pay**
3. Should show booking confirmation
4. Check email for confirmation message

### 5. Test Admin Dashboard

1. Sign in with admin account (with `role: "admin"` in Clerk)
2. Visit `/admin`
3. Should see dashboard with statistics

### 6. Check Email Notifications

1. Look for booking confirmation email
2. Verify payment receipt
3. Check formatting

---

## Troubleshooting

### Frontend Shows "Clerk not configured"

**Problem:** SignIn component doesn't load
**Solution:**
1. Check `VITE_CLERK_PUBLISHABLE_KEY` is correct
2. Verify key matches Clerk Dashboard
3. Redeploy after updating

### Backend Server Won't Start

**Problem:** "Missing required environment variable"
**Solution:**
1. Check all REQUIRED variables in `.env`
2. Run `node -e "require('dotenv').config(); console.log(process.env)"`
3. Copy exact values from services

### Payments Fail

**Problem:** "Payment failed" error
**Solution:**
1. Check Razorpay keys are in TEST mode
2. Use test card: `4111111111111111`
3. Verify webhook is configured (optional for basic testing)

### Emails Not Sending

**Problem:** Booking confirmation email not received
**Solution:**
1. Check Gmail App Password is correct (16 characters)
2. Verify 2FA is enabled on Gmail
3. Check spam folder
4. Review server logs for SMTP errors

### Movies Not Loading

**Problem:** Blank movie list
**Solution:**
1. Check TMDB_API_KEY is correct
2. Verify MongoDB connection: `MONGODB_URI`
3. Run seed script: `npm run seed` (in server)
4. Check Network tab for API errors

### "Cannot find module" Error

**Problem:** Package import fails
**Solution:**
1. Run `npm install` in affected directory
2. Check all `import` paths are correct
3. Verify Node version is 18+

### CORS Errors

**Problem:** "CORS policy: No 'Access-Control-Allow-Origin' header"
**Solution:**
1. Check `FRONTEND_URL` is set correctly
2. Verify CORS config in `server.js`
3. Ensure backend URL is whitelisted

---

## Support

For issues:
1. Check this guide's Troubleshooting section
2. Review service provider docs (Clerk, MongoDB, Razorpay)
3. Check error logs on Vercel and Render
4. Create issue on GitHub repository

---

## Production Checklist

Before going live:

- [ ] All environment variables configured
- [ ] Frontend deployed and accessible
- [ ] Backend deployed and accessible
- [ ] Clerk authentication working
- [ ] MongoDB has data
- [ ] Payments tested with real test cards
- [ ] Email notifications working
- [ ] Admin dashboard accessible with admin account
- [ ] Movie listing loads
- [ ] Booking flow works end-to-end
- [ ] Error pages display (404, 500)
- [ ] Security headers configured
- [ ] SSL certificate installed (auto with Vercel)
- [ ] Database backups configured (MongoDB Atlas)
- [ ] Monitoring set up (optional)

---

**Happy Booking! 🎬🎟️**
