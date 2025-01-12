# Running Tests locally

```bash
xcodebuild \
  -project VisWakeClock.xcodeproj \
  -scheme VisWakeClock \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPad (10th generation),OS=18.2' \
  test
```

