

rm /home/anrc_a-iot/AIOT/TICKStack/iisctailTelegraf
touch /home/anrc_a-iot/AIOT/TICKStack/iisctailTelegraf
rm /home/anrc_a-iot/AIOT/TICKStack/json/czone_file.txt

rm /home/anrc_a-iot/AIOT/TICKStack/hcltailTelegraf
touch /home/anrc_a-iot/AIOT/TICKStack/hcltailTelegraf
rm /home/anrc_a-iot/AIOT/TICKStack/json/pm_file.txt

rm /home/anrc_a-iot/AIOT/TICKStack/wiprotailTelegraf
touch /home/anrc_a-iot/AIOT/TICKStack/wiprotailTelegraf
rm /home/anrc_a-iot/AIOT/TICKStack/json/ozone_file.txt

cd /home/anrc_a-iot/AIOT/TICKStack/Java

javac -classpath .:classes:/opt/lib/'*' Read_czone_iisc.java
java -classpath .:classes:/opt/lib/'*' Read_czone_iisc Simulink_Data.xlsx

javac -classpath .:classes:/opt/lib/'*' Read_ozone_wipro.java
java -classpath .:classes:/opt/lib/'*' Read_ozone_wipro Simulink_Data.xlsx ozone_file.txt
java -classpath .:classes:/opt/lib/'*' Read_ozone_wipro Simulink_Data_Ozone_80.xlsx ozone_base_file.txt

javac -classpath .:classes:/opt/lib/'*' Read_pm_hcl.java
java -classpath .:classes:/opt/lib/'*' Read_pm_hcl Simulink_Data.xlsx


cd /home/anrc_a-iot/AIOT/TICKStack

firefox 'http://localhost:8888/' &

val=$1
str1a='interval = "'
str1b='flush_interval = "'
str2='s"'
str4=$str1a$val$str2
str9=$str1b$val$str2
sed -i '4s,.*,'"$str4"',' /home/anrc_a-iot/AIOT/TICKStack/telegrafs/iisc_new.conf
sed -i '9s,.*,'"$str9"',' /home/anrc_a-iot/AIOT/TICKStack/telegrafs/iisc_new.conf
sed -i '4s,.*,'"$str4"',' /home/anrc_a-iot/AIOT/TICKStack/telegrafs/wipro_new.conf
sed -i '9s,.*,'"$str9"',' /home/anrc_a-iot/AIOT/TICKStack/telegrafs/wipro_new.conf
sed -i '4s,.*,'"$str4"',' /home/anrc_a-iot/AIOT/TICKStack/telegrafs/wipro_base_new.conf
sed -i '9s,.*,'"$str9"',' /home/anrc_a-iot/AIOT/TICKStack/telegrafs/wipro_base_new.conf


#sed -i '4s/.*/interval = "5s"/' /home/anrc_a-iot/AIOT/TICKStack/telegrafs/hcl_new.conf
#sed -i '9s/.*/flush_interval = "5s"/' /home/anrc_a-iot/AIOT/TICKStack/telegrafs/hcl_new.conf
#sed -i '4s/.*/interval = "5s"/' /home/anrc_a-iot/AIOT/TICKStack/telegrafs/wipro_new.conf
#sed -i '9s/.*/flush_interval = "5s"/' /home/anrc_a-iot/AIOT/TICKStack/telegrafs/wipro_new.conf

xterm -T iisc_telegraf -e telegraf -config /home/anrc_a-iot/AIOT/TICKStack/telegrafs/iisc_new.conf & 
xterm -T hcl_telegraf -e ./telegraf -config /home/anrc_a-iot/AIOT/TICKStack/telegrafs/hcl_new.conf & 
xterm -T wipro_telegraf -e telegraf -config /home/anrc_a-iot/AIOT/TICKStack/telegrafs/wipro_new.conf & 
xterm -T wipro_base_telegraf -e telegraf -config /home/anrc_a-iot/AIOT/TICKStack/telegrafs/wipro_base_new.conf & 

xterm -T iisc_flight -e ./iiscflightNew.pl json/czone_file.txt $1 &
xterm -T hcl_flight -e ./hclflightNew.pl json/pm_file.txt $1 &
xterm -T wipro_flight -e ./wiproflightNew.pl json/ozone_file.txt $1 &
xterm -T wipro_base_flight -e ./wiprobaseflightNew.pl json/ozone_base_file.txt $1 &
