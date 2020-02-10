DROP TABLE CHOICEBI.FACT_CENSUS_BUDGET_DATA CASCADE CONSTRAINTS;

CREATE TABLE CHOICEBI.FACT_CENSUS_BUDGET_DATA
(
  DL_LOB_ID     NUMBER,
  DESCRIPTION   VARCHAR2(400 BYTE),
  BUDGET_TYPE   VARCHAR2(100 BYTE),
  MONTH_ID      NUMBER,
  RATE_CODE     NUMBER,
  REGION        VARCHAR2(400 BYTE),
  PRODUCT_ID    VARCHAR2(10 BYTE),
  BUDGET_VALUE  NUMBER
);


GRANT SELECT ON CHOICEBI.FACT_CENSUS_BUDGET_DATA TO MSTRSTG;

GRANT SELECT ON CHOICEBI.FACT_CENSUS_BUDGET_DATA TO ROC_RO;


Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201709, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201710, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201711, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201712, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201701, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201702, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201703, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201704, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201705, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201706, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201707, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201708, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201709, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201710, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201711, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Census', 201712, 2209, 
    8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201701, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201702, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201703, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201704, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201705, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201706, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201707, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201708, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201709, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201710, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201711, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Census', 201712, 2274, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201701, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201702, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201703, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201704, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201705, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201706, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201707, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201708, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201709, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201710, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201711, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Census', 201712, 2205, 
    10);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201701, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201702, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201703, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201704, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201705, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201706, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201707, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201708, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201709, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201710, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201711, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Census', 201712, 2272, 
    12);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201701, 2273, 
    30);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201701, 2275, 
    35);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201702, 2275, 
    35);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201703, 2275, 
    35);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201702, 2273, 
    40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201703, 2273, 
    40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201704, 2273, 
    40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201705, 2273, 
    40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201706, 2273, 
    40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201707, 2273, 
    40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201708, 2273, 
    40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201709, 2273, 
    40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201710, 2273, 
    40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201711, 2273, 
    40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'New Enrollments', 201712, 2273, 
    40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201704, 2275, 
    45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201705, 2275, 
    45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201706, 2275, 
    45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201707, 2275, 
    45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201708, 2275, 
    45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201709, 2275, 
    45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201710, 2275, 
    45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201711, 2275, 
    45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'New Enrollments', 201712, 2275, 
    45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201701, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201702, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201703, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201704, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201705, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201706, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201707, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201708, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201709, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201710, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201711, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Census', 201712, 2201, 
    72);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201701, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201702, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201703, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201704, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201705, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201706, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201707, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201708, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201709, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201710, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201711, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Census', 201712, 2273, 
    1680);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201701, 2275, 
    1762);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201702, 2275, 
    1762);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201703, 2275, 
    1762);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201704, 2275, 
    1763);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201705, 2275, 
    1763);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201706, 2275, 
    1763);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201707, 2275, 
    1764);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201708, 2275, 
    1764);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201709, 2275, 
    1764);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201710, 2275, 
    1764);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201711, 2275, 
    1765);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Census', 201712, 2275, 
    1765);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201701, 'Manhattan', 
    296);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201702, 'Manhattan', 
    284);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201703, 'Manhattan', 
    272);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201704, 'Manhattan', 
    261);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201705, 'Manhattan', 
    250);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201705, 2275, 
    -45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201706, 2275, 
    -45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201708, 2275, 
    -45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201709, 2275, 
    -45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201710, 2275, 
    -45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201712, 2275, 
    -45);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201704, 2275, 
    -44);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201707, 2275, 
    -44);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201711, 2275, 
    -44);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201702, 2273, 
    -40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201703, 2273, 
    -40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201704, 2273, 
    -40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201705, 2273, 
    -40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201706, 2273, 
    -40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201707, 2273, 
    -40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201708, 2273, 
    -40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201709, 2273, 
    -40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201710, 2273, 
    -40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201711, 2273, 
    -40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201712, 2273, 
    -40);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201702, 2275, 
    -35);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201703, 2275, 
    -35);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Disenrollments', 201701, 2275, 
    -30);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Disenrollments', 201701, 2273, 
    -25);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201701, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201702, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201703, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201704, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201705, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201706, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201707, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201708, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201709, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201710, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201711, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Census', 201712, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201701, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201702, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201703, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201704, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201705, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201706, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201707, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201708, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201709, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201710, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201711, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Census', 201712, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201701, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201702, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201703, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201704, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201705, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201706, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201707, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201708, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201709, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201710, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201711, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Census', 201712, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201701, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201702, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201703, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201704, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201705, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201706, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201707, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201708, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201709, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201710, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201711, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Census', 201712, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201701, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201702, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201703, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201704, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201705, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201706, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201707, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201708, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201709, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201710, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201711, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Disenrollments', 201712, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201701, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201702, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201703, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201704, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201705, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201706, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201707, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201708, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201709, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201710, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201711, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Disenrollments', 201712, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201701, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201702, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201703, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201704, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201705, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201706, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201707, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201708, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201709, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201710, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201711, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Disenrollments', 201712, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201701, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201702, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201703, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201704, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201705, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201706, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201707, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201708, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201709, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201710, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201711, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Disenrollments', 201712, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201701, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201702, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201703, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201704, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201705, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201706, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201707, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201708, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201709, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201710, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201711, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Disenrollments', 201712, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201701, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201702, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201703, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201704, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201705, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201706, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201707, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201708, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201709, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201710, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201711, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Disenrollments', 201712, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201701, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201702, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201703, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201704, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201705, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201706, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201707, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201708, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201709, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201710, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201711, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Disenrollments', 201712, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201701, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201702, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201703, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201704, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201705, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201706, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201707, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201708, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201709, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201710, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201711, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Disenrollments', 201712, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201701, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201702, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201703, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201704, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201705, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201706, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201707, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201708, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201709, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201710, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201711, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Disenrollments', 201712, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201701, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201702, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201703, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201704, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201705, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201706, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201707, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201708, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201709, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201710, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201711, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'New Enrollments', 201712, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201701, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201702, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201703, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201704, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201705, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201706, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201707, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201708, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201709, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201710, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201711, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'New Enrollments', 201712, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201701, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201702, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201703, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201704, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201705, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201706, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201707, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201708, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201709, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201710, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201711, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'New Enrollments', 201712, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201701, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201702, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201703, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201704, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201705, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201706, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201707, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201708, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201709, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201710, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201711, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'New Enrollments', 201712, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201701, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201702, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201703, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201704, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201705, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201706, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201707, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201708, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201709, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201710, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201711, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'New Enrollments', 201712, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201701, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201702, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201703, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201704, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201705, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201706, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201707, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201708, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201709, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201710, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201711, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'New Enrollments', 201712, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201701, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201702, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201703, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201704, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201705, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201706, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201707, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201708, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201709, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201710, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201711, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'New Enrollments', 201712, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201701, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201702, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201703, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201704, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201705, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201706, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201707, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201708, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201709, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201710, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201711, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'New Enrollments', 201712, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201701, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201702, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201703, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201704, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201705, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201706, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201707, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201708, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201709, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201710, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201711, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'New Enrollments', 201712, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201701, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201702, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201703, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201704, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201705, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201706, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201707, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201708, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201709, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201710, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201711, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI  Children (2274)', 'Transfers', 201712, 2274, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201701, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201702, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201703, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201704, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201705, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201706, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201707, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201708, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201709, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201710, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201711, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS SSI Adults (2275)', 'Transfers', 201712, 2275, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201701, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201702, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201703, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201704, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201705, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201706, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201707, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201708, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201709, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201710, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201711, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Adults (2273)', 'Transfers', 201712, 2273, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201701, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201702, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201703, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201704, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201705, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201706, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201707, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201708, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201709, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201710, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201711, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'HIV AIDS TANF/SN Children (2272)', 'Transfers', 201712, 2272, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201701, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201702, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201703, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201704, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201705, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201706, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201707, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201708, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201709, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201710, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201711, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults not infected (1232)', 'Transfers', 201712, 1232, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201701, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201702, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201703, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201704, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201705, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201706, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201707, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201708, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201709, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201710, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201711, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Adults or Children Homeless uninfected (1231)', 'Transfers', 201712, 1231, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201701, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201702, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201703, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201704, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201705, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201706, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201707, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201708, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201709, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201710, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201711, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'SSI Children (2209)', 'Transfers', 201712, 2209, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201701, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201702, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201703, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201704, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201705, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201706, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201707, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201708, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201709, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201710, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201711, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults Homeless uninfected (1229)', 'Transfers', 201712, 1229, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201701, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201702, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201703, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201704, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201705, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201706, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201707, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201708, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201709, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201710, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201711, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Adults not infected (2205)', 'Transfers', 201712, 2205, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201701, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201702, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201703, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201704, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201705, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201706, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201707, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201708, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201709, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201710, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201711, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children Homeless uninfected (1230)', 'Transfers', 201712, 1230, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201701, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201702, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201703, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201704, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201705, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201706, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201707, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, RATE_CODE, 
    BUDGET_VALUE)
 Values
   (3, 'TANF/SN Children not infected (2201)', 'Transfers', 201708, 2201, 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201706, 'Manhattan', 
    240);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201707, 'Manhattan', 
    230);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201708, 'Manhattan', 
    221);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201709, 'Manhattan', 
    212);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201710, 'Manhattan', 
    203);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201711, 'Manhattan', 
    195);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Census', 201712, 'Manhattan', 
    187);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201701, 'Manhattan', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201702, 'Manhattan', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201703, 'Manhattan', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201704, 'Manhattan', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201705, 'Manhattan', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201706, 'Manhattan', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201707, 'Manhattan', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201708, 'Manhattan', 
    -3);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201709, 'Manhattan', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201710, 'Manhattan', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201711, 'Manhattan', 
    -3);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Disenrollments', 201712, 'Manhattan', 
    -3);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201701, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201702, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201703, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201704, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201705, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201706, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201707, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201708, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201709, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201710, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201711, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'New Enrollments', 201712, 'Manhattan', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201701, 'Manhattan', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201702, 'Manhattan', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201703, 'Manhattan', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201704, 'Manhattan', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201705, 'Manhattan', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201706, 'Manhattan', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201707, 'Manhattan', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201708, 'Manhattan', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201709, 'Manhattan', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201710, 'Manhattan', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201711, 'Manhattan', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5101 - CHO Manhattan Network', 'Transfers', 201712, 'Manhattan', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201701, 'Bronx', 
    339);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201702, 'Bronx', 
    327);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201703, 'Bronx', 
    315);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201704, 'Bronx', 
    303);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201705, 'Bronx', 
    292);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201706, 'Bronx', 
    281);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201707, 'Bronx', 
    271);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201708, 'Bronx', 
    261);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201709, 'Bronx', 
    251);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201710, 'Bronx', 
    242);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201711, 'Bronx', 
    233);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Census', 201712, 'Bronx', 
    224);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201701, 'Bronx', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201702, 'Bronx', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201703, 'Bronx', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201704, 'Bronx', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201705, 'Bronx', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201706, 'Bronx', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201707, 'Bronx', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201708, 'Bronx', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201709, 'Bronx', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201710, 'Bronx', 
    -3);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201711, 'Bronx', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Disenrollments', 201712, 'Bronx', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201701, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201702, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201703, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201704, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201705, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201706, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201707, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201708, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201709, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201710, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201711, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'New Enrollments', 201712, 'Bronx', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201701, 'Bronx', 
    -8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201702, 'Bronx', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201703, 'Bronx', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201704, 'Bronx', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201705, 'Bronx', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201706, 'Bronx', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201707, 'Bronx', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201708, 'Bronx', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201709, 'Bronx', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201710, 'Bronx', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201711, 'Bronx', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5102 - CHO Bronx Network', 'Transfers', 201712, 'Bronx', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201701, 'Queens', 
    423);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201702, 'Queens', 
    410);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201703, 'Queens', 
    398);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201704, 'Queens', 
    386);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201705, 'Queens', 
    374);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201706, 'Queens', 
    363);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201707, 'Queens', 
    352);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201708, 'Queens', 
    341);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201709, 'Queens', 
    331);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201710, 'Queens', 
    321);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201711, 'Queens', 
    311);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Census', 201712, 'Queens', 
    302);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201701, 'Queens', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201702, 'Queens', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201703, 'Queens', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201704, 'Queens', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201705, 'Queens', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201706, 'Queens', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201707, 'Queens', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201708, 'Queens', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201709, 'Queens', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201710, 'Queens', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201711, 'Queens', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Disenrollments', 201712, 'Queens', 
    -3);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201701, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201702, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201703, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201704, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201705, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201706, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201707, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201708, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201709, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201710, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201711, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'New Enrollments', 201712, 'Queens', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201701, 'Queens', 
    -8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201702, 'Queens', 
    -8);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201703, 'Queens', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201704, 'Queens', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201705, 'Queens', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201706, 'Queens', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201707, 'Queens', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201708, 'Queens', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201709, 'Queens', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201710, 'Queens', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201711, 'Queens', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5103 - CHO Queens Network', 'Transfers', 201712, 'Queens', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201701, 'Brooklyn', 
    395);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201702, 'Brooklyn', 
    382);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201703, 'Brooklyn', 
    370);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201704, 'Brooklyn', 
    358);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201705, 'Brooklyn', 
    347);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201706, 'Brooklyn', 
    336);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201707, 'Brooklyn', 
    325);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201708, 'Brooklyn', 
    315);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201709, 'Brooklyn', 
    305);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201710, 'Brooklyn', 
    295);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201711, 'Brooklyn', 
    286);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Census', 201712, 'Brooklyn', 
    277);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201701, 'Brooklyn', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201702, 'Brooklyn', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201703, 'Brooklyn', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201704, 'Brooklyn', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201705, 'Brooklyn', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201706, 'Brooklyn', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201707, 'Brooklyn', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201708, 'Brooklyn', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201709, 'Brooklyn', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201710, 'Brooklyn', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201711, 'Brooklyn', 
    -3);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Disenrollments', 201712, 'Brooklyn', 
    -4);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201701, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201702, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201703, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201704, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201705, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201706, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201707, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201708, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201709, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201710, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201711, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'New Enrollments', 201712, 'Brooklyn', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201701, 'Brooklyn', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201702, 'Brooklyn', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201703, 'Brooklyn', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201704, 'Brooklyn', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201705, 'Brooklyn', 
    -7);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201706, 'Brooklyn', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201707, 'Brooklyn', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201708, 'Brooklyn', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201709, 'Brooklyn', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201710, 'Brooklyn', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201711, 'Brooklyn', 
    -6);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5104 - CHO Brooklyn Network', 'Transfers', 201712, 'Brooklyn', 
    -5);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201701, 'Staten Island', 
    71);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201702, 'Staten Island', 
    69);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201703, 'Staten Island', 
    67);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201704, 'Staten Island', 
    65);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201705, 'Staten Island', 
    63);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201706, 'Staten Island', 
    61);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201707, 'Staten Island', 
    59);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201708, 'Staten Island', 
    57);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201709, 'Staten Island', 
    55);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201710, 'Staten Island', 
    53);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201711, 'Staten Island', 
    51);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Census', 201712, 'Staten Island', 
    49);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201701, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201702, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201703, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201704, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201705, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201706, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201707, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201708, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201709, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201710, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201711, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Disenrollments', 201712, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201701, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201702, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201703, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201704, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201705, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201706, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201707, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201708, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201709, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201710, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201711, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'New Enrollments', 201712, 'Staten Island', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201701, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201702, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201703, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201704, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201705, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201706, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201707, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201708, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201709, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201710, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201711, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5105 - CHO Staten Island Network', 'Transfers', 201712, 'Staten Island', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201701, 'Nassau', 
    28);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201702, 'Nassau', 
    27);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201703, 'Nassau', 
    26);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201704, 'Nassau', 
    25);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201705, 'Nassau', 
    24);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201706, 'Nassau', 
    24);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201707, 'Nassau', 
    24);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201708, 'Nassau', 
    24);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201709, 'Nassau', 
    24);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201710, 'Nassau', 
    24);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201711, 'Nassau', 
    24);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Census', 201712, 'Nassau', 
    24);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201701, 'Nassau', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201702, 'Nassau', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201703, 'Nassau', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201704, 'Nassau', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201705, 'Nassau', 
    -1);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201706, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201707, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201708, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201709, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201710, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201711, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Disenrollments', 201712, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201701, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201702, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201703, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201704, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201705, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201706, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201707, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201708, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201709, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201710, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201711, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'New Enrollments', 201712, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201701, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201702, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201703, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201704, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201705, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201706, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201707, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201708, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201709, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201710, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201711, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5175 - CHO Nassau Network', 'Transfers', 201712, 'Nassau', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201701, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201702, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201703, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201704, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201705, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201706, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201707, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201708, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201709, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201710, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201711, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Census', 201712, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201701, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201702, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201703, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201704, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201705, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201706, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201707, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201708, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201709, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201710, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201711, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Disenrollments', 201712, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201701, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201702, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201703, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201704, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201705, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201706, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201707, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201708, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201709, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201710, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201711, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'New Enrollments', 201712, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201701, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201702, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201703, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201704, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201705, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201706, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201707, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201708, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201709, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201710, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201711, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5176 - CHO Suffolk Network', 'Transfers', 201712, 'Suffolk', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201701, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201702, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201703, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201704, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201705, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201706, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201707, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201708, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201709, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201710, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201711, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Census', 201712, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201701, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201702, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201703, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201704, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201705, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201706, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201707, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201708, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201709, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201710, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201711, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Disenrollments', 201712, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201701, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201702, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201703, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201704, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201705, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201706, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201707, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201708, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201709, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201710, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201711, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'New Enrollments', 201712, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201701, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201702, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201703, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201704, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201705, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201706, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201707, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201708, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201709, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201710, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201711, 'Westchester', 
    0);
Insert into FACT_CENSUS_BUDGET_DATA
   (DL_LOB_ID, DESCRIPTION, BUDGET_TYPE, MONTH_ID, REGION, 
    BUDGET_VALUE)
 Values
   (4, '5177 - CHO Westchester Network', 'Transfers', 201712, 'Westchester', 
    0);
COMMIT;
