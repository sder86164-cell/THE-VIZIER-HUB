# مسار الثيوس في جهازك
THEOS = /var/theos

export TARGET = iphone:clang:latest:15.0
export ARCHS = arm64 arm64e
export THEOS_PACKAGE_SCHEME = rootless

# اسم الأداة (الوزير VIP)
TWEAK_NAME = SnapS006

# قائمة الملفات (تأكد أن كل هذه الملفات موجودة في GitHub)
SnapS006_FILES = baypass.xm Tweak.x Extra.xm downloaded.xm Login.xm Menu.xm
SnapS006_FRAMEWORKS = UIKit CoreLocation MapKit Foundation QuartzCore Security CoreMedia AVFoundation

# إعدادات الحماية ومنع الأخطاء أثناء البناء
SnapS006_CFLAGS = -fobjc-arc -O3 -Wno-deprecated-declarations -Wno-unused-variable -Wno-error -fvisibility=hidden

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

# تنظيف السناب وتشغيله بعد التثبيت
after-install::
	install.exec "killall -9 Snapchat" || true
