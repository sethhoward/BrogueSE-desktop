# Release archives (Brogue SE desktop: Windows + Linux)

common_bin := bin/assets bin/keymap.txt

define make_release_base
	mkdir $@
	cp README.md $@/README.txt
	cp CHANGELOG.md $@/CHANGELOG.txt
	cp LICENSE.txt $@
endef

# Flatten bin/ in the Windows archive
BrogueSE-windows:
	$(make_release_base)
	cp -r $(common_bin) bin/{brogue.exe,brogue-cmd.bat} $@

BrogueSE-linux:
	$(make_release_base)
	cp brogue $@
	cp -r --parents $(common_bin) bin/brogue $@
	cp linux/make-link-for-desktop.sh $@
