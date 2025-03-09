# Magenta: Mental Health Mentor

Currently WIP

Welcome to **Magenta**, a comprehensive mental health app designed to act as a mentor to support your mental well-being. Magenta offers a range of tools and resources to help people deal with stress, grief, anxiety, and other mental health challenges.
The inspiration for the app name came from Blance Devereaux's term, "Feeling Magenta".

## Front-End Technical Details:
- Language: Swift
- Architecture pattern: MVVM
- Frameworks used: SwiftUI, UIKit, CoreData, Combine, Security, Foundation, Health Kit, XCTest, Swift Testing, GraphQL, Journaling Suggestions, MusicKit, Swift Charts
- OS's supported: iOS, iPadOS, watchOS, visionOS, macOS
- Minimum OS's supported: iOS 18.0, iPadOS 18.0, watchOS tba
- Authentication - Supports Apple Sign-In, Google Sign-In, Face ID and traditional username/email sign in.
- TODO: Add Push Notifications and Activities for some of the features

## Back-End Technical Details:
- Go

## Features

<details>
<summary><strong>Art Therapy</strong></summary>

### Key Features
- To Be Added
</details>

<details>
<summary><strong>Journal</strong></summary>

Maintain a private journal to express your thoughts and feelings using suggestions provided by Apple's Journaling Suggestions framework.

### Key Features
- To Be Added
</details>

<details>
<summary><strong>Exercise</strong></summary>

### Key Features
- To Be Added
</details>

<details>
<summary><strong>Sleep</strong></summary>

### Key Features
- To Be Added
</details>

<details>
<summary><strong>Mood Tracking</strong></summary>

Track your daily mood and identify patterns over time.

### Key Features
- To Be Added

</details>

<details>
<summary><strong>Nutrition</strong></summary>

### Key Features
- To Be Added
</details>

<details>
<summary><strong>Books that Help Me</strong></summary>

A curated digital bookshelf designed to support mental health and personal growth.

### Key Features
- Track books related to mental health, personal development, and self-improvement
- Organize books into three reading statuses:
  - Want to Read
  - Currently Reading
  - Finished Reading

</details>

<details>
<summary><strong>Mental Health Playlists</strong></summary>

Curate Music playlists using Apple's MusicKit framework.

### Key Features
- To Be Added
</details>

<details>
<summary><strong>Helpful Quotes</strong></summary>

### Key Features
- To Be Added
</details>

<details>
<summary><strong>Therapist Search</strong></summary>

Find nearby mental health professionals using this API: https://findtreatment.gov/assets/FindTreatment-Developer-Guide.pdf

### Key Features
- To Be Added
</details>

<details>
<summary><strong>Meditations</strong></summary>

Access a library of guided meditations to help you relax and reduce stress.

### Key Features
- To Be Added
</details>

<details>
<summary><strong>Cycle Tracking</strong></summary>

For females to track their period cycle using HealthKit because fluctuating hormones can have a huge effect on mental health.

### Key Features
- To Be Added
</details>

## Project Roadmap

Below is the development plan and subsequent phases for Magenta, leading up to the app's release on July 28th, 2025.

### Development Phase
- **Tasks**:
  - **March 10th**: Mood Tracker
  - **March 17th**: Helpful Quotes
  - **March 24th**: Sleep
  - **March 31st**: Exercise
  - **April 7th**: Nutrition
  - **April 14th**: Mental Health Playlists
  - **April 21st**: Cycle Tracking
  - **April 28th**: Art Therapy
  - **May 5th**: Books that Help Me
  - **May 12th**: Journal
  - **May 19th**: Meditations
  - **May 26th**: Therapist Search
  - **June 2nd**: Apple Watch Integration
  - **June 9th**: Account Setup
  - **June 16th**: Authentication
  - **June 23rd**: Backend Integration
- **Deliverable**: Individual feature modules completed and unit tested.

### Integration Phase
- **Start Date**: June 30th, 2025  
- **End Date**: July 7th, 2025  
- **Duration**: 1 week  
- **Tasks**:
  - Combine all features into a cohesive app.  
  - Test initial integration and resolve conflicts.  
- **Deliverable**: Fully integrated app prototype.

