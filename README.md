# Magenta: Mental Health Mentor

**Status**: Currently in Progress (WIP)

Welcome to **Magenta**, a comprehensive mental health app designed to act as a mentor to support your mental well-being. Magenta offers a range of tools and resources to help individuals manage stress, grief, anxiety, and other mental health challenges. The inspiration for the app name stems from Blanche Devereaux's term, "Feeling Magenta."

---

## Technical Specifications

### Front-End Technical Details:
The following table summarizes the front-end technologies and configurations for Magenta:

| **Category**            | **Details**                                      |
|--------------------------|--------------------------------------------------|
| **Language**            | Swift                                           |
| **Architecture Pattern**| MVVM                                            |
| **Frameworks**          | SwiftUI, UIKit, CoreData, Combine, Security, Foundation, HealthKit, XCTest, Swift Testing, GraphQL, Journaling Suggestions, MusicKit, Swift Charts |
| **Supported OS**        | iOS, watchOS |
| **Minimum OS Versions** | iOS 18.0, iPadOS 18.0, watchOS (TBA) |
| **Authentication**      | Apple Sign-In, Google Sign-In, Face ID, Username/Email |
| **TODO**                | Add Push Notifications and Activities for some features |

### Back-End Technical Details:
The back-end is built using **Go**. Further details (e.g., APIs, databases) will be added as development progresses.

| **Category**      | **Details**      |
|-------------------|------------------|
| **Language**      | Go               |
| **TODO**          | Define APIs, database structure, server setup |

---

## Features

The following table provides an overview of Magenta's features, with planned key functionalities to be detailed during development.

| **Feature**              | **Description**                                                                 | **Key Features (TBA)**         |
|---------------------------|---------------------------------------------------------------------------------|--------------------------------|
| **Art Therapy**           | Interactive tools for creative expression to support mental health.             | To Be Added                    |
| **Journal**               | Private journaling with suggestions from Apple's Journaling Suggestions framework. | To Be Added                    |
| **Exercise**              | Tools to track and encourage physical activity for mental well-being.           | To Be Added                    |
| **Sleep**                 | Features to monitor and improve sleep patterns.                                | To Be Added                    |
| **Mood Tracking**         | Track daily moods and identify patterns over time.                             | To Be Added                    |
| **Nutrition**             | Guidance on nutrition to support mental health.                                | To Be Added                    |
| **Books that Help Me**    | Curated digital bookshelf for mental health and personal growth.               | Track books, Organize by status (Want to Read, Currently Reading, Finished Reading) |
| **Mental Health Playlists**| Curate playlists using Apple's MusicKit framework.                            | To Be Added                    |
| **Helpful Quotes**        | Inspirational quotes to uplift and motivate users.                            | To Be Added                    |
| **Therapist Search**      | Locate nearby mental health professionals via [FindTreatment API](https://findtreatment.gov/assets/FindTreatment-Developer-Guide.pdf). | To Be Added                    |
| **Meditations**           | Library of guided meditations for relaxation and stress reduction.             | To Be Added                    |
| **Cycle Tracking**        | Period cycle tracking for females using HealthKit, linked to mental health.    | To Be Added                    |

*Note*: "Key Features" will be populated with specific functionalities as development progresses (e.g., for Mood Tracking: "Daily mood logging, weekly summary chart").

---

## Project Roadmap

Below is the development plan and subsequent phases for Magenta, leading to the app's release on July 28th, 2025.

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
