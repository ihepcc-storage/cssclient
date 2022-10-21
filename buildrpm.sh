#!/bin/bash
FULLVER=$(./genversion.sh)
VER=$(echo $FULLVER|cut -d"." -f1,2)
RLS=$(echo $FULLVER|cut -d"." -f3|cut -d"-" -f1)
echo "$VER $RLS"
sed  's/VERSION_UNDEF/'$VER'/g' cssclient.spec.in > cssclient.spec
sed  -i  's/RELEASE_UNDEF/'$RLS'/g' cssclient.spec
TNAME=cssclient.tar.gz
cd ..
tar czvf $TNAME cssclient/
mv $TNAME cssclient
cd cssclient
rpmbuild -ta $TNAME
