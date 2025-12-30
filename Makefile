version ?= 0.10.0

ci: clean stage deps lint build-docker-base

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
	packer plugins install github.com/hashicorp/docker 1.1.2
	packer plugins install github.com/hashicorp/ansible 1.1.4

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
		templates/packer/docker-base.pkr.hcl

publish-docker-base:
	docker image push cliffano/base:latest
	docker image push cliffano/base:$(version)

.PHONY: ci clean rmdeps deps deps-upgrade lint build-aws-base build-docker-base publish-docker-base
