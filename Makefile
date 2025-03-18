.DEFAULT_GOAL := help

.PHONY: record
record: ## 録画する
	go run . > scripts/cmd.sh
	xhost +Local:* # Allow X server connection
	docker compose run --rm \
	--user $(shell id -u):$(shell id -g) \
	caster \
	/bin/sh -c "./scripts/record.sh"

.PHONY: help
help: ## ヘルプを表示する
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
