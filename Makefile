.PHONY: test

test:
	nvim --headless --noplugin \
		-u lua/tests/minimal.lua \
		-c "PlenaryBustedDirectory lua/tests/ { init = 'lua/tests/minimal.lua' }"
