---
layout: post
title:  "Configure Vodafone DSL-EasyBox 802 as a router and a wifi access point"
date:   2016-09-29 21:54:46 +0000
category: post
tags: [Misc]
---

The cable modem provided by my ISP has a quite weak wifi signal strength. After being disappointed by two wifi repeaters, I turned my decommissioned DSL modem (Vodafone DSL-EasyBox 802) into a router and an extra access point. The EasyBox is connected to the cable modem via a LAN cable. The LAN cable can be extended with a pair of PowerLAN adapters, so that the EasyBox can be placed at where ever the new access point is needed.

I could not find a good how-to article on this in English, so I think maybe I can write down what I did, which might help others.

## Setup routing

1. Perform a reset of EasyBox by pressing the Reset button on the back with a pointed object (e.g., toothpick, paper clip, etc.) for at least 10 seconds with EasyBox powered on.

2. After EasyBox is restarted, connect a phone and after the drivel is over, dial the number \*8375\* on the phone. EasyBox will restart again (it reboots in the "VDSL mode").

3. Connect a LAN cable from the modem to the LAN1 port of EasyBox, and connect your PC via a LAN cable to another LAN port of EasyBox.

4. Enter the address 192.168.2.1 in the browser and login with the username root and password 123456.

5. Select Open Mode, click Next (or Continue), go to DATA, then click the WAN menu.

    <img src="https://user-images.githubusercontent.com/15970333/32409768-84c92cc8-c1b2-11e7-9309-428c99da8cac.png" >

6. Enter now at WAN1:

    * Protocol: Routing
    * Leave the IP address and so on to 0.0.0.0
    * DHCP client: checkbox selected
    * 802.1Q (1p/VLAN ID) tagging to 0

    <img src="https://user-images.githubusercontent.com/15970333/32409829-b7706960-c1b3-11e7-9ad9-f287338ca0cf.png" >

7. Unplug EasyBox and plug it back in.

After EasyBox is rebooted, the PC shall have internet connection routed through EasyBox. That can be verified by visiting a website with the PC's wifi turned off.

## Set up wifi

After that I also did the following steps:

1. Go to Password Settings under EXTRAS and change username and password

    <img src="https://user-images.githubusercontent.com/15970333/32409836-0041bb6c-c1b4-11e7-829a-b589295449be.png" >

2. Setup wifi

    <img src="https://user-images.githubusercontent.com/15970333/32409844-4d9060bc-c1b4-11e7-9ce5-02c96a076fe7.png" >

3. Disconnect the PC from the LAN port of EasyBox and connect to the SSID set in the previous step via wifi.

## References (in German)

1. [http://www.ip-phone-forum.de/showthread.php?t=222367](http://www.ip-phone-forum.de/showthread.php?t=222367)

2. [https://thomasheinz.net/EasyBox-802-als-dhcp-client-internet-uber-lan1/](https://thomasheinz.net/EasyBox-802-als-dhcp-client-internet-uber-lan1/)

3. [EasyBox 802 user manual](https://dsl.vodafone.de/hilfe/files/vfksc/pdf/VF_EasyBox_802_CD-MANUAL_Release_update_April_4_2009.pdf)
