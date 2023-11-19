.PHONY: init start validate export add-tag

init:
	python3 -m venv myenv
	source myenv/bin/activate && pip install -r requirements.txt

validate:
	yaml-resume validate resume.yaml

export:
	yaml-resume export resume.yaml -e pdf -o resume

add-skill:
	yq --yaml-output '.skills += [{"level": $(LEVEL), "name": "$(NAME)"}]' resume.yaml | sponge resume.yaml
