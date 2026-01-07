# Testing Checklist for ThreeWeigh

## Pre-Deployment Manual Testing Checklist

### Environment: Development (localhost)

**Date Tested:** \***\*\_\*\***
**Tester:** \***\*\_\*\***
**Environment:** `bin/dev` (development mode)

---

## 🔐 Authentication & Authorization

- [ ] **Sign Up**

  - Visit `/users/sign_up`
  - Create new account with email/password
  - Redirects to dashboard after signup
  - No errors in logs

- [ ] **Sign In**

  - Visit `/users/sign_in`
  - Log in with valid credentials
  - Redirects to dashboard
  - Shows welcome message

- [ ] **Sign Out**

  - Click "Sign Out" link
  - Redirects to landing page
  - Can't access dashboard (redirects to login)

- [ ] **Password Reset** (if mailer configured)

  - Click "Forgot password?"
  - Enter email
  - Receives reset email
  - Can reset password

- [ ] **Rate Limiting** (security test)

  - Try logging in with wrong password 6 times
  - 6th attempt should be rate limited (429 error or lockout)
  - Wait 20 minutes OR restart server to reset

- [ ] **Account Lockout** (security test)

  - Try logging in with wrong password 5 times
  - Account should lock
  - Shows "Your account is locked" message
  - Can unlock after 1 hour OR via email

- [ ] **Session Timeout** (security test)
  - Log in
  - Wait 30 minutes (or change config to 1 minute for testing)
  - Try accessing dashboard
  - Should redirect to login

---

## ⚖️ Weight Tracking

- [ ] **View Dashboard**

  - Dashboard loads without errors
  - Shows weight stats (or "No entries yet")
  - Shows current streak (or 0)
  - Shows fasting stats

- [ ] **Add Weight Entry**

  - Fill in weight field on dashboard
  - Select today's date (pre-filled)
  - Add optional notes
  - Click "Log Weight"
  - Entry appears in stats
  - Streak increments if consecutive day
  - No errors in browser console

- [ ] **Edit Weight Entry**

  - Click "Edit" on weight entry
  - Change weight value
  - Click "Update"
  - Shows updated value
  - Returns to index page

- [ ] **Delete Weight Entry**

  - Click "Delete" on weight entry
  - Confirms deletion (browser confirm dialog)
  - Entry is removed
  - Streak updates accordingly

- [ ] **View Weight Analytics**

  - Visit `/weight_analytics`
  - Chart renders correctly
  - Shows trend line
  - No JavaScript errors in console (JS errors, Controllor bind error )
  - No CSP violations in console (important!)(JS ERRORS CSP violation,can not read JS code)

- [ ] **Weight Logging Heatmap**
  - Heatmap displays on dashboard
  - Shows green squares for logged days
  - Shows gray squares for missed days
  - Hover tooltip shows date and status(does not work, no state) ? what is tooltip here?
  - Empty state if no entries(does not work, no state)

---

## ⏱️ Fasting Tracking

- [ ] **Start Fast**

  - Click "Start Fast" button
  - Select fasting mode (16:8, 18:6, etc.)
  - Fast timer starts
  - Shows countdown/progress

- [ ] **View Active Fast**

  - Dashboard shows current fast
  - Timer updates (refresh to check)
  - Progress bar shows correctly

- [ ] **Complete Fast**

  - Click "Complete Fast"
  - Fast status changes to "completed"
  - Stats update
  - No errors

- [ ] **Break Fast Early**

  - Start a new fast(click start, if succeed,no eye-catching animation/tooltip)
  - Click "Break Fast"
  - Confirms action
  - Fast status changes to "broken"

- [ ] **View Fasting History**
  - Visit `/fasting_entries`
  - Shows list of all fasts
  - Shows completed, broken, and active fasts
  - Can delete entries

---

## 👤 User Profile

- [ ] **View Profile**

  - Visit `/profile`
  - Shows current user data
  - Displays metric/imperial setting

- [ ] **Edit Profile**
  - Click "Edit Profile"
  - Change unit system (metric ↔ imperial) ?(can not change metrics into imperial?)
  - Change height, age, goal weight
  - Click "Update"
  - Changes saved
  - Returns to profile page

---

## 🔒 Security Features (Production Testing)

These should be tested in production after deployment:

