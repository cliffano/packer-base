version ?= 1.1.1-pre.0
# Target image architecture (amd64 or arm64), defaults to the host architecture
arch ?= $(shell uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')

ci: clean stage lint build-docker-base

clean:
	rm -rf stage/ logs/ /tmp/packer-tmp/

stage:
	mkdir -p stage/ stage/ansible/roles/ stage/ansible/collections/

rmdeps:
	rm -rf .venv/

define python_venv
	. .venv/bin/activate && $(1)
endef

deps:
	python3 -m venv .venv
	$(call python_venv,python3 -m pip install -r requirements.txt)
	# Available versions: https://github.com/hashicorp/packer-plugin-docker/tags
	packer plugins install github.com/hashicorp/docker 1.1.4
	# Available versions: https://github.com/hashicorp/packer-plugin-ansible/tags
	packer plugins install github.com/hashicorp/ansible 1.1.6

deps-upgrade:
	python3 -m venv .venv
	$(call python_venv,python3 -m pip install -r requirements-dev.txt)
	$(call python_venv,pip-compile --upgrade)

lint:
	$(call python_venv,ansible-lint -v .)
	$(call python_venv,yamllint .)
#   Disable shellcheck for now due to likely resource issue with the shellcheck run
# 	shellcheck provisioners/shell/*.sh

build-docker-base:
	mkdir -p logs/ /tmp/packer-tmp/
	PACKER_LOG_PATH=logs/packer-docker-base.log \
		PACKER_LOG=1 \
		PACKER_TMP_DIR=/tmp/packer-tmp/ \
		packer build \
		-var-file=conf/docker-base.json \
		-var arch=$(arch) \
		templates/packer/docker-base.pkr.hcl

publish-docker-base:
	docker image push cliffano/base:$(version)-$(arch)

# Combine the per-architecture images into multi-arch version and latest tags
publish-docker-base-manifest:
	docker buildx imagetools create \
		--tag cliffano/base:$(version) \
		--tag cliffano/base:latest \
		cliffano/base:$(version)-amd64 \
		cliffano/base:$(version)-arm64

.PHONY: ci clean rmdeps deps deps-upgrade lint build-aws-base build-docker-base publish-docker-base publish-docker-base-manifest
