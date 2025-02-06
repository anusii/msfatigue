# MS Fatigue Installers

Flutter supports multiple platform targets. Flutter based apps can run
native on Android, iOS, Linux, MacOS, and Windows, as well as directly
in a browser from the web. Flutter functionality is essentially
identical across all platforms so the experience across different
platforms will be very similar.

Visit the
[CHANGELOG](https://github.com/anusii/msfatigue/blob/dev/CHANGELOG.md)
for the latest updates.

## Prerequisite

There are no specific prerequisites for installing and running
HealthPod.

## Android

You can side load the latest version of the app by visiting the
[Installer](https://solidcommunity.au/installers/msfatigue.apk) from
your Android device's browser. This will download the app to your
Android device where you can click on the `msfatigue.apk` file. Your
browser will ask if you are comfortable to install the app locally. If
you are comfortable with side loading the app then choose to do so.

## Linux

### Zip Install

Download [msfatigue-dev-linux.zip](https://solidcommunity.au/installers/msfatigue-dev-linux.zip)

To try it out:

```bash
wget https://solidcommunity.au/installers/msfatigue-dev-linux.zip -O msfatigue-dev-linux.zip
unzip msfatigue-dev-linux.zip -d msfatigue
./msfatigue/msfatigue
```

To install for the local user and to make it known to GNOME and KDE,
with a desktop icon for their desktop, begin by downloading the **zip** and
installing that into a local folder:

```bash
unzip msfatigue-dev-linux.zip -d ${HOME}/.local/share/msfatigue
```

Then set up your local installation (only required once):

```bash
ln -s ${HOME}/.local/share/msfatigue/msfatigue ${HOME}/.local/bin/
wget https://raw.githubusercontent.com/gjwgit/msfatigue/dev/installers/msfatigue.desktop -O ${HOME}/.local/share/applications/msfatigue.desktop
sed -i "s/USER/$(whoami)/g" ${HOME}/.local/share/applications/msfatigue.desktop
mkdir -p ${HOME}/.local/share/icons/hicolor/256x256/apps/
wget https://github.com/gjwgit/msfatigue/raw/dev/installers/msfatigue.png -O ${HOME}/.local/share/icons/hicolor/256x256/apps/msfatigue.png
```

To install for any user on the computer:

```bash
sudo unzip msfatigue-dev-linux.zip -d /opt/msfatigue
sudo ln -s /opt/msfatigue/msfatigue /usr/local/bin/
```

The
[msfatigue.desktop](https://solidcommunity.au/installers/msfatigue.desktop)
and [app icon](https://solidcommunity.au/installers/msfatigue.png) can
be installed into `/usr/local/share/applications/` and
`/usr/local/share/icons/` respectively.

Once installed you can run the app from the GNOME desktop through
Alt-F2 and type `msfatigue` then Enter.

## MacOS

The zip file
[msfatigue-dev-macos.zip](https://solidcommunity.au/installers/msfatigue-dev-macos.zip)
can be installed on MacOS. Download the file and open it on your
Mac. Then, holding the Control key click on the app icon to display a
menu. Choose `Open`. Then accept the warning to then run the app. The
app should then run without the warning next time.

## Web -- No Installation Required

No installer is required for a browser based experience of
Msfatigue. Simply visit https://msfatigue.solidcommunity.au.

Also, your Web browser will provide an option in its menus to install
the app locally, which can add an icon to your home screen to start
the web-based app directly.

## Windows Installer

Download and run the self extracting archive
[msfatigue-dev-windows-inno.exe](https://solidcommunity.au/installers/msfatigue-dev-windows-inno.exe)
to self install the app on Windows.
