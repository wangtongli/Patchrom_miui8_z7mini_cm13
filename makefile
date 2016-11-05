#
# Makefile for Nubia
#

PORT_PRODUCT := z7mini_rogue

# The original zip file, MUST be specified by each product
local-zip-file     := stockrom.zip

# The output zip file of MIUI rom, the default is porting_miui.zip if not specified
local-out-zip-file := MIUI_z7mini.zip

# the location for local-ota to save target-file
local-previous-target-dir := 

# All apps from original ZIP, but has smali files chanded
local-modified-apps := 

local-modified-jars := org.cyanogenmod.platform

# All apks from MIUI
local-miui-removed-apps := 


local-miui-modified-apps := TeleService XiaomiServiceFramework MiuiSystemUI InCallUI SecurityCoreAdd  miuisystem MiuiKeyguard

local-density := XXHDPI


# The certificate for release version
local-certificate-dir := 


# All vendor apks needed
local-phone-apps := AntHalService BasicDreams Bluetooth BluetoothExt BluetoothMidiService CertInstaller KeyChain \
	LiveWallpapers NoiseField PacProcessor PhaseBeam PhotoTable PicoTts PrintSpooler shutdownlistener Stk \
	telresources TimeService WAPPushManager \

local-phone-priv-apps := CMAudioService BackupRestoreConfirmation CarrierConfig CellBroadcastReceiver \
	CMSettingsProvider ExternalStorageProvider FusedLocation InputDevices ProxyHandler qcrilmsgtunnel \
	SharedStorageBackup Shell ThemesProvider VpnDialogs \



#include phoneapps.mk

# To include the local targets before and after zip the final ZIP file, 
# and the local-targets should:
# (1) be defined after including porting.mk if using any global variable(see porting.mk)
# (2) the name should be leaded with local- to prevent any conflict with global targets
local-pre-zip := local-pre-zip-misc
local-after-zip:= local-put-to-phone

# The local targets after the zip file is generated, could include 'zip2sd' to 
# deliver the zip file to phone, or to customize other actions

include $(PORT_BUILD)/porting.mk

# To define any local-target
#updater := $(ZIP_DIR)/META-INF/com/google/android/updater-script
#pre_install_data_packages := $(TMP_DIR)/pre_install_apk_pkgname.txt
local-pre-zip-misc:
	cp -rf other/system $(ZIP_DIR)/
	echo "#service for su" >> $(ZIP_DIR)/system/etc/init.miui.rc
	echo "service su_daemon /system/xbin/su --daemon" >> $(ZIP_DIR)/system/etc/init.miui.rc
	echo "    class main" >> $(ZIP_DIR)/system/etc/init.miui.rc
	echo "    oneshot" >> $(ZIP_DIR)/system/etc/init.miui.rc
	
	@echo goodbye! miui prebuilt binaries!
	rm -rf $(ZIP_DIR)/system/bin/app_process32_vendor
	cp -rf stockrom/system/bin/app_process32 $(ZIP_DIR)/system/bin/app_process32
	
pre-zip-misc:
	$(TOOLS_DIR)/post_process_props.py out/ZIP/system/build.prop metadata/build.prop	
