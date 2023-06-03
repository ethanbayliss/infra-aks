.DEFAULT_GOAL := done_dev
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

test_az_cli:
	@az version --output table 1> /dev/null
	@az account list --query "[?isDefault]" --output table 1> /dev/null

confirm_az_account: test_az_cli
	@echo "\033[0;31mPlease confirm you're using the correct Azure account and Subscription\033[0m"
	@az account list --query "[?isDefault]" --output table
	@echo "Subscription ID: $$(az account list --query '[?isDefault].id' --output tsv)"
	@echo -n "[y/N] " && read ans && [ $${ans:-N} = y ]

create_service_account: confirm_az_account
	@SUBSCRIPTION=$$(az account list --query "[?isDefault].id" -o tsv); \
	az ad sp create-for-rbac --role="Contributor" \
	                         --scopes="/subscriptions/$$SUBSCRIPTION" \
	                         --display-name "service.$(current_dir).terraform";

done_dev: create_service_account 
	@echo "Done"
