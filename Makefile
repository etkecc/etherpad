PLUGINS = ep_font_size ep_font_family ep_font_color ep_spellcheck ep_table_of_contents ep_subscript_and_superscript ep_mammoth ep_print ep_comments_page ep_embedded_hyperlinks2
### CI vars
CI_LOGIN_COMMAND = @echo "Not a CI, skip login"
CI_REGISTRY_IMAGE ?= registry.gitlab.com/etke.cc/etherpad
CI_COMMIT_TAG ?= latest
# for main branch it must be set explicitly
ifeq ($(CI_COMMIT_TAG), main)
CI_COMMIT_TAG = latest
endif
# login command
ifdef CI_JOB_TOKEN
CI_LOGIN_COMMAND = @docker login -u gitlab-ci-token -p $(CI_JOB_TOKEN) $(CI_REGISTRY)
endif

# CI: docker login
login:
	@echo "trying to login to docker registry..."
	$(CI_LOGIN_COMMAND)

# docker build
docker:
	docker buildx create --use
	docker buildx build --platform linux/amd64 --push -t ${CI_REGISTRY_IMAGE}:${CI_COMMIT_TAG} --build-arg ETHERPAD_PLUGINS="$(PLUGINS)" --build-arg INSTALL_SOFFICE=true etherpad-lite
	# docker buildx build --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --push -t ${CI_REGISTRY_IMAGE}:${CI_COMMIT_TAG} --build-arg ETHERPAD_PLUGINS="$(PLUGINS)" --build-arg INSTALL_SOFFICE=true etherpad-lite
