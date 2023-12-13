plugin:
	cd plugin && yarn install
service-proxy:
	cd service-proxy && mvn clean install

service-proxy-image: service-proxy
	docker build -t quay.io/ikanello/quarkus-openshift-console-plugin:latest plugin

plugin-image: plugin
	docker build -t quay.io/ikanello/quarkus-openshift-console-plugin:latest plugin

images: plugin-image service-proxy-iamge

push-service-proxy: service-proxy-image 
	docker push quay.io/ikanello/quarkus-openshift-console-plugin:latest
	docker push quay.io/ikanello/quarkus-openshift-console-produi-proxy:latest

push-plugin: plugin-image 
	docker push quay.io/ikanello/quarkus-openshift-console-produi-proxy:latest
push: push-plugin push-service-proxy

deploy-plugin:
	./bin/quarkus-install-openshift-console-plugin

deploy-proxy:
	cd service-proxy && \
	mvn clean install && \
	quarkus deploy openshift --image-build --namespace plugin-quarkus-openshift-console-plugin

deploy: deploy-plugin deploy-proxy

undeploy:
	helm uninstall quarkus-openshift-console-plugin --namespace=plugin-quarkus-openshift-console-plugin
all: images push deploy
