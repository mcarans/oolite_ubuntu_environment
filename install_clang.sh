cd /home/mcarans/Code/OoliteRelated/

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

run_script() {
    cd libobjc2
    rm -rf build
    mkdir build
    cd build
    # if ! cmake -DTESTS=on -DCMAKE_BUILD_TYPE=Release -DGNUSTEP_INSTALL_TYPE=NONE -DCMAKE_INSTALL_PREFIX=/usr -DEMBEDDED_BLOCKS_RUNTIME=ON -DOLDABI_COMPAT=ON ../
    if ! cmake -DTESTS=on -DCMAKE_BUILD_TYPE=Release -DGNUSTEP_INSTALL_TYPE=NONE -DCMAKE_INSTALL_PREFIX=/usr -DEMBEDDED_BLOCKS_RUNTIME=ON -DOLDABI_COMPAT=OFF ../
        echo "libobjc2 cmake configure failed!"
        return 1
    fi

    if ! cmake --build .
        echo "libobjc2 cmake build failed!"
        return 1
    fi
    sudo cmake --install .
    cd ../..

    cd tools-make
    #./configure --prefix=/usr --with-library-combo=gnu-gnu-gnu --with-libdir=lib --with-objc-lib-flag="-L/usr/lib/x86_64-linux-gnu/ -lobjc"
    if ! ./configure --prefix=/usr --with-library-combo=ng-gnu-gnu --with-libdir=lib --with-runtime-abi=gnustep-2.2 --with-objc-lib-flag="-L/usr/lib/x86_64-linux-gnu/ -lobjc"
    # ./configure --prefix=/usr --with-library-combo=ng-gnu-gnu --with-libdir=lib --with-runtime-abi=gnustep-1.9 --with-objc-lib-flag="-L/usr/lib/x86_64-linux-gnu/ -lobjc"
        echo "tools-make configure failed!"
        return 1
    fi
    make
    sudo make install
    cd ..

    cd libs-base
    . /usr/share/GNUstep/Makefiles/GNUstep.sh
    if ! ./configure --prefix=/usr
        echo "libs-base configure failed!"
        return 1
    fi
    if ! make -j16
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

