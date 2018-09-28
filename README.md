tg-luci
Package Files & Directions required for installation of Luci. (TG789/799)
-
Step 1) Run Autoflash GUI by Mark Smith. Run this tool to obtain root access.

Step 2) Download WinSCP, set to SCP and connect to the router

Step 3) Download the install.sh script from my Github.
	Using WinSCP, transfer the script file downloaded above, to the /root directory.
	There will be 2 different options provided:
	Install.sh is the Stable Branch (Allows co-existance w/tch-nginx-gui).
	Dev Branch will require a slightly different command to run. **COMING THIS WEEKEND...HOPEFULLY...LOL**
	Make sure to run the following command so you can proceed as directed: chmod +x *.sh

If using install.sh, you can proceed to Step 6, if not, continue as per directed.
-
Step 4) Using vi, edit the scripts as per your liking, paying close attention to the sections that are hashed out, these are areas that **NEED** to be edited & will be hashed out with ##.
		Save & exit, then run the following command: chmod +x *.sh

Step 5) Before proceeding with the first reboot, please take this moment to **DOUBLE CHECK** the relevant sections you've just modified to suit your network. Otherwise you'll be locked out

Step 6) Run the script/s (Depending which ones you choose). If it's mine, it will reboot automatically. If the other scripts, you'll need to reboot before proceeding.

****************************************************************************************************************
NOTE: PLEASE ENSURE TO DO THE STEPS AS REQUESTED. DON'T ASK FOR HELP OTHERWISE. IT'S DONE THIS WAY FOR A REASON*
****************************************************************************************************************

If using install.sh, you can proceed to Step 12, if not, continue as per directed.
-
Step 7) Using vi, edit the following file: /etc/opkg.conf & check to see if the following lines have been successfully installed. If not, edit the file and add them before proceeding.
		arch all 100
		arch brcm63xx 200
		arch brcm63xx-tch 300

Step 8) Run opkg update. This is crucial for the next step, so **DON'T MISS IT**

Step 9) Now here's where the fun begins. Run the following command: opkg --force-reinstall --force-overwrite --force-checksum install *.ipk
		 This command will then forcibly install the required libraries to continue with the next step

Step 10) Run uci commit & reboot the router. This will allow a clean slate to continue. Proceed with the next step/s

Step 11) Use the following command to get luci installed: opkg update && opkg install luci luci-lib-json luci-lib-jsonc luci-lib-nixio luci-mod-rpc <---- These extra libraries are *CRITICAL*

Step 12) Run uci commit. Then reboot.

Step 13) Once it reboots, browse to the routers designated IP. Login as per usual (root/root)

Step 14) Change the root password.

Step 15) Thank me :) & enjoy Release 1 OpenWRT TG789/799. You get base functionality + Wireless. There will be minor reporting glitching on the wireless, but that will get fixed in time.
		**DON'T INSTALL EXTRA MODULES YET**. There are a few known modules which cause the router to segfault. As we get more time to experiment/add, the list will be expanded, but if you leave it as 
		it is, it will *just work*

Step 16) Ensure to run a configuration backup through Luci. Then keep it safe, so if in future you need to reinstall, its a quick restore.

Step 17) Pray for an unlocked bootloader
