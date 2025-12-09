# Deployment Security Guide

This document outlines security best practices for deploying ThreeWeigh to production.

## 🔐 Rails Master Key Security

### What is the Master Key?

The `config/master.key` file decrypts `config/credentials.yml.enc`, which contains all your application secrets (database passwords, API keys, SMTP credentials, etc.).

### ⚠️ CRITICAL: Never Deploy master.key File

**DO NOT** include `config/master.key` in your production deployment!

### ✅ Proper Production Setup

#### 1. Get Your Master Key Value

```bash
# On your development machine
cat config/master.key
# Copy the output (long hex string)
```

#### 2. Set as Environment Variable in Production

**On your production server / hosting platform:**

```bash
# Set environment variable (not a file!)
export RAILS_MASTER_KEY="your_master_key_value_here"
```

**Platform-Specific Instructions:**

**Railway:**
```bash
# In Railway dashboard, go to Variables tab
RAILS_MASTER_KEY=your_master_key_value_here
```

**Heroku:**
```bash
heroku config:set RAILS_MASTER_KEY=your_master_key_value_here
```

**Fly.io:**
```bash
fly secrets set RAILS_MASTER_KEY=your_master_key_value_here
```

**Kamal (Docker):**
```yaml
# config/deploy.yml
env:
  secret:
    - RAILS_MASTER_KEY
```

#### 3. Verify in Production

```bash
# SSH into production server
RAILS_ENV=production rails credentials:show
# Should display decrypted credentials without error
```

### 🔒 Security Checklist

- [ ] `config/master.key` is in `.gitignore` (already done ✅)
- [ ] `RAILS_MASTER_KEY` set as environment variable in production
- [ ] `config/master.key` does NOT exist on production filesystem
- [ ] Master key backed up securely (password manager, encrypted vault)
- [ ] Master key never committed to git (check with `git log --all -p | grep master.key`)

### 🚨 What if Master Key is Compromised?

If your master key is exposed (committed to git, leaked, etc.):

1. **Generate new credentials:**
   ```bash
   rm config/credentials.yml.enc
   EDITOR=nano rails credentials:edit
   # This creates a new master.key and credentials.yml.enc
   ```

2. **Re-enter all secrets** in the new credentials file

3. **Update production environment variable** with new master key

4. **Rotate all secrets** (database passwords, API keys, etc.)

### 📚 Additional Resources

- [Rails Credentials Guide](https://guides.rubyonrails.org/security.html#custom-credentials)
- [Rails Security Best Practices](https://guides.rubyonrails.org/security.html)

---

## 🔒 Other Security Best Practices

### HTTPS/SSL
- Already configured: `config.force_ssl = true` in `config/environments/production.rb`
- Ensure your hosting platform provides SSL certificates (most do automatically)

### Database Security
- Use strong database passwords
- Store in `config/credentials.yml.enc`, not environment variables
- Restrict database access to application server only

### Session Security
- Session timeout enabled: 30 minutes (✅ Implemented in #70)
- Secure cookies enforced via `force_ssl`
- Session secret rotated via credentials

### Authentication Security
- Rate limiting enabled: 5 login attempts per 20 minutes (✅ Implemented in #64)
- Account lockout enabled: 5 failed attempts (✅ Implemented in #69)
- Strong password requirements via Devise defaults

### XSS Protection
- XSS vulnerability fixed in analytics view (✅ Implemented in #66)
- Content Security Policy enabled (✅ Implemented in #65)
- Rails default escaping for all views

### Host Authorization
- Enabled in production (✅ Implemented in #67)
- Prevents DNS rebinding attacks
- Configure with your actual domain

---

## 📋 Pre-Deployment Checklist

Before deploying to production, verify:

- [ ] All security issues resolved (#64-70, except #71 mailer)
- [ ] `RAILS_MASTER_KEY` environment variable set
- [ ] Database credentials in `credentials.yml.enc`
- [ ] Host authorization configured with actual domain
- [ ] `config.force_ssl = true` in production.rb
- [ ] `.env` file NOT committed to git
- [ ] `master.key` NOT committed to git
- [ ] Run `bundle exec brakeman` for security scan
- [ ] Test application in staging environment first

---

**Last Updated:** December 2024
**Status:** Production Security Hardening Complete ✅
