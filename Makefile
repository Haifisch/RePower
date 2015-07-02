export TARGET = iphone:latest:8.1:clang
export ARCHS = armv7 armv7s arm64
export THEOS_BUILD_DIR = Packages
THEOS = /opt/theos

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RePower
RePower_FILES = $(wildcard *.xm) $(wildcard *.m)
RePower_FRAMEWORKS = Foundation UIKit QuartzCore
RePower_PRIVATE_FRAMEWORKS = TelephonyUI CoreGraphics
RePower_CFLAGS = -fobjc-arc
#RePower_LIBRARIES = cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += RePowerPrefs
#SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 backboardd"
