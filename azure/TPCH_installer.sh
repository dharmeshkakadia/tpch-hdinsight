wget -O /tmp/HDInsightUtilities-v01.sh -q https://hdiconfigactions.blob.core.windows.net/linuxconfigactionmodulev01/HDInsightUtilities-v01.sh && source /tmp/HDInsightUtilities-v01.sh && rm -f /tmp/HDInsightUtilities-v01.sh

if [[ `hostname -f` -z `get_primary_headnode` ]]; then
	wget https://github.com/dharmeshkakadia/tpch-datagen-as-hive-query/archive/master.zip
	unzip master.zip; cd tpch-datagen-as-hive-query-master;
	hive -i settings.hql -f TPCHDataGen.hql -hiveconf SCALE=10 -hiveconf PARTS=10 -hiveconf LOCATION=/HiveTPCH/ -hiveconf TPCHBIN=resources 
fi
