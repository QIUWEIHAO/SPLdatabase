DROP DATABASE IF EXISTS spl_2016;
CREATE DATABASE spl_2016;
USE spl_2016;


source scripts/createTablesToLoad.sql
source scripts/loadTables.sql
