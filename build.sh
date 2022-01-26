#!

source function.sh

output "Installing Package . . ."
sleep 5
cd ~
hide_output sudo apt-get update
hide_output sudo add-apt-repository -y ppa:bitcoin/bitcoin
hide_output apt_install build-essential libtool autotools-dev \
automake pkg-config libssl-dev libevent-dev bsdmainutils git libboost-all-dev libminiupnpc-dev \
libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev \
protobuf-compiler libqrencode-dev libzmq3-dev libgmp-dev
echo -e "$GREEN Done...$COL_RESET"

echo ""
output "Create Directory . . ."
sleep 5
cd ~
sudo mkdir -p ~/builder/bls/
sudo mkdir -p ~/builder/compil/berkeley/
sudo mkdir -p ~/builder/compil/coind
sudo mkdir -p ~/builder/compil/openssl/
cd ~/builder/compil/berkeley/
echo -e "$GREEN Done...$COL_RESET"

#output "Create Config . . ."
#sleep 5
#echo '
#autogen=true
#berkeley="4.8"
#' | sudo -E tee ~/builder/berkeley/.my.cnf >/dev/null 2>&1;
#clear

echo ""
output "Installing Berkeley db 4.8 . . ."
sleep 5
sudo mkdir -p ~/builder/berkeley/db4/
hide_output sudo wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
hide_output sudo tar -xzvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix/
hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=~/builder/berkeley/db4/
hide_output sudo make install
cd ~/builder/compil/berkeley/
hide_output sudo rm -r db-5.1.29.tar.gz db-5.1.29
echo -e "$GREEN Done...$COL_RESET"

echo ""
output "Installing Berkeley db 5.1 . . ."
sleep 5
sudo mkdir -p ~/builder/berkeley/db5/
hide_output sudo wget 'http://download.oracle.com/berkeley-db/db-5.1.29.tar.gz'
hide_output sudo tar -xzvf db-5.1.29.tar.gz
cd db-5.1.29/build_unix/
hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=~/builder/berkeley/db5/
hide_output sudo make install
cd ~/builder/compil/berkeley/
hide_output sudo rm -r db-5.1.29.tar.gz db-5.1.29
echo -e "$GREEN Done...$COL_RESET"

echo ""
output "Installing Berkeley db 5.3 . . ."
sleep 5
sudo mkdir -p ~/builder/berkeley/db5.3/
hide_output sudo wget 'http://anduin.linuxfromscratch.org/BLFS/bdb/db-5.3.28.tar.gz'
hide_output sudo tar -xzvf db-5.3.28.tar.gz
cd db-5.3.28/build_unix/
hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=~/builder/berkeley/db5.3/
hide_output sudo make install
cd ~/builder/compil/berkeley/
hide_output sudo rm -r db-5.3.28.tar.gz db-5.3.28
echo -e "$GREEN Done...$COL_RESET"

echo ""
output "Installing OpenSSL 1.0.2g . . ."
sleep 5
cd ~/builder/compil/openssl/
sudo mkdir -p ~/builder/openssl/
hide_output sudo wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2g.tar.gz --no-check-certificate
hide_output sudo tar -xf openssl-1.0.2g.tar.gz
cd openssl-1.0.2g
hide_output sudo ./config --prefix=$STORAGE_ROOT/openssl --openssldir=~/builder/openssl shared zlib
hide_output sudo make
hide_output sudo make install
cd ~/builder/compil/openssl/
hide_output sudo rm -r openssl-1.0.2g.tar.gz openssl-1.0.2g
echo -e "$GREEN Done...$COL_RESET"

echo ""
output "Installing Bls-signatures . . ."
sleep 5
cd ~/builder/bls/
hide_output sudo wget 'https://github.com/codablock/bls-signatures/archive/v20181101.zip'
hide_output sudo unzip v20181101.zip
cd bls-signatures-20181101
hide_output sudo cmake .
hide_output sudo make install
cd ~/builder/bls
hide_output sudo rm -r v20181101.zip
echo -e "$GREEN Done...$COL_RESET"

echo ""
output "Move to /usr/bin/ . . ."
sleep 5
cd ~/builder/
sudo chmod 777 ~/builder/coind.sh
sudo chmod 777 ~/builder/start.sh
sudo rm -rvf /usr/bin/coind
sudo cp coind.sh /usr/bin/
sudo mv /usr/bin/coind.sh /usr/bin/coind
echo -e "$GREEN Done...$COL_RESET"
sleep 5
clear
exit