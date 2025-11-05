#!/bin/bash

cd /home/mcarans/Code/OoliteRelated/

export CC=/usr/bin/gcc
export CXX=/usr/bin/g++

run_script() {
    cd tools-make
    make distclean
    if ! ./configure --prefix=/usr --with-library-combo=gnu-gnu-gnu --with-libdir=lib --with-objc-lib-flag="-L/usr/lib/x86_64-linux-gnu/ -l:libobjc.so.4"; then
        echo "tools-make configure failed!"
        return 1
    fi
    make
    sudo make install
    cd ..

    cd libs-base
    make distclean
    . /usr/share/GNUstep/Makefiles/GNUstep.sh
    if ! ./configure --prefix=/usr; then
        echo "libs-base configure failed!"
        return 1
    fi

    if ! make -j16; then
        echo "libs-base make failed!"
        return 1
    fi

    sudo make install
    cd ..
}


run_script
status=$?


# Exit only if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    exit $status
fi
