# Include custom targets and environment variables here
GO_BUILD_FLAGS += -ldflags "-X main.rudderDataplaneURL=$(MM_RUDDER_DATAPLANE_URL) -X main.rudderWriteKey=$(MM_RUDDER_WRITE_KEY)"

## Generate mocks.
mocks:
ifneq ($(HAS_SERVER),)
	go install github.com/golang/mock/mockgen
	mockgen -destination server/config/mocks/mock_service.go github.com/mattermost/mattermost-plugin-incident-management/server/config Service
	mockgen -destination server/bot/mocks/mock_logger.go github.com/mattermost/mattermost-plugin-incident-management/server/bot Logger
	mockgen -destination server/bot/mocks/mock_poster.go github.com/mattermost/mattermost-plugin-incident-management/server/bot Poster
	mockgen -destination server/incident/mocks/mock_service.go github.com/mattermost/mattermost-plugin-incident-management/server/incident Service
	mockgen -destination server/incident/mocks/mock_store.go github.com/mattermost/mattermost-plugin-incident-management/server/incident Store
	mockgen -destination server/incident/mocks/mock_job_once_scheduler.go github.com/mattermost/mattermost-plugin-incident-management/server/incident JobOnceScheduler
	mockgen -destination server/playbook/mocks/mock_service.go github.com/mattermost/mattermost-plugin-incident-management/server/playbook Service
	mockgen -destination server/playbook/mocks/mock_store.go github.com/mattermost/mattermost-plugin-incident-management/server/playbook Store
	mockgen -destination server/pluginkvstore/mocks/mock_kvapi.go github.com/mattermost/mattermost-plugin-incident-management/server/pluginkvstore KVAPI
	mockgen -destination server/pluginkvstore/mocks/serverpluginapi/mock_plugin.go github.com/mattermost/mattermost-server/v5/plugin API
	mockgen -destination server/sqlstore/mocks/mock_kvapi.go github.com/mattermost/mattermost-plugin-incident-management/server/sqlstore KVAPI
	mockgen -destination server/sqlstore/mocks/mock_storeapi.go github.com/mattermost/mattermost-plugin-incident-management/server/sqlstore StoreAPI
	mockgen -destination server/sqlstore/mocks/mock_configurationapi.go github.com/mattermost/mattermost-plugin-incident-management/server/sqlstore ConfigurationAPI
endif

## Runs the redocly server.
.PHONY: docs-server
docs-server:
	npx @redocly/openapi-cli@1.0.0-beta.3 preview-docs server/api/api.yaml
