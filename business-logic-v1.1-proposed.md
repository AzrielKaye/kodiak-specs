# Business Logic v1.1 — Proposed

> Development of a Web-based Student Housing Vacancy Map using Next.js for Viscans

- Allowed Platforms: Web, Android

## Project Details

- Company/Startup/Team Name: TRAJECT
- Project Code Name: Kodiak
- Project Short Code: KD
- Short Description: A community-powered web map where Viscans discover and report recently observed boarding-house and student-housing vacancies.
- Long Description: Kodiak helps Viscans find recently observed housing vacancies without requiring landlords to create accounts or maintain listings. Students can view active vacancy sightings on an approximate-location map, contribute what they observe, reconfirm availability, or flag information that is no longer trustworthy. Reports expire after 14 days unless reconfirmed, so Kodiak is a lightweight discovery tool for current signals rather than a property marketplace or rental transaction service.

### Positioning

- **Primary users:** Viscans who need a quick way to discover nearby student-housing vacancy signals and students who pass a vacancy notice and can contribute it.
- **Core problem:** Housing information is distributed across signs and informal word of mouth, while vacancy status changes quickly.
- **Core promise:** Kodiak turns recent student observations into a simple, privacy-protective map of possible vacancies without pretending that a report is a landlord-verified listing.
- **Differentiation:** The product is community-powered, time-bounded, approximate by location, and focused only on discovery; it does not compete with landlords or property-management systems.
- **Normal-day use:** A student opens Kodiak to scan current options or contributes a sighting in a few steps after noticing a vacancy sign.

## User Levels

> Kodiak separates system administration and moderation responsibilities from student contribution and vacancy discovery.

| User Level              | Description |
| ----------------------- | ----------- |
| A. System Administrator | Maintains system configurations and regular backups for the Kodiak service. |
| B. Administrator        | Oversees system administration and supports the moderation process. |
| C. Moderator            | Reviews the moderation queue and handles reports against the community guidelines. |
| D. Contributor          | Reports vacancy sightings and contributes confirmations or availability flags. |
| E. Guest                | Discovers approximate vacancy locations and uses the available map filters. |

## System Requirements

1. The app shall show active community-reported vacancies on a web map and allow filtering by Bedspace, Solo Room, and Shared Room. Inactive or expired reports shall not appear as active vacancies.
2. The app shall allow contributors to submit a vacancy sighting with an approximate location, exactly one housing type, an optional gender restriction if stated, an optional short description, and the time it was observed.
3. The app shall display only an approximate, fuzzed location and shall never expose the exact coordinates of a vacancy report to other users through the map, page, or API response.
4. The app shall make a report inactive 14 days after its latest observation or reconfirmation unless another user reconfirms it before expiry; reconfirmation shall begin a new 14-day active window.
5. The app shall allow users to choose either "Confirm availability" or "No longer available" for a report, shall use those actions to update its current status or moderation signal, and shall not display reputation scores.
6. The app shall allow users to report spam, wrong location, misleading information, or no longer available information into a simple moderation queue that a moderator can review and resolve.

## Required Solution Layers

1. **Security and privacy by design.** The solution shall protect approximate locations, avoid exposing exact coordinates or per-user activity trails, apply the 14-day report-retention rule, use aggregation thresholds where information is shared in aggregate, and obtain consent before any data resale. Data resale remains the last revenue option.
2. **Trust without gamification.** Community-guideline hits, confirmation signals, expiry, and moderation shall protect information quality. The MVP shall not use visible reputation scores, credits, money, or convertible rewards.
3. **Fast, focused web experience.** The web MVP shall keep the map, six defined actions, clear active/expired states, and concise submission flow easy to use on ordinary student devices. Additional platform clients and convenience features are deferred.

## MVP Features and Access

> See the User Levels table for reference. The MVP remains limited to the six features below; positioning and trust rules are supporting behavior, not additional features.

| Feature               | Access      |
| --------------------- | ----------- |
| 1. Discover active vacancies on a map with Bedspace, Solo Room, and Shared Room filters. | A,B,C,D,E |
| 2. Submit a vacancy sighting with approximate location, housing type, optional stated gender restriction, optional short description, and observation time. | A,B,C,D |
| 3. Protect reports through approximate, fuzzed locations and never expose exact coordinates. | A,B,C,D,E |
| 4. Expire reports 14 days after the latest observation or reconfirmation unless reconfirmed again. | A,B,C,D,E |
| 5. Confirm availability or flag no longer available, without visible reputation scores. | A,B,C,D |
| 6. Report problematic information into the moderation queue. | A,B,C |

### MVP Completion Gaps

The following decisions must be fixed before implementation is considered complete; none adds a new user-facing feature:

1. **Geographic scope:** define the initial map area served for Viscans so a report is not presented outside the intended student-housing context.
2. **Location rule:** define the minimum fuzzing precision and enforce it in the API response, not only in the map interface.
3. **Expiry rule:** use the latest observation or reconfirmation time as the single source for the 14-day active window, and make active/inactive state visible.
4. **Moderation rule:** define the allowed report categories, the moderator resolution states, and when a "No longer available" signal changes status versus entering review.
5. **Submission validation:** define the short-description limit, accepted observation-time format, and required fields so incomplete sightings do not pollute the map.
6. **Privacy lifecycle:** define when expired report data is deleted or irreversibly aggregated, and ensure no per-user trail is retained for reputation or ranking.
7. **Access decision:** confirm whether contribution actions are available without an account; the MVP must not add landlord accounts, and any identity requirement must be justified by moderation and privacy needs.

## Notes

- The MVP supports discovery and community-reported vacancy information only. It does not support landlord accounts, booking, rental applications, payments, deposits, contracts, direct messaging, property management, reservations, or rent collection.
- Android is not part of this web MVP. A future client must consume the same approved contract rather than expand the current feature list.
- Users receive no credits, money, or convertible rewards for contributing.
- Kodiak should earn a place in a normal day as a quick way to consume or contribute vacancy information, while keeping the feature list concise for fast time-to-market.
- Revenue direction may vary, but data resale is the last option and requires consent and the privacy safeguards above.

### MVP Success Checks

- A student can find active sightings using the map and the three housing-type filters.
- A contributor can submit a complete sighting without exposing an exact location.
- A report becomes inactive at the defined 14-day boundary and can be renewed only by reconfirmation.
- Users can distinguish an availability confirmation, a no-longer-available signal, and a moderated report without seeing reputation scores.
- A moderator can review and resolve every supported problem category through the simple queue.
