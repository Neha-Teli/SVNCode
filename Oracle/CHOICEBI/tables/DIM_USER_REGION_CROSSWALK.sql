create table DIM_USER_REGION_CROSSWALK
(
    URC_NO  NUMBER,
    URC_PAYMENT_REG_NAME    VARCHAR2(400),
    URC_REGION_DESC1        VARCHAR2(400),
    URC_COUNTY              VARCHAR2(400),
    URC_REGION_DESC2        VARCHAR2(400)    
);

grant select on DIM_USER_REGION_CROSSWALK to MSTRSTG with grant option 

insert into DIM_USER_REGION_CROSSWALK values(9,'5700 - CHO Albany Network','Rating Region 3','Albany','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(10,'5701 - CHO Allegany Network','Rating Region 4','Allegany','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(63,'Out of Area','Out of Area','Bergen','Out of Area');
insert into DIM_USER_REGION_CROSSWALK values(2,'5102 - CHO Bronx Network','Rating Region 1','Bronx','Bronx');
insert into DIM_USER_REGION_CROSSWALK values(11,'5703 - CHO Broome Network','Rating Region 4','Broome','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(12,'5704 - CHO Cattaraugus Network','Rating Region 4','Cattaraugus','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(13,'5705 - CHO Cayuga Network','Rating Region 4','Cayuga','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(14,'5706 - CHO Chautauqua Network','Rating Region 4','Chautauqua','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(15,'5707 - CHO Chemung Network','Rating Region 4','Chemung','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(16,'5708 - CHO Chenango Network','Rating Region 4','Chenango','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(17,'5709 - CHO Clinton Network','Rating Region 4','Clinton','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(18,'5710 - CHO Columbia Network','Rating Region 4','Columbia','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(19,'5711 - CHO Cortland Network','Rating Region 4','Cortland','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(20,'5712 - CHO Delaware Network','Rating Region 4','Delaware','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(21,'5713 - CHO Dutchess Network','Rating Region 2','Dutchess','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(22,'5714 - CHO Erie Network','Rating Region 3','Erie','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(23,'5715 - CHO Essex Network','Rating Region 4','Essex','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(24,'5716 - CHO Franklin Network','Rating Region 4','Franklin','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(25,'5717 - CHO Fulton Network','Rating Region 3','Fulton','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(26,'5718 - CHO Genesse Network','Rating Region 3','genesee','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(27,'5719 - CHO Greene Network','Rating Region 4','greene','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(28,'5720 - CHO Hamilton Network','Rating Region 4','hamilton','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(29,'5721 - CHO Herkimer  Network','Rating Region 4','herkimer','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(30,'5722 - CHO Jefferson  Network','Rating Region 4','jefferson','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(4,'5104 - CHO Brooklyn Network','Rating Region 1','Kings','Brooklyn/Kings');
insert into DIM_USER_REGION_CROSSWALK values(64,'Out of Area','Out of Area','Lee','Out of Area');
insert into DIM_USER_REGION_CROSSWALK values(31,'5723 - CHO Lewis  Network','Rating Region 4','lewis','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(32,'5724 - CHO Livingston  Network','Rating Region 4','livingston','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(33,'5725 - CHO Madison Network','Rating Region 3','madison','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(66,'Out of Area','Out of Area','MERCER','Out of Area');
insert into DIM_USER_REGION_CROSSWALK values(34,'5726 - CHO Monroe Network','Rating Region 3','monroe','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(35,'5727 - CHO Montgomery Network','Rating Region 3','montgomery','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(6,'5175 - CHO Nassau Network','Rating Region 1','Nassau','Nassau/Suffolk');
insert into DIM_USER_REGION_CROSSWALK values(1,'5101 - CHO Manhattan Network','Rating Region 1','New York','New York/Manhattan');
insert into DIM_USER_REGION_CROSSWALK values(36,'5728 - CHO Niagra Network','Rating Region 3','niagara','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(37,'5729 - CHO Oneida Network','Rating Region 4','oneida','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(38,'5730 - CHO Onondaga Network','Rating Region 3','onondaga','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(39,'5731 - CHO Ontario Network','Rating Region 4','ontario','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(40,'5732 - CHO Orange Network','Rating Region 2','orange','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(41,'5733 - CHO Orleans Network','Rating Region 3','orleans','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(42,'5734 - CHO Oswego Network','Rating Region 4','oswego','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(43,'5735 - CHO Otsego Network','Rating Region 4','otsego','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(65,'Out of Area','Out of Area','Palm Beach','Out of Area');
insert into DIM_USER_REGION_CROSSWALK values(67,'Out of Area','Out of Area','PASSAIC','Out of Area');
insert into DIM_USER_REGION_CROSSWALK values(44,'5736 - CHO Putnan Network','Rating Region 2','putnam','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(3,'5103 - CHO Queens Network','Rating Region 1','Queens','Queens');
insert into DIM_USER_REGION_CROSSWALK values(45,'5737 - CHO Rensselaer Network','Rating Region 3','rensselaer','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(46,'5738 - CHO Rockland Network','Rating Region 2','rockland','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(48,'5740 - CHO Saratoga Network','Rating Region 3','saratoga','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(49,'5741 - CHO Schenectady Network','Rating Region 3','schenectady','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(50,'5742 - CHO Schoharie Network','Rating Region 4','schoharie','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(51,'5743 - CHO Schuyler Network','Rating Region 4','schuyler','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(52,'5744 - CHO Seneca Network','Rating Region 4','seneca','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(47,'5739 - CHO St. Lawrence Network','Rating Region 4','St Lawrence','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(5,'5105 - CHO Staten Island Network','Rating Region 1','Staten Island','Staten Island/Richmond');
insert into DIM_USER_REGION_CROSSWALK values(53,'5745 - CHO Steuben Network','Rating Region 4','steuben','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(7,'5176 - CHO Suffolk Network','Rating Region 1','Suffolk','Nassau/Suffolk');
insert into DIM_USER_REGION_CROSSWALK values(54,'5746 - CHO Sullivan Network','Rating Region 2','sullivan','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(55,'5747 - CHO Tioga Network','Rating Region 4','tioga','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(56,'5748 - CHO Tompkins Network','Rating Region 4','tompkins','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(57,'5749 - CHO Ulster Network','Rating Region 2','ulster','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(58,'5750 - CHO  Warren Network','Rating Region 3','warren','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(59,'5751 - CHO Washington Network','Rating Region 3','washington','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(60,'5752 - CHO Wayne Network','Rating Region 4','wayne','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(8,'5177 - CHO Westchester Network','Rating Region 1','Westchester','Westchester');
insert into DIM_USER_REGION_CROSSWALK values(61,'5753 - CHO Wyoming Network','Rating Region 3','wyoming','Upstate');
insert into DIM_USER_REGION_CROSSWALK values(62,'5754 - CHO Yates Network','Rating Region 4','yates','Upstate');
