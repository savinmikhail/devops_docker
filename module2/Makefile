.PHONY: init start validate export add-tag

init:
	yaml-resume init resume.yaml

validate:
	yaml-resume validate resume.yaml

# Define the default export format
EXT ?= pdf
export:
	yaml-resume export resume.yaml -e $(EXT) -o resume


add-skill:
	yq --yaml-output '.skills += [{"level": $(LEVEL), "name": "$(NAME)"}]' resume.yaml | sponge resume.yaml
