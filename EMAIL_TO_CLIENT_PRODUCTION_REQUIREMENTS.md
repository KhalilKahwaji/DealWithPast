# Email to UNDP - Production Requirements for DealWithPast App

---

**Subject:** Action Required: DealWithPast Mobile App - Production Launch Requirements & Long-term Involvement

---

Dear UNDP Team,

I hope this email finds you well. We're making excellent progress on the **DealWithPast (خارطة وذاكرة)** mobile application. As we approach the production launch phase, I need to outline the required accounts, services, and ongoing involvement needed from your team to successfully deploy and maintain the app.

---

## **PART 1: Required Accounts & Services**

### **A. Mobile App Publishing Accounts**

#### **1. Apple Developer Account (iOS App Store)**
- **Cost:** $99 USD/year
- **Required for:** Publishing to iOS App Store
- **Who should own it:** UNDP organization account (recommended)
- **Setup time:** 1-2 weeks (Apple verification process)
- **Action needed:**
  - Create Apple Developer account at https://developer.apple.com/programs/
  - Add me (ziad@...) as Admin/Developer role
  - Provide: Organization D-U-N-S Number, Legal Entity Name, Tax ID

#### **2. Google Play Developer Account (Android)**
- **Cost:** $25 USD (one-time fee)
- **Required for:** Publishing to Google Play Store
- **Who should own it:** UNDP organization account
- **Setup time:** 2-3 days
- **Action needed:**
  - Create Google Play Console account at https://play.google.com/console/signup
  - Add me as Admin with release management permissions
  - Provide: Organization details, Payment method

---

### **B. Google Cloud Platform / Firebase**

#### **3. Google Cloud Platform Account (Organizational)**
**Currently using my personal account - THIS MUST CHANGE FOR PRODUCTION**

**Services we're using:**
- **Firebase Authentication** (Google Sign-In)
  - Current usage: ~100 users/month
  - Cost: FREE up to 50,000 users/month

- **Google Maps SDK for Android/iOS**
  - Current usage: ~1,000 map loads/month
  - Cost: FREE (covered by $200/month credit)

- **Potential future services:**
  - Geocoding API (address lookup): $5 per 1,000 requests
  - Places API (location search): $17 per 1,000 requests (basic)

**Estimated monthly cost:** $0-20 USD for current scale (under 500 users)
**Scaling:** $50-100 USD/month for 2,000+ active users

**Action needed:**
- Create Google Cloud account using UNDP organizational email
- Enable billing (credit card required, even for free tier)
- Set budget alerts at $20, $50, $100
- Transfer Firebase project ownership to UNDP account
- Grant me "Editor" role for technical management

**Why this matters:**
- My personal account cannot be used for production
- UNDP owns the data and infrastructure
- Billing tied to UNDP, not personal credit card
- Ensures continuity if team changes

---

### **C. WordPress/Server Access**

#### **4. WordPress Admin Credentials (dwp.world)**
**Current status:** Using admin credentials hardcoded in app (NOT SECURE)

**Action needed:**
- Create dedicated API user account for mobile app
- Username: `mobile_app_api`
- Assign role: Editor or custom role with specific permissions
- Generate Application Password for REST API authentication
- Remove hardcoded admin credentials from codebase

#### **5. Server Hosting Details**
**For production deployment and monitoring:**
- Hosting provider details (current: dwp.world)
- Server access (SSH/FTP) for WordPress plugin updates
- Database backup schedule confirmation
- SSL certificate renewal process
- Uptime monitoring setup

---

## **PART 2: Content Moderation & Ongoing Involvement**

### **A. Content Review Workflow**

**Stories Submission:**
Currently, user-submitted stories are published immediately. **For production, we recommend:**

**Option 1: Manual Review (Recommended for launch)**
- Stories submitted → saved as "Pending Review"
- UNDP team reviews daily via WordPress dashboard
- Approve/Reject with feedback
- Approved stories go live on map

**Option 2: Auto-publish with Post-moderation**
- Stories publish immediately
- Flagged content reviewed within 24 hours
- UNDP can hide/remove inappropriate content

**Who's responsible:**
- UNDP team member(s) assigned as Content Moderators
- Estimated time: 30-60 min/day for ~50 stories/week
- Training needed: WordPress admin panel, content policy

**Mission Creation:**
- Missions created by users → Pending approval
- UNDP reviews: Appropriate topic, valid time period, clear description
- Approve → Mission goes live on map
- Reject → User notified with reason

**Who's responsible:**
- UNDP team member(s) review missions 2-3x per week
- Estimated time: 1-2 hours/week

---

### **B. Content Moderation Policy (Need UNDP Input)**

**Please define guidelines for:**

1. **Acceptable Content:**
   - Historical accuracy requirements
   - Sensitive topics handling (war, trauma, politics)
   - Language/tone expectations
   - Photo/media guidelines (privacy, consent, appropriateness)

2. **Prohibited Content:**
   - Hate speech, discrimination
   - Personal attacks
   - False information
   - Privacy violations (names, addresses without consent)
   - Explicit content

3. **Flagging System:**
   - Should users be able to report inappropriate content?
   - How quickly should flagged content be reviewed?

**Action needed:**
- Schedule meeting to discuss content policy
- Provide written guidelines document
- Identify 2-3 team members responsible for moderation

---

### **C. Long-term Maintenance & Support**

**What UNDP team will handle:**

