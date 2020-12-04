#!/bin/sh

# this is a script to help build my blog

echo $(which ruby)
echo "::debug:: the gem home that was set is $GEM_HOME"
echo "::debug:: the jekyll src that was set is $JEKYLL_SRC"

# Check to see if all the environmetn variables that will be needed are set
# If they are not set then set them to reasonable default vaules

if [ -n "${INPUT_JEKYLL_SRC}" ]; then
  JEKYLL_SRC="${INPUT_JEKYLL_SRC}"
  echo "::debug::Source directory is set via input parameter"
elif [ -n "${SRC}" ]; then
  JEKYLL_SRC=${SRC}
  echo "::debug::Source directory is set via SRC environment var"
else
  JEKYLL_SRC=$(find . -path '*/vendor/bundle' -prune -o -name '_config.yml' -exec dirname {} \;)
  JEKYLL_FILES_COUNT=$(echo "$JEKYLL_SRC" | wc -l | xargs)
  if [ "$JEKYLL_FILES_COUNT" != "1" ]; then
    echo "::error::Found $JEKYLL_FILES_COUNT Jekyll sites! Please define which to use with input variable \"jekyll_src\""
    echo "$JEKYLL_SRC"
    exit 1
  fi
  JEKYLL_SRC=$(echo $JEKYLL_SRC | tr -d '\n')
  echo "::debug::Source directory is found in file system"
fi
echo "::debug::Using \"${JEKYLL_SRC}\" as a source directory"

if [ -n "${INPUT_GEM_SRC}" ]; then
  GEM_SRC="${INPUT_GEM_SRC}"
  echo "::debug::Gem directory is set via input parameter"
elif [ -f "${JEKYLL_SRC}/Gemfile.lock" ]; then
  GEM_SRC="${JEKYLL_SRC}"
  echo "::debug::Gem directory is set via source directory"
fi

if [ -z "${GEM_SRC}" ]; then
  GEM_SRC=$(find . -path '*/vendor/bundle' -prune -o -name Gemfile.lock -exec dirname {} \;)
  GEM_FILES_COUNT=$(echo "$GEM_SRC" | wc -l)
  if [ "$GEM_FILES_COUNT" != "1" ]; then
    echo "::error::Found $GEM_FILES_COUNT Gemfiles! Please define which to use with input variable \"gem_src\""
    echo "$GEM_SRC"
    exit 1
  fi
  GEM_SRC=$(echo $GEM_SRC | tr -d '\n')
  echo "::debug::Gem directory is found in file system"
fi

echo "::debug::Using \"${GEM_SRC}\" as Gem directory"

cd $GEM_SRC

# execute building and deployment of blog

# depends on the mode we are in prod or dev

if [[ $BLOG_STATUS == 'prod' ]]; then
	echo 'Begin production building'
	# I have a rake file that will publish all draft posts based on the current date
	# rake publish_post

  # clean the workspace and preform a normal build
	jekyll clean --destination ./prod
	jekyll build --destination ./prod

	# things should be in the _site folder, although I may change this location on production builds

  # after a sucessful build then zip up the site folder and get it ready for transport to the s3 bucket
  FILE = ./prod/_config.yml
	if [[ -f $FILE ]]; then
    tar -czvf blog-published.tar.gz ./prod
  fi
	# after doing every thing here exit with 0 success!
	exit 0
fi

if [[ $BLOG_STATUS == 'dev' ]]; then

  # starting up the development build

	echo ' Just a normal day in the office! '

	jekyll clean
	jekyll serve --verbose --trace --unpublished --drafts --port 8001

	# print out all the environment variables
	echo 'Installed Ruby: ' $(which ruby)
	echo 'Gem Env: '$(gem env)

fi

if [[ -z $BLOG_STATUS ]]; then
	echo ' we need to set the BLOG_STATUS environment variable to dev or prod'
fi