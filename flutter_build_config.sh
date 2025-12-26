#!/bin/bash

# MealMesh Build Script
# Usage: ./flutter_build_config.sh [dev|prod]

ENV=${1:-dev}

echo "Building MealMesh for $ENV environment..."

case $ENV in
  dev)
    # Development build
    flutter run --dart-define=SUPABASE_URL=https://mmgmlfqcpdvhgprwxrzn.supabase.co \
                --dart-define=SUPABASE_ANON_KEY=sb_publishable_lLp7vUB8kT7189VXpeMzAw_cQeTpE4S \
                --dart-define=APP_ENV=development
    ;;
  prod)
    # Production build - Use separate production keys
    flutter build apk --release \
          --dart-define=SUPABASE_URL=https://mmgmlfqcpdvhgprwxrzn.supabase.co \
          --dart-define=SUPABASE_ANON_KEY=sb_publishable_lLp7vUB8kT7189VXpeMzAw_cQeTpE4S \
          --dart-define=APP_ENV=production
    ;;
  *)
    echo "Invalid environment: $ENV"
    echo "Usage: ./flutter_build_config.sh [dev|prod]"
    exit 1
    ;;
esac
