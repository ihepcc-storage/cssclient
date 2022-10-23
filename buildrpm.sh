#!/bin/bash
FULLVER=$(./genversion.sh)
VER=$(echo $FULLVER|cut -d"." -f1,2)
RLS=$(echo $FULLVER|cut -d"." -f3|cut -d"-" -f1)
echo "$VER $RLS"
sed  's/VERSION_UNDEF/'$VER'/g' cssclient.spec.in > cssclient.spec
sed  -i  's/RELEASE_UNDEF/'$RLS'/g' cssclient.spec
TNAME=cssclient.tar.gz
cd ..
tar cvzf $TNAME --exclude=cssclient/build cssclient
mv $TNAME cssclient
cd cssclient
rpmbuild -ta $TNAME
rm -rf $TNAME 
