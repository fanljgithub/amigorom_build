usage:
	@echo ">>> The main target for porting:"
	@echo "	make zipfile    - to create the full ZIP file, all apks are signed using testkey"
	@echo "	make zipone     - zipfile, plus the customized actions, such as zip2sd"
	@echo "	make zip2sd     - to push the ZIP file to phone in recovery mode"
	@echo "	make clean      - clear everything for output of this makefile"
	@echo "	make reallyclean- clear everything of related."
	@echo "	make workspace  - prepare the initial workspace for porting"
	@echo "	make firstpatch - add the amigo hook into target framework smali code first time for a device"
	@echo "	make patchamigo  - incrementaly add the amigo hook into target framework smali code"
	@echo "	make fullota    - generate full ota package, all apks are signed using apkcerts.txt"
	@echo ">>> Other helper targets:"
	@echo "	make apktool-if            - install the framework for apktool"
	@echo "	make verify                - to check if any error in the makefile"
	@echo "	make verify-ota            - to generate an ota for ota verification"
	@echo "	make out/xxxx.jar-phone    - to make out a single jar file and push to phone"
	@echo "	make xxxx.apk.sign         - to generate a xxxx.apk and sign/push to phone"
	@echo "	make clean-xxxx/make xxxx  - just as make under android-build-top"
	@echo "	make sign                  - Sign all generated apks by this makefile and push to phone"
	@echo ">>> local ota targets:"
	@echo "	make zipfile-ota-base              - create the zipfile and the ota base with build-number"
	@echo "	make -e otabase=BN zipfile-and-ota - create the zipfile and the ota package based on BN"
	@echo "	make -e otabase=BN zipfile-ota     - create the ota package based on BN"
	@echo ">>> Environment overrides:"
	@echo "	make -e showcommand=true   - to show all executed commands"
	@echo "	make -e log=quiet|info|verbose - to control the output from make command"

# Target to prepare porting workspace
workspace: apktool-if $(JARS_OUTDIR) $(APPS_OUTDIR) fix-framework-res
	@echo Prepare workspace completed!

# Target to install apktool framework 
apktool-if: $(TMP_DIR)/apktool-if

