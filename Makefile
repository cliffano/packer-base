version ?= 0.9.0-pre.0

ci: clean stage deps lint build-docker-base

clean:
	rm -rf stage/ logs/ /tmp/packer-tmp/

stage:
	mkdir -p stage/ stage/ansible/roles/ stage/ansible/collections/

deps:
	packer plugins install github.com/hashicorp/docker 1.1.2
	packer plugins install github.com/hashicorp/ansible 1.1.4

lint:
	echo "TODO: Ansible Lint"
	# bundle exec puppet-lint \
	# 	--fail-on-warnings \
	# 	--no-documentation-check \
	# 	provisioners/*.pp \
	# 	modules-extra/*/manifests/langs/*.pp
	# shellcheck \
		# provisioners/shell/*.sh

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

.PHONY: ci clean deps lint build-aws-base build-docker-base publish-docker-base
