IMAGE=bobkonf-2024-copilot-tutorial

build:
	docker build --progress plain -t $(IMAGE) .
