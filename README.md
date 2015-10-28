# Preseed
A script which will automaticly download a debian 8 netinstall iso and create a remastered hybrid iso including a preseed file for an automatic debian installation.

## Requirements
You will need access to a running debian system with internet access to use this script. This debian system can be a physical or a virtual one.

A preseed file is needed. You can use the preseed.cfg in this repository.

ATTENTION: the included preseed file will delete all content on /dev/sda on the target system.

## HowTo

Download the bash-script and make it executable.

		<code>chmod +x gen-preseed-iso.sh</code>
	
Run the script with root rights (as user root or sudo).

	# ./gen-preseed-iso.sh
	
	$ sudo ./gen-preseed-iso.sh

If the script runs fine you will find a file <code>debian-autoinstall.iso</code> in <code>/tmp</code>. This iso file is a hybrid image so you can burn it on a CD, mount it as virtual disk or copy it to an usb stick.
