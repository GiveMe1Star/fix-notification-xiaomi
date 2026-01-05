@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title WHITELIST XIAOMI + GMS/XMSF FULL (v6.4.0 - HyperOS/MIUI) - Creator: LE MINH CUONG

echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║   WHITELIST XIAOMI - 61 APP + GMS/XMSF (v6.4.0 - MENU)   ║
echo ║   GSF + XMSF + KEEPER + OTT (14 APP) + ZALO IN E ONLY    ║
echo ║   HyperOS / MIUI Compatible                              ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

:: Kiểm tra adb.exe
if not exist "adb\adb.exe" (
    echo [LOI] Khong tim thay adb\adb.exe!
    pause
    exit /b 1
)

:: Kiểm tra thiết bị - PHIÊN BẢN ĐƠN GIẢN
echo [1/9] Kiem tra ket noi...
adb\adb devices >nul 2>&1
if errorlevel 1 (
    echo [LOI] Khong ket noi duoc!
    pause
    exit /b 1
)
echo [OK] Ket noi thanh cong!
echo.
adb\adb devices
echo.

:: Kiểm tra hệ thống - PHIÊN BẢN ĐƠN GIẢN
echo [2/9] Kiem tra he thong...
set "ANDROID_VER=Unknown"
for /f "delims=" %%a in ('adb\adb shell getprop ro.build.version.release 2^>nul') do set "ANDROID_VER=%%a"
set "ANDROID_VER=!ANDROID_VER:
=!"
if not defined ANDROID_VER set "ANDROID_VER=Unknown"

:: Kiểm tra HyperOS
set "HYPEROS_VER="
for /f "delims=" %%a in ('adb\adb shell getprop ro.mi.os.version.name 2^>nul') do set "HYPEROS_VER=%%a"
set "HYPEROS_VER=!HYPEROS_VER:
=!"

:: Kiểm tra MIUI version
set "MIUI_VER="
for /f "delims=" %%a in ('adb\adb shell getprop ro.miui.ui.version.code 2^>nul') do set "MIUI_VER=%%a"
set "MIUI_VER=!MIUI_VER:
=!"

if defined HYPEROS_VER if not "!HYPEROS_VER!"=="" (
    echo Phat hien: HyperOS !HYPEROS_VER! ^(Android !ANDROID_VER!^)
) else if defined MIUI_VER if not "!MIUI_VER!"=="" (
    echo Phat hien: MIUI !MIUI_VER! ^(Android !ANDROID_VER!^)
) else (
    echo Phat hien: Android !ANDROID_VER!
)
echo.

:: ================================
:: KIỂM TRA CHINA ROM - FIX getprop (TRÁNH \r) + đa tiêu chí
:: ================================
echo [2.5/9] Kiem tra loai ROM...
set "IS_CHINA_ROM=0"
set "ROM_TYPE=Global/International"
set "CHINA_INDICATORS=0"

:: 1) region
set "ROM_REGION="
for /f "delims=" %%a in ('adb\adb shell getprop ro.miui.region 2^>nul') do set "ROM_REGION=%%a"
set "ROM_REGION=!ROM_REGION:
=!"
if not defined ROM_REGION set "ROM_REGION=Unknown"

:: 1.1) miui build region (thường chuẩn hơn)
set "MIUI_BUILD_REGION="
for /f "delims=" %%a in ('adb\adb shell getprop ro.miui.build.region 2^>nul') do set "MIUI_BUILD_REGION=%%a"
set "MIUI_BUILD_REGION=!MIUI_BUILD_REGION:
=!"
if not defined MIUI_BUILD_REGION set "MIUI_BUILD_REGION=Unknown"

:: 2) build incremental
set "BUILD_VERSION="
for /f "delims=" %%a in ('adb\adb shell getprop ro.build.version.incremental 2^>nul') do set "BUILD_VERSION=%%a"
set "BUILD_VERSION=!BUILD_VERSION:
=!"
if not defined BUILD_VERSION set "BUILD_VERSION=Unknown"

:: 3) product model
set "PRODUCT_MODEL="
for /f "delims=" %%a in ('adb\adb shell getprop ro.product.model 2^>nul') do set "PRODUCT_MODEL=%%a"
set "PRODUCT_MODEL=!PRODUCT_MODEL:
=!"
if not defined PRODUCT_MODEL set "PRODUCT_MODEL=Unknown"

:: 4) miui version name (hay chứa CNXM/Global/EEA...)
set "MIUI_VERSION_NAME="
for /f "delims=" %%a in ('adb\adb shell getprop ro.miui.ui.version.name 2^>nul') do set "MIUI_VERSION_NAME=%%a"
set "MIUI_VERSION_NAME=!MIUI_VERSION_NAME:
=!"
if not defined MIUI_VERSION_NAME set "MIUI_VERSION_NAME=Unknown"

:: Đánh giá đa tiêu chí
if /i "!ROM_REGION!"=="CN" set /a CHINA_INDICATORS+=1
if /i "!MIUI_BUILD_REGION!"=="CN" set /a CHINA_INDICATORS+=1
echo !BUILD_VERSION! | findstr /i "CN" >nul && set /a CHINA_INDICATORS+=1
echo !MIUI_VERSION_NAME! | findstr /i "CN" >nul && set /a CHINA_INDICATORS+=1
echo !PRODUCT_MODEL! | findstr /i "CHINA" >nul && set /a CHINA_INDICATORS+=1

:: Quyết định loại ROM
if !CHINA_INDICATORS! geq 2 (
    set "IS_CHINA_ROM=1"
    set "ROM_TYPE=China ROM"

    if /i "!ROM_REGION!"=="CN" (
        if /i not "!BUILD_VERSION!"=="Unknown" (
            set "ROM_TYPE=China ROM (Official - !BUILD_VERSION!)"
        ) else (
            set "ROM_TYPE=China ROM (Official)"
        )
    ) else (
        set "ROM_TYPE=China ROM (Modified/Port)"
    )
) else (
    set "IS_CHINA_ROM=0"
    if /i "!ROM_REGION!"=="CN" (
        set "ROM_TYPE=Global with CN region"
    ) else (
        set "ROM_TYPE=Global/International"
    )
)

