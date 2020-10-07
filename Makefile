VERSION = 0.1.0
IMAGE_NAME ?= dnxsolutions/shell:$(VERSION)
TAG = $(VERSION)

build:
	docker build -t $(IMAGE_NAME) .

shell:
	docker run --rm -it --entrypoint=/bin/bash -v ~/.aws:/root/.aws -v $(PWD):/opt/app $(IMAGE_NAME)

gitTag:
	-git tag -d $(TAG)
	-git push origin :refs/tags/$(TAG)
	git tag $(TAG)
	git push origin $(TAG)
