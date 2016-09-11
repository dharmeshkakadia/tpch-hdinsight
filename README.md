# tpch-datagen-as-hive-query
This are set of UDFs and queries that you can use with Hive to use TPCH datagen in parrellel on hadoop cluster.

##How to use
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