:: Hiển thị thông tin chi tiết
echo [INFO] Loai ROM: !ROM_TYPE!
echo [INFO] Region: !ROM_REGION!
echo [INFO] MIUI Build Region: !MIUI_BUILD_REGION!
echo [INFO] Build: !BUILD_VERSION!
echo [INFO] MIUI Version Name: !MIUI_VERSION_NAME!
echo.

if "!IS_CHINA_ROM!"=="1" (
    echo [CANH BAO] PHAT HIEN ROM TRUNG QUOC - AP DUNG CHE DO DAC BIET
    echo.

    :: Xử lý China ROM nâng cao
    echo [China ROM] Disable battery optimization nang cao...
    adb\adb shell settings put global app_auto_startup_switch 1 >nul 2>&1
    adb\adb shell settings put secure adaptive_battery_management_enabled 0 >nul 2>&1
    adb\adb shell settings put global power_supersave_mode_enabled 0 >nul 2>&1
    adb\adb shell settings put global app_standby_enabled 0 >nul 2>&1

    :: Thêm cài đặt đặc biệt cho China ROM
    echo [China ROM] Cai dat che do dac biet...
    adb\adb shell settings put global background_restriction_enabled 0 >nul 2>&1
    adb\adb shell settings put secure sleep_timeout 0 >nul 2>&1

    echo [China ROM] Xu ly nang cao hoan tat!
    echo.
) else (
    echo [INFO] ROM Global/Quoc te - Che do binh thuong
    echo.
)

:: ================================
:: TẤT CẢ PACKAGE + SERVICE + PROCESS
:: ================================
set "ALL_PKGS=com.google.android.gms,com.google.android.gsf,com.google.android.gsf.login,com.google.android.syncadapters.contacts,com.google.android.syncadapters.calendar,com.xiaomi.xmsf,com.xiaomi.xmsfkeeper,com.google.android.ext.services,com.agribank.emobile,com.vnpay.bidv,com.google.android.gm,com.google.android.gm.lite,com.mbbank.mbbank,com.mservice.momotransfer,com.microsoft.office.outlook,com.microsoft.outlooklite,com.microsoft.office.outlook.beta,com.microsoft.teams,com.microsoft.teams.lite,com.microsoft.teams.beta,com.shb.SHBMBanking,vn.com.techcombank.bb.app,com.tpb.mb.gprsandroid,com.vcb,com.vietinbank.ipay,com.bplus.vtpay,com.vib.myvib,com.vnpay.app,vn.com.vpbank.mobile,com.google.android.projection.gearhead,com.android.chrome,com.chrome.beta,com.facebook.katana,com.fptplay,com.grabtaxi.passenger,com.grabtaxi.passenger.lite,com.lazada.android,jp.naver.line.android,com.shopee.vn,com.shopee.lite,com.zhiliaoapp.musically,com.vtvgo,com.google.android.youtube,com.google.android.apps.youtube.mango,com.instagram.android,com.twitter.android,com.linkedin.android,com.discord,com.facebook.orca,com.skype.raider,org.telegram.messenger,com.viber.voip,com.tencent.mm,com.whatsapp,com.whatsapp.w4b,com.zing.zalo,com.zing.zalo.lite,com.zing.zalo.pc,org.thunderdog.challegram"

set "ALL_PROCS=com.google.android.gms,com.google.android.gms.persistent,com.google.android.gms:gcm,com.google.android.gms:chimera,com.google.android.gms:unstable,com.google.android.gsf,com.google.android.gsf.login,com.google.android.syncadapters.contacts,com.google.android.syncadapters.calendar,com.xiaomi.xmsf,com.xiaomi.xmsf:push,com.xiaomi.xmsfkeeper,com.agribank.emobile,com.agribank.emobile:push,com.vnpay.bidv,com.vnpay.bidv:push,com.google.android.gm,com.google.android.gm:sync,com.google.android.gm.lite,com.mbbank.mbbank,com.mbbank.mbbank:push,com.mservice.momotransfer,com.mservice.momotransfer:push,com.microsoft.office.outlook,com.microsoft.office.outlook:push,com.microsoft.outlooklite,com.microsoft.teams,com.microsoft.teams:push,com.microsoft.teams.lite,com.microsoft.teams.beta,com.shb.SHBMBanking,com.shb.SHBMBanking:push,vn.com.techcombank.bb.app,vn.com.techcombank.bb.app:push,com.tpb.mb.gprsandroid,com.tpb.mb.gprsandroid:push,com.vcb,com.vcb:push,com.vietinbank.ipay,com.vietinbank.ipay:push,com.bplus.vtpay,com.bplus.vtpay:push,com.vib.myvib,com.vib.myvib:push,com.vnpay.app,com.vnpay.app:push,vn.com.vpbank.mobile,vn.com.vpbank.mobile:push,com.google.android.projection.gearhead,com.android.chrome,com.android.chrome:background,com.chrome.beta,com.facebook.katana,com.facebook.katana:push,com.fptplay,com.fptplay:push,com.grabtaxi.passenger,com.grabtaxi.passenger:push,com.grabtaxi.passenger.lite,com.lazada.android,com.lazada.android:push,jp.naver.line.android,jp.naver.line.android:push,com.shopee.vn,com.shopee.vn:push,com.shopee.lite,com.zhiliaoapp.musically,com.zhiliaoapp.musically:push,com.vtvgo,com.vtvgo:push,com.google.android.youtube,com.google.android.youtube:background,com.google.android.apps.youtube.mango,com.instagram.android,com.instagram.android:push,com.twitter.android,com.twitter.android:push,com.linkedin.android,com.linkedin.android:push,com.discord,com.discord:push,com.facebook.orca,com.skype.raider,com.skype.raider:push,org.telegram.messenger,org.telegram.messenger:push,com.viber.voip,com.viber.voip:push,com.tencent.mm,com.tencent.mm:push,com.whatsapp,com.whatsapp:push,com.whatsapp.w4b,com.whatsapp.w4b:push,com.zing.zalo,com.zing.zalo:push,com.zing.zalo.lite,com.zing.zalo.pc,org.thunderdog.challegram,org.thunderdog.challegram:push"

