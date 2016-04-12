#!/usr/bin/env bash

set -e

project="$(basename $(pwd))"
webFileName="${project}-web.zip"
projectVersion="$(./gradlew printVersion | perl -ne 'chomp; print if $prevline eq ":printVersion"; $prevline = $_;')"
desktopFileName="desktop/build/libs/desktop-${projectVersion}.jar"

if [[ -n $TRAVIS_BUILD_NUMBER ]]; then
  bintrayVersion="build-$TRAVIS_BUILD_NUMBER"
else
  bintrayVersion="$projectVersion"
fi

bintrayApiUrl="https://api.bintray.com/content/${BINTRAY_USER}/${BINTRAY_REPO}/${project}/${bintrayVersion}"

for e in BINTRAY_USER BINTRAY_API_KEY BINTRAY_REPO project bintrayVersion webFileName bintrayApiUrl; do
  if [[ -z $(eval "echo \$$e") ]]; then
    echo "$e is a required environment variable"
    exit 1
  fi
done

if [[ -d deploy ]]; then
  rm -r deploy
fi
if [[ -e $webFileName ]]; then
  rm "$webFileName"
fi

mkdir deploy
cp -r html/build/dist/* deploy/

cd deploy
zip -r "../${webFileName}" ./
cd ..

# Upload to bintray
printf "\nUploading desktop to bintray:\n"
curl -H "X-Bintray-Publish: 1" -H "X-Bintray-Override: 1" -T "${desktopFileName}" -u"${BINTRAY_USER}:${BINTRAY_API_KEY}" "${bintrayApiUrl}/${project}-${bintrayVersion}-desktop.jar"
printf "\nUploading web to bintray:\n"
curl -H "X-Bintray-Publish: 1" -H "X-Bintray-Override: 1" -T "${webFileName}" -u"${BINTRAY_USER}:${BINTRAY_API_KEY}" "${bintrayApiUrl}/${project}-${bintrayVersion}-web.zip"

