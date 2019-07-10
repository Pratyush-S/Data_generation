

rm /home/tejeshwini/AIOT/TICKStack/iisctailTelegraf
touch /home/tejeshwini/AIOT/TICKStack/iisctailTelegraf
rm /home/tejeshwini/AIOT/TICKStack/json/czone_file.txt

rm /home/tejeshwini/AIOT/TICKStack/hcltailTelegraf
touch /home/tejeshwini/AIOT/TICKStack/hcltailTelegraf
rm /home/tejeshwini/AIOT/TICKStack/json/pm_file.txt

rm /home/tejeshwini/AIOT/TICKStack/wiprotailTelegraf
touch /home/tejeshwini/AIOT/TICKStack/wiprotailTelegraf
rm /home/tejeshwini/AIOT/TICKStack/json/ozone_file.txt

cd /home/tejeshwini/AIOT/TICKStack/Java

javac -classpath .:classes:/opt/lib/'*' Read_czone_iisc.java
java -classpath .:classes:/opt/lib/'*' Read_czone_iisc Simulink_Data.xlsx

javac -classpath .:classes:/opt/lib/'*' Read_ozone_wipro.java
java -classpath .:classes:/opt/lib/'*' Read_ozone_wipro Simulink_Data.xlsx

javac -classpath .:classes:/opt/lib/'*' Read_pm_hcl.java
java -classpath .:classes:/opt/lib/'*' Read_pm_hcl Simulink_Data.xlsx


cd /home/tejeshwini/AIOT/TICKStack

firefox 'http://localhost:8888/' &

xterm -T kapacitor_log -e sudo tail -f /var/log/kapacitor/kapacitor.log &
xterm -T iisc_telegraf -e telegraf -config /home/tejeshwini/AIOT/TICKStack/telegrafs/iisc_new.conf & 
xterm -T iisc_flight -e ./iiscflightNew.pl json/czone_file.txt &

xterm -T hcl_telegraf -e ./telegraf -config /home/tejeshwini/AIOT/TICKStack/telegrafs/hcl_new.conf & 
xterm -T hcl_flight -e ./hclflightNew.pl json/pm_file.txt &

xterm -T wipro_telegraf -e telegraf -config /home/tejeshwini/AIOT/TICKStack/telegrafs/wipro_new.conf & 
xterm -T wipro_flight -e ./wiproflightNew.pl json/ozone_file.txt &
