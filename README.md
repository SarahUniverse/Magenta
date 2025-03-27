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
| **Minimum OS Versions** | iOS 18.0, watchOS (TBA) |
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

# Magenta App Features

The following table provides an overview of Magenta's features, with key functionalities detailed for development.

| **Feature**              | **Description**                                                                 | **Key Features**                                                                 |
|--------------------------|---------------------------------------------------------------------------------|----------------------------------------------------------------------------------|
| **Art Therapy**          | Interactive tools for creative expression to support mental health.             | Guided art prompts, track emotional impact of art sessions. Plus more TBD |
| **Journal**              | Private journaling with suggestions from Apple's Journaling Suggestions framework. | Daily journal entries with prompts, integration with Apple’s Journaling Suggestions, mood tagging, search and filter entries, export entries as PDF. |
| **Exercise**             | Tools to track and encourage physical activity for mental well-being.           | Activity tracking via HealthKit, set exercise goals, guided workout routines, reminders for movement breaks, log mental health benefits of exercise. |
| **Sleep**                | Features to monitor and improve sleep patterns.                                | Sleep tracking via HealthKit, bedtime reminders, sleep quality analysis, guided wind-down routines, sleep goal setting and progress tracking. |
| **Mood Tracking**        | Track daily moods and identify patterns over time. **(Completed March 9, 2025)** | Daily mood logging with emoji selection, 7-day bar chart summary, today’s mood circle indicator with month/date navigation. |
| **Nutrition**            | Guidance on nutrition to support mental health.                                | Log meals and water intake, nutritional tips for mental well-being, mood-food correlation tracking, personalized meal suggestions, integration with HealthKit. |
| **Books that Help Me**   | Curated digital bookshelf for mental health and personal growth.               | Track books, organize by status (Want to Read, Currently Reading, Finished Reading), add notes and reflections, search for recommended books. |
| **Mental Health Playlists** | Curate playlists using Apple's MusicKit framework.                            | Create, edit, and delete playlists; search and add songs to playlists; view playlist details with songs, description, and curator info; sort playlists by creation date; swipe-to-delete playlists. |
| **Helpful Quotes**       | Inspirational quotes to uplift and motivate users.                            | Showcase a curated collection of inspirational quotes, featuring favorites and diverse subjects for mental well-being. Allow users to add new quotes, manage them, and view a visually engaging summary highlighting the most recent favorite quote with animations and customization. |
| **Therapist Search**     | Locate nearby mental health professionals via [FindTreatment API](https://findtreatment.gov/assets/FindTreatment-Developer-Guide.pdf). | Search for therapists by location, filter by specialty and insurance, view therapist profiles, save favorite providers, direct contact options. |
| **Meditations**          | Library of guided meditations for relaxation and stress reduction.             | Access a library of guided meditations, filter by duration and theme (e.g., stress, sleep), track meditation history, set meditation reminders, save favorite sessions. |
| **Cycle Tracking**       | Period cycle tracking for females using HealthKit, linked to mental health.    | Track menstrual cycles via HealthKit, log symptoms and moods, analyze cycle impact on mental health, receive cycle-related wellness tips. |

*Note*: "Key Features" will be populated with specific functionalities as development progresses.

---

## Project Roadmap

Below is the development plan and subsequent phases for Magenta, leading to the app's release on July 28th, 2025.

### Development Phase
- **Tasks(dates to be completed by)**:
  - Mood Tracker :white_check_mark: 
  - Helpful Quotes :white_check_mark:
  - Sleep :white_check_mark:
  - Exercise
  - Nutrition
  - Mental Health Playlists :white_check_mark:
  - Cycle Tracking
  - Art Therapy :white_check_mark:
  - Books that Help Me :white_check_mark:
  - Journal :white_check_mark:
  - Meditations :white_check_mark:
  - Therapist Search
  - Apple Watch Integration
  - Account Setup
  - Authentication
  - Backend Integration
  - Notifications and Activities
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

## License
Proprietary Software

© 2025 SarahUniverse

This software and its source code are the exclusive property of SarahUniverse.
No part of this software may be reproduced, distributed, or transmitted in any form or by any means without prior written permission.
