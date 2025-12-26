#!/bin/bash

echo "Building for Android..."
flutter build apk --release \
    --dart-define=SUPABASE_URL=https://mmgmlfqcpdvhgprwxrzn.supabase.co \
    --dart-define=SUPABASE_ANON_KEY=sb_publishable_lLp7vUB8kT7189VXpeMzAw_cQeTpE4S

echo "Android build complete! APK is in build/app/outputs/flutter-apk/"
