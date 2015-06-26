
install-global-deps:
	npm install -g grunt-cli

publish-bower:
	TARGET_REPO_NAME="ag-module-router-bower" GITHUB_USERNAME="ag-module-router-backdoor" GITHUB_AUTH=${BOWER_DEPLOYMENT_GITHUB_AUTH} ./scripts/publish-bower.sh
