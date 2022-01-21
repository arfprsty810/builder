
source ~/builder/berkeley/.my.cnf

now=$(date +"%m_%d_%Y")
set -e
NPROC=$(nproc)

#if [[ ! -e '~/builder/compil/coind' ]]; then
#sudo mkdir -p ~/builder/compil/coind/
#else
#echo "coind file already exists.... Skipping"
#fi

# Just double checking folder permissions
sudo setfacl -m u:$USER:rwx ~/builder/compil/coind/

cd ~/builder/compil/coind/
clear
echo "This script assumes you already have the dependicies installed on your system!"
echo ""

read -r -e -p "Enter the name of the coin : " coin
read -r -e -p "Paste the github link for the coin : " git_hub
read -r -e -p "Do you need to use a specific github branch of the coin (y/n) : " branch_git_hub
if [[ ("$branch_git_hub" == "y" || "$branch_git_hub" == "Y" || "$branch_git_hub" == "yes" || "$branch_git_hub" == "Yes" || "$branch_git_hub" == "YES") ]]; then
read -r -e -p "Please enter the branch name exactly as in github, i.e. v2.5.1  : " branch_git_hub_ver
fi

coindir=$coin$now

# save last coin information in case coin build fails
echo '
lastcoin='"${coindir}"'
' | sudo -E tee ~/builder/compil/coind/.lastcoin.conf >/dev/null 2>&1

# Clone the coin
if [[ ! -e $coindir ]]; then
git clone $git_hub $coindir
cd "${coindir}"
if [[ ("$branch_git_hub" == "y" || "$branch_git_hub" == "Y" || "$branch_git_hub" == "yes" || "$branch_git_hub" == "Yes" || "$branch_git_hub" == "YES") ]]; then
  git fetch
  git checkout "$branch_git_hub_ver"
fi
else
echo "~/builder/compil/coind/${coindir} already exists.... please wait to removed $ $coindir"
sudo rm -rvf $coindir
clear
echo "$coindir removed"
echo "resume to installing"
#echo "If there was an error in the build use the build error options on the installer"
#exit 0
git clone $git_hub $coindir
cd "${coindir}"
if [[ ("$branch_git_hub" == "y" || "$branch_git_hub" == "Y" || "$branch_git_hub" == "yes" || "$branch_git_hub" == "Yes" || "$branch_git_hub" == "YES") ]]; then
  git fetch
  git checkout "$branch_git_hub_ver"
fi

# Building 
if [[ ("$autogen" == "true") ]]; then
if [[ ("$berkeley" == "4.8") ]]; then
###################################################################
echo "Building using Berkeley 4.8..."
basedir=$(pwd)
sh autogen.sh
if [[ ! -e '~/builder/compil/coind/${coindir}/share/genbuild.sh' ]]; then
  echo "genbuild.sh not found skipping"
else
sudo chmod 777 ~/builder/compil/coind/${coindir}/share/genbuild.sh
fi
if [[ ! -e '~/builder/compil/coind/${coindir}/src/leveldb/build_detect_platform' ]]; then
  echo "build_detect_platform not found skipping"
else
sudo chmod 777 ~/builder/compil/coind/${coindir}/src/leveldb/build_detect_platform
fi
./configure CPPFLAGS="-I ~/builder/berkeley/db4/include -O2" LDFLAGS="-L ~/builder/berkeley/db4/lib" --without-gui --disable-tests
else
####################################################################
echo "Building using Berkeley 5.1..."
basedir=$(pwd)
sh autogen.sh
if [[ ! -e '~/builder/compil/coind/${coindir}/share/genbuild.sh' ]]; then 
  echo "genbuild.sh not found skipping"
else
sudo chmod 777 ~/builder/compil/coind/${coindir}/share/genbuild.sh
fi
if [[ ! -e '~/builder/compil/coind/${coindir}/src/leveldb/build_detect_platform' ]]; then
  echo "build_detect_platform not found skipping"