1. **Daily/Weekly:**
   - Content moderation (stories, missions)
   - User support emails/messages
   - Monitor app reviews (App Store, Play Store)

2. **Monthly:**
   - Review analytics (user growth, engagement)
   - Approve app updates (if any)
   - Check server/database health

3. **Quarterly:**
   - Feature requests review
   - Budget review (Google Cloud costs)
   - App performance optimization

**What requires developer involvement (me):**
- Bug fixes
- New features implementation
- App store updates (iOS/Android)
- API/backend updates
- Security patches

**Recommended Support Structure:**
- **Tier 1 Support:** UNDP team (content, user questions)
- **Tier 2 Support:** Developer (technical issues, bugs)
- **Maintenance contract:** [TO BE DISCUSSED - hours/month or retainer]

---

## **PART 3: Data Ownership & Privacy**

### **D. Legal & Compliance**

**Required before launch:**

1. **Privacy Policy**
   - Data collection disclosure (name, email, location, photos)
   - Data storage location (Lebanon/EU servers?)
   - Third-party services (Google, Firebase)
   - User rights (access, deletion, export)
   - Action: UNDP legal team to draft/approve

2. **Terms of Service**
   - User responsibilities
   - Content ownership/licensing
   - Age requirements (13+, 16+, 18+?)
   - Action: UNDP legal team to draft/approve

3. **Data Protection (GDPR/Regional compliance)**
   - EU users covered by GDPR?
   - Lebanese data protection laws?
   - User consent mechanisms
   - Action: Legal review needed

4. **Content Licensing**
   - Who owns submitted stories/photos?
   - Can UNDP use content for exhibitions/publications?
   - User attribution requirements
   - Action: Define in Terms of Service

---

## **PART 4: Launch Checklist**

### **Immediate Actions (This Week)**
- [ ] Create Apple Developer account
- [ ] Create Google Play Console account
- [ ] Create Google Cloud organizational account
- [ ] Assign content moderation team members

### **Short-term Actions (Next 2 Weeks)**
- [ ] Transfer Firebase project to UNDP account
- [ ] Set up dedicated WordPress API user
- [ ] Draft content moderation policy
- [ ] Legal team: Draft Privacy Policy & Terms of Service

### **Pre-Launch Actions (Before App Store Submission)**
- [ ] Content moderation workflow tested
- [ ] 10-20 test stories reviewed and approved
- [ ] Privacy Policy URL ready
- [ ] Support email address set up (e.g., support@dwp.world)
- [ ] App store listings prepared (screenshots, descriptions, keywords)

---

## **PART 5: Budget Summary**

### **One-time Costs:**
| Item | Cost |
|------|------|
| Apple Developer Account (yearly) | $99 USD |
| Google Play Developer Account | $25 USD |
| **Total** | **$124 USD** |

### **Monthly/Annual Recurring Costs:**
| Item | Cost (Low Usage) | Cost (High Usage) |
|------|------------------|-------------------|
| Apple Developer renewal | $99/year | $99/year |
| Google Cloud (Firebase, Maps) | $0-20/month | $50-100/month |
| WordPress Hosting (existing) | [Current cost?] | [Current cost?] |
| **Estimated Monthly** | **$0-20** | **$50-100** |

### **Maintenance & Support (To Be Discussed):**
- Bug fixes & updates: [Hourly rate or monthly retainer?]
- Feature development: [Project-based pricing?]

---

## **PART 6: Questions for UNDP Team**

**Please provide answers to:**

1. **Timeline:**
   - Target launch date?
   - Soft launch (limited users) or full public launch?

2. **User Management:**
   - Should all users go through approval before posting?
   - Open registration or invite-only initially?

3. **Geographic Scope:**
   - Lebanon only, or other countries in future?
   - Language: Arabic only, or English/French support needed?

4. **Content Moderation:**
   - Who will be the primary moderators (names, emails)?
   - Availability: Daily, 2-3x per week?
   - Training: In-person or remote session?

5. **Analytics & Reporting:**
   - What metrics are important to track?
   - Monthly reports needed?

6. **Marketing/Launch:**
   - PR/media announcements planned?
   - Social media strategy?
   - Need app promotional materials (graphics, videos)?

---

## **Next Steps**

**Proposed action plan:**

1. **This Week:** Schedule 1-hour video call to discuss this document
2. **Week 2-3:** UNDP team creates necessary accounts and provides access
3. **Week 4:** Transfer project ownership, finalize content policy
4. **Week 5-6:** Test moderation workflow with beta users
5. **Week 7:** Legal documents finalized (Privacy Policy, ToS)
6. **Week 8:** App Store submission

**I'm ready to schedule a meeting at your convenience to walk through these requirements and answer any questions.**

---

## **Contact Information**

**Developer:** Ziad Fakhri
**Email:** [your email]
**Phone:** [your phone]

**For urgent technical issues:** [emergency contact?]

---

**Looking forward to your response and collaboration on launching this important cultural preservation project.**

Best regards,
Ziad Fakhri
Lead Developer - DealWithPast Mobile App

---

## **Attachments (Optional to include):**
- [ ] Project timeline Gantt chart
- [ ] App mockups/screenshots
- [ ] Technical architecture diagram
- [ ] Content moderation workflow diagram

---

**P.S.** This email is long because I want to ensure we're aligned on all aspects before launch. The goal is a smooth, successful deployment with no surprises. Please don't hesitate to ask questions or request clarification on any point.
