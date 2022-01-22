#!

source function.sh

output "Installing Package . . ."
sleep 5
cd ~
sudo apt-get update
sudo add-apt-repository -y ppa:bitcoin/bitcoin
apt_install build-essential libtool autotools-dev \
automake pkg-config libssl-dev libevent-dev bsdmainutils git libboost-all-dev libminiupnpc-dev \
libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev \
protobuf-compiler libqrencode-dev libzmq3-dev libgmp-dev
clear

output "Create Directory . . ."
sleep 5
cd ~
sudo mkdir -p ~/builder/bls/
sudo mkdir -p ~/builder/compil/berkeley/
sudo mkdir -p ~/builder/compil/coind
sudo mkdir -p ~/builder/compil/openssl/
cd ~/builder/compil/berkeley/
clear

#output "Create Config . . ."
#sleep 5
#echo '
#autogen=true
#berkeley="4.8"
#' | sudo -E tee ~/builder/berkeley/.my.cnf >/dev/null 2>&1;
#clear

output "Installing Berkeley db 4.8 . . ."
sleep 5
sudo mkdir -p ~/builder/berkeley/db4/
sudo wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
sudo tar -xzvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix/
sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=~/builder/berkeley/db4/
sudo make install
cd ~/builder/compil/berkeley/
sudo rm -r db-5.1.29.tar.gz db-5.1.29
clear

output "Installing Berkeley db 5.1 . . ."
sleep 5
sudo mkdir -p ~/builder/berkeley/db5/
sudo wget 'http://download.oracle.com/berkeley-db/db-5.1.29.tar.gz'
sudo tar -xzvf db-5.1.29.tar.gz
cd db-5.1.29/build_unix/
sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=~/builder/berkeley/db5/
sudo make install
cd ~/builder/compil/berkeley/
sudo rm -r db-5.1.29.tar.gz db-5.1.29
clear

output "Installing Berkeley db 5.3 . . ."
sleep 5
sudo mkdir -p ~/builder/berkeley/db5.3/
sudo wget 'http://anduin.linuxfromscratch.org/BLFS/bdb/db-5.3.28.tar.gz'
sudo tar -xzvf db-5.3.28.tar.gz
cd db-5.3.28/build_unix/
sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=~/builder/berkeley/db5.3/
sudo make install
cd ~/builder/compil/berkeley/
sudo rm -r db-5.3.28.tar.gz db-5.3.28
clear

output "Installing OpenSSL 1.0.2g . . ."
sleep 5
cd ~/builder/compil/openssl/
sudo mkdir -p ~/builder/openssl/
sudo wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2g.tar.gz --no-check-certificate
sudo tar -xf openssl-1.0.2g.tar.gz
cd openssl-1.0.2g
sudo ./config --prefix=$STORAGE_ROOT/openssl --openssldir=~/builder/openssl shared zlib
sudo make
sudo make install
cd ~/builder/compilopenssl/
sudo rm -r openssl-1.0.2g.tar.gz openssl-1.0.2g
clear

output "Installing Bls-signatures . . ."
sleep 5
cd ~/builder/bls/
sudo wget 'https://github.com/codablock/bls-signatures/archive/v20181101.zip'
sudo unzip v20181101.zip
cd bls-signatures-20181101
sudo cmake .
sudo make install
cd ~/builder/bls
sudo rm -r v20181101.zip
clear

output "Move to /usr/bin/ . . ."
sleep 5
cd ~/builder/
sudo chmod 777 ~/builder/coind.sh
sudo chmod 777 ~/builder/start.sh
sudo rm -rvf /usr/bin/coind
sudo cp coind.sh /usr/bin/
sudo mv /usr/bin/coind.sh /usr/bin/coind
clear
exit