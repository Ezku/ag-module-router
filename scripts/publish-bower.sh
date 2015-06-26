#!/bin/bash

# Push a version update commit with this message
MESSAGE=$(git log --oneline -n1)

TARGET_DIR=$(mktemp -d)
DIST_DIR=dist
HEAD_VERSION=$(git rev-parse HEAD)
DEFAULT_CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
CURRENT_BRANCH=${TRAVIS_BRANCH:-$DEFAULT_CURRENT_BRANCH}
TARGET_REPO_URL=https://$GITHUB_USERNAME:$GITHUB_AUTH@github.com/AppGyver/$TARGET_REPO_NAME.git

# Does the announced branch name looks like a semver tag?
if [[ "$CURRENT_BRANCH" =~ ^v[0-9]+\.[0-9]+\.[0-9]+ ]]; then
  IS_TAG_RELEASE=true
  echo Tagging release $CURRENT_BRANCH with message $MESSAGE
else
  IS_TAG_RELEASE=false
  echo Publishing branch $CURRENT_BRANCH version $HEAD_VERSION with message $MESSAGE
fi

# Build distributable
grunt build

# Clone target repo
echo Cloning $TARGET_REPO_NAME to $TARGET_DIR
git clone $TARGET_REPO_URL $TARGET_DIR --depth 1 > /dev/null
(cd $TARGET_DIR ; git config user.email "richard.anderson+$TARGET_REPO_NAME-backdoor@appgyver.com" ; git config user.name "Richard Anderson")

(
  # Check out the announced branch unless this is a tag release, in which case we operate in master
  (
    $IS_TAG_RELEASE && \
    echo "Tagging release $CURRENT_BRANCH in target repository"
  ) || \
  (
    echo "Updating branch $CURRENT_BRANCH in target repository" && \
    cd $TARGET_DIR && \
    (

      git checkout -b $CURRENT_BRANCH || \
      git checkout $CURRENT_BRANCH
    )
  )
) && \
(
  # Copy distribution artefacts to target bower repo
  rm -rf $TARGET_DIR/* && \
  cp -r $DIST_DIR/* $TARGET_DIR && \
  cp bower.json $TARGET_DIR && \
  cp README.bower.md $TARGET_DIR/README.md
) && \
(
  # Commit changes to build artefacts
  cd $TARGET_DIR && \
  git add -A && \
  (
    # If this is a tag release, tag and push only the tag
    $IS_TAG_RELEASE && \
      git commit --allow-empty -m "$MESSAGE" && \
      git tag $CURRENT_BRANCH && \
      git push origin --force --tags > /dev/null
  ) || \
  (
    # Otherwise push under the announced branch name
    git commit -m "$MESSAGE" && \
    git push origin --force $CURRENT_BRANCH > /dev/null
  )
)

# Clean up
echo Cleaning up
rm -rf $TARGET_DIR
echo Done!