else
sudo chmod 777 ~/builder/compil/coind/${coindir}/src/leveldb/build_detect_platform
fi
./configure CPPFLAGS="-I ~/builder/berkeley/db5/include -O2" LDFLAGS="-L ~/builder/berkeley/db5/lib" --without-gui --disable-tests
fi
make -j$(nproc)
else
####################################################################
echo "Building using makefile.unix method..."
cd ~/builder/compil/coind/${coindir}/src
if [[ ! -e '~/builder/compil/coind/${coindir}/src/obj' ]]; then
mkdir -p ~/builder/compil/coind/${coindir}/src/obj
else
echo "Hey the developer did his job and the src/obj dir is there!"
fi
if [[ ! -e '~/builder/compil/coind/${coindir}/src/obj/zerocoin' ]]; then
mkdir -p ~/builder/compil/coind/${coindir}/src/obj/zerocoin
else
echo  "Wow even the /src/obj/zerocoin is there! Good job developer!"
fi
cd ~/builder/compil/coind/${coindir}/src/leveldb
sudo chmod +x build_detect_platform
sudo make clean
sudo make libleveldb.a libmemenv.a
cd ~/builder/compil/coind/${coindir}/src
#sed -i '/USE_UPNP:=0/i BDB_LIB_PATH = /home/crypto-data/berkeley/db4/lib\nBDB_INCLUDE_PATH = /home/crypto-data/berkeley/db4/include\nOPENSSL_LIB_PATH = /home/crypto-data/openssl/lib\nOPENSSL_INCLUDE_PATH = /home/crypto-data/openssl/include' makefile.unix
#sed -i '/USE_UPNP:=1/i BDB_LIB_PATH = /home/crypto-data/berkeley/db4/lib\nBDB_INCLUDE_PATH = /home/crypto-data/berkeley/db4/include\nOPENSSL_LIB_PATH = /home/crypto-data/openssl/lib\nOPENSSL_INCLUDE_PATH = /home/crypto-data/openssl/include' makefile.unix
make -j$NPROC -f makefile.unix USE_UPNP=-
fi
####################################################################
clear 

# LS the SRC dir to have user input bitcoind and bitcoin-cli names
cd ~/builder/compil/coind/${coindir}/src/
find . -maxdepth 1 -type f \( -perm -1 -o \( -perm -10 -o -perm -100 \) \) -printf "%f\n"
read -r -e -p "Please enter the coind name from the directory above, example bitcoind :" xcoind
read -r -e -p "Is there a coin-cli, example bitcoin-cli [y/N] :" ifcoincli

if [[ ("$ifcoincli" == "y" || "$ifcoincli" == "Y") ]]; then
read -r -e -p "Please enter the coin-cli name :" coincli
fi
clear

# Strip and copy to Daemon
mkdir -p ~/builder/daemon/$coin
sudo strip ~/builder/compil/coind/${coindir}/src/${xcoind}
sudo cp ~/builder/compil/coind/${coindir}/src/${xcoind} ~/builder/daemon/$coin
if [[ ("$ifcoincli" == "y" || "$ifcoincli" == "Y") ]]; then
sudo strip ~/builder/compil/coind/${coindir}/src/${coincli}
sudo cp ~/builder/compil/coind/${coindir}/src/${coincli} ~/builder/daemon/$coin
fi

# Make the new wallet folder have user paste the coin.conf and finally start the daemon
if [[ ! -e '/home/$USER/' ]]; then
cd /home/$USER/
fi

#sudo setfacl -m u:$USER:rwx $STORAGE_ROOT/wallets
mkdir -p ~/."${xcoind::-1}"
echo "I am now going to open nano, please copy and paste the config from yiimp in to this file."
read -n 1 -s -r -p "Press any key to continue"
sudo nano ~/."${xcoind::-1}"/${xcoind::-1}.conf
clear
cd ~/builder/daemon/$coin
echo "Starting ${xcoind::-1}"
"${xcoind}" -datadir=~/."${xcoind::-1}" -conf="${xcoind::-1}.conf" -daemon -shrinkdebugfile

# If we made it this far everything built fine removing last coin.conf and build directory
sudo rm -rvf ~/builder/compil/coind/.lastcoin.conf
sudo rm -rvf ~/builder/compil/coind/${coindir}

clear
echo "Installation of ${xcoind::-1} is completed and running."
echo Type coind at anytime to install a new coin!
exit