#!/bin/bash
echo "WARNING: Replace with actual production keys!"
echo "Running with development keys for testing..."
flutter run --dart-define=SUPABASE_URL=https://mmgmlfqcpdvhgprwxrzn.supabase.co \
            --dart-define=SUPABASE_ANON_KEY=sb_publishable_lLp7vUB8kT7189VXpeMzAw_cQeTpE4S
