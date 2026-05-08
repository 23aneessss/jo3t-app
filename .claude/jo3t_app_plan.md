# JO3T — App Plan
> Version 1.0 | Algeria's community-driven food & venue discovery app

---

## 1. Vision

JO3T (جعت) fills a gap no app currently owns in Algeria: a local, community-first platform where real people surface the best places to eat, drink coffee, and chill — not algorithms, not ads. The name is the concept. You're hungry, you open JO3T, you find your next spot.

---

## 2. Problem Statement

Algerians traveling between wilayas, or even within their own city, have no reliable, local, social way to discover quality restaurants and cafés. Google Maps exists but is generic and sparse. Word of mouth is the current standard. JO3T makes word of mouth scalable.

---

## 3. Target Users

| Segment | Profile |
|---|---|
| Urban youth (18–30) | Students and young professionals in Algiers, Oran, Constantine, Blida. Heavy smartphone users. Value aesthetics and authenticity. |
| Travelers & moussafrine | Algerians moving between wilayas for work or weekends. Need trusted local picks fast. |
| Food enthusiasts | People who genuinely track where they eat and love sharing it with their network. |
| Restaurant & café owners | Secondary users who can claim listings and post updates. |

---

## 4. Core Concept: Community Over Algorithm

The entire product is built on a trust layer. Recommendations are weighted by:
- People you follow (social trust)
- Verified locals of a wilaya (geographic trust)
- Review quality and depth (contribution trust)

No sponsored placements. No ads in the feed. The best place wins because people say so.

---

## 5. Feature Set

### Phase 1 — MVP (Months 1–3)

**Discovery Feed**
- Home feed showing trending spots based on user's current wilaya
- Filter by category: Restaurant, Café, Patisserie, Sandwich, Street Food, Juice Bar
- Filter by wilaya (48 wilayas supported from day one)
- Search with autocomplete (place name, cuisine, neighborhood)

**Place Profiles**
- Name, category, wilaya + neighborhood
- Cover photo + gallery (user-submitted)
- Address with Google Maps deep-link
- Average rating (1–10 scale, not 5 stars — more granular, like Beli)
- Community reviews with photos
- Opening hours
- Price range indicator (€ / €€ / €€€)

**Map View**
- Google Maps SDK embedded
- Clustered pins by category
- Tap a pin → bottom sheet with place preview
- "Near me" mode with location permission

**User Profiles**
- Display name + avatar
- Wilaya badge
- List of places reviewed
- "Want to try" list (personal, private or public)
- Followers / Following count

**Add a Place**
- Submit a new restaurant/café with name, category, wilaya, address, photo
- Moderation queue before it goes live (community flag system)

**Authentication**
- Google Sign-In
- Phone number (Algerian numbers: +213)
- Guest browse mode (no account needed to explore)

---

### Phase 2 — Growth (Months 4–6)

**Social Layer**
- Follow friends and food enthusiasts
- Activity feed: "Amine reviewed Chez Fatima · Blida · 8.5/10"
- Mutual recommendations: "3 people you follow liked this"

**Collections / Lists**
- Create curated lists: "Best coffee in Oran", "Hidden gems in Bab El Oued"
- Share lists as a link or in-app

**Wilaya Leaderboard**
- Top 10 places per wilaya, recalculated weekly
- Community-voted, not paid

**Notifications**
- New review on a place you saved
- Friend activity
- Weekly digest: "Top picks near you this week"

---

### Phase 3 — Maturity (Months 7–12)

**Venue Owner Dashboard**
- Claim your listing
- Add official photos, menu PDF, hours
- Respond to reviews
- No promoted placement — just verified badge

**Events**
- Restaurants can post one-off events (Ramadan special menu, live music night)
- Users can RSVP and share

**JO3T Score**
- Proprietary ranking score combining: recency of reviews, number of unique reviewers, social trust weight
- Replaces raw average as primary sorting signal

**Offline Mode**
- Cache your saved places and their addresses for offline map viewing

---

## 6. User Flows

### New User Onboarding
```
Splash → Language select (AR / FR) → Sign up (Google / Phone)
→ Select wilaya → Select 3+ food preferences → Follow suggestions
→ Home Feed
```

### Discovering a Place
```
Home Feed → Browse / Search → Place Profile
→ View photos, reviews, map → Save to list OR open in Google Maps
```

### Adding a Review
```
Search place → "Review this place" → Rate (1–10)
→ Write review (min 20 chars) → Add photo (optional) → Publish
```

### Adding a New Place
```
"+" button → Fill form (name, category, wilaya, address, photo)
→ Submit for review → Confirmation → Goes live after moderation
```

---

## 7. Content Moderation Strategy

- All new place submissions go through a 24-hour moderation queue
- Community flagging: 3 flags on a review triggers manual review
- Volunteer moderators per wilaya (power users invited)
- Zero-tolerance for fake reviews: account ban + review removal

---

## 8. Monetization (Future — not MVP)

JO3T is free, forever, for users. Future revenue:
- Verified badge for venue owners (subscription, ~500 DZD/month)
- JO3T Pro for users: advanced lists, analytics on your reviews
- B2B: anonymized, aggregated trend data sold to food industry players

No in-feed ads. Ever.

---

## 9. Success Metrics

| Metric | MVP Target (Month 3) |
|---|---|
| Registered users | 2,000 |
| Places listed | 500 |
| Reviews submitted | 1,500 |
| DAU/MAU ratio | > 25% |
| Wilayas covered | 10 major wilayas |
| Avg session duration | > 3 min |

---

## 10. Risks & Mitigations

| Risk | Mitigation |
|---|---|
| Cold start (no content at launch) | Pre-seed with 200+ places manually entered before launch |
| Fake / spam reviews | Moderation queue + phone verification |
| Low photo quality | Minimum resolution requirement, auto-reject blurry uploads |
| Google Maps API cost | Implement caching + session tokens, set hard spending caps |
| Algerian internet connectivity | Offline caching, image lazy loading, small bundle sizes |

---

## 11. Timeline

| Phase | Duration | Milestone |
|---|---|---|
| Pre-production | 2 weeks | Documents finalized, design system ready, repo set up |
| MVP Development | 10 weeks | All Phase 1 features built and tested |
| Beta (closed) | 3 weeks | 100 beta users in Algiers and Blida |
| Launch | Week 16 | Public release on Google Play (Android first) |
| Phase 2 | Months 4–6 | Social features, collections, leaderboard |
| iOS | Month 7 | App Store submission |

---

*Document owner: JO3T Core Team — updated as decisions are made.*