- [ ] **HTTPS Enforced**

  - Try visiting `http://yourapp.com`
  - Should redirect to `https://yourapp.com`

- [ ] **Host Authorization**

  - Try accessing with invalid Host header (advanced)
  - Should block or redirect

- [ ] **Content Security Policy**
  - Check browser console for CSP violations
  - All resources should load correctly
  - No "blocked by CSP" errors

---

## 📱 Mobile Testing (Optional but Recommended)

- [ ] **Dashboard on Mobile**

  - Responsive layout
  - Touch targets large enough
  - No horizontal scroll
  - Charts visible and interactive

- [ ] **Weight Entry on Mobile**

  - Keyboard shows number pad for weight input
  - Date picker works
  - Submit button reachable

- [ ] **Navigation on Mobile**
  - Sidebar/menu accessible
  - Links work
  - No overlapping elements

---

## 🐛 Browser Testing (Multi-Browser Check)

Test in at least 2 browsers:

- [ ] **Chrome/Edge** (Chromium)

  - All features work
  - No console errors

- [ ] **Safari** (if on Mac)

  - All features work
  - Charts render correctly

- [ ] **Firefox** (optional)
  - All features work
  - CSP enforced correctly

---

## ⚡ Performance Check

- [ ] **Page Load Speed**

  - Dashboard loads in < 2 seconds
  - No slow queries in logs
  - Images/charts load quickly

- [ ] **Database Performance**
  - Check `log/development.log` for slow queries
  - No N+1 query warnings
  - Indexes on foreign keys exist

---

## 📊 Data Integrity

- [ ] **Streak Calculation**

  - Log weight for 3 consecutive days
  - Streak should show "3"
  - Skip a day
  - Streak should reset to 0
  - Log weight today
  - Streak should show "1"

- [ ] **Heatmap Accuracy**

  - Heatmap shows correct logged days
  - Matches weight entries in database
  - No missing or extra days

- [ ] **Analytics Charts**
  - Chart shows correct data points
  - Trend line calculates properly
  - Date labels are accurate

---

## 🚨 Error Handling

- [ ] **Invalid Data Entry**

  - Try creating weight entry with negative weight
  - Should show validation error
  - Try creating weight entry without weight
  - Should show "can't be blank"

- [ ] **Duplicate Entry Prevention**

  - Try creating 2 weight entries for same date
  - Should show "already exists" error

- [ ] **404 Pages**
  - Visit `/invalid-page`
  - Shows 404 error page (or redirects)

---

## 🔄 Edge Cases

- [ ] **No Data State**

  - Create fresh user account
  - Dashboard shows "No entries yet"
  - Analytics shows "Need more data"
  - Heatmap shows empty state

- [ ] **Large Data Set**
  - Run `rails db:seed` (if seeds exist)
  - Dashboard handles 90+ days of data
  - Charts render without lag
  - Pagination works (if implemented)

---

## ✅ Pre-Production Deployment Checklist

Before pushing to production:

- [ ] All critical path tests pass (auth, weight, fasting)
- [ ] No errors in development logs
- [ ] Browser console clean (no errors)
- [ ] Mobile layout works
- [ ] Database migrations run successfully
- [ ] Seed data works (optional)
- [ ] `DEPLOYMENT_SECURITY.md` checklist reviewed

---

## 🚀 Post-Production Deployment Checklist

After deploying to production:

- [ ] App accessible via HTTPS
- [ ] Can sign up new account
- [ ] Can log in
- [ ] Can add weight entry
- [ ] Dashboard loads
- [ ] Charts render
- [ ] No errors in production logs
- [ ] Rate limiting works (test with wrong password)
- [ ] Session timeout works (wait 30 min)

---

## 📝 Notes

**Testing Philosophy for Personal Projects:**

- Manual testing > Automated tests (for solo developer)
- Test critical paths thoroughly
- Edge cases: test if you have time
- Use the app yourself daily = best testing!

**When to Write Automated Tests:**

- Before adding team members
- Before opening to public users
- For critical business logic
- When bugs keep recurring

**Tools:**

- Browser DevTools (F12) - Check console for errors
- Rails logs - `tail -f log/development.log`
- Database console - `rails console` for data verification

---

**Last Updated:** December 2024
**Status:** Ready for manual testing ✅
