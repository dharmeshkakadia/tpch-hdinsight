# tpch-datagen-as-hive-query
This are set of UDFs and queries that you can use with Hive to use TPCH datagen in parrellel on hadoop cluster. You can deploy to azure using :
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdharmeshkakadia%2Ftpch-datagen-as-hive-query%2Fmaster%2Fazure%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


##How to use with Hive CLI
1. Clone this repo.

    ```shell
    git clone https://github.com/dharmeshkakadia/tpch-datagen-as-hive-query/ && cd tpch-datagen-as-hive-query
    ```
2. Run TPCHDataGen.hql with settings.hql file and set the required config variables.
    ```shell
    hive -i settings.hql -f TPCHDataGen.hql -hiveconf SCALE=10 -hiveconf PARTS=10 -hiveconf LOCATION=/HiveTPCH/ -hiveconf TPCHBIN=resources 
    ```
    Here, `SCALE` is a scale factor for TPCH, 
    `PARTS` is a number of task to use for datagen (parrellelization), 
    `LOCATION` is the directory where the data will be stored on HDFS, 
    `TPCHBIN` is where the resources are found. You can specify specific settings in settings.hql file.

3. Now you can create tables on the generated data.
    ```shell
    hive -i settings.hql -f ddl/createAllExternalTables.hql -hiveconf LOCATION=/HiveTPCH/ -hiveconf DBNAME=tpch
    ```
    Generate ORC tables and analyze
    ```shell
    hive -i settings.hql -f ddl/createAllORCTables.hql -hiveconf ORCDBNAME=tpch_orc -hiveconf SOURCE=tpch 
    hive -i settings.hql -f ddl/analyze.hql -hiveconf ORCDBNAME=tpch_orc 
    ```

4. Run the queries !
    ```shell
    hive -database tpch_orc -i settings.hql -f queries/tpch_query1.hql 
    ```

##How to use with Beeline CLI
1. Clone this repo.

    ```shell
    git clone https://github.com/dharmeshkakadia/tpch-datagen-as-hive-query/ && cd tpch-datagen-as-hive-query
    ```
2. Upload the resources to DFS.
    ```shell
    hdfs dfs -copyFromLocal resoruces /tmp
    ```

3. Run TPCHDataGen.hql with settings.hql file and set the required config variables.
    ```shell
   beeline -u "jdbc:hive2://`hostname -f`:10001/;transportMode=http" -n "" -p "" -i settings.hql -f TPCHDataGen.hql -hiveconf SCALE=10 -hiveconf PARTS=10 -hiveconf LOCATION=/HiveTPCH/ -hiveconf TPCHBIN=`grep -A 1 "fs.defaultFS" /etc/hadoop/conf/core-site.xml | grep -o "wasb[^<]*"`/tmp/resources 
    ```
    Here, `SCALE` is a scale factor for TPCH, 
    `PARTS` is a number of task to use for datagen (parrellelization), 
    `LOCATION` is the directory where the data will be stored on HDFS, 
    `TPCHBIN` is where the resources are uploaded on step 2. You can specify specific settings in settings.hql file.

4. Now you can create tables on the generated data.
    ```shell
    beeline -u "jdbc:hive2://`hostname -f`:10001/;transportMode=http" -n "" -p "" -i settings.hql -f ddl/createAllExternalTables.hql -hiveconf LOCATION=/HiveTPCH/ -hiveconf DBNAME=tpch
    ```
    Generate ORC tables and analyze
    ```shell
    beeline -u "jdbc:hive2://`hostname -f`:10001/;transportMode=http" -n "" -p "" -i settings.hql -f ddl/createAllORCTables.hql -hiveconf ORCDBNAME=tpch_orc -hiveconf SOURCE=tpch 
    beeline -u "jdbc:hive2://`hostname -f`:10001/;transportMode=http" -n "" -p "" -i settings.hql -f ddl/analyze.hql -hiveconf ORCDBNAME=tpch_orc 
    ```

5. Run the queries !
    ```shell
    beeline -u "jdbc:hive2://`hostname -f`:10001/tpch_orc;transportMode=http" -n "" -p "" -i settings.hql -f queries/tpch_query1.hql 
    ```

## FAQ

1. Does it work with scale factor 1?

    No. The parrellel data generation assumes that scale > 1. If you are just starting out, I would suggest you start with 10 and then move to standard higher scale factors (100, 1000, 10000,..)

2. Do I have to specify PARTS=SCALE ?

    Yes.