#TODO all apktool if result file is at $HOME/apktool/framework/
APKTOOL_IF_RESULT_FILE := $(HOME)/apktool/framework
$(TMP_DIR)/apktool-if: $(ZIP_FILE) $(APKTOOL_IF_RESULT_FILE)/6.apk | $(TMP_DIR)
	@echo ">>> Install framework resources for apktool..."
	$(hide) for res_file in `find $(PORT_BUILD)/res/ -name "*.apk"`;do\
		$(APKTOOL) if $$res_file; \
	done
	@echo install amigo framework-res.apk
	$(APKTOOL) if $(SYSOUT_DIR)/framework/framework-res.apk
	$(UNZIP) $(ZIP_FILE) "system/framework/*.apk" -d $(TMP_DIR)
	$(hide) for res_file in `find $(TMP_DIR)/system/framework/ -name "*.apk"`; do\
		echo install $$res_file ; \
		$(APKTOOL) if $$res_file; \
	done
	$(hide) rm -r $(TMP_DIR)/system/framework/*.apk
	@echo "<<< install framework resources completed!"
	@touch $@

$(APKTOOL_IF_RESULT_FILE)/6.apk:

fix-framework-res:
	@echo fix the apktool multiple position substitution bug
	$(FIX_PLURALS) framework-res

# Target to add amigo hook into target framework first time
firstpatch:
	$(PATCH_AMIGO_FRAMEWORK) $(PORT_ROOT)/android/google-framework $(PORT_ROOT)/android `pwd`

# Target to incrementaly add amigo hook into target framework
patchamigo:
	$(PATCH_AMIGO_FRAMEWORK) $(PORT_ROOT)/android/last-framework $(PORT_ROOT)/android `pwd`
	@echo Patchamigo completed!

# Target to release AMIGO jar and apks
release: $(RELEASE_AMIGO) release-framework-base-src

ifeq ($(strip $(ANDROID_BRANCH)),)
release-framework-base-src:
	$(error To release source code for framework base, run envsetup -b to specify branch)
else
release-framework-base-src: release-amigo-resources
	@echo "To release source code for framework base..."
	$(RLZ_SOURCE) $(ANDROID_BRANCH) $(ANDROID_TOP) $(RELEASE_PATH)
endif


# Target to sign apks in the connected phone
sign: $(SIGNAPKS)
	@echo Sign competed!

# Target to clean the .build
clean:
	$(hide) if [ -f ".delete-zip-file-when-clean" ]; then rm $(ZIP_FILE); fi
	$(hide) rm -f .delete-zip-file-when-clean
	$(hide) rm -rf $(TMP_DIR)
	$(hide) rm -f $(OUT_APK_PATH)/*.apk-tozip $(OUT_JAR_PATH)/*-tozip
	$(hide) rm -f releasetools.pyc
	$(hide) rm -f $(TOOL_DIR)/releasetools/common.pyc $(TOOL_DIR)/releasetools/edify_generator.pyc
	@echo clean completed!

reallyclean: clean $(ERR_REPORT) $(REALLY_CLEAN)
	@echo "ALL CLEANED!"

# Target to verify env and debug info
verify: $(ERR_REPORT)
	@echo "-------------------"
	@echo ">>>>> ENV VARIABLE:"
	@echo "PORT_ROOT   = $(PORT_ROOT)"
	@echo "ANDROID_TOP = $(ANDROID_TOP)"
	@echo "ANDROID_OUT = $(ANDROID_OUT)"
	@echo "BUILD_NUMBER= $(BUILD_NUMBER)"
	@echo "----------------------"
	@echo ">>>>> GLOBAL VARIABLE:"
	@echo "TMP_DIR    = $(TMP_DIR)"
	@echo "ZIP_DIR    = $(ZIP_DIR)"
	@echo "OUT_ZIP    = $(OUT_ZIP)"
	@echo "TOOL_DIR   = $(TOOL_DIR)"
	@echo "APKTOOL    = $(APKTOOL)"
	@echo "SIGN       = $(SIGN)"
	@echo "ADDMIUI    = $(ADDMIUI)"
	@echo "SYSOUT_DIR = $(SYSOUT_DIR)"
	@echo "----------------------"
	@echo ">>>>> LOCAL VARIABLE:"
	@echo "local-use-android-out = $(local-use-android-out)"
	@echo "local-zip-file        = $(local-zip-file)"
	@echo "local-out-zip-file    = $(local-out-zip-file)"
	@echo "local-modified-apps   = $(local-modified-apps)"
	@echo "local-amigo-apps       = $(local-amigo-apps)"
	@echo "local-remove-apps     = $(local-remove-apps)"
	@echo "local-phone-apps      = $(local-phone-apps)"
	@echo "local-pre-zip         = $(local-pre-zip)"
	@echo "local-after-zip       = $(local-after-zip)"
	@echo "----------------------"
	@echo ">>>>> INTERNAL VARIABLE:"
	@echo "ERR_REPORT= $(ERR_REPORT)"
	@echo "OUT_SYS_PATH    = $(OUT_SYS_PATH)"
	@echo "OUT_JAR_PATH    = $(OUT_JAR_PATH)"
	@echo "OUT_APK_PATH    = $(OUT_APK_PATH)"
	@echo "ACT_PRE_ZIP     = $(ACT_PRE_ZIP)"
	@echo "ACT_PRE_ZIP     = $(ACT_AFTER_ZIP)"
	@echo "USE_ANDROID_OUT = $(USE_ANDROID_OUT)"
	@echo "RELEASE_AMIGO    = $(RELEASE_AMIGO)"
	@echo "AMIGOAPPS_MOD    = $(AMIGOAPPS_MOD)"
	@echo "amigo-apps       = $(private-amigo-apps)"
	@echo "AMIGOAPPS        = $(AMIGOAPPS)"
	@echo "OTA_BASE        = $(OTA_BASE)"
	@echo "APKTOOL_IF_RESULT_FILE = $(APKTOOL_IF_RESULT_FILE)"
	@echo "----------------------"
	@echo ">>>>> OUTPUT VARIABLE:"
	@echo "PROG    = $(PROG)"
	@echo "INFO    = $(INFO)"
	@echo "VERBOSE = $(VERBOSE)"
	@echo "hide   = $(hide)"
	@echo ">>>>> MORE VARIABLE:"
	@echo "SIGNAPKS     = $(SIGNAPKS)"
	@echo "REALLY-CLEAN = $(REALLY_CLEAN)"

# Push the generated ZIP file to phone
zip2sd: $(OUT_ZIP)
	adb shell mount /storage/extSdCard
	sleep 5
	@echo push $(OUT_ZIP) to phone sdcard
	adb shell rm -f /storage/extSdCard/$(OUT_ZIP_FILE)
	adb push $(OUT_ZIP) /storage/extSdCard/$(OUT_ZIP_FILE)
	adb reboot recovery

zip2sd-r: $(OUT_ZIP)
	adb reboot recovery
	sleep 50
	adb shell mount sdcard
	sleep 5
	@echo push $(OUT_ZIP) to phone sdcard
	adb shell rm -f /sdcard/$(OUT_ZIP_FILE)
	adb push $(OUT_ZIP) /sdcard/$(OUT_ZIP_FILE)

error-no-zipfile:
	$(error local-zip-file must be defined to specify the ZIP file)

error-android-env:
	$(error local-use-android-out set as true, should run lunch for android first)

last_target_files.zip:
	make clean
	make -e VERIFY_OTA=local-ota-update fullota
	cp $(TMP_DIR)/target_files.zip last_target_files.zip
	cp $(TMP_DIR)/fullota.zip last_fullota.zip
	make clean

verify-ota: last_target_files.zip fullota
	$(TOOL_DIR)/releasetools/ota_from_target_files -k ../build/security/testkey -i last_target_files.zip $(TMP_DIR)/target_files.zip $(TMP_DIR)/ota_update.zip
	@mv last_target_files.zip $(TMP_DIR)
	@mv last_fullota.zip $(TMP_DIR)

# target for local ota package for local debug
# 1. the previous target_file.zip is built from zipfile-ota-base and
# the location for target zip file should be specified by local-previous-target-dir
# 2. the ota is generated by make -e otabase=xxx zipfile-ota
save_previous_target_file := $(local-previous-target-dir)/target_file.$(ROM_BUILD_NUMBER).zip
use_previous_target_file  := $(local-previous-target-dir)/target_file.$(OTA_BASE).zip
zipfile-ota: $(TMP_DIR)/target_files.zip $(use_previous_target_file)
	$(TOOL_DIR)/releasetools/ota_from_target_files -k ../build/security/testkey -i $(use_previous_target_file) $(TMP_DIR)/target_files.zip $(TMP_DIR)/ota_update_$(OTA_BASE).zip
	@echo OTA package generated at: $(TMP_DIR)/ota_update_$(OTA_BASE).zip

zipfile-and-ota: zipfile-ota-base zipfile-ota

$(use_previous_target_file):
	$(info Available target files for OTA base:)
	$(info $(shell ls -Fl $(local-previous-target-dir)))
	$(error need to specify the build number as ota base: make -e OTA_BASE=build-number zipfile-ota)

zipfile-ota-base: zipfile
	@mkdir -p $(local-previous-target-dir)
	@cp $(TMP_DIR)/target_files.zip $(save_previous_target_file)
	@echo "$(save_previous_target_file) is saved as OTA-BASE"

ota-base-restore: $(use_previous_target_file)
	unzip $(use_previous_target_file) SYSTEM/framework/*framework* -d /tmp/
	unzip $(use_previous_target_file) SYSTEM/framework/services.jar -d /tmp/
	unzip $(use_previous_target_file) SYSTEM/framework/android.policy.jar -d /tmp/
	for app in $(AMIGOAPPS_MOD) $(APPS); do \
		unzip $(use_previous_target_file) SYSTEM/app/$$app.apk -d /tmp/; \
	done
	adb remount
	adb push /tmp/SYSTEM/framework/ system/framework
	adb push /tmp/SYSTEM/app/ system/app
	rm -rf /tmp/SYSTEM/framework
	rm -rf /tmp/SYSTEM/app

amigo-apps-included:
	@echo $(addsuffix .apk,$(private-amigo-apps) $(private-preinstall-apps) amigoframework-res gnframework-res)

