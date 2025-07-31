# GitHub Repository Setup Guide

**Project:** Taartu Mobile App  
**Repository:** taartu/taartu_mobile  
**Status:** Ready for GitHub Setup

## 🚀 **Step-by-Step GitHub Setup**

### **1. Create GitHub Repository**

#### **Option A: Via GitHub Web Interface**
1. Go to [GitHub.com](https://github.com)
2. Click the "+" icon in the top right
3. Select "New repository"
4. Fill in the details:
   - **Repository name:** `taartu_mobile`
   - **Description:** `Taartu - Salon Booking Marketplace App (Flutter)`
   - **Visibility:** Public (or Private based on preference)
   - **Initialize with:** Don't initialize (we have existing code)
5. Click "Create repository"

#### **Option B: Via GitHub CLI**
```bash
# Install GitHub CLI if not installed
brew install gh

# Login to GitHub
gh auth login

# Create repository
gh repo create taartu/taartu_mobile --public --description "Taartu - Salon Booking Marketplace App (Flutter)" --source=. --remote=origin --push
```

### **2. Connect Local Repository to GitHub**

Once the repository is created, run these commands:

```bash
# Add the remote origin
git remote add origin https://github.com/taartu/taartu_mobile.git

# Set the main branch as default
git branch -M main

# Push all code to GitHub
git push -u origin main
```

### **3. Repository Configuration**

#### **Repository Settings**
1. Go to repository Settings
2. **General:**
   - Enable Issues
   - Enable Wiki
   - Enable Discussions
3. **Pages:** Configure for web deployment
4. **Security:** Enable security features

#### **Branch Protection Rules**
1. Go to Settings → Branches
2. Add rule for `main` branch:
   - Require pull request reviews
   - Require status checks to pass
   - Require branches to be up to date
   - Include administrators

### **4. GitHub Actions Setup**

The CI/CD pipeline is already configured in `.github/workflows/ci.yml`. It will:
- Run tests on every push
- Build for all platforms
- Deploy to staging on main branch
- Run security scans

### **5. Repository Structure**

```
taartu_mobile/
├── .github/workflows/ci.yml          # CI/CD Pipeline
├── lib/                              # Flutter source code
├── test/                             # Unit tests
├── integration_test/                 # Integration tests
├── docs/                             # Documentation
├── scripts/                          # Build scripts
├── README.md                         # Project overview
├── DEPLOYMENT_GUIDE.md              # Deployment instructions
├── INTEGRATION_SUMMARY.md           # Integration summary
└── pubspec.yaml                     # Flutter dependencies
```

### **6. GitHub Repository Features**

#### **Issues Template**
Create `.github/ISSUE_TEMPLATE/bug_report.md`:
```markdown
---
name: Bug report
about: Create a report to help us improve
title: ''
labels: bug
assignees: ''

---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment:**
 - OS: [e.g. iOS, Android, Web]
 - Version: [e.g. 1.0.0]
 - Device: [e.g. iPhone 15, Samsung Galaxy]

**Additional context**
Add any other context about the problem here.
```

#### **Pull Request Template**
Create `.github/pull_request_template.md`:
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes
```

### **7. GitHub Pages Setup**

For web deployment documentation:
1. Go to Settings → Pages
2. Source: Deploy from a branch
3. Branch: main
4. Folder: /docs
5. Save

### **8. Security Setup**

#### **Dependabot Alerts**
1. Go to Security → Dependabot alerts
2. Enable for all ecosystems
3. Configure auto-merge for minor updates

#### **Code Scanning**
1. Go to Security → Code scanning
2. Enable CodeQL analysis
3. Configure for Dart/Flutter

### **9. Collaboration Settings**

#### **Team Access**
1. Go to Settings → Collaborators
2. Add team members with appropriate permissions
3. Set up code review requirements

#### **Project Board**
1. Create a new project board
2. Add columns: Backlog, In Progress, Review, Done
3. Link to issues and pull requests

### **10. Release Management**

#### **Create First Release**
```bash
# Tag the current version
git tag v1.0.0

# Push tags
git push origin v1.0.0
```

#### **Release Notes Template**
- Features added
- Bugs fixed
- Breaking changes
- Migration guide

## 🎯 **Next Steps After GitHub Setup**

1. **Configure CI/CD Secrets**
   - Add API keys
   - Configure deployment credentials
   - Set up environment variables

2. **Set Up Monitoring**
   - Connect Sentry for error tracking
   - Configure analytics
   - Set up performance monitoring

3. **Documentation**
   - Update README with setup instructions
   - Add contribution guidelines
   - Create development workflow docs

4. **Deployment**
   - Configure production environment
   - Set up staging environment
   - Configure automated deployments

## 📋 **Repository Checklist**

- [ ] Repository created on GitHub
- [ ] Local repository connected to remote
- [ ] All code pushed to main branch
- [ ] Branch protection rules configured
- [ ] GitHub Actions enabled
- [ ] Issue templates created
- [ ] Pull request template created
- [ ] Security features enabled
- [ ] Team access configured
- [ ] First release tagged

---

**🚀 Ready to set up GitHub repository!**

Follow the steps above to create and configure your GitHub repository for the Taartu mobile app. 