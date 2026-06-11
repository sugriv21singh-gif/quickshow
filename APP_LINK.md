# QuickShow Direct Links & Setup

## 🎬 Live Deployment
- **App:** https://quickshow-main-coral.vercel.app/
- **Admin Dashboard:** https://quickshow-main-coral.vercel.app/admin
- **Backend API:** Running on Render (see CONFIGURATION.md for details)

---

## 🚀 Quick Start - Local Development

### Prerequisites
- Node.js 18+ and npm
- Git

### Setup Steps

```bash
# 1. Clone repository
git clone https://github.com/YOUR_USERNAME/QuickShow.git
cd QuickShow

# 2. Install dependencies
npm run install-all

# 3. Create environment files
# Copy and fill in your API keys (see CONFIGURATION.md)
cp client/.env.example client/.env.local
cp server/.env.example server/.env

# 4. Start development servers
npm run dev

# 5. Open in browser
# Frontend: http://localhost:5173
# Backend: http://localhost:3000
```

### Required Configuration
Before running, you need to set up:
1. **Clerk Authentication** - Get keys from https://clerk.com
2. **MongoDB Atlas** - Create free cluster at https://mongodb.com/cloud/atlas
3. **TMDB API** - Get key from https://www.themoviedb.org/settings/api
4. **Razorpay** - Create account at https://razorpay.com

**See [CONFIGURATION.md](CONFIGURATION.md) for detailed setup instructions.**

---

## 📚 Documentation

- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Complete production deployment guide
- **[CONFIGURATION.md](CONFIGURATION.md)** - Environment variables and service setup
- **[PRODUCTION_CHECKLIST.md](PRODUCTION_CHECKLIST.md)** - Verification checklist
- **[README.md](README.md)** - Project overview and features

---

## 🌐 Deploy Your Own Copy

### Frontend (Vercel)

1. **Push to GitHub**
```bash
git add .
git commit -m "Deploy to production"
git push origin main
```

2. **Deploy on Vercel**
   - Go to https://vercel.com
   - Click "New Project"
   - Select your GitHub repository
   - Set root directory: `./client`
   - Add environment variables (see CONFIGURATION.md)
   - Click Deploy

3. **Update Clerk**
   - Add Vercel domain to Clerk allowed redirects
   - Format: `https://your-project-name.vercel.app`

### Backend (Render)

1. **Create Render Service**
   - Go to https://render.com
   - Click "New +" → "Web Service"
   - Select your GitHub repository
   - Set root directory: `server`

2. **Configure Service**
   - Runtime: Node
   - Build: `npm install`
   - Start: `node server.js`

3. **Add Environment Variables**
   - MongoDB URI
   - Clerk keys
   - API keys (TMDB, Razorpay, etc.)
   - Email configuration

**See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed step-by-step instructions.**

---

## 🔑 Environment Variables

### Frontend (client/.env.local)
```
VITE_CLERK_PUBLISHABLE_KEY=your-key
VITE_BASE_URL=http://localhost:3000  # Change for production
```

### Backend (server/.env)
```
MONGODB_URI=your-mongodb-connection
CLERK_SECRET_KEY=your-secret
TMDB_API_KEY=your-key
RAZORPAY_KEY_ID=your-key
RAZORPAY_KEY_SECRET=your-secret
```

**Full list:** See [CONFIGURATION.md](CONFIGURATION.md)

---

## ✅ Features

- ✅ Email/Password authentication via Clerk
- ✅ Google OAuth login
- ✅ Movie browsing with TMDB data
- ✅ Seat booking with real-time availability
- ✅ Razorpay payment integration
- ✅ Booking confirmation emails
- ✅ Admin dashboard
- ✅ User profile and bookings history
- ✅ Favorite movies list
- ✅ Responsive design

---

## 📞 Support

- **Setup Issues?** → See [CONFIGURATION.md](CONFIGURATION.md)
- **Deployment Problems?** → See [DEPLOYMENT.md](DEPLOYMENT.md)
- **Want to verify everything?** → See [PRODUCTION_CHECKLIST.md](PRODUCTION_CHECKLIST.md)

---

## 📋 Production Checklist

Before going live:
1. ✅ All environment variables configured
2. ✅ Clerk authentication working
3. ✅ MongoDB Atlas active
4. ✅ Razorpay production keys added
5. ✅ Email notifications tested
6. ✅ Frontend deployed to Vercel
7. ✅ Backend deployed to Render
8. ✅ Domain configured
9. ✅ SSL certificate active
10. ✅ Error monitoring set up

**Full checklist:** See [PRODUCTION_CHECKLIST.md](PRODUCTION_CHECKLIST.md)

---

## 🎯 Test Mode

For testing without real payments:
1. Use Razorpay **test keys** (not live keys)
2. Test card: `4111111111111111`
3. Mock payment mode available (no Razorpay keys)

---

## 🔒 Security

- All sensitive data in environment variables
- CORS configured for security
- Rate limiting on all endpoints
- Input validation throughout
- Admin routes protected
- Payment verification required

---

**Happy booking! 🎬🎟️**

Last updated: June 2026

