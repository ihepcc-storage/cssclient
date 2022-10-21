CSSClient is a tool to operate computational storage functions implemented in EOS <br>
Developed by CCIHEP, 2022 <br>

#compile  
Please make sure you are using gcc version 9  
git clone https://code.ihep.ac.cn/storage/eoscss/cssclient.git      
cd cssclient  
mkdir build  
cd build  
cmake3 ../  
make -j 4 
   
#build rpm package  
./buildrpm.sh
