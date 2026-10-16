# NutriVision Firebase Backend

## Requirements
- Node.js 20
- Firebase CLI
- A Firebase project with Authentication, Cloud Firestore, Cloud Storage, Cloud Functions, and Cloud Messaging enabled.
- Billing enabled for Cloud Functions and any paid AI provider.

## Configure AI
From the repository root, run:

    firebase functions:secrets:set AI_API_KEY

Paste the AI provider key only into the interactive secret prompt. Never commit the key or put it in Flutter configuration.

## Install and compile

    cd functions
    npm install
    npm run build

## Local emulators

    firebase emulators:start --only auth,functions,firestore,storage

The Flutter app currently uses the configured Firebase project by default. To use emulators locally, add explicit emulator configuration in a development-only initialization path; never enable emulator endpoints in production builds.

## Deploy
From repository root:

    cd functions && npm install && npm run build && cd ..
    firebase deploy --only functions,firestore:rules,firestore:indexes,storage

## Callable functions
- bootstrapUser
- completeOnboarding
- updateNutritionProfile
- updateUserPreferences
- saveMeal, deleteMeal, getDashboardSummary
- analyzeMeal, sendCoachMessage, generateRecipe
- saveGroceryItem, deleteGroceryItem
- saveProgressEntry, deleteProgressEntry, getProgressHistory
- deleteUserAccount
- registerDeviceToken, scheduleMealReminder, sendScheduledReminders

All callable functions require Firebase Authentication unless explicitly documented otherwise.

## Important production checks
1. Verify Email/Password is enabled in Firebase Console.
2. Confirm the configured Android package name and iOS bundle ID match the Firebase apps.
3. Test Firestore and Storage rules in the Emulator Suite.
4. Configure App Check enforcement after validating each supported platform.
5. Add integration tests for every callable function and AI-provider failure path.
6. Confirm your AI provider's data retention and privacy terms before sending health-related user content.
7. Recipe generation currently stores private recipes. Add a server-validated publishing flow before exposing shared recipes.
8. Verify scheduled reminder timezone behavior and idempotency with tests before production use.
9. Run npm run build, flutter pub get, dart format lib, and flutter analyze locally before merging.