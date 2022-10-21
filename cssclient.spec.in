Name:		cssclient
Version:	1.0
Release:	1
Summary:	Computation Storage Client for EOS Storage System
Vendor: 	CC-IHEP
Group:		Application/Plug-in
License:	GPL
Source0:	cssclient.tar.gz

BuildRoot: %{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
The cssclient is a tool to operate computation storage function implemented in EOS Storage System

BuildRequires: xrootd-client-devel >= 4.12.1

%prep
rm -rf $RPM_BUILD_ROOT
tar -xvfz $RPM_SOURCE_DIR/cssclient.tar.gz

%build
cd ./cssclient/build/
cmake3 .. -L -DCMAKE_INSTALL_FULL_LIBDIR=/usr/local -DCMAKE_INSTALL_PREFIX=/usr/local
make

%install
#rm -rf %{buildroot}
cd ./cssclient/build/
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root)
%doc
/usr/local/bin/cssclient

%changelog

