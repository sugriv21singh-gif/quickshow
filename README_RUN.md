One-click run instructions

- Double-click `run-dev.bat` (Windows) to install dependencies and start both server and client.
- Or right-click `run-dev.ps1` and choose "Run with PowerShell" (may require allowing script execution).

Manual (terminal) options:

```powershell
# Install root deps for server and client
npm run install-all
# Start both dev servers
npm run dev
```

Notes:
- `npm run dev` uses `npx concurrently` to run `server` and `client` scripts in parallel.
- On first run, installing server and client dependencies may take a few minutes.
- If PowerShell blocks script execution, run PowerShell as Administrator and allow the script:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

Environment setup:
- Add `RAZORPAY_KEY_ID` and `RAZORPAY_KEY_SECRET` to `server/.env` before running.

One-click shortcuts:

- Double-click `run-and-open.bat` to start the dev servers in a new window and open the app in your browser.
- Double-click `open-app.bat` to open the frontend at `http://localhost:5173/` (useful if servers are already running).
