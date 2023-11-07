#!/usr/bin/env bash
# place this script in project/android/app/
cd ..
# fail if any command fails
set -e
# debug log
set -x

cd ..
# choose a different release channel if you want - https://github.com/flutter/flutter/wiki/Flutter-build-release-channels
# stable - recommended for production

git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

echo "Building with flavor $FLAVOR"

target="lib/main.dart"
if [ "$FLAVOR" == "qa" ]; then
    target="lib/main_qa.dart";
elif [ "$FLAVOR" == "prod" ]; then
    target="lib/main.dart";
fi

echo "using entrypoint: $target"

flutter channel stable
flutter doctor
flutter pub get
flutter pub run build_runner build
#flutter build apk --release --dart-define=API_KEY=$API_KEY --dart-define=FLAVOR=$FLAVOR --flavor $FLAVOR -t $target
flutter build apk --release

# change apk file name
mv build/app/outputs/flutter-apk/app-$FLAVOR-release.apk build/app/outputs/flutter-apk/wfm.apk

# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/flutter-apk/wfm.apk $_