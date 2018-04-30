Name     : firefox
Version  : 59.0.3
Release  : 10
URL      : http://ftp.mozilla.org/pub/firefox/releases/59.0.3/linux-x86_64/en-US/firefox-59.0.3.tar.bz2
Source0  : http://ftp.mozilla.org/pub/firefox/releases/59.0.3/linux-x86_64/en-US/firefox-59.0.3.tar.bz2
Source1  : https://hg.mozilla.org/releases/mozilla-release/archive/6b51784853e47e091d213d421a19cb623af718f0.tar.gz
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
