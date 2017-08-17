Name     : firefox
Version  : 55.0.2
Release  : 10
URL      : http://ftp.mozilla.org/pub/firefox/releases/55.0.2/linux-x86_64/en-US/firefox-55.0.2.tar.bz2
Source0  : http://ftp.mozilla.org/pub/firefox/releases/55.0.2/linux-x86_64/en-US/firefox-55.0.2.tar.bz2
Source1  : http://ftp.mozilla.org/pub/firefox/releases/55.0.2/source/firefox-55.0.2.source.tar.xz
Source2  : firefox.desktop
Source3  : firefox.sh
Summary  : Firefox web browser
Group    : Development/Tools
License  : GPL-2.0+ MPL-2.0
Requires : alsa-lib bzip2 tar
Requires : chrome-gnome-shell

%description
Introduction
============
Stub package to assist with installation of Mozilla Firefox Web Browser

%install
rm -rf %{buildroot}
install -D -m 00644 %{SOURCE0} %{buildroot}/usr/share/firefox-stub/firefox-%{version}.tar.bz2

# Desktop launcher
install -D -m 00644 %{SOURCE2} %{buildroot}/usr/share/applications/firefox.desktop

# Binwrapper - extracts and sets up firefox, or passes through, as appropriate
install -D -m 00755 %{SOURCE3} %{buildroot}/usr/bin/firefox

# Ensure the versioning is consistent - centralise this stuff.
sed -i %{buildroot}/usr/bin/firefox -e 's/\#\#VERSION\#\#/%{version}/g'

%files
%defattr(-,root,root,-)
/usr/bin/firefox
/usr/share/firefox-stub/firefox-%{version}.tar.bz2
/usr/share/applications/firefox.desktop