set "ALL_SVCS=com.google.android.gms.gcm.GcmService,com.google.android.gms.gcm.nts.SchedulerService,com.google.android.gms.chimera.PersistentApiService,com.google.android.gms.measurement.AppMeasurementService,com.google.android.gms.measurement.AppMeasurementJobService,com.google.android.gms.fcm.FcmSdkGmsTaskService,com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver,com.google.android.gms.auth.account.authenticator.GoogleAccountAuthenticatorService,com.google.android.gsf.gservices.GservicesValueService,com.google.android.gsf.login.LoginService,com.google.android.syncadapters.contacts.ContactsSyncAdapterService,com.google.android.syncadapters.calendar.CalendarSyncAdapterService,com.xiaomi.xmsf.push.service.XMPushService,com.xiaomi.xmsf.push.service.MIPushNotificationService,com.xiaomi.xmsf.push.service.HttpService,com.xiaomi.xmsfkeeper.XmsfKeeperService,com.agribank.emobile.push.FCMService,com.agribank.emobile.job.JobService,com.agribank.emobile.services.SyncService,com.vnpay.bidv.push.FCMService,com.vnpay.bidv.service.SyncService,com.google.android.gm.notification.GmailFirebaseMessagingService,com.google.android.gm.exchange.ExchangeService,com.google.android.gm.lite.notification.GmailFirebaseMessagingService,com.mbbank.mbbank.push.FCMService,com.mbbank.mbbank.service.SyncService,com.mservice.momotransfer.push.MoMoFirebaseMessagingService,com.mservice.momotransfer.service.SyncService,com.microsoft.office.outlook.notifications.OutlookFirebaseMessagingService,com.microsoft.office.outlook.sync.OutlookSyncService,com.microsoft.outlooklite.push.OutlookLiteFCMService,com.microsoft.office.outlook.notifications.OutlookFirebaseMessagingService,com.microsoft.teams.services.push.TeamsFirebaseMessagingService,com.microsoft.teams.services.sync.TeamsSyncService,com.microsoft.teams.lite.push.TeamsLiteFCMService,com.microsoft.teams.services.push.TeamsFirebaseMessagingService,com.shb.SHBMBanking.push.FCMService,com.shb.SHBMBanking.service.SyncService,vn.com.techcombank.bb.app.push.FCMMessagingService,vn.com.techcombank.bb.app.service.SyncService,com.tpb.mb.gprsandroid.push.TPBankFCMService,com.tpb.mb.gprsandroid.service.SyncService,com.vcb.mobilebanking.push.FCMService,com.vcb.mobilebanking.service.SyncService,com.vietinbank.ipay.push.FCMService,com.vietinbank.ipay.service.SyncService,com.bplus.vtpay.push.VTPayFCMService,com.bplus.vtpay.service.SyncService,com.vib.myvib.push.MyVibFCMService,com.vib.myvib.service.SyncService,com.vnpay.app.push.FCMService,com.vnpay.app.service.SyncService,vn.com.vpbank.mobile.push.FCMService,vn.com.vpbank.mobile.service.SyncService,com.google.android.gms.car.CarFirebaseMessagingService,org.chromium.chrome.browser.services.gcm.ChromeGcmListenerService,org.chromium.chrome.browser.notifications.NotificationService,org.chromium.chrome.browser.services.gcm.ChromeGcmListenerService,com.facebook.push.fcm.FcmListenerService,com.facebook.mqttlite.MqttService,com.facebook.rti.mqtt.common.service.MqttService,com.fptplay.service.PushService,com.fptplay.service.SyncService,com.grabtaxi.passenger.push.GrabFirebaseMessagingService,com.grabtaxi.passenger.service.SyncService,com.grabtaxi.passenger.lite.push.GrabLiteFCMService,com.lazada.android.push.LazadaFcmService,com.lazada.android.service.SyncService,jp.naver.line.android.service.PushService,jp.naver.line.android.service.SyncService,com.shopee.app.push.fcm.ShopeeFcmService,com.shopee.app.service.SyncService,com.shopee.lite.push.ShopeeLiteFCMService,com.ss.android.ugc.aweme.push.AwemeFcmService,com.ss.android.ugc.aweme.service.SyncService,com.vtvgo.service.PushService,com.vtvgo.service.SyncService,com.google.android.apps.youtube.app.notification.NotificationService,com.google.android.apps.youtube.app.background.service.YouTubeBackgroundService,com.google.android.apps.youtube.mango.notification.NotificationService,com.instagram.push.fbns.InstagramPushService,com.instagram.service.SyncService,com.twitter.android.push.TwitterFirebaseMessagingService,com.twitter.android.service.SyncService,com.linkedin.android.push.LinkedInFirebaseMessagingService,com.linkedin.android.service.SyncService,com.discord.firebase.messaging.DiscordFirebaseMessagingService,com.discord.service.SyncService,com.facebook.push.fcm.FcmListenerService,com.facebook.mqttlite.MqttService,com.facebook.rti.mqtt.common.service.MqttService,com.skype.raider.service.PushService,com.skype.raider.service.SyncService,org.telegram.messenger.FirebaseMessagingService,org.telegram.messenger.NotificationService,com.viber.voip.messages.core.push.ViberPushService,com.viber.voip.service.SyncService,com.tencent.mm.plugin.push.service.PushService,com.tencent.mm.service.SyncService,com.whatsapp.push.FcmListenerService,com.whatsapp.service.SyncService,com.whatsapp.w4b.push.FcmListenerService,com.zing.zalo.service.ZaloFirebaseMessagingService,com.zing.zalo.service.SyncService,com.zing.zalo.lite.push.ZaloLiteFCMService,com.zing.zalo.pc.service.ZaloPcPushService,org.thunderdog.challegram.service.PushService,org.thunderdog.challegram.service.SyncService"

