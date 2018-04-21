#!/bin/sh

checkResult(){
    if [ $1 -eq 0 ]
    then
	echo "$2     执行成功"
    else
	echo "$2     执行失败"
    fi
}

sudo apt-get install git -y
checkResult $? " test    install git"

sudo apt-get install curl -y
checkResult $? " test    install curl"

sudo apt-get update
checkResult $? " test    install update"

wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key
checkResult $? " test    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key"

sudo apt-get install python3-dev -y
checkResult $? " test    install python3-dev"

sudo apt-get install clang-4.0 lldb-4.0 libclang-4.0-dev cmake make -y
checkResult $? " test    install clang-4.0 lldb-4.0 libclang-4.0-dev cmake make"

sudo apt-get install libbz2-dev libssl-dev libgmp3-dev -y
checkResult $? " test    install libbz2-dev libssl-dev libgmp3-dev"

sudo apt-get install autotools-dev build-essential -y
checkResult $? " test    install autotools-dev build-essential"

sudo apt-get install libbz2-dev libicu-dev python-dev -y
checkResult $? " test    install libbz2-dev libicu-dev python-dev"

sudo apt-get install autoconf libtool git mongodb -y
checkResult $? " test    install autoconf libtool git mongodb"


cd ~

wget -c 'https://sourceforge.net/projects/boost/files/boost/1.66.0/boost_1_66_0.tar.bz2/download' -O boost_1.66.0.tar.bz2

tar xjf boost_1.66.0.tar.bz2

cd boost_1_66_0/

echo "export BOOST_ROOT=$HOME/boost_1_66_0" >> ~/.bash_profile

source ~/.bash_profile

./bootstrap.sh "--prefix=$BOOST_ROOT"

./b2 install
checkResult $? " test    install boost_1.66.0"

source ~/.bash_profile


cd ~

curl -LO https://github.com/mongodb/mongo-c-driver/releases/download/1.9.3/mongo-c-driver-1.9.3.tar.gz

tar xf mongo-c-driver-1.9.3.tar.gz

cd mongo-c-driver-1.9.3

./configure --enable-static --enable-ssl=openssl --disable-automatic-init-and-cleanup --prefix=/usr/local

make -j$( nproc )

sudo make install

git clone https://github.com/mongodb/mongo-cxx-driver.git --branch releases/stable --depth 1

cd mongo-cxx-driver/build

cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ..

sudo make -j$( nproc )
checkResult $? " test    install mangodb C++ driver"


cd ~

git clone https://github.com/cryptonomex/secp256k1-zkp.git

cd secp256k1-zkp

./autogen.sh

./configure

make

sudo make install
checkResult $? " test    make install secp256k1-zkp"

mkdir  ~/wasm-compiler

cd ~/wasm-compiler

git clone --depth 1 --single-branch --branch release_40 https://github.com/llvm-mirror/llvm.git

cd llvm/tools

git clone --depth 1 --single-branch --branch release_40 https://github.com/llvm-mirror/clang.git

cd ..

mkdir build

cd build

cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=.. -DLLVM_TARGETS_TO_BUILD= -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly -DCMAKE_BUILD_TYPE=Release ../

make -j4 install
checkResult $? " test    install LLVM clang"


cd ~

git clone https://github.com/eosio/eos --recursive


cd eos
./eosio_build.sh