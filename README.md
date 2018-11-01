# tg-luci: LuCI GUI for Technicolor Modems.
## Tested Working Models:
<ul>
<li>TG799vac</li>
<li>TG789vac v2</li>
</ul>

## Disclamer
<b>If you manage to make your hardware 'inoperable' the creator and contributors DO NOT take any responsibility. If you manage to make your hardware 'inoperable' by not following the instructions DO NOT ask for help.</b>

### Using Install.sh
<ol type="1">
	<li>Run Autoflash GUI by Mark Smith. Run this tool to obtain root access.</li>
<br>	
	<li>Download WinSCP, set to SCP and connect to the router</li>
<br>
	<li>Download the install.sh script from my Github.</li>
<br>
	<li>Using WinSCP, transfer the script file downloaded above, to the /root directory.</li>
 	 There will be 2 different options provided:
	  Install.sh is the Stable Branch (Allows co-existance w/tch-nginx-gui). Dev Branch will require a slightly different command 		to run.     **COMING THIS WEEKEND...HOPEFULLY...LOL**
 	 <b>Make sure to run the following command so you can proceed as directed: chmod +x *.sh</b>
<br>
	<li>Run the following command: chmod +x *.sh</li>
<br>
	<li>Run install.sh: $ /root/install.sh && reboot</li>
<br>
	<li>Once it reboots, browse to the routers IP address and add on the port: 9080<br>
		eg. http://x.x.x.x:9080
	</li>
<br>
	<li>Change the root password.</li>
<br>
	<li>Thank me :) & enjoy Release 1 OpenWRT TG789/799. You get base functionality + Wireless. There will be minor 			reporting glitching on the wireless, but that will get fixed in time.<br>
	**DON'T INSTALL EXTRA MODULES YET**.<br> There are a few known modules which cause the router to segfault. As we get 			more time to experiment/add, the list will be expanded, but if you leave it as it is, it will *just work*</li>
<br>
	<li>Ensure to run a configuration backup through Luci. Then keep it safe, so if in future you need to reinstall, its a quick 		restore.</li>
<br>
	<li>Pray for an unlocked bootloader</li>
</ol>

## Modules found to cause segfault (Will update as more are known):
<ul>
<li>luci-app-sqm</li>
</ul>