:: ================================
:: PACKAGE + SERVICE + PROCESS
:: ================================
set "PKG_1=com.google.android.gms"
set "SVC_1=com.google.android.gms.gcm.GcmService,com.google.android.gms.gcm.nts.SchedulerService,com.google.android.gms.chimera.PersistentApiService,com.google.android.gms.measurement.AppMeasurementService,com.google.android.gms.measurement.AppMeasurementJobService,com.google.android.gms.fcm.FcmSdkGmsTaskService,com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver,com.google.android.gms.auth.account.authenticator.GoogleAccountAuthenticatorService"
set "PROC_1=%PKG_1%,%PKG_1%.persistent,%PKG_1%:gcm,%PKG_1%:chimera,%PKG_1%:unstable"

set "PKG_2=com.google.android.gsf"
set "SVC_2=com.google.android.gsf.gservices.GservicesValueService"
set "PROC_2=%PKG_2%"

set "PKG_3=com.google.android.gsf.login"
set "SVC_3=com.google.android.gsf.login.LoginService"
set "PROC_3=%PKG_3%"

set "PKG_4=com.google.android.syncadapters.contacts"
set "SVC_4=com.google.android.syncadapters.contacts.ContactsSyncAdapterService"
set "PROC_4=%PKG_4%"

set "PKG_5=com.google.android.syncadapters.calendar"
set "SVC_5=com.google.android.syncadapters.calendar.CalendarSyncAdapterService"
set "PROC_5=%PKG_5%"

set "PKG_6=com.xiaomi.xmsf"
set "SVC_6=com.xiaomi.xmsf.push.service.XMPushService,com.xiaomi.xmsf.push.service.MIPushNotificationService,com.xiaomi.xmsf.push.service.HttpService"
set "PROC_6=%PKG_6%,%PKG_6%:push"

set "PKG_7=com.xiaomi.xmsfkeeper"
set "SVC_7=com.xiaomi.xmsfkeeper.XmsfKeeperService"
set "PROC_7=%PKG_7%"

set "PKG_EXT=com.google.android.ext.services"

set "PKG_8=com.agribank.emobile"
set "SVC_8=com.agribank.emobile.push.FCMService,com.agribank.emobile.job.JobService,com.agribank.emobile.services.SyncService"
set "PROC_8=%PKG_8%,%PKG_8%:push"

set "PKG_9=com.google.android.projection.gearhead"
set "SVC_9=com.google.android.gms.car.CarFirebaseMessagingService"
set "PROC_9=%PKG_9%"

set "PKG_10=com.vnpay.bidv"
set "SVC_10=com.vnpay.bidv.push.FCMService,com.vnpay.bidv.service.SyncService"
set "PROC_10=%PKG_10%,%PKG_10%:push"

set "PKG_11=com.android.chrome"
set "SVC_11=org.chromium.chrome.browser.services.gcm.ChromeGcmListenerService,org.chromium.chrome.browser.notifications.NotificationService"
set "PROC_11=%PKG_11%,%PKG_11%:background"

set "PKG_12=com.chrome.beta"
set "SVC_12=org.chromium.chrome.browser.services.gcm.ChromeGcmListenerService"
set "PROC_12=%PKG_12%"

set "PKG_13=com.discord"
set "SVC_13=com.discord.firebase.messaging.DiscordFirebaseMessagingService,com.discord.service.SyncService"
set "PROC_13=%PKG_13%,%PKG_13%:push"

set "PKG_14=com.facebook.katana"
set "SVC_14=com.facebook.push.fcm.FcmListenerService,com.facebook.mqttlite.MqttService,com.facebook.rti.mqtt.common.service.MqttService"
set "PROC_14=%PKG_14%,%PKG_14%:push"

set "PKG_15=com.fptplay"
set "SVC_15=com.fptplay.service.PushService,com.fptplay.service.SyncService"
set "PROC_15=%PKG_15%,%PKG_15%:push"

set "PKG_16=com.google.android.gm"
set "SVC_16=com.google.android.gm.notification.GmailFirebaseMessagingService,com.google.android.gm.exchange.ExchangeService"
set "PROC_16=%PKG_16%,%PKG_16%:sync"

set "PKG_17=com.google.android.gm.lite"
set "SVC_17=com.google.android.gm.lite.notification.GmailFirebaseMessagingService"
set "PROC_17=%PKG_17%"

set "PKG_18=com.grabtaxi.passenger"
set "SVC_18=com.grabtaxi.passenger.push.GrabFirebaseMessagingService,com.grabtaxi.passenger.service.SyncService"
set "PROC_18=%PKG_18%,%PKG_18%:push"

set "PKG_19=com.grabtaxi.passenger.lite"
set "SVC_19=com.grabtaxi.passenger.lite.push.GrabLiteFCMService"
set "PROC_19=%PKG_19%"

set "PKG_20=com.lazada.android"
set "SVC_20=com.lazada.android.push.LazadaFcmService,com.lazada.android.service.SyncService"
set "PROC_20=%PKG_20%,%PKG_20%:push"

set "PKG_21=jp.naver.line.android"
set "SVC_21=jp.naver.line.android.service.PushService,jp.naver.line.android.service.SyncService"
set "PROC_21=%PKG_21%,%PKG_21%:push"

set "PKG_22=com.mbbank.mbbank"
set "SVC_22=com.mbbank.mbbank.push.FCMService,com.mbbank.mbbank.service.SyncService"
set "PROC_22=%PKG_22%,%PKG_22%:push"

set "PKG_23=com.facebook.orca"
set "SVC_23=com.facebook.push.fcm.FcmListenerService,com.facebook.mqttlite.MqttService,com.facebook.rti.mqtt.common.service.MqttService"
set "PROC_23=%PKG_23%,%PKG_23%:push"

