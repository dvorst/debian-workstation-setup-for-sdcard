.PHONY: lint syntax-check render-test molecule-test molecule-converge molecule-verify test clean

# Place dummy vault vars where both playbooks expect them (never commit real values here)
GROUP_VARS_VAULT := group_vars/all/vault.yml

$(GROUP_VARS_VAULT):
	mkdir -p group_vars/all
	cp preseed/tests/vars.yml $(GROUP_VARS_VAULT)

lint:
	yamllint .
	ansible-lint

syntax-check: $(GROUP_VARS_VAULT)
	ansible-playbook --syntax-check -i inventory.ini site.yml
	ansible-playbook --syntax-check -i inventory.ini preseed/build.yml

render-test:
	ansible-playbook -i inventory.ini preseed/tests/render_preseed.yml

# Full Molecule cycle: create → prepare → converge → verify → destroy
molecule-test:
	molecule test

# Run only converge (useful during development to re-apply the playbook)
molecule-converge:
	molecule converge

# Run only verify (useful after a manual converge)
molecule-verify:
	molecule verify

test: lint syntax-check render-test

clean:
	rm -f group_vars/all/vault.yml preseed.cfg
	rmdir --ignore-fail-on-non-empty group_vars/all group_vars 2>/dev/null || true
