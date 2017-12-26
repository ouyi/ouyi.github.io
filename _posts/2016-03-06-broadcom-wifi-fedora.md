---
layout: post
title:  "Broadcom wifi driver on Linux Fedora 23"
date:   2016-03-06 19:54:46 +0000
last_modified_at: 2017-12-25 20:07:26
category: post
tags: [Linux]
---

**Contents**
* TOC
{:toc}
After installing Fedora 23 Linux, I had to do a few steps to get my wifi adapter working, which is a Broadcom BCM43228 card. It turns out that these steps have to be repeated each time after a kernel update.

## Short version

Those steps are automated in [this script](https://gist.github.com/ouyi/d7768d21fa9dfc6d27b0/raw/250aea83cc7b09d99c01fe41e50249c9702082e7/fedora23_broadcom_wl.sh), which can be executed as the root user:

```
su - # or `sudo su -`, depending on your Linux distro
dnf upgrade && reboot # to avoid an error while building the driver (see Step 2 in the long version)

su -
cd /var/tmp
wget https://gist.github.com/ouyi/d7768d21fa9dfc6d27b0/raw/250aea83cc7b09d99c01fe41e50249c9702082e7/fedora23_broadcom_wl.sh
chmod +x ./fedora23_broadcom_wl.sh
./fedora23_broadcom_wl.sh
```

After that I was able to onnect to my Wi-Fi network via the NetworkManager.

## Long version

The solution basically consists of three steps:

1. Download the driver

    The Linux driver can be downloaded from the [Broadcom site](https://www.broadcom.com/support/802.11). According to the [README](https://www.broadcom.com/docs/linux_sta/README_6.30.223.271.txt) The driver supports (but not limited to) these cards :

    ```
    BCM4311
    BCM4311
    BCM4311
    BCM4312
    BCM4313
    BCM4321
    BCM4321
    BCM4321
    BCM4321
    BCM4322
    BCM4322
    BCM4322
    BCM43142
    BCM43224
    BCM43225
    BCM43227
    BCM43228
    BCM4331
    BCM4360
    BCM4352
    ```

2. Build and install the driver

    Run a `dnf upgrade` and reboot first, to avoid the following error while building the driver:

    ```
    error: make[1]: *** /lib/modules/4.2.3-300.fc23.x86_64/build: No such file or directory. Stop.
    ```

3. Load the driver

    A `depmod -a` was needed to make the newly installed driver available to the modprobe command and to avoid missing dependency issues like the following:

    ```
    [ 1350.902636] wl: module license 'MIXED/Proprietary' taints kernel.
    [ 1350.902649] Disabling lock debugging due to kernel taint
    [ 1350.913297] wl: module verification failed: signature and/or required key missing - tainting kernel
    [ 1350.913486] wl: Unknown symbol cfg80211_inform_bss_frame_data (err 0)
    [ 1350.913538] wl: Unknown symbol cfg80211_scan_done (err 0)
    [ 1350.913597] wl: Unknown symbol cfg80211_disconnected (err 0)
    [ 1350.913646] wl: Unknown symbol wiphy_new_nm (err 0)
    [ 1350.913679] wl: Unknown symbol wiphy_register (err 0)
    [ 1350.913709] wl: Unknown symbol cfg80211_put_bss (err 0)
    [ 1350.913737] wl: Unknown symbol cfg80211_roamed (err 0)
    [ 1350.913767] wl: Unknown symbol cfg80211_gtk_rekey_notify (err 0)
    [ 1350.913801] wl: Unknown symbol cfg80211_ibss_joined (err 0)
    [ 1350.913836] wl: Unknown symbol cfg80211_michael_mic_failure (err 0)
    [ 1350.913865] wl: Unknown symbol cfg80211_connect_result (err 0)
    [ 1350.913901] wl: Unknown symbol wiphy_unregister (err 0)
    [ 1350.913934] wl: Unknown symbol cfg80211_get_bss (err 0)
    [ 1350.913969] wl: Unknown symbol __ieee80211_get_channel (err 0)
    [ 1350.914022] wl: Unknown symbol ieee80211_channel_to_frequency (err 0)
    [ 1350.914055] wl: Unknown symbol cfg80211_report_wowlan_wakeup (err 0)
    [ 1350.914139] wl: Unknown symbol cfg80211_inform_bss_data (err 0)
    [ 1350.914169] wl: Unknown symbol ieee80211_frequency_to_channel (err 0)
    [ 1350.914207] wl: Unknown symbol wiphy_free (err 0)
    ```

## References

The solution is based on [this page](https://onpub.com/install-broadcom-linux-wi-fi-driver-on-fedora-23-s7-a192).

[This one](http://www.cyberciti.biz/faq/fedora-linux-install-broadcom-wl-sta-wireless-driver-for-bcm43228/) does not work for me.

## Update 21st Oct 2016

Unfortunately, the recent kernel update to 4.7.7 broke the above method. The build process fails with this message:

```
cfg80211 api is prefered for this kernel version ieee80211_BAND_2ghz undeclared
```

Selecting the previous kernel version (4.5.6 in my case) from the boot menu allows me to still work with wifi.