set "PKG_24=com.mservice.momotransfer"
set "SVC_24=com.mservice.momotransfer.push.MoMoFirebaseMessagingService,com.mservice.momotransfer.service.SyncService"
set "PROC_24=%PKG_24%,%PKG_24%:push"

set "PKG_25=com.microsoft.office.outlook"
set "SVC_25=com.microsoft.office.outlook.notifications.OutlookFirebaseMessagingService,com.microsoft.office.outlook.sync.OutlookSyncService"
set "PROC_25=%PKG_25%,%PKG_25%:push"

set "PKG_26=com.microsoft.outlooklite"
set "SVC_26=com.microsoft.outlooklite.push.OutlookLiteFCMService"
set "PROC_26=%PKG_26%"

set "PKG_27=com.microsoft.office.outlook.beta"
set "SVC_27=com.microsoft.office.outlook.notifications.OutlookFirebaseMessagingService"
set "PROC_27=%PKG_27%"

set "PKG_28=com.microsoft.teams"
set "SVC_28=com.microsoft.teams.services.push.TeamsFirebaseMessagingService,com.microsoft.teams.services.sync.TeamsSyncService"
set "PROC_28=%PKG_28%,%PKG_28%:push"

set "PKG_29=com.microsoft.teams.lite"
set "SVC_29=com.microsoft.teams.lite.push.TeamsLiteFCMService"
set "PROC_29=%PKG_29%"

set "PKG_30=com.microsoft.teams.beta"
set "SVC_30=com.microsoft.teams.services.push.TeamsFirebaseMessagingService"
set "PROC_30=%PKG_30%"

set "PKG_31=com.shb.SHBMBanking"
set "SVC_31=com.shb.SHBMBanking.push.FCMService,com.shb.SHBMBanking.service.SyncService"
set "PROC_31=%PKG_31%,%PKG_31%:push"

set "PKG_32=com.shopee.vn"
set "SVC_32=com.shopee.app.push.fcm.ShopeeFcmService,com.shopee.app.service.SyncService"
set "PROC_32=%PKG_32%,%PKG_32%:push"

set "PKG_33=com.shopee.lite"
set "SVC_33=com.shopee.lite.push.ShopeeLiteFCMService"
set "PROC_33=%PKG_33%"

set "PKG_34=com.skype.raider"
set "SVC_34=com.skype.raider.service.PushService,com.skype.raider.service.SyncService"
set "PROC_34=%PKG_34%,%PKG_34%:push"

set "PKG_35=vn.com.techcombank.bb.app"
set "SVC_35=vn.com.techcombank.bb.app.push.FCMMessagingService,vn.com.techcombank.bb.app.service.SyncService"
set "PROC_35=%PKG_35%,%PKG_35%:push"

set "PKG_36=org.telegram.messenger"
set "SVC_36=org.telegram.messenger.FirebaseMessagingService,org.telegram.messenger.NotificationService"
set "PROC_36=%PKG_36%,%PKG_36%:push"

set "PKG_37=com.zhiliaoapp.musically"
set "SVC_37=com.ss.android.ugc.aweme.push.AwemeFcmService,com.ss.android.ugc.aweme.service.SyncService"
set "PROC_37=%PKG_37%,%PKG_37%:push"

set "PKG_38=com.tpb.mb.gprsandroid"
set "SVC_38=com.tpb.mb.gprsandroid.push.TPBankFCMService,com.tpb.mb.gprsandroid.service.SyncService"
set "PROC_38=%PKG_38%,%PKG_38%:push"

set "PKG_39=com.vcb"
set "SVC_39=com.vcb.mobilebanking.push.FCMService,com.vcb.mobilebanking.service.SyncService"
set "PROC_39=%PKG_39%,%PKG_39%:push"

set "PKG_40=com.vietinbank.ipay"
set "SVC_40=com.vietinbank.ipay.push.FCMService,com.vietinbank.ipay.service.SyncService"
set "PROC_40=%PKG_40%,%PKG_40%:push"

set "PKG_41=com.bplus.vtpay"
set "SVC_41=com.bplus.vtpay.push.VTPayFCMService,com.bplus.vtpay.service.SyncService"
set "PROC_41=%PKG_41%,%PKG_41%:push"

set "PKG_42=com.vib.myvib"
set "SVC_42=com.vib.myvib.push.MyVibFCMService,com.vib.myvib.service.SyncService"
set "PROC_42=%PKG_42%,%PKG_42%:push"

set "PKG_43=com.viber.voip"
set "SVC_43=com.viber.voip.messages.core.push.ViberPushService,com.viber.voip.service.SyncService"
set "PROC_43=%PKG_43%,%PKG_43%:push"

set "PKG_46=com.vnpay.app"
set "SVC_46=com.vnpay.app.push.FCMService,com.vnpay.app.service.SyncService"
set "PROC_46=%PKG_46%,%PKG_46%:push"

set "PKG_47=vn.com.vpbank.mobile"
set "SVC_47=vn.com.vpbank.mobile.push.FCMService,vn.com.vpbank.mobile.service.SyncService"
set "PROC_47=%PKG_47%,%PKG_47%:push"

set "PKG_48=com.vtvgo"
set "SVC_48=com.vtvgo.service.PushService,com.vtvgo.service.SyncService"
set "PROC_48=%PKG_48%,%PKG_48%:push"

set "PKG_49=com.tencent.mm"
set "SVC_49=com.tencent.mm.plugin.push.service.PushService,com.tencent.mm.service.SyncService"
set "PROC_49=%PKG_49%,%PKG_49%:push"

set "PKG_50=com.whatsapp"
set "SVC_50=com.whatsapp.push.FcmListenerService,com.whatsapp.service.SyncService"
set "PROC_50=%PKG_50%,%PKG_50%:push"

set "PKG_51=com.whatsapp.w4b"
set "SVC_51=com.whatsapp.w4b.push.FcmListenerService"
set "PROC_51=%PKG_51%,%PKG_51%:push"

set "PKG_53=com.google.android.youtube"
set "SVC_53=com.google.android.apps.youtube.app.notification.NotificationService,com.google.android.apps.youtube.app.background.service.YouTubeBackgroundService"
set "PROC_53=%PKG_53%,%PKG_53%:background"

