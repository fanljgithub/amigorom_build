add-prebuilt-app: $(ZIP_DIR)/system/xbin/busybox
	@echo To add prebuilt apps
#	$(hide) cp -f $(SYSOUT_DIR)/xbin/invoke-as $(ZIP_DIR)/system/xbin/
#	$(hide) cp -f $(SYSOUT_DIR)/xbin/shelld $(ZIP_DIR)/system/xbin/
#	$(hide) mkdir -p $(ZIP_DIR)/data/media
#	$(hide) cp -rf $(DATAOUT_DIR)/media/preinstall_apps/ $(ZIP_DIR)/data/media/

$(ZIP_DIR)/system/xbin/busybox:
	$(hide) cp -f $(SYSOUT_DIR)/xbin/busybox $(ZIP_DIR)/system/xbin/

add-prebuilt-libraries:
	@echo To add prebuilt libraries
	$(hide) cp -f $(SYSOUT_DIR)/lib/lib_gn_music.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libgnspecialeffect.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/liblocSDK_2.4.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libnative_graph.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libnative_camera_r2.3.3.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libBMapApiEngine_v1_3_3.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libandroidgl20.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libgdx.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libxmpp2ber.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libmsc-v5.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libsmartaiwrite-jni-v4.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libsmartaiwrite-jni-v5.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libsmartaiwrite-jni-v6.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libsmartaiwrite-jni-v7.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libvadLib-v3.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libBMapApiEngine_v1_3_5.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/liblocSDK_2_5OEM.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libHAOMA.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libjni_latinime.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/libjni_pinyinime.so $(ZIP_DIR)/system/lib/
	$(hide) cp -f $(SYSOUT_DIR)/lib/lib_gn_patchapply.so $(ZIP_DIR)/system/lib/


add-prebuilt-framework:
	@echo To add prebuilt amigo framework
	$(hide) cp -f $(SYSOUT_DIR)/framework/baidumapapi.jar $(ZIP_DIR)/system/framework/
	$(hide) cp -f $(SYSOUT_DIR)/framework/amigoframework.jar $(ZIP_DIR)/system/framework/
	$(hide) cp -f $(SYSOUT_DIR)/framework/gionee-common.jar $(ZIP_DIR)/system/framework/
	$(hide) cp -f $(SYSOUT_DIR)/framework/gnframework.jar $(ZIP_DIR)/system/framework/
	$(hide) cp -f $(SYSOUT_DIR)/framework/amigoframework-res.apk $(ZIP_DIR)/system/framework/
	$(hide) cp -f $(SYSOUT_DIR)/framework/gnframework-res.apk $(ZIP_DIR)/system/framework/
	$(hide) cp -f $(SYSOUT_DIR)/app/GN_Graf.gnz $(ZIP_DIR)/system/app/GN_Graf.gnz


add-prebuilt-media:
	@echo To add prebuilt media files
	$(hide) cp -rf $(SYSOUT_DIR)/media $(ZIP_DIR)/system

add-prebuilt-etc-files:
	@echo To add prebuilt files under etc
	$(hide) cp -f $(SYSOUT_DIR)/etc/apns-conf.xml $(ZIP_DIR)/system/etc/
	$(hide) cp -rf $(SYSOUT_DIR)/etc/GN_Contacts/ $(ZIP_DIR)/system/etc/
	$(hide) cp -rf $(SYSOUT_DIR)/etc/weather/ $(ZIP_DIR)/system/etc/
	$(hide) cp -rf $(SYSOUT_DIR)/etc/GN_Launcher/ $(ZIP_DIR)/system/etc/
	$(hide) cp -rf $(SYSOUT_DIR)/etc/theme/ $(ZIP_DIR)/system/etc/
	$(hide) cp -rf $(SYSOUT_DIR)/etc/Amigo_CustomerService/ $(ZIP_DIR)/system/etc/


add-lbesec-amigo:
	@echo To add LBESEC_AMIGO

	$(hide) cp -f $(SYSOUT_DIR)/xbin/su $(ZIP_DIR)/system/xbin/
	$(hide) cp -f $(SYSOUT_DIR)/bin/bootanimation $(ZIP_DIR)/system/bin/
release-prebuilt-app:
	@echo Release prebuilt apps
	$(hide) mkdir -p $(RELEASE_PATH)/system/xbin
	$(hide) cp $(SYSOUT_DIR)/xbin/invoke-as $(RELEASE_PATH)/system/xbin/
	$(hide) cp $(SYSOUT_DIR)/xbin/shelld $(RELEASE_PATH)/system/xbin/
	$(hide) cp $(SYSOUT_DIR)/xbin/busybox $(RELEASE_PATH)/system/xbin/
	$(hide) mkdir -p $(RELEASE_PATH)/system/bin
	$(hide) cp $(SYSOUT_DIR)/bin/installd $(RELEASE_PATH)/system/bin/
	$(hide) cp -f $(SYSOUT_DIR)/app/LBESEC_MIUI.apk $(RELEASE_PATH)/system/app
	$(hide) cp -f $(SYSOUT_DIR)/xbin/su $(RELEASE_PATH)/system/xbin/
	$(hide) mkdir -p $(RELEASE_PATH)/data/media
	$(hide) cp -rf $(DATAOUT_DIR)/media/preinstall_apps/ $(RELEASE_PATH)/data/media/


add-amigo-prebuilt: add-prebuilt-app add-prebuilt-libraries add-prebuilt-framework add-prebuilt-media add-prebuilt-etc-files add-lbesec-amigo
	@echo Add amigo prebuilt completed!


