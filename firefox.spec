Name     : firefox
Version  : 105.0.3
Release  : 136
URL      : https://archive.mozilla.org/pub/firefox/releases/105.0.3/linux-x86_64/en-US/firefox-105.0.3.tar.bz2
Source0  : https://archive.mozilla.org/pub/firefox/releases/105.0.3/linux-x86_64/en-US/firefox-105.0.3.tar.bz2
Source1  : https://archive.mozilla.org/pub/firefox/releases/105.0.3/source/firefox-105.0.3.source.tar.xz
Source2  : firefox.desktop
Source3  : firefox.sh
Summary  : Firefox web browser
Group    : Development/Tools
License  : GPL-2.0+ MPL-2.0
Requires : alsa-lib bzip2 tar
Requires : chrome-gnome-shell
Requires : nspr nss-lib pango cairo gtk3 mesa gtk+
Requires : dbus-glib

%description
Introduction
============
Stub package to assist with installation of Mozilla Firefox Web Browser

%install
rm -rf %{buildroot}

# Install icons
tar xf %{SOURCE0} firefox/browser/chrome/icons/default/default16.png --xform='s,^.+/,,x'
install -D -m 0644 default16.png %{buildroot}/usr/share/icons/hicolor/16x16/apps/firefox.png

tar xf %{SOURCE0} firefox/browser/chrome/icons/default/default32.png --xform='s,^.+/,,x'
install -D -m 0644 default32.png %{buildroot}/usr/share/icons/hicolor/32x32/apps/firefox.png

tar xf %{SOURCE0} firefox/browser/chrome/icons/default/default48.png --xform='s,^.+/,,x'
install -D -m 0644 default48.png %{buildroot}/usr/share/icons/hicolor/48x48/apps/firefox.png

tar xf %{SOURCE0} firefox/browser/chrome/icons/default/default64.png --xform='s,^.+/,,x'
install -D -m 0644 default64.png %{buildroot}/usr/share/icons/hicolor/64x64/apps/firefox.png

tar xf %{SOURCE0} firefox/browser/chrome/icons/default/default128.png --xform='s,^.+/,,x'
install -D -m 0644 default128.png %{buildroot}/usr/share/icons/hicolor/128x128/apps/firefox.png

# Install stub
mkdir -p  %{buildroot}/usr/share/firefox-stub/
bunzip2 -c %{SOURCE0} > %{buildroot}/usr/share/firefox-stub/firefox-%{version}.tar


# Desktop launcher
install -D -m 00644 %{SOURCE2} %{buildroot}/usr/share/applications/firefox.desktop

# Binwrapper - extracts and sets up firefox, or passes through, as appropriate
install -D -m 00755 %{SOURCE3} %{buildroot}/usr/bin/firefox

# Ensure the versioning is consistent - centralise this stuff.
sed -i %{buildroot}/usr/bin/firefox -e 's/\#\#VERSION\#\#/%{version}/g'

%files
%defattr(-,root,root,-)
/usr/bin/firefox
/usr/share/firefox-stub/firefox-%{version}.tar
/usr/share/applications/firefox.desktop
/usr/share/icons/hicolor/16x16/apps/firefox.png
/usr/share/icons/hicolor/32x32/apps/firefox.png
/usr/share/icons/hicolor/48x48/apps/firefox.png
/usr/share/icons/hicolor/64x64/apps/firefox.png
/usr/share/icons/hicolor/128x128/apps/firefox.png