set "PKG_54=com.google.android.apps.youtube.mango"
set "SVC_54=com.google.android.apps.youtube.mango.notification.NotificationService"
set "PROC_54=%PKG_54%"

set "PKG_55=com.zing.zalo"
set "SVC_55=com.zing.zalo.service.ZaloFirebaseMessagingService,com.zing.zalo.service.SyncService"
set "PROC_55=%PKG_55%,%PKG_55%:push"

set "PKG_56=com.zing.zalo.lite"
set "SVC_56=com.zing.zalo.lite.push.ZaloLiteFCMService"
set "PROC_56=%PKG_56%"

set "PKG_57=com.instagram.android"
set "SVC_57=com.instagram.push.fbns.InstagramPushService,com.instagram.service.SyncService"
set "PROC_57=%PKG_57%,%PKG_57%:push"

set "PKG_58=com.twitter.android"
set "SVC_58=com.twitter.android.push.TwitterFirebaseMessagingService,com.twitter.android.service.SyncService"
set "PROC_58=%PKG_58%,%PKG_58%:push"

set "PKG_59=com.linkedin.android"
set "SVC_59=com.linkedin.android.push.LinkedInFirebaseMessagingService,com.linkedin.android.service.SyncService"
set "PROC_59=%PKG_59%,%PKG_59%:push"

set "PKG_60=com.zing.zalo.pc"
set "SVC_60=com.zing.zalo.pc.service.ZaloPcPushService"
set "PROC_60=%PKG_60%"

set "PKG_61=org.thunderdog.challegram"
set "SVC_61=org.thunderdog.challegram.service.PushService,org.thunderdog.challegram.service.SyncService"
set "PROC_61=%PKG_61%"

:: ================================
:: MENU
:: ================================
:menu
cls
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                WHITELIST THEO APP HOẶC TẤT CẢ             ║
echo ║             (C) 2026 - LE MINH CUONG - All Rights Reserved    ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo DANH SÁCH APP:
echo.

echo   1. Google Services          17. Gmail Go                33. Shopee Lite
echo   2. Google Framework         18. Grab Superapp           34. Skype
echo   3. Google Account           19. Grab Lite               35. Techcombank
echo   4. Contacts Sync            20. Lazada                  36. Telegram
echo   5. Calendar Sync            21. Line                    37. TikTok
echo   6. Xiaomi Services          22. MB Bank                 38. TPBank Mobile
echo   7. XMSF Keeper              23. Messenger               39. Vietcombank
echo   8. Agribank                 24. MoMo Wallet             40. VietinBank
echo   9. Android Auto             25. Outlook                 41. ViettelPay
echo  10. BIDV SmartBanking        26. Outlook Lite            42. VIB MyVIB
echo  11. Chrome                   27. Outlook Beta            43. Viber
echo  12. Chrome Beta              28. Teams                   46. VNPAY
echo  13. Discord                  29. Teams Lite              47. VPBank NEO
echo  14. Facebook                 30. Teams Beta              48. VTV Go
echo  15. FPT Play                 31. SHB Mobile              49. WeChat
echo  16. Gmail                    32. Shopee VN               50. WhatsApp

echo.
echo  51. WhatsApp Business        56. Zalo Lite               59. LinkedIn
echo  53. YouTube                  57. Instagram               60. Zalo PC
echo  54. YouTube Go               58. Twitter (X)             61. Telegram X
echo  55. Zalo

echo.
echo Vi du:
echo   0            - TAT CA
echo   1 2 3        - Google Services + Framework + Account
echo   8 22 24      - Agribank + MB Bank + MoMo
echo   55 36 13     - Zalo + Telegram + Discord
echo   14 57 58     - Facebook + Instagram + Twitter
echo   X            - Thoat
echo.

set "rt_list="
set "power_pkg_list="
set "power_proc_list="
set "power_svc_list="
set "selected_apps="

set /p choice=Nhap so app (cach nhau boi dau cach): 

if /i "%choice%"=="X" exit /b 0

if "%choice%"=="0" (
    set "rt_list=%ALL_PKGS%"
    set "power_pkg_list=%ALL_PKGS%"
    set "power_proc_list=%ALL_PROCS%"
    set "power_svc_list=%ALL_SVCS%"
    goto apply
)

:: lọc input chỉ nhận số
for %%i in (%choice%) do (
    echo %%i | findstr /r "^[0-9][0-9]*$" >nul && set "selected_apps=!selected_apps! %%i"
)

if not defined selected_apps (
    echo [LOI] Vui long nhap dung!
    timeout /t 2 >nul
    goto menu
)

