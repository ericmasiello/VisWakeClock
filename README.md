# Running Tests locally

```bash
xcodebuild \
  -project VisWakeClock.xcodeproj \
  -scheme VisWakeClock \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPad (A16),OS=18.4' \
  test
```

