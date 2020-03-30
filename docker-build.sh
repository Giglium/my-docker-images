#!/bin/sh
#docker login -u $DOCKER_NAME -p $DOCKER_PASSWORD

for directory in "$(find . -maxdepth 1 -mindepth 1 -type d -regex '\./[^\.].*')"; do
	if printf '%s\n' "$(git log -1 --pretty="" --name-only)" | grep -Fqe "$(basename "${directory}")"; then
	  cd $(basename "${directory}")
  		export REPO=$DOCKER_NAME/$(basename "${directory}")
  		export TAG=`if [ "$TRAVIS_BRANCH" == "master" ]; then echo "latest"; else echo $TRAVIS_BRANCH ; fi`
  		docker build -f Dockerfile -t $REPO:$COMMIT .
  		docker tag $REPO:$COMMIT $REPO:$TAG
  		docker tag $REPO:$COMMIT $REPO:travis-$TRAVIS_BUILD_NUMBER
  		docker push $REPO
		cd ..
	fi
done