:: Xử lý app riêng
for %%a in (%selected_apps%) do (
    if %%a==1  call :add_app "%PKG_1%" "%PKG_EXT%" "%SVC_1%" "%PROC_1%"
    if %%a==2  call :add_app "%PKG_2%" "" "%SVC_2%" "%PROC_2%"
    if %%a==3  call :add_app "%PKG_3%" "" "%SVC_3%" "%PROC_3%"
    if %%a==4  call :add_app "%PKG_4%" "" "%SVC_4%" "%PROC_4%"
    if %%a==5  call :add_app "%PKG_5%" "" "%SVC_5%" "%PROC_5%"
    if %%a==6  call :add_app "%PKG_6%" "" "%SVC_6%" "%PROC_6%"
    if %%a==7  call :add_app "%PKG_7%" "" "%SVC_7%" "%PROC_7%"
    if %%a==8  call :add_app "%PKG_8%" "" "%SVC_8%" "%PROC_8%"
    if %%a==9  call :add_app "%PKG_9%" "" "%SVC_9%" "%PROC_9%"
    if %%a==10 call :add_app "%PKG_10%" "" "%SVC_10%" "%PROC_10%"
    if %%a==11 call :add_app "%PKG_11%" "" "%SVC_11%" "%PROC_11%"
    if %%a==12 call :add_app "%PKG_12%" "" "%SVC_12%" "%PROC_12%"
    if %%a==13 call :add_app "%PKG_13%" "" "%SVC_13%" "%PROC_13%"
    if %%a==14 call :add_app "%PKG_14%" "" "%SVC_14%" "%PROC_14%"
    if %%a==15 call :add_app "%PKG_15%" "" "%SVC_15%" "%PROC_15%"
    if %%a==16 call :add_app "%PKG_16%" "" "%SVC_16%" "%PROC_16%"
    if %%a==17 call :add_app "%PKG_17%" "" "%SVC_17%" "%PROC_17%"
    if %%a==18 call :add_app "%PKG_18%" "" "%SVC_18%" "%PROC_18%"
    if %%a==19 call :add_app "%PKG_19%" "" "%SVC_19%" "%PROC_19%"
    if %%a==20 call :add_app "%PKG_20%" "" "%SVC_20%" "%PROC_20%"
    if %%a==21 call :add_app "%PKG_21%" "" "%SVC_21%" "%PROC_21%"
    if %%a==22 call :add_app "%PKG_22%" "" "%SVC_22%" "%PROC_22%"
    if %%a==23 call :add_app "%PKG_23%" "" "%SVC_23%" "%PROC_23%"
    if %%a==24 call :add_app "%PKG_24%" "" "%SVC_24%" "%PROC_24%"
    if %%a==25 call :add_app "%PKG_25%" "" "%SVC_25%" "%PROC_25%"
    if %%a==26 call :add_app "%PKG_26%" "" "%SVC_26%" "%PROC_26%"
    if %%a==27 call :add_app "%PKG_27%" "" "%SVC_27%" "%PROC_27%"
    if %%a==28 call :add_app "%PKG_28%" "" "%SVC_28%" "%PROC_28%"
    if %%a==29 call :add_app "%PKG_29%" "" "%SVC_29%" "%PROC_29%"
    if %%a==30 call :add_app "%PKG_30%" "" "%SVC_30%" "%PROC_30%"
    if %%a==31 call :add_app "%PKG_31%" "" "%SVC_31%" "%PROC_31%"
    if %%a==32 call :add_app "%PKG_32%" "" "%SVC_32%" "%PROC_32%"
    if %%a==33 call :add_app "%PKG_33%" "" "%SVC_33%" "%PROC_33%"
    if %%a==34 call :add_app "%PKG_34%" "" "%SVC_34%" "%PROC_34%"
    if %%a==35 call :add_app "%PKG_35%" "" "%SVC_35%" "%PROC_35%"
    if %%a==36 call :add_app "%PKG_36%" "" "%SVC_36%" "%PROC_36%"
    if %%a==37 call :add_app "%PKG_37%" "" "%SVC_37%" "%PROC_37%"
    if %%a==38 call :add_app "%PKG_38%" "" "%SVC_38%" "%PROC_38%"
    if %%a==39 call :add_app "%PKG_39%" "" "%SVC_39%" "%PROC_39%"
    if %%a==40 call :add_app "%PKG_40%" "" "%SVC_40%" "%PROC_40%"
    if %%a==41 call :add_app "%PKG_41%" "" "%SVC_41%" "%PROC_41%"
    if %%a==42 call :add_app "%PKG_42%" "" "%SVC_42%" "%PROC_42%"
    if %%a==43 call :add_app "%PKG_43%" "" "%SVC_43%" "%PROC_43%"
    if %%a==46 call :add_app "%PKG_46%" "" "%SVC_46%" "%PROC_46%"
    if %%a==47 call :add_app "%PKG_47%" "" "%SVC_47%" "%PROC_47%"
    if %%a==48 call :add_app "%PKG_48%" "" "%SVC_48%" "%PROC_48%"
    if %%a==49 call :add_app "%PKG_49%" "" "%SVC_49%" "%PROC_49%"
    if %%a==50 call :add_app "%PKG_50%" "" "%SVC_50%" "%PROC_50%"
    if %%a==51 call :add_app "%PKG_51%" "" "%SVC_51%" "%PROC_51%"
    if %%a==53 call :add_app "%PKG_53%" "" "%SVC_53%" "%PROC_53%"
    if %%a==54 call :add_app "%PKG_54%" "" "%SVC_54%" "%PROC_54%"
    if %%a==55 call :add_app "%PKG_55%" "" "%SVC_55%" "%PROC_55%"
    if %%a==56 call :add_app "%PKG_56%" "" "%SVC_56%" "%PROC_56%"
    if %%a==57 call :add_app "%PKG_57%" "" "%SVC_57%" "%PROC_57%"
    if %%a==58 call :add_app "%PKG_58%" "" "%SVC_58%" "%PROC_58%"
    if %%a==59 call :add_app "%PKG_59%" "" "%SVC_59%" "%PROC_59%"
    if %%a==60 call :add_app "%PKG_60%" "" "%SVC_60%" "%PROC_60%"
    if %%a==61 call :add_app "%PKG_61%" "" "%SVC_61%" "%PROC_61%"
)

goto apply

:: ================================
:: HÀM THÊM APP (FIX: check trùng + split PROC theo dấu phẩy)
:: ================================
:add_app
set "pkg1=%~1"
set "pkg2=%~2"
set "svc=%~3"
set "proc=%~4"

