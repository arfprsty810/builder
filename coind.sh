source ~/builder/function.sh

output "Select Your Installation Option!"
echo ""
sleep 5
echo "1. Berkeley 4.8"
echo "2. Berkeley 5.1"
echo "3. Makefile.unix"
echo "4. Manually"
read -r -e -p "Input your number option 1-4 (ex; 1 ) :" testbuild

output "Create data . . ."
sleeo 5
if [[ ("$testbuild" == "1") ]]; then 
echo '
autogen=true
berkeley=1
' | sudo -E tee ~/builder/berkeley/.my.cnf >/dev/null 2>&1;
fi
clear

if [[ ("$testbuild" == "2") ]]; then 
echo '
berkeley=2
' | sudo -E tee ~/builder/berkeley/.my.cnf >/dev/null 2>&1;
fi
clear

if [[ ("$testbuild" == "3") ]]; then 
echo '
berkeley=3
' | sudo -E tee ~/builder/berkeley/.my.cnf >/dev/null 2>&1;
fi
clear

if [[ ("$testbuild" == "4") ]]; then 
echo '
berkeley=4
' | sudo -E tee ~/builder/berkeley/.my.cnf >/dev/null 2>&1;
fi
clear

cd ~/builder/
bash ./start.sh