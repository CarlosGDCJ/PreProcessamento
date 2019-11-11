DROP TABLE continua;
CREATE TABLE continua (
    t_rec TIMESTAMP WITH TIME ZONE ,
    rx NUMERIC,
    rvaluemin NUMERIC ,
    rvaluemax NUMERIC ,
    rvalueavg NUMERIC ,
    usfluxmin NUMERIC ,
    usfluxmax NUMERIC ,
    usfluxavg NUMERIC ,
    classemin TEXT ,
    classemax TEXT
);

DROP TABLE continua2010;
DROP TABLE continua2011;
DROP TABLE continua2012;
DROP TABLE continua2013;
DROP TABLE continua2014;
DROP TABLE continua2015;
DROP TABLE continua2016;
DROP TABLE continua2017;

CREATE TABLE continua2010 AS (SELECT * FROM continua LIMIT 1);
TRUNCATE TABLE continua2010;
CREATE TABLE continua2011 AS (SELECT * FROM continua LIMIT 1);
TRUNCATE TABLE continua2011;
CREATE TABLE continua2012 AS (SELECT * FROM continua LIMIT 1);
TRUNCATE TABLE continua2012;
CREATE TABLE continua2013 AS (SELECT * FROM continua LIMIT 1);
TRUNCATE TABLE continua2013;
CREATE TABLE continua2014 AS (SELECT * FROM continua LIMIT 1);
TRUNCATE TABLE continua2014;
CREATE TABLE continua2015 AS (SELECT * FROM continua LIMIT 1);
TRUNCATE TABLE continua2015;
CREATE TABLE continua2016 AS (SELECT * FROM continua LIMIT 1);
TRUNCATE TABLE continua2016;
CREATE TABLE continua2017 AS (SELECT * FROM continua LIMIT 1);
TRUNCATE TABLE continua2017;