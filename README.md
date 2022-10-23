CSSClient is a tool to operate computational storage functions implemented in EOS <br>
Developed by CC-IHEP, 2022 <br>



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

#how to use  
1) first setup EOS_MGM_URL, like export EOS_MGM_URL=root://eosbak02.ihep.ac.cn/  
2) cssclient --help to check the manunal
3) cssclient -f /eos/user/chyd/data.txt -c sort 

#notice  
Of Course, computational storage in EOS can be used without cssclient, ie, it is fine to use xrootd protocal directly, for example:  
xrdcp root://eosbak02.ihep.ac.cn//eos/user/chyd/data.txt?css=sort - 
