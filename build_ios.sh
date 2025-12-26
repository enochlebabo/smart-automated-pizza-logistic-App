#!/bin/bash

echo "Building for iOS..."
flutter build ios --release \
    --dart-define=SUPABASE_URL=https://mmgmlfqcpdvhgprwxrzn.supabase.co \
    --dart-define=SUPABASE_ANON_KEY=sb_publishable_lLp7vUB8kT7189VXpeMzAw_cQeTpE4S

echo "iOS build complete!"
