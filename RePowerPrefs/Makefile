TARGET = :clang::5.0
ARCHS = armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = RePower
RePower_FILES = $(wildcard *.xm) $(wildcard *.m)
RePower_INSTALL_PATH = /Library/PreferenceBundles
RePower_FRAMEWORKS = UIKit CoreGraphics
RePower_PRIVATE_FRAMEWORKS = Preferences
RePower_LIBRARIES = cepheiprefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp Resources/entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/RePower.plist$(ECHO_END)
	$(ECHO_NOTHING)cp Resources/RePower*.png $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(ECHO_END)
