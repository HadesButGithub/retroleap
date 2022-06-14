# retroleap

Retroleap is a custom firmware for supported Leapster devices to run retro game emulators on your Leapster device.

-------------------------------------------------------------------------------

## Prerequisites
1. This will overwrite the stock firmware on your Leapster device, including save files. Saves cannot be backed up.
2. The installation requires a Linux desktop. WSL will not work, nor will live USBs. VMware Workstation seems to work the best if using a VM.

## Installation on Leapster Explorer

### 1. Install the necessary dependencies:
On ubuntu/debian/etc: `sudo apt install sg3-utils git python`

### 2. Clone sshflash to your PC:
`git clone https://github.com/mac2612/sshflash.git
cd sshflash`

### 3. Download the latest release
https://github.com/mac2612/retroleap/releases

### 4. Extract the release file into the sshflash directory. 
You should now have the uImage, rootfs.ubifs, and surgeon_zImage files in your sshflash directory.

### 5. Enter Surgeon Mode
Plug your Leapster into a USB port on your PC. Turn it on while holding the L and R shoulder buttons. 
You should see an image of a leapster connected to a PC on the leapster's screen. If you see a LeapFrog logo, power off and try again. 
If using VMware, pass the LeapFrog through to the VM when prompted.

### 6. Run sshflash:
./remote_flash.sh

### 7. Wait...
sshflash will do it's thing. If using VMware, make sure to allow any new devices into the VM.

### 8. Finalising
Once the installation completes, your device should reboot into Retroleap!

## Tested Operating Systems
This guide has been tested on Ubuntu 18.04, 18.10, and Pop!OS 21.10.


Button Layout:
On the LeapsterGS:
-A/B/Pause/Question buttons - B/A/X/Y
-L/R shoulders - L/R
-Volume down/up - select/start
-Home button - modifier key for retroarch stuff
-Home + Question - Go back to retroarch menu when in an emulator
-Home + vol up / down - Volume up/down
-Home + L shoulder - Save emulator state
-Home + R shoulder - Load emulator state
-Power - Power off. Quick press for graceful power-off, long press for force-shutdown.

On the LeapPad2:
LeapPad2 has quite a limited button layout, so it may not be good for systems with a lot of buttons like SNES.
-Note that the D-pad is rotated to match the orientation of retroarch (i.e. left arrow is up, etc)
-Vol down/up - B/A
-Down arrow key - Select (doubles as the normal down arrow key).
-Home button - Start, and also retroarch modifier key
-Home button + Up arrow - go back to retroarch menu when in an emulator
-Home button + left arrow - Save emulator state
-Home button + right arrow - Load emulator state
-Home button + Volume up/down - Volume up/down


Default Cores:

atari800 - a tweaked atari800 emulator modified for leapster by JabberwockPL
catsfc - SNES emulator. Performance is alright depending on the game.
fceumm - NES emulator, good speed and fairly accurate.
gpsp - GBA emulator. Runs well; you need to put your GBA bios at /roms/gba_bios.bin on the device (see 'Adding ROMs')
imame4all - MAME, performance depends on the game. 
picodrive - Genesis emulator, runs well on the games I've tried.
pocketsnes - SNES emulator, runs some games well but slow on others.
quicknes - NES emulator, low accuracy but very fast.


Adding ROMs:

When you attach a booted leapster device running retroleap, it will show up as a network interface.
Retroleap will give your PC an IP on this interface in the 169.254.6.X space. The leapster is accessible on 169.254.6.1, using the private key supplied with sshflash.

To add ROMs, create the directory structure that you prefer using SSH - it should be within /roms in order to get full use of the flash memory in the device.

Then, use scp to move ROMs into the directory you just made.

For example:

ssh -i ~/sshflash/keys/id_rsa root@169.254.6.1 'mkdir /roms/nes'
scp -i ~/sshflash/keys/id_rsa /home/foobar/my_awesome_homebrew.nes root@169.254.6.1:/roms/nes

You can use df -h to see how much space you have available:

ssh -i ~/sshflash/keys/id_rsa root@169.254.6.1 'df -h /roms'


Emergency:
If you're stuck and your device is in a weird state, you can always go back to the stock leapster OS by booting your device in Surgeon mode (hold L + R shoulder buttons while powering up), and connecting to the Leapfrog Connect app. This will allow you to restore the stock leapster OS on the device.

Additionally, you can get serial access to the device either via the cartridge port, or via a header on the inside of the device.

Retroleap does not replace the stock bootloader, so unless something really nasty happens, you should be safe from bricking your device.


Doing your own build:

To do a build, clone the source tree with git.
Then do this:

make lfXXXX_defconfig (where XXXX is the board version you are building i.e. lf1000, lf2000 or lf3000)
make menuconfig (change whatever you want to change here - adding cores, etc.)
make
cp output/images/* ~/sshflash/ (equivalent for your system/location of SSHflash).


Wishlist/planned features:
-More cores to support additional systems.
-Overlay support for the tablet form-factor devices to make up for lack of buttons.
-Support for more leapster devices e.g. leapster explorer, didj(?), leappad, leappad3 and platinum.
-Overclocking support.
-Menuing other than the retroarch rgui menuing system.

If you'd like to get involved with this project, please get in touch! New contributors are always welcome :)


Shoutouts/thank yous:
-JabberwockPL (https://github.com/JabberwockPL) for being a trusted tester and collaborator, and doing cool stuff with atari800 cores, which will soon be integrated into retroleap!
-Special thanks for jrspruitt (https://github.com/jrspruitt) who wrote a bunch of the low-level code to talk to leapfrog's bootloader as part of OpenLFConnect
-The retroarch team and all the folks writing ARM-optimized cores that run so well on very dinky ARM systems (notaz especially!)
-LeapFrog Enterprises - for making such a cool and fun to hack device, being forthcoming with GPL requests, and generally being awesome. Sorry to see you guys get bought out by VTech, your products were infinitely better engineered and better manufactured. Hopefully through this projects, some of the old Leapster devices can live on past their original lifespan.