:: --- ADD PKG1 ---
if defined pkg1 if not "%pkg1%"=="" (
    echo(,!rt_list!, | findstr /i /c:",%pkg1%," >nul || (
        set "rt_list=!rt_list!%pkg1%,"
        set "power_pkg_list=!power_pkg_list!%pkg1%,"
    )
)

:: --- ADD PKG2 (optional) ---
if defined pkg2 if not "%pkg2%"=="" (
    echo(,!rt_list!, | findstr /i /c:",%pkg2%," >nul || (
        set "rt_list=!rt_list!%pkg2%,"
        set "power_pkg_list=!power_pkg_list!%pkg2%,"
    )
)

:: --- ADD PROC LIST (CSV -> split by comma) ---
if defined proc if not "%proc%"=="" (
    for %%p in (%proc:,= %) do (
        echo(,!power_proc_list!, | findstr /i /c:",%%p," >nul || (
            set "power_proc_list=!power_proc_list!%%p,"
        )
    )
)

:: --- ADD SVC LIST (CSV -> split by comma) ---
if defined svc if not "%svc%"=="" (
    for %%s in (%svc:,= %) do (
        echo(,!power_svc_list!, | findstr /i /c:",%%s," >nul || (
            set "power_svc_list=!power_svc_list!%%s,"
        )
    )
)

goto :eof

:: ================================
:: ÁP DỤNG (FIX: chỉ cắt dấu phẩy cuối nếu có)
:: ================================
:apply
if not defined rt_list (
    echo [LOI] Chua chon ung dung nao!
    pause
    goto menu
)

:: Cắt dấu phẩy cuối CHỈ NẾU có (tránh cắt mất ký tự khi chọn 0)
if "!rt_list:~-1!"=="," set "rt_list=!rt_list:~0,-1!"
if "!power_pkg_list:~-1!"=="," set "power_pkg_list=!power_pkg_list:~0,-1!"
if "!power_proc_list:~-1!"=="," set "power_proc_list=!power_proc_list:~0,-1!"
if "!power_svc_list:~-1!"=="," set "power_svc_list=!power_svc_list:~0,-1!"

echo.
echo [3/9] rt_pkg_white_list...
adb\adb shell settings put system rt_pkg_white_list "!rt_list!" >nul 2>&1

echo [4/9] power_pkg_white_list...
adb\adb shell settings put system power_pkg_white_list "!power_pkg_list!" >nul 2>&1

echo [5/9] power_proc_white_list...
adb\adb shell settings put system power_proc_white_list "!power_proc_list!" >nul 2>&1

echo [6/9] power_service_white_list...
adb\adb shell settings put system power_service_white_list "!power_svc_list!" >nul 2>&1

echo [7/9] deviceidle whitelist...
for %%p in (!power_pkg_list:,= !) do (
    adb\adb shell dumpsys deviceidle whitelist +%%p >nul 2>&1
)

:: ================================
:: XỬ LÝ BỔ SUNG CHO CHINA ROM (FIX if + tránh settings put đè liên tục)
:: ================================
if "!IS_CHINA_ROM!"=="1" (
    echo [7.5/9] Xu ly bo sung cho China ROM...

    :: Gợi ý: set 1 lần thay vì set từng app (tránh bị ghi đè)
    adb\adb shell settings put system battery_optimization_whitelist_apps "!power_pkg_list!" >nul 2>&1

    :: Enable app (nếu có)
    for %%p in (!power_pkg_list:,= !) do (
        adb\adb shell pm enable %%p >nul 2>&1
    )

    :: Disable thêm các tính năng tiết kiệm pin
    adb\adb shell settings put global app_standby_enabled 0 >nul 2>&1
    adb\adb shell settings put secure adaptive_battery_management_enabled 0 >nul 2>&1
    adb\adb shell settings put global power_supersave_mode_enabled 0 >nul 2>&1

    :: Set standby bucket active
    echo [China ROM] Enabling auto-start for selected apps...
    for %%p in (!power_pkg_list:,= !) do (
        adb\adb shell am set-standby-bucket %%p active >nul 2>&1
    )

    echo [China ROM] Xu ly bo sung hoan tat!
)

:: ================================
:: GMS CHECKIN MENU
:: ================================
:gms_checkin_menu
cls
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║            GMS CHECK-IN TIMEOUT - TỐI ƯU THÔNG BÁO         ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo   [1] 1 phut   [2] 2 phut   [3] 3 phut (TOI UU)
echo   [4] 4 phut   [5] 5 phut   [6] 6 phut
echo   [0] KHONG BAT    [X] THOAT
echo.

set "timeout_min="
set /p gms_choice=Nhap: 

if /i "%gms_choice%"=="X" goto complete
if "%gms_choice%"=="0" goto complete

if "%gms_choice%"=="1" set "timeout_min=1"
if "%gms_choice%"=="2" set "timeout_min=2"
if "%gms_choice%"=="3" set "timeout_min=3"
if "%gms_choice%"=="4" set "timeout_min=4"
if "%gms_choice%"=="5" set "timeout_min=5"
if "%gms_choice%"=="6" set "timeout_min=6"

if not defined timeout_min (
    echo [LOI] Nhap sai!
    timeout /t 2 >nul
    goto gms_checkin_menu
)

echo [8/9] Dat gms_checkin_timeout_min = !timeout_min! phut...
adb\adb shell settings put global gms_checkin_timeout_min !timeout_min! >nul 2>&1
adb\adb shell settings put global gms_checkin_enabled 1 >nul 2>&1
echo [OK] Hoan tat!

:complete
echo.
echo [9/9] HOAN TAT! KHOI DONG LAI MAY DE AP DUNG.

if "!IS_CHINA_ROM!"=="1" (
    echo.
    echo ════════════════════════════════════════════════
    echo    LƯU Ý QUAN TRỌNG CHO CHINA ROM:
    echo ════════════════════════════════════════════════
    echo.
    echo Sau khi khoi dong, can kiem tra:
    echo 1. Vao Settings -> Apps -> Chon tung app da whitelist
    echo 2. Chon "Battery saver" -> "No restrictions"
    echo 3. Bat "Auto-start" trong App settings
    echo 4. Kiem tra thong bao co hoat dong khong
    echo.
)

set /p reboot=Khoi dong lai? (y/N): 
if /i "%reboot%"=="y" (
    adb\adb devices | findstr /r /c:"device$" >nul
    if errorlevel 1 (
        echo [LOI] Khong tim thay thiet bi ADB (device). Hay rut/cam lai cap, mo khoa man hinh, chap nhan USB debugging.
    ) else (
        adb\adb reboot
    )
)


echo.
echo                (C) 2026 - LE MINH CUONG - All Rights Reserved
echo.
pause
exit /b 0
