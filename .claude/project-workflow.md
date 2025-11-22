# ThreeWeigh Project Workflow

## Git Workflow

### Branch Strategy
- **Always create a feature/fix/security branch** before making changes
- Never commit directly to `main`

### Branch Naming Convention
- **Features**: `feature/description` (e.g., `feature/weight-logging-heatmap`)
- **Bug fixes**: `fix/description` (e.g., `fix/authentication-redirect`)
- **Security fixes**: `security/description` (e.g., `security/rate-limiting`)
- **Refactoring**: `refactor/description`

### Merge Strategy
- Use `--no-ff` flag (always create merge commit for history)
- Merge locally first, then push
- Delete feature branch after successful merge (optional)

### Complete Workflow
1. **Create issue branch** from main
   ```bash
   git checkout main
   git pull
   git checkout -b security/rate-limiting
   ```

2. **Make changes** (code, test, iterate)

3. **Test manually** in browser
   - Start server: `bin/dev`
   - Test all affected functionality
   - Check for errors in console/logs

4. **Commit with descriptive message**
   ```bash
   git add .
   git commit -m "feat(security): implement rate limiting with Rails 8 native API"
   ```

5. **Merge to main locally**
   ```bash
   git checkout main
   git merge security/rate-limiting --no-ff
   ```

6. **Push to origin**
   ```bash
   git push origin main
   ```

---

## Development Process

### Testing Strategy
- **Manual testing preferred** for personal project
- Run `bin/rails test` before merging to ensure no regressions
- Controller tests commented out (pragmatic choice for solo developer)
- Focus on integration/system testing over unit tests

### Code Quality
- Use Rubocop for style checking (omakase preset)
- Run Brakeman for security scanning periodically
- Keep code simple and maintainable

---

## Code Style & Architecture

### Rails Conventions
- Follow Rails conventions and idioms
- Use generators when available
- Keep controllers thin, models fat

### Frontend Architecture
- **Prefer ViewComponent** for reusable UI components
- **Prefer server-side rendering** over client-side JavaScript when possible
- Use Stimulus for progressive enhancement (not for full SPA behavior)
- Use Hotwire/Turbo for dynamic updates

### Component Structure
- ViewComponents in `app/components/`
- Stimulus controllers in `app/javascript/controllers/`
- Keep components focused and single-purpose

---

## Commit Message Format

Use conventional commits format:

```
<type>(<scope>): <description>

[optional body]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation changes
- `test`: Test additions/changes
- `chore`: Maintenance tasks

### Examples
```
feat(security): implement rate limiting with Rails 8
fix(auth): resolve session timeout redirect loop
refactor(dashboard): extract weight chart to ViewComponent
docs(readme): add deployment instructions
```

---

## Security Practices

### Before Committing
- Never commit secrets (`.env`, `master.key`, API keys)
- Check `.gitignore` is up to date
- Run `bundle audit` periodically for gem vulnerabilities
- Review code for XSS, SQL injection, and other OWASP Top 10 issues

### Security Workflow
- Create security issues in GitHub for tracking
- Fix critical security issues on dedicated branches
- Test security fixes thoroughly before deploying
- Document security decisions in commit messages

---

## Deployment

### Pre-Deployment Checklist
- [ ] All tests pass (`bin/rails test`)
- [ ] Manual testing complete
- [ ] No secrets in commits
- [ ] Security scan clean (`bundle exec brakeman`)
- [ ] Database migrations tested
- [ ] Environment variables configured

### Deployment Process
- Use Kamal for Docker-based deployment
- Deploy to staging first (if available)
- Verify health checks pass
- Monitor logs after deployment

---

## Communication with AI Assistants (Claude Code)

### What to Expect
- Claude will **always create a feature branch** before making changes
- Claude will **use TodoWrite** to track multi-step tasks
- Claude will **ask questions** when requirements are unclear
- Claude will **provide context** for technical decisions

### How to Give Feedback
- Be specific about preferences (e.g., "use ViewComponent not Stimulus")
- Correct assumptions early (e.g., "no, merge to main first")
- Request explanations when needed (e.g., "why did you choose this approach?")

### Project-Specific Preferences
- **Personal project**: Pragmatic over perfect (e.g., commented controller tests)
- **Learning focus**: Explain technical decisions, provide learning resources
- **Rails 8 native features**: Prefer built-in Rails 8 features over gems when available
- **Simplicity**: Avoid over-engineering, keep solutions minimal

---

## Issue Tracking

### GitHub Issues
- Use labels: `security`, `critical`, `high-priority`, `medium-priority`, `enhancement`, `bug`
- Close issues when complete
- Reference issues in commit messages: `Closes #64`

### Issue Workflow
1. Create issue with detailed description
2. Create branch from issue
3. Implement solution
4. Test thoroughly
5. Commit and merge
6. Close issue with reference to commit

---

## Notes

This is a **personal project** focused on:
- Learning Rails 8 features
- Understanding production deployment
- Building security best practices knowledge
- Pragmatic development (not enterprise-level complexity)

**Flexibility over rigidity** - These are guidelines, not strict rules. Adapt as needed!