### Testing Phase
- **Start Date**: July 7th, 2025  
- **End Date**: July 21st, 2025  
- **Duration**: ~2 weeks  
- **Tasks**:
  - User testing, performance testing, UI/UX validation, bug tracking, network testing, accessibility testing, and resolution.  
- **Deliverable**: Stable app with minimal bugs.

### Release Preparation and Deployment Phase
- **Start Date**: July 21st, 2025  
- **End Date**: July 28th, 2025  
- **Duration**: ~1 week
- **Tasks**:
  - Prepare App Store assets (screenshots, description, icons) and submit for review.  
  - Final testing and approval checks.  
  - July 28th, 2025: Release app to App Store.  
- **Deliverable**: App live on App Store.

### Gantt Chart
The following table represents the timeline for all features and phases. Each "X" indicates a task being active during that week.

| Task                          | Mar 10 | Mar 17 | Mar 24 | Mar 31 | Apr 7 | Apr 14 | Apr 21 | Apr 28 | May 5 | May 12 | May 19 | May 26 | Jun 2 | Jun 9 | Jun 16 | Jun 23 | Jun 30 | Jul 7 | Jul 14 | Jul 21 | Jul 28 |
|-------------------------------|--------|--------|--------|--------|-------|--------|--------|--------|-------|--------|--------|--------|-------|-------|--------|--------|--------|-------|--------|--------|--------|
| Mood Tracker                 |   X    |        |        |        |       |        |        |        |       |        |        |        |       |       |        |        |        |       |        |        |        |
| Helpful Quotes               |        |   X    |        |        |       |        |        |        |       |        |        |        |       |       |        |        |        |       |        |        |        |
| Sleep                        |        |        |   X    |        |       |        |        |        |       |        |        |        |       |       |        |        |        |       |        |        |        |
| Exercise                     |        |        |        |   X    |       |        |        |        |       |        |        |        |       |       |        |        |        |       |        |        |        |
| Nutrition                    |        |        |        |        |   X   |        |        |        |       |        |        |        |       |       |        |        |        |       |        |        |        |
| Mental Health Playlists      |        |        |        |        |       |   X    |        |        |       |        |        |        |       |       |        |        |        |       |        |        |        |
| Cycle Tracking               |        |        |        |        |       |        |   X    |        |       |        |        |        |       |       |        |        |        |       |        |        |        |
| Art Therapy                  |        |        |        |        |       |        |        |   X    |       |        |        |        |       |       |        |        |        |       |        |        |        |
| Books that Help Me           |        |        |        |        |       |        |        |        |   X   |        |        |        |       |       |        |        |        |       |        |        |        |
| Journal                      |        |        |        |        |       |        |        |        |       |   X    |        |        |       |       |        |        |        |       |        |        |        |
| Meditations                  |        |        |        |        |       |        |        |        |       |        |   X    |        |       |       |        |        |        |       |        |        |        |
| Therapist Search             |        |        |        |        |       |        |        |        |       |        |        |   X    |       |       |        |        |        |       |        |        |        |
| Apple Watch Integration      |        |        |        |        |       |        |        |        |       |        |        |        |   X   |       |        |        |        |       |        |        |        |
| Account Setup                |        |        |        |        |       |        |        |        |       |        |        |        |       |   X   |        |        |        |       |        |        |        |
| Authentication               |        |        |        |        |       |        |        |        |       |        |        |        |       |       |   X    |        |        |       |        |        |        |
| Backend Integration          |        |        |        |        |       |        |        |        |       |        |        |        |       |       |        |   X    |        |       |        |        |        |
| Integration Phase            |        |        |        |        |       |        |        |        |       |        |        |        |       |       |        |        |   X    |       |        |        |        |
| Testing Phase                |        |        |        |        |       |        |        |        |       |        |        |        |       |       |        |        |        |   X   |   X    |        |        |
| Release Preparation          |        |        |        |        |       |        |        |        |       |        |        |        |       |       |        |        |        |       |        |   X    |        |
| App Store Release            |        |        |        |        |       |        |        |        |       |        |        |        |       |       |        |        |        |       |        |        |   X    |

## License
Proprietary Software

© 2025 SarahUniverse

This software and its source code are the exclusive property of SarahUniverse.
No part of this software may be reproduced, distributed, or transmitted in any form or by any means without prior written permission.
