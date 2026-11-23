# Business Logic

> Development of a Web-based Student Housing Vacancy Map using Next.js for Viscans

- Allowed Platforms: Web, Android

## Project Details

- Company/Startup/Team Name: TRAJECT
- Project Code Name: Kodiak
- Project Short Code: KD
- Short Description: A community-powered web map where VSU students discover and report recently observed boarding-house and student-housing vacancies.
- Long Description: Kodiak lets students discover vacancy sightings on a map and contribute reports based on what they recently observe, such as a "Bedspace Available" sign. Reports use approximate, fuzzed locations rather than exact coordinates and expire after 7 days unless another user reconfirms availability. The system supports vacancy discovery, community confirmation, and a simple moderation queue for problematic information; it does not provide landlord listings or rental transactions.

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

1. The app shall allow users to discover community-reported vacancies on a map and filter them by Bedspace, Solo Room, and Shared Room.
2. The app shall allow contributors to submit a vacancy sighting with an approximate location, housing type, gender restriction if stated, optional short description, and observation time.
3. The app shall show only approximate, fuzzed locations to other users and shall never show the exact coordinates of a vacancy report.
4. The app shall make a vacancy report inactive after 7 days unless another user reconfirms its availability.
5. The app shall allow users to confirm availability or flag that a vacancy is no longer available, without displaying reputation scores.
6. The app shall allow users to report spam, wrong location, misleading information, or no longer available vacancies into a simple moderation queue.

## Required Solution Layers

1. Security and privacy by design. The solution shall protect approximate locations, apply the 7-day retention limit for inactive vacancy reports, avoid per-user trails, apply aggregation thresholds where information is shared in aggregate, and obtain consent before any data resale. Enforcement shall use community-guideline hits rather than visible reputation scores, and any revenue direction shall treat data resale as the last option.

## MVP Features and Access

> See the User Levels table for reference.

| Feature               | Access      |
| --------------------- | ----------- |
| 1. Discover vacancies on a map with Bedspace, Solo Room, and Shared Room filters. | A,B,C,D,E |
| 2. Submit a vacancy sighting with the specified observation details. | A,B,C,D |
| 3. Protect reports through approximate, fuzzed locations. | A,B,C,D,E |
| 4. Expire reports after 7 days unless reconfirmed. | A,B,C,D,E |
| 5. Confirm availability or flag no longer available, without visible reputation scores. | A,B,C,D |
| 6. Report problematic information into the moderation queue. | A,B,C |

## Notes
- The MVP supports discovery and community-reported vacancy information only. It does not support landlord accounts, booking, rental applications, payments, deposits, contracts, direct messaging, property management, reservations, or rent collection.
- Users receive no credits, money, or convertible rewards for contributing.
- Kodiak should fit into a normal day as a quick way to consume or contribute vacancy information, while keeping the feature list concise for fast time-to-market.
