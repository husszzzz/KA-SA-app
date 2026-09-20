TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SHSHOP

SHSHOP_FILES = Tweak.x
SHSHOP_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
