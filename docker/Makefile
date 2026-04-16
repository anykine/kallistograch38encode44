NAME=kallistogrch38encode44
TAG=v0.52
NOW=$(shell date +%Y-%m-%d:%H:%M:%S)
GIT_SHA=$(shell git rev-parse --short HEAD)


all: build

testbuild: 

	docker build \
		-t $(NAME):testbuild\
		-f Dockerfile ../..


build:
	docker build \
	-t $(NAME):$(TAG) \
	-t $(NAME):$(GIT_SHA) \
	-f Dockerfile \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
    	--build-arg BUILD_DATE=`date +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VERSION=$(TAG) \
	../..

	#docker tag $(NAME):latest beigebox/$(NAME):latest
	#docker tag $(NAME):$(TAG) beigebox/$(NAME):$(TAG)

