DROP TABLE D_VNS_PLANS;

CREATE TABLE D_VNS_PLANS
(
    VNS_PLAN_ID         NUMBER,
    VNS_PLAN_SHORT_NAME VARCHAR2(100),
    VNS_PLAN_DESC       VARCHAR2(400),
    LOB_ID              NUMBER,
    PBP_ID              varchar2(10)
);

insert into d_vns_plans values(1, 'MA-Preferred', 'MA-Preferred',1000,'002');
insert into d_vns_plans values(2, 'MA-Total', 'MA-Total',1000,'003');
insert into d_vns_plans values(3, 'MA-Enhanced', 'MA-Enhanced',1000,'004');
insert into d_vns_plans values(4, 'MA-Maximum', 'MA-Maximum',1000,'006');
insert into d_vns_plans values(5, 'MA-Classic', 'MA-Classic',1000,'008');
insert into d_vns_plans values(6, 'MA-Ultra', 'MA-Ultra',1000,'009');
insert into d_vns_plans values(7, 'HIV-SNP', 'HIV-SNP',3000,'HIVSNP');
insert into d_vns_plans values(8, 'MLTC', 'MLTC',2000,'MLTC');
insert into d_vns_plans values(9, 'FI', 'FIDA',4000,'FI');

DROP  TABLE D_VNS_PLANS_PDPD_MAPPING;

CREATE TABLE D_VNS_PLANS_PDPD_MAPPING
(
    VNS_PLAN_PDPD_ID        NUMBER,
    VNS_PLAN_ID             number,
    VNS_PLAN_SHORT_NAME     VARCHAR(100),
    PDPD_ID                 varchar2(100),
    LOB_ID                  NUMBER,
    PBP_ID                  varchar2(10)
);

--select * from mstrstg.d_line_of_business

Insert into D_VNS_PLANS_PDPD_MAPPING values (1,1,'MA-Preferred','VNSNY007',1000, '002'); 
Insert into D_VNS_PLANS_PDPD_MAPPING values (2,1,'MA-Preferred','VNS02007',1000, '002'); 
Insert into D_VNS_PLANS_PDPD_MAPPING values (3,1,'MA-Preferred','VNS020A7',1000, '002');  
Insert into D_VNS_PLANS_PDPD_MAPPING values (4,2,'MA-Total','VNS03007',1000, '003');
Insert into D_VNS_PLANS_PDPD_MAPPING values (5,2,'MA-Total','VNS030A7',1000, '003');
Insert into D_VNS_PLANS_PDPD_MAPPING values (6,3,'MA-Enhanced','VNS04007',1000, '004');
Insert into D_VNS_PLANS_PDPD_MAPPING values (7,3,'MA-Enhanced','VNS040A7',1000, '004');
Insert into D_VNS_PLANS_PDPD_MAPPING values (8,3,'MA-Enhanced','VNS040B7',1000, '004');
Insert into D_VNS_PLANS_PDPD_MAPPING values (9,4,'MA-Maximum','VNS06007',1000, '006');
Insert into D_VNS_PLANS_PDPD_MAPPING values (10,5,'MA-Classic','VNS08007',1000, '008');
Insert into D_VNS_PLANS_PDPD_MAPPING values (11,5,'MA-Classic','VNS080A7',1000, '008');
Insert into D_VNS_PLANS_PDPD_MAPPING values (12,5,'MA-Classic','VNS080B7',1000, '008');
Insert into D_VNS_PLANS_PDPD_MAPPING values (13,6,'MA-Ultra','VNS09007',1000, '009');
Insert into D_VNS_PLANS_PDPD_MAPPING values (14,6,'MA-Ultra','VNS090A7',1000, '009');
Insert into D_VNS_PLANS_PDPD_MAPPING values (15,6,'MA-Ultra','VNS090B7',1000, '009');
Insert into D_VNS_PLANS_PDPD_MAPPING values (16,7,'HIV-SNP','MD000004',3000,'');
Insert into D_VNS_PLANS_PDPD_MAPPING values (17,7,'HIV-SNP','MD000008',3000,'');
Insert into D_VNS_PLANS_PDPD_MAPPING values (18,8,'MLTC','MD000002',2000,'');
Insert into D_VNS_PLANS_PDPD_MAPPING values (19,8,'MLTC','MD000003',2000,'');
Insert into D_VNS_PLANS_PDPD_MAPPING values (20,9,'FIDA','V6000000',4000,'');

GRANT SELECT ON CHOICEBI.D_VNS_PLANS_PDPD_MAPPING TO DW_OWNER;

GRANT SELECT ON CHOICEBI.D_VNS_PLANS_PDPD_MAPPING TO MSTRSTG;

GRANT SELECT ON CHOICEBI.D_VNS_PLANS_PDPD_MAPPING TO ROC_RO;

GRANT SELECT ON CHOICEBI.D_VNS_PLANS TO DW_OWNER;

GRANT SELECT ON CHOICEBI.D_VNS_PLANS TO MSTRSTG;

GRANT SELECT ON CHOICEBI.D_VNS_PLANS TO ROC_RO;
