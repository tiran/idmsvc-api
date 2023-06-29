srcdir = .

PYTHON = python3
VENV = $(srcdir)/.venv
PYTHON_VENV = $(VENV)/bin/python
VALIDATOR = $(VENV)/bin/openapi-spec-validator

SWAGGER_CONTAINER = swagger-editor

.PHONY: all
all:
	$(MAKE) openapi-sort
	$(MAKE) validate

.PHONY: clean
clean:
	rm -rf $(VENV)

$(PYTHON_VENV):
	$(PYTHON) -m venv $(VENV)
	$(PYTHON_VENV) -m pip install -U pip
	$(PYTHON_VENV) -m pip install -r requirements-dev.txt

$(VALIDATOR): $(PYTHON_VENV)

.PHONY: validate
validate: $(VALIDATOR)
	$(VALIDATOR) api/public.openapi.yaml
	$(VALIDATOR) api/internal.openapi.yaml
	$(VALIDATOR) api/metrics.openapi.yaml

.PHONY: openapi-sort
openapi-sort: $(PYTHON_VENV)
	$(PYTHON_VENV) yamlsort.py api/*.yaml

.PHONY: swagger-editor
swagger-editor:
	podman run --rm --detach \
	  -p 8080:8080 \
	  -v $(shell pwd)/api:/api:ro,Z \
	  --name $(SWAGGER_CONTAINER) \
	  -e SWAGGER_FILE=/api/public.openapi.yaml \
	  docker.io/swaggerapi/swagger-editor
	xdg-open http://localhost:8080

.PHONY: swagger-editor-stop
swagger-editor-stop:
	podman stop $(SWAGGER_CONTAINER)
