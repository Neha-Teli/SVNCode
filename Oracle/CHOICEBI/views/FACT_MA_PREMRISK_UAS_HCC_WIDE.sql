

CREATE OR REPLACE VIEW FACT_MA_PREMRISK_UAS_HCC_WIDE AS  
WITH HCC AS 
( 
    SELECT 
        /*+ NO_MERGE MATERIALIZE*/ 
        DL_ASSESS_SK,    
        ASSESSMENTDATE,    
        MEDICAID_NUM, 
        ESRD_V21,    
        AGEDIS_V22,    
        AGEDIS_V23,    
        AGEDIS_V24,    
        RXHCC_V05,
        ESRD_V21_IND,
        AGEDIS_V22_IND,
        AGEDIS_V23_IND,
        AGEDIS_V24_IND,
        RXHCC_V05_IND
    FROM FACT_MA_PREMRISK_UAS_HCC_LONG
    WHERE (ESRD_V21 IS NOT NULL OR   
          AGEDIS_V22 IS NOT NULL OR    
          AGEDIS_V23 IS NOT NULL OR
          AGEDIS_V24 IS NOT NULL OR
          RXHCC_V05 IS NOT NULL)
          --and DL_ASSESS_SK = 87188 
    GROUP BY 
        DL_ASSESS_SK,    
        ASSESSMENTDATE,    
        MEDICAID_NUM, 
        ESRD_V21,    
        AGEDIS_V22,    
        AGEDIS_V23,    
        AGEDIS_V24,    
        RXHCC_V05,
        ESRD_V21_IND,
        AGEDIS_V22_IND,
        AGEDIS_V23_IND,
        AGEDIS_V24_IND,
        RXHCC_V05_IND
)
SELECT 
    /*+ NO_MERGE MATERIALIZE*/ 
    MDL, DL_ASSESS_SK, ASSESSMENTDATE, MEDICAID_NUM,
    SUM(HCC1)         HCC1           ,
    SUM(HCC2)         HCC2           ,
    SUM(HCC5)         HCC5           ,
    SUM(HCC6)         HCC6           ,
    SUM(HCC8)         HCC8           ,
    SUM(HCC9)         HCC9           ,
    SUM(HCC10)         HCC10          ,
    SUM(HCC11)         HCC11          ,
    SUM(HCC12)         HCC12          ,
    SUM(HCC15)         HCC15          ,
    SUM(HCC16)         HCC16          ,
    SUM(HCC17)         HCC17          ,
    SUM(HCC18)         HCC18          ,
    SUM(HCC19)         HCC19          ,
    SUM(HCC21)         HCC21          ,
    SUM(HCC22)         HCC22          ,
    SUM(HCC23)         HCC23          ,
    SUM(HCC27)         HCC27          ,
    SUM(HCC28)         HCC28          ,
    SUM(HCC29)         HCC29          ,
    SUM(HCC30)         HCC30          ,
    SUM(HCC31)         HCC31          ,
    SUM(HCC33)         HCC33          ,
    SUM(HCC34)         HCC34          ,
    SUM(HCC35)         HCC35          ,
    SUM(HCC39)         HCC39          ,
    SUM(HCC40)         HCC40          ,
    SUM(HCC41)         HCC41          ,
    SUM(HCC42)         HCC42          ,
    SUM(HCC43)         HCC43          ,
    SUM(HCC45)         HCC45          ,
    SUM(HCC46)         HCC46          ,
    SUM(HCC47)         HCC47          ,
    SUM(HCC48)         HCC48          ,
    SUM(HCC51)         HCC51          ,
    SUM(HCC52)         HCC52          ,
    SUM(HCC54)         HCC54          ,
    SUM(HCC55)         HCC55          ,
    SUM(HCC56)         HCC56          ,
    SUM(HCC57)         HCC57          ,
    SUM(HCC58)         HCC58          ,
    SUM(HCC59)         HCC59          ,
    SUM(HCC60)         HCC60          ,
    SUM(HCC65)         HCC65          ,
    SUM(HCC66)         HCC66          ,
    SUM(HCC67)         HCC67          ,
    SUM(HCC68)         HCC68          ,
    SUM(HCC70)         HCC70          ,
    SUM(HCC71)         HCC71          ,
    SUM(HCC72)         HCC72          ,
    SUM(HCC73)         HCC73          ,
    SUM(HCC74)         HCC74          ,
    SUM(HCC75)         HCC75          ,
    SUM(HCC76)         HCC76          ,
    SUM(HCC77)         HCC77          ,
    SUM(HCC78)         HCC78          ,
    SUM(HCC79)         HCC79          ,
    SUM(HCC80)         HCC80          ,
    SUM(HCC82)         HCC82          ,
    SUM(HCC83)         HCC83          ,
    SUM(HCC84)         HCC84          ,
    SUM(HCC85)         HCC85          ,
    SUM(HCC86)         HCC86          ,
    SUM(HCC87)         HCC87          ,
    SUM(HCC88)         HCC88          ,
    SUM(HCC95)         HCC95          ,
    SUM(HCC96)         HCC96          ,
    SUM(HCC97)         HCC97          ,
    SUM(HCC98)         HCC98          ,
    SUM(HCC99)         HCC99          ,
    SUM(HCC100)         HCC100         ,
    SUM(HCC103)         HCC103         ,
    SUM(HCC104)         HCC104         ,
    SUM(HCC106)         HCC106         ,
    SUM(HCC107)         HCC107         ,
    SUM(HCC108)         HCC108         ,
    SUM(HCC110)         HCC110         ,
    SUM(HCC111)         HCC111         ,
    SUM(HCC112)         HCC112         ,
    SUM(HCC114)         HCC114         ,
    SUM(HCC115)         HCC115         ,
    SUM(HCC122)         HCC122         ,
    SUM(HCC124)         HCC124         ,
    SUM(HCC130)         HCC130         ,
    SUM(HCC131)         HCC131         ,
    SUM(HCC132)         HCC132         ,
    SUM(HCC133)         HCC133         ,
    SUM(HCC134)         HCC134         ,
    SUM(HCC135)         HCC135         ,
    SUM(HCC136)         HCC136         ,
    SUM(HCC137)         HCC137         ,
    SUM(HCC138)         HCC138         ,
    SUM(HCC139)         HCC139         ,
    SUM(HCC140)         HCC140         ,
    SUM(HCC141)         HCC141         ,
    SUM(HCC145)         HCC145         ,
    SUM(HCC146)         HCC146         ,
    SUM(HCC147)         HCC147         ,
    SUM(HCC148)         HCC148         ,
    SUM(HCC156)         HCC156         ,
    SUM(HCC157)         HCC157         ,
    SUM(HCC158)         HCC158         ,
    SUM(HCC159)         HCC159         ,
    SUM(HCC160)         HCC160         ,
    SUM(HCC161)         HCC161         ,
    SUM(HCC162)         HCC162         ,
    SUM(HCC163)         HCC163         ,
    SUM(HCC164)         HCC164         ,
    SUM(HCC165)         HCC165         ,
    SUM(HCC166)         HCC166         ,
    SUM(HCC167)         HCC167         ,
    SUM(HCC168)         HCC168         ,
    SUM(HCC169)         HCC169         ,
    SUM(HCC170)         HCC170         ,
    SUM(HCC173)         HCC173         ,
    SUM(HCC176)         HCC176         ,
    SUM(HCC185)         HCC185         ,
    SUM(HCC186)         HCC186         ,
    SUM(HCC187)         HCC187         ,
    SUM(HCC188)         HCC188         ,
    SUM(HCC189)         HCC189         ,
    SUM(HCC193)         HCC193         ,
    SUM(HCC206)         HCC206         ,
    SUM(HCC207)         HCC207         ,
    SUM(HCC215)         HCC215         ,
    SUM(HCC216)         HCC216         ,
    SUM(HCC225)         HCC225         ,
    SUM(HCC226)         HCC226         ,
    SUM(HCC227)         HCC227         ,
    SUM(HCC241)         HCC241         ,
    SUM(HCC243)         HCC243         ,
    SUM(HCC260)         HCC260         ,
    SUM(HCC261)         HCC261         ,
    SUM(HCC262)         HCC262         ,
    SUM(HCC263)         HCC263         ,
    SUM(HCC311)         HCC311         ,
    SUM(HCC314)         HCC314         ,
    SUM(HCC316)         HCC316         ,
    SUM(HCC355)         HCC355         ,
    SUM(HCC395)         HCC395         ,
    SUM(HCC396)         HCC396         ,
    SUM(HCC397)         HCC397         
FROM 
(
    (
        SELECT 'ESRD_V21' MDL, 
        DL_ASSESS_SK   
        ,ASSESSMENTDATE 
        ,MEDICAID_NUM   
        ,HCC1           
        ,HCC2           
        ,HCC5           
        ,HCC6           
        ,HCC8           
        ,HCC9           
        ,HCC10          
        ,HCC11          
        ,HCC12          
        ,HCC15          
        ,HCC16          
        ,HCC17          
        ,HCC18          
        ,HCC19          
        ,HCC21          
        ,HCC22          
        ,HCC23          
        ,HCC27          
        ,HCC28          
        ,HCC29          
        ,HCC30          
        ,HCC31          
        ,HCC33          
        ,HCC34          
        ,HCC35          
        ,HCC39          
        ,HCC40          
        ,HCC41          
        ,HCC42          
        ,HCC43          
        ,HCC45          
        ,HCC46          
        ,HCC47          
        ,HCC48          
        ,HCC51          
        ,HCC52          
        ,HCC54          
        ,HCC55          
        ,HCC56          
        ,HCC57          
        ,HCC58          
        ,HCC59          
        ,HCC60          
        ,HCC65          
        ,HCC66          
        ,HCC67          
        ,HCC68          
        ,HCC70          
        ,HCC71          
        ,HCC72          
        ,HCC73          
        ,HCC74          
        ,HCC75          
        ,HCC76          
        ,HCC77          
        ,HCC78          
        ,HCC79          
        ,HCC80          
        ,HCC82          
        ,HCC83          
        ,HCC84          
        ,HCC85          
        ,HCC86          
        ,HCC87          
        ,HCC88          
        ,HCC95          
        ,HCC96          
        ,HCC97          
        ,HCC98          
        ,HCC99          
        ,HCC100         
        ,HCC103         
        ,HCC104         
        ,HCC106         
        ,HCC107         
        ,HCC108         
        ,HCC110         
        ,HCC111         
        ,HCC112         
        ,HCC114         
        ,HCC115         
        ,HCC122         
        ,HCC124         
        ,HCC130         
        ,HCC131         
        ,HCC132         
        ,HCC133         
        ,HCC134         
        ,HCC135         
        ,HCC136         
        ,HCC137         
        ,HCC138         
        ,HCC139         
        ,HCC140         
        ,HCC141         
        ,HCC145         
        ,HCC146         
        ,HCC147         
        ,HCC148         
        ,HCC156         
        ,HCC157         
        ,HCC158         
        ,HCC159         
        ,HCC160         
        ,HCC161         
        ,HCC162         
        ,HCC163         
        ,HCC164         
        ,HCC165         
        ,HCC166         
        ,HCC167         
        ,HCC168         
        ,HCC169         
        ,HCC170         
        ,HCC173         
        ,HCC176         
        ,HCC185         
        ,HCC186         
        ,HCC187         
        ,HCC188         
        ,HCC189         
        ,HCC193         
        ,HCC206         
        ,HCC207         
        ,HCC215         
        ,HCC216         
        ,HCC225         
        ,HCC226         
        ,HCC227         
        ,HCC241         
        ,HCC243         
        ,HCC260         
        ,HCC261         
        ,HCC262         
        ,HCC263         
        ,HCC311         
        ,HCC314         
        ,HCC316         
        ,HCC355         
        ,HCC395         
        ,HCC396         
        ,HCC397         
        FROM
        (
        SELECT * 
        FROM HCC  
        PIVOT
        ( 
            min('1') FOR ESRD_V21 IN ( 
                                        '1' AS HCC1,
                                        '2' AS HCC2,
                                        '5' AS HCC5,
                                        '6' AS HCC6,
                                        '8' AS HCC8,
                                        '9' AS HCC9,
                                        '10' AS HCC10,
                                        '11' AS HCC11,
                                        '12' AS HCC12,
                                        '15' AS HCC15,
                                        '16' AS HCC16,
                                        '17' AS HCC17,
                                        '18' AS HCC18,
                                        '19' AS HCC19,
                                        '21' AS HCC21,
                                        '22' AS HCC22,
                                        '23' AS HCC23,
                                        '27' AS HCC27,
                                        '28' AS HCC28,
                                        '29' AS HCC29,
                                        '30' AS HCC30,
                                        '31' AS HCC31,
                                        '33' AS HCC33,
                                        '34' AS HCC34,
                                        '35' AS HCC35,
                                        '39' AS HCC39,
                                        '40' AS HCC40,
                                        '41' AS HCC41,
                                        '42' AS HCC42,
                                        '43' AS HCC43,
                                        '45' AS HCC45,
                                        '46' AS HCC46,
                                        '47' AS HCC47,
                                        '48' AS HCC48,
                                        '51' AS HCC51,
                                        '52' AS HCC52,
                                        '54' AS HCC54,
                                        '55' AS HCC55,
                                        '56' AS HCC56,
                                        '57' AS HCC57,
                                        '58' AS HCC58,
                                        '59' AS HCC59 ,
                                        '60' AS HCC60 ,
                                        '65' AS HCC65 ,
                                        '66' AS HCC66 ,
                                        '67' AS HCC67 ,
                                        '68' AS HCC68 ,
                                        '70' AS HCC70 ,
                                        '71' AS HCC71 ,
                                        '72' AS HCC72 ,
                                        '73' AS HCC73 ,
                                        '74' AS HCC74 ,
                                        '75' AS HCC75 ,
                                        '76' AS HCC76 ,
                                        '77' AS HCC77 ,
                                        '78' AS HCC78 ,
                                        '79' AS HCC79 ,
                                        '80' AS HCC80 ,
                                        '82' AS HCC82 ,
                                        '83' AS HCC83 ,
                                        '84' AS HCC84 ,
                                        '85' AS HCC85 ,
                                        '86' AS HCC86 ,
                                        '87' AS HCC87 ,
                                        '88' AS HCC88 ,
                                        '95' AS HCC95 ,
                                        '96' AS HCC96 ,
                                        '97' AS HCC97 ,
                                        '98' AS HCC98 ,
                                        '99' AS HCC99 ,
                                        '100' AS HCC100 ,
                                        '103' AS HCC103 ,
                                        '104' AS HCC104 ,
                                        '106' AS HCC106 ,
                                        '107' AS HCC107 ,
                                        '108' AS HCC108 ,
                                        '110' AS HCC110 ,
                                        '111' AS HCC111 ,
                                        '112' AS HCC112 ,
                                        '114' AS HCC114 ,
                                        '115' AS HCC115 ,
                                        '122' AS HCC122 ,
                                        '124' AS HCC124 ,
                                        '130' AS HCC130 ,
                                        '131' AS HCC131 ,
                                        '132' AS HCC132 ,
                                        '133' AS HCC133 ,
                                        '134' AS HCC134 ,
                                        '135' AS HCC135 ,
                                        '136' AS HCC136 ,
                                        '137' AS HCC137 ,
                                        '138' AS HCC138 ,
                                        '139' AS HCC139 ,
                                        '140' AS HCC140 ,
                                        '141' AS HCC141 ,
                                        '145' AS HCC145 ,
                                        '146' AS HCC146 ,
                                        '147' AS HCC147 ,
                                        '148' AS HCC148 ,
                                        '156' AS HCC156 ,
                                        '157' AS HCC157 ,
                                        '158' AS HCC158 ,
                                        '159' AS HCC159 ,
                                        '160' AS HCC160 ,
                                        '161' AS HCC161 ,
                                        '162' AS HCC162 ,
                                        '163' AS HCC163 ,
                                        '164' AS HCC164 ,
                                        '165' AS HCC165 ,
                                        '166' AS HCC166 ,
                                        '167' AS HCC167 ,
                                        '168' AS HCC168 ,
                                        '169' AS HCC169 ,
                                        '170' AS HCC170 ,
                                        '173' AS HCC173 ,
                                        '176' AS HCC176 ,
                                        '185' AS HCC185 ,
                                        '186' AS HCC186 ,
                                        '187' AS HCC187 ,
                                        '188' AS HCC188 ,
                                        '189' AS HCC189 ,
                                        '193' AS HCC193 ,
                                        '206' AS HCC206 ,
                                        '207' AS HCC207 ,
                                        '215' AS HCC215 ,
                                        '216' AS HCC216 ,
                                        '225' AS HCC225 ,
                                        '226' AS HCC226 ,
                                        '227' AS HCC227 ,
                                        '241' AS HCC241 ,
                                        '243' AS HCC243 ,
                                        '260' AS HCC260 ,
                                        '261' AS HCC261 ,
                                        '262' AS HCC262 ,
                                        '263' AS HCC263 ,
                                        '311' AS HCC311 ,
                                        '314' AS HCC314 ,
                                        '316' AS HCC316 ,
                                        '355' AS HCC355 ,
                                        '395' AS HCC395 ,
                                        '396' AS HCC396 ,
                                        '397' AS HCC397   
            )
            )
            WHERE ESRD_V21_IND = 1
        ) A
    )
    UNION ALL
    (
        SELECT 'AGEDIS_V22' MDL, 
        DL_ASSESS_SK   
        ,ASSESSMENTDATE 
        ,MEDICAID_NUM   
        ,HCC1           
        ,HCC2           
        ,HCC5           
        ,HCC6           
        ,HCC8           
        ,HCC9           
        ,HCC10          
        ,HCC11          
        ,HCC12          
        ,HCC15          
        ,HCC16          
        ,HCC17          
        ,HCC18          
        ,HCC19          
        ,HCC21          
        ,HCC22          
        ,HCC23          
        ,HCC27          
        ,HCC28          
        ,HCC29          
        ,HCC30          
        ,HCC31          
        ,HCC33          
        ,HCC34          
        ,HCC35          
        ,HCC39          
        ,HCC40          
        ,HCC41          
        ,HCC42          
        ,HCC43          
        ,HCC45          
        ,HCC46          
        ,HCC47          
        ,HCC48          
        ,HCC51          
        ,HCC52          
        ,HCC54          
        ,HCC55          
        ,HCC56          
        ,HCC57          
        ,HCC58          
        ,HCC59          
        ,HCC60          
        ,HCC65          
        ,HCC66          
        ,HCC67          
        ,HCC68          
        ,HCC70          
        ,HCC71          
        ,HCC72          
        ,HCC73          
        ,HCC74          
        ,HCC75          
        ,HCC76          
        ,HCC77          
        ,HCC78          
        ,HCC79          
        ,HCC80          
        ,HCC82          
        ,HCC83          
        ,HCC84          
        ,HCC85          
        ,HCC86          
        ,HCC87          
        ,HCC88          
        ,HCC95          
        ,HCC96          
        ,HCC97          
        ,HCC98          
        ,HCC99          
        ,HCC100         
        ,HCC103         
        ,HCC104         
        ,HCC106         
        ,HCC107         
        ,HCC108         
        ,HCC110         
        ,HCC111         
        ,HCC112         
        ,HCC114         
        ,HCC115         
        ,HCC122         
        ,HCC124         
        ,HCC130         
        ,HCC131         
        ,HCC132         
        ,HCC133         
        ,HCC134         
        ,HCC135         
        ,HCC136         
        ,HCC137         
        ,HCC138         
        ,HCC139         
        ,HCC140         
        ,HCC141         
        ,HCC145         
        ,HCC146         
        ,HCC147         
        ,HCC148         
        ,HCC156         
        ,HCC157         
        ,HCC158         
        ,HCC159         
        ,HCC160         
        ,HCC161         
        ,HCC162         
        ,HCC163         
        ,HCC164         
        ,HCC165         
        ,HCC166         
        ,HCC167         
        ,HCC168         
        ,HCC169         
        ,HCC170         
        ,HCC173         
        ,HCC176         
        ,HCC185         
        ,HCC186         
        ,HCC187         
        ,HCC188         
        ,HCC189         
        ,HCC193         
        ,HCC206         
        ,HCC207         
        ,HCC215         
        ,HCC216         
        ,HCC225         
        ,HCC226         
        ,HCC227         
        ,HCC241         
        ,HCC243         
        ,HCC260         
        ,HCC261         
        ,HCC262         
        ,HCC263         
        ,HCC311         
        ,HCC314         
        ,HCC316         
        ,HCC355         
        ,HCC395         
        ,HCC396         
        ,HCC397         
        FROM
        (
        SELECT * 
        FROM HCC  
        PIVOT
        ( 
            min('1') FOR AGEDIS_V22 IN ( 
                                        '1' AS HCC1,
                                        '2' AS HCC2,
                                        '5' AS HCC5,
                                        '6' AS HCC6,
                                        '8' AS HCC8,
                                        '9' AS HCC9,
                                        '10' AS HCC10,
                                        '11' AS HCC11,
                                        '12' AS HCC12,
                                        '15' AS HCC15,
                                        '16' AS HCC16,
                                        '17' AS HCC17,
                                        '18' AS HCC18,
                                        '19' AS HCC19,
                                        '21' AS HCC21,
                                        '22' AS HCC22,
                                        '23' AS HCC23,
                                        '27' AS HCC27,
                                        '28' AS HCC28,
                                        '29' AS HCC29,
                                        '30' AS HCC30,
                                        '31' AS HCC31,
                                        '33' AS HCC33,
                                        '34' AS HCC34,
                                        '35' AS HCC35,
                                        '39' AS HCC39,
                                        '40' AS HCC40,
                                        '41' AS HCC41,
                                        '42' AS HCC42,
                                        '43' AS HCC43,
                                        '45' AS HCC45,
                                        '46' AS HCC46,
                                        '47' AS HCC47,
                                        '48' AS HCC48,
                                        '51' AS HCC51,
                                        '52' AS HCC52,
                                        '54' AS HCC54,
                                        '55' AS HCC55,
                                        '56' AS HCC56,
                                        '57' AS HCC57,
                                        '58' AS HCC58,
                                        '59' AS HCC59 ,
                                        '60' AS HCC60 ,
                                        '65' AS HCC65 ,
                                        '66' AS HCC66 ,
                                        '67' AS HCC67 ,
                                        '68' AS HCC68 ,
                                        '70' AS HCC70 ,
                                        '71' AS HCC71 ,
                                        '72' AS HCC72 ,
                                        '73' AS HCC73 ,
                                        '74' AS HCC74 ,
                                        '75' AS HCC75 ,
                                        '76' AS HCC76 ,
                                        '77' AS HCC77 ,
                                        '78' AS HCC78 ,
                                        '79' AS HCC79 ,
                                        '80' AS HCC80 ,
                                        '82' AS HCC82 ,
                                        '83' AS HCC83 ,
                                        '84' AS HCC84 ,
                                        '85' AS HCC85 ,
                                        '86' AS HCC86 ,
                                        '87' AS HCC87 ,
                                        '88' AS HCC88 ,
                                        '95' AS HCC95 ,
                                        '96' AS HCC96 ,
                                        '97' AS HCC97 ,
                                        '98' AS HCC98 ,
                                        '99' AS HCC99 ,
                                        '100' AS HCC100 ,
                                        '103' AS HCC103 ,
                                        '104' AS HCC104 ,
                                        '106' AS HCC106 ,
                                        '107' AS HCC107 ,
                                        '108' AS HCC108 ,
                                        '110' AS HCC110 ,
                                        '111' AS HCC111 ,
                                        '112' AS HCC112 ,
                                        '114' AS HCC114 ,
                                        '115' AS HCC115 ,
                                        '122' AS HCC122 ,
                                        '124' AS HCC124 ,
                                        '130' AS HCC130 ,
                                        '131' AS HCC131 ,
                                        '132' AS HCC132 ,
                                        '133' AS HCC133 ,
                                        '134' AS HCC134 ,
                                        '135' AS HCC135 ,
                                        '136' AS HCC136 ,
                                        '137' AS HCC137 ,
                                        '138' AS HCC138 ,
                                        '139' AS HCC139 ,
                                        '140' AS HCC140 ,
                                        '141' AS HCC141 ,
                                        '145' AS HCC145 ,
                                        '146' AS HCC146 ,
                                        '147' AS HCC147 ,
                                        '148' AS HCC148 ,
                                        '156' AS HCC156 ,
                                        '157' AS HCC157 ,
                                        '158' AS HCC158 ,
                                        '159' AS HCC159 ,
                                        '160' AS HCC160 ,
                                        '161' AS HCC161 ,
                                        '162' AS HCC162 ,
                                        '163' AS HCC163 ,
                                        '164' AS HCC164 ,
                                        '165' AS HCC165 ,
                                        '166' AS HCC166 ,
                                        '167' AS HCC167 ,
                                        '168' AS HCC168 ,
                                        '169' AS HCC169 ,
                                        '170' AS HCC170 ,
                                        '173' AS HCC173 ,
                                        '176' AS HCC176 ,
                                        '185' AS HCC185 ,
                                        '186' AS HCC186 ,
                                        '187' AS HCC187 ,
                                        '188' AS HCC188 ,
                                        '189' AS HCC189 ,
                                        '193' AS HCC193 ,
                                        '206' AS HCC206 ,
                                        '207' AS HCC207 ,
                                        '215' AS HCC215 ,
                                        '216' AS HCC216 ,
                                        '225' AS HCC225 ,
                                        '226' AS HCC226 ,
                                        '227' AS HCC227 ,
                                        '241' AS HCC241 ,
                                        '243' AS HCC243 ,
                                        '260' AS HCC260 ,
                                        '261' AS HCC261 ,
                                        '262' AS HCC262 ,
                                        '263' AS HCC263 ,
                                        '311' AS HCC311 ,
                                        '314' AS HCC314 ,
                                        '316' AS HCC316 ,
                                        '355' AS HCC355 ,
                                        '395' AS HCC395 ,
                                        '396' AS HCC396 ,
                                        '397' AS HCC397   
            )
            )
            WHERE AGEDIS_V22_ind = 1
        ) A
        )
    UNION ALL
    (
        SELECT 
         'AGEDIS_V23' MDL, 
         DL_ASSESS_SK   
        ,ASSESSMENTDATE 
        ,MEDICAID_NUM   
        ,HCC1           
        ,HCC2           
        ,HCC5           
        ,HCC6           
        ,HCC8           
        ,HCC9           
        ,HCC10          
        ,HCC11          
        ,HCC12          
        ,HCC15          
        ,HCC16          
        ,HCC17          
        ,HCC18          
        ,HCC19          
        ,HCC21          
        ,HCC22          
        ,HCC23          
        ,HCC27          
        ,HCC28          
        ,HCC29          
        ,HCC30          
        ,HCC31          
        ,HCC33          
        ,HCC34          
        ,HCC35          
        ,HCC39          
        ,HCC40          
        ,HCC41          
        ,HCC42          
        ,HCC43          
        ,HCC45          
        ,HCC46          
        ,HCC47          
        ,HCC48          
        ,HCC51          
        ,HCC52          
        ,HCC54          
        ,HCC55          
        ,HCC56          
        ,HCC57          
        ,HCC58          
        ,HCC59          
        ,HCC60          
        ,HCC65          
        ,HCC66          
        ,HCC67          
        ,HCC68          
        ,HCC70          
        ,HCC71          
        ,HCC72          
        ,HCC73          
        ,HCC74          
        ,HCC75          
        ,HCC76          
        ,HCC77          
        ,HCC78          
        ,HCC79          
        ,HCC80          
        ,HCC82          
        ,HCC83          
        ,HCC84          
        ,HCC85          
        ,HCC86          
        ,HCC87          
        ,HCC88          
        ,HCC95          
        ,HCC96          
        ,HCC97          
        ,HCC98          
        ,HCC99          
        ,HCC100         
        ,HCC103         
        ,HCC104         
        ,HCC106         
        ,HCC107         
        ,HCC108         
        ,HCC110         
        ,HCC111         
        ,HCC112         
        ,HCC114         
        ,HCC115         
        ,HCC122         
        ,HCC124         
        ,HCC130         
        ,HCC131         
        ,HCC132         
        ,HCC133         
        ,HCC134         
        ,HCC135         
        ,HCC136         
        ,HCC137         
        ,HCC138         
        ,HCC139         
        ,HCC140         
        ,HCC141         
        ,HCC145         
        ,HCC146         
        ,HCC147         
        ,HCC148         
        ,HCC156         
        ,HCC157         
        ,HCC158         
        ,HCC159         
        ,HCC160         
        ,HCC161         
        ,HCC162         
        ,HCC163         
        ,HCC164         
        ,HCC165         
        ,HCC166         
        ,HCC167         
        ,HCC168         
        ,HCC169         
        ,HCC170         
        ,HCC173         
        ,HCC176         
        ,HCC185         
        ,HCC186         
        ,HCC187         
        ,HCC188         
        ,HCC189         
        ,HCC193         
        ,HCC206         
        ,HCC207         
        ,HCC215         
        ,HCC216         
        ,HCC225         
        ,HCC226         
        ,HCC227         
        ,HCC241         
        ,HCC243         
        ,HCC260         
        ,HCC261         
        ,HCC262         
        ,HCC263         
        ,HCC311         
        ,HCC314         
        ,HCC316         
        ,HCC355         
        ,HCC395         
        ,HCC396         
        ,HCC397         
        FROM
        (
        SELECT * 
        FROM HCC  
        PIVOT
        ( 
            min('1') FOR AGEDIS_V23 IN ( 
                                        '1' AS HCC1,
                                        '2' AS HCC2,
                                        '5' AS HCC5,
                                        '6' AS HCC6,
                                        '8' AS HCC8,
                                        '9' AS HCC9,
                                        '10' AS HCC10,
                                        '11' AS HCC11,
                                        '12' AS HCC12,
                                        '15' AS HCC15,
                                        '16' AS HCC16,
                                        '17' AS HCC17,
                                        '18' AS HCC18,
                                        '19' AS HCC19,
                                        '21' AS HCC21,
                                        '22' AS HCC22,
                                        '23' AS HCC23,
                                        '27' AS HCC27,
                                        '28' AS HCC28,
                                        '29' AS HCC29,
                                        '30' AS HCC30,
                                        '31' AS HCC31,
                                        '33' AS HCC33,
                                        '34' AS HCC34,
                                        '35' AS HCC35,
                                        '39' AS HCC39,
                                        '40' AS HCC40,
                                        '41' AS HCC41,
                                        '42' AS HCC42,
                                        '43' AS HCC43,
                                        '45' AS HCC45,
                                        '46' AS HCC46,
                                        '47' AS HCC47,
                                        '48' AS HCC48,
                                        '51' AS HCC51,
                                        '52' AS HCC52,
                                        '54' AS HCC54,
                                        '55' AS HCC55,
                                        '56' AS HCC56,
                                        '57' AS HCC57,
                                        '58' AS HCC58,
                                        '59' AS HCC59 ,
                                        '60' AS HCC60 ,
                                        '65' AS HCC65 ,
                                        '66' AS HCC66 ,
                                        '67' AS HCC67 ,
                                        '68' AS HCC68 ,
                                        '70' AS HCC70 ,
                                        '71' AS HCC71 ,
                                        '72' AS HCC72 ,
                                        '73' AS HCC73 ,
                                        '74' AS HCC74 ,
                                        '75' AS HCC75 ,
                                        '76' AS HCC76 ,
                                        '77' AS HCC77 ,
                                        '78' AS HCC78 ,
                                        '79' AS HCC79 ,
                                        '80' AS HCC80 ,
                                        '82' AS HCC82 ,
                                        '83' AS HCC83 ,
                                        '84' AS HCC84 ,
                                        '85' AS HCC85 ,
                                        '86' AS HCC86 ,
                                        '87' AS HCC87 ,
                                        '88' AS HCC88 ,
                                        '95' AS HCC95 ,
                                        '96' AS HCC96 ,
                                        '97' AS HCC97 ,
                                        '98' AS HCC98 ,
                                        '99' AS HCC99 ,
                                        '100' AS HCC100 ,
                                        '103' AS HCC103 ,
                                        '104' AS HCC104 ,
                                        '106' AS HCC106 ,
                                        '107' AS HCC107 ,
                                        '108' AS HCC108 ,
                                        '110' AS HCC110 ,
                                        '111' AS HCC111 ,
                                        '112' AS HCC112 ,
                                        '114' AS HCC114 ,
                                        '115' AS HCC115 ,
                                        '122' AS HCC122 ,
                                        '124' AS HCC124 ,
                                        '130' AS HCC130 ,
                                        '131' AS HCC131 ,
                                        '132' AS HCC132 ,
                                        '133' AS HCC133 ,
                                        '134' AS HCC134 ,
                                        '135' AS HCC135 ,
                                        '136' AS HCC136 ,
                                        '137' AS HCC137 ,
                                        '138' AS HCC138 ,
                                        '139' AS HCC139 ,
                                        '140' AS HCC140 ,
                                        '141' AS HCC141 ,
                                        '145' AS HCC145 ,
                                        '146' AS HCC146 ,
                                        '147' AS HCC147 ,
                                        '148' AS HCC148 ,
                                        '156' AS HCC156 ,
                                        '157' AS HCC157 ,
                                        '158' AS HCC158 ,
                                        '159' AS HCC159 ,
                                        '160' AS HCC160 ,
                                        '161' AS HCC161 ,
                                        '162' AS HCC162 ,
                                        '163' AS HCC163 ,
                                        '164' AS HCC164 ,
                                        '165' AS HCC165 ,
                                        '166' AS HCC166 ,
                                        '167' AS HCC167 ,
                                        '168' AS HCC168 ,
                                        '169' AS HCC169 ,
                                        '170' AS HCC170 ,
                                        '173' AS HCC173 ,
                                        '176' AS HCC176 ,
                                        '185' AS HCC185 ,
                                        '186' AS HCC186 ,
                                        '187' AS HCC187 ,
                                        '188' AS HCC188 ,
                                        '189' AS HCC189 ,
                                        '193' AS HCC193 ,
                                        '206' AS HCC206 ,
                                        '207' AS HCC207 ,
                                        '215' AS HCC215 ,
                                        '216' AS HCC216 ,
                                        '225' AS HCC225 ,
                                        '226' AS HCC226 ,
                                        '227' AS HCC227 ,
                                        '241' AS HCC241 ,
                                        '243' AS HCC243 ,
                                        '260' AS HCC260 ,
                                        '261' AS HCC261 ,
                                        '262' AS HCC262 ,
                                        '263' AS HCC263 ,
                                        '311' AS HCC311 ,
                                        '314' AS HCC314 ,
                                        '316' AS HCC316 ,
                                        '355' AS HCC355 ,
                                        '395' AS HCC395 ,
                                        '396' AS HCC396 ,
                                        '397' AS HCC397   
            )
            )
            WHERE AGEDIS_V23_inD = 1
        ) A
    )
    UNION ALL
    (
        SELECT 
         'AGEDIS_V24' MDL, 
         DL_ASSESS_SK   
        ,ASSESSMENTDATE 
        ,MEDICAID_NUM   
        ,HCC1           
        ,HCC2           
        ,HCC5           
        ,HCC6           
        ,HCC8           
        ,HCC9           
        ,HCC10          
        ,HCC11          
        ,HCC12          
        ,HCC15          
        ,HCC16          
        ,HCC17          
        ,HCC18          
        ,HCC19          
        ,HCC21          
        ,HCC22          
        ,HCC23          
        ,HCC27          
        ,HCC28          
        ,HCC29          
        ,HCC30          
        ,HCC31          
        ,HCC33          
        ,HCC34          
        ,HCC35          
        ,HCC39          
        ,HCC40          
        ,HCC41          
        ,HCC42          
        ,HCC43          
        ,HCC45          
        ,HCC46          
        ,HCC47          
        ,HCC48          
        ,HCC51          
        ,HCC52          
        ,HCC54          
        ,HCC55          
        ,HCC56          
        ,HCC57          
        ,HCC58          
        ,HCC59          
        ,HCC60          
        ,HCC65          
        ,HCC66          
        ,HCC67          
        ,HCC68          
        ,HCC70          
        ,HCC71          
        ,HCC72          
        ,HCC73          
        ,HCC74          
        ,HCC75          
        ,HCC76          
        ,HCC77          
        ,HCC78          
        ,HCC79          
        ,HCC80          
        ,HCC82          
        ,HCC83          
        ,HCC84          
        ,HCC85          
        ,HCC86          
        ,HCC87          
        ,HCC88          
        ,HCC95          
        ,HCC96          
        ,HCC97          
        ,HCC98          
        ,HCC99          
        ,HCC100         
        ,HCC103         
        ,HCC104         
        ,HCC106         
        ,HCC107         
        ,HCC108         
        ,HCC110         
        ,HCC111         
        ,HCC112         
        ,HCC114         
        ,HCC115         
        ,HCC122         
        ,HCC124         
        ,HCC130         
        ,HCC131         
        ,HCC132         
        ,HCC133         
        ,HCC134         
        ,HCC135         
        ,HCC136         
        ,HCC137         
        ,HCC138         
        ,HCC139         
        ,HCC140         
        ,HCC141         
        ,HCC145         
        ,HCC146         
        ,HCC147         
        ,HCC148         
        ,HCC156         
        ,HCC157         
        ,HCC158         
        ,HCC159         
        ,HCC160         
        ,HCC161         
        ,HCC162         
        ,HCC163         
        ,HCC164         
        ,HCC165         
        ,HCC166         
        ,HCC167         
        ,HCC168         
        ,HCC169         
        ,HCC170         
        ,HCC173         
        ,HCC176         
        ,HCC185         
        ,HCC186         
        ,HCC187         
        ,HCC188         
        ,HCC189         
        ,HCC193         
        ,HCC206         
        ,HCC207         
        ,HCC215         
        ,HCC216         
        ,HCC225         
        ,HCC226         
        ,HCC227         
        ,HCC241         
        ,HCC243         
        ,HCC260         
        ,HCC261         
        ,HCC262         
        ,HCC263         
        ,HCC311         
        ,HCC314         
        ,HCC316         
        ,HCC355         
        ,HCC395         
        ,HCC396         
        ,HCC397         
        FROM
        (
        SELECT * 
        FROM HCC  
        PIVOT
        ( 
            min('1') FOR AGEDIS_V24 IN ( 
                                        '1' AS HCC1,
                                        '2' AS HCC2,
                                        '5' AS HCC5,
                                        '6' AS HCC6,
                                        '8' AS HCC8,
                                        '9' AS HCC9,
                                        '10' AS HCC10,
                                        '11' AS HCC11,
                                        '12' AS HCC12,
                                        '15' AS HCC15,
                                        '16' AS HCC16,
                                        '17' AS HCC17,
                                        '18' AS HCC18,
                                        '19' AS HCC19,
                                        '21' AS HCC21,
                                        '22' AS HCC22,
                                        '23' AS HCC23,
                                        '27' AS HCC27,
                                        '28' AS HCC28,
                                        '29' AS HCC29,
                                        '30' AS HCC30,
                                        '31' AS HCC31,
                                        '33' AS HCC33,
                                        '34' AS HCC34,
                                        '35' AS HCC35,
                                        '39' AS HCC39,
                                        '40' AS HCC40,
                                        '41' AS HCC41,
                                        '42' AS HCC42,
                                        '43' AS HCC43,
                                        '45' AS HCC45,
                                        '46' AS HCC46,
                                        '47' AS HCC47,
                                        '48' AS HCC48,
                                        '51' AS HCC51,
                                        '52' AS HCC52,
                                        '54' AS HCC54,
                                        '55' AS HCC55,
                                        '56' AS HCC56,
                                        '57' AS HCC57,
                                        '58' AS HCC58,
                                        '59' AS HCC59 ,
                                        '60' AS HCC60 ,
                                        '65' AS HCC65 ,
                                        '66' AS HCC66 ,
                                        '67' AS HCC67 ,
                                        '68' AS HCC68 ,
                                        '70' AS HCC70 ,
                                        '71' AS HCC71 ,
                                        '72' AS HCC72 ,
                                        '73' AS HCC73 ,
                                        '74' AS HCC74 ,
                                        '75' AS HCC75 ,
                                        '76' AS HCC76 ,
                                        '77' AS HCC77 ,
                                        '78' AS HCC78 ,
                                        '79' AS HCC79 ,
                                        '80' AS HCC80 ,
                                        '82' AS HCC82 ,
                                        '83' AS HCC83 ,
                                        '84' AS HCC84 ,
                                        '85' AS HCC85 ,
                                        '86' AS HCC86 ,
                                        '87' AS HCC87 ,
                                        '88' AS HCC88 ,
                                        '95' AS HCC95 ,
                                        '96' AS HCC96 ,
                                        '97' AS HCC97 ,
                                        '98' AS HCC98 ,
                                        '99' AS HCC99 ,
                                        '100' AS HCC100 ,
                                        '103' AS HCC103 ,
                                        '104' AS HCC104 ,
                                        '106' AS HCC106 ,
                                        '107' AS HCC107 ,
                                        '108' AS HCC108 ,
                                        '110' AS HCC110 ,
                                        '111' AS HCC111 ,
                                        '112' AS HCC112 ,
                                        '114' AS HCC114 ,
                                        '115' AS HCC115 ,
                                        '122' AS HCC122 ,
                                        '124' AS HCC124 ,
                                        '130' AS HCC130 ,
                                        '131' AS HCC131 ,
                                        '132' AS HCC132 ,
                                        '133' AS HCC133 ,
                                        '134' AS HCC134 ,
                                        '135' AS HCC135 ,
                                        '136' AS HCC136 ,
                                        '137' AS HCC137 ,
                                        '138' AS HCC138 ,
                                        '139' AS HCC139 ,
                                        '140' AS HCC140 ,
                                        '141' AS HCC141 ,
                                        '145' AS HCC145 ,
                                        '146' AS HCC146 ,
                                        '147' AS HCC147 ,
                                        '148' AS HCC148 ,
                                        '156' AS HCC156 ,
                                        '157' AS HCC157 ,
                                        '158' AS HCC158 ,
                                        '159' AS HCC159 ,
                                        '160' AS HCC160 ,
                                        '161' AS HCC161 ,
                                        '162' AS HCC162 ,
                                        '163' AS HCC163 ,
                                        '164' AS HCC164 ,
                                        '165' AS HCC165 ,
                                        '166' AS HCC166 ,
                                        '167' AS HCC167 ,
                                        '168' AS HCC168 ,
                                        '169' AS HCC169 ,
                                        '170' AS HCC170 ,
                                        '173' AS HCC173 ,
                                        '176' AS HCC176 ,
                                        '185' AS HCC185 ,
                                        '186' AS HCC186 ,
                                        '187' AS HCC187 ,
                                        '188' AS HCC188 ,
                                        '189' AS HCC189 ,
                                        '193' AS HCC193 ,
                                        '206' AS HCC206 ,
                                        '207' AS HCC207 ,
                                        '215' AS HCC215 ,
                                        '216' AS HCC216 ,
                                        '225' AS HCC225 ,
                                        '226' AS HCC226 ,
                                        '227' AS HCC227 ,
                                        '241' AS HCC241 ,
                                        '243' AS HCC243 ,
                                        '260' AS HCC260 ,
                                        '261' AS HCC261 ,
                                        '262' AS HCC262 ,
                                        '263' AS HCC263 ,
                                        '311' AS HCC311 ,
                                        '314' AS HCC314 ,
                                        '316' AS HCC316 ,
                                        '355' AS HCC355 ,
                                        '395' AS HCC395 ,
                                        '396' AS HCC396 ,
                                        '397' AS HCC397   
            )
            )
            WHERE AGEDIS_V24_inD = 1
        ) A
    )
    UNION ALL
    (
        SELECT 
         'RXHCC_V05' MDL, 
         DL_ASSESS_SK   
        ,ASSESSMENTDATE 
        ,MEDICAID_NUM   
        ,HCC1           
        ,HCC2           
        ,HCC5           
        ,HCC6           
        ,HCC8           
        ,HCC9           
        ,HCC10          
        ,HCC11          
        ,HCC12          
        ,HCC15          
        ,HCC16          
        ,HCC17          
        ,HCC18          
        ,HCC19          
        ,HCC21          
        ,HCC22          
        ,HCC23          
        ,HCC27          
        ,HCC28          
        ,HCC29          
        ,HCC30          
        ,HCC31          
        ,HCC33          
        ,HCC34          
        ,HCC35          
        ,HCC39          
        ,HCC40          
        ,HCC41          
        ,HCC42          
        ,HCC43          
        ,HCC45          
        ,HCC46          
        ,HCC47          
        ,HCC48          
        ,HCC51          
        ,HCC52          
        ,HCC54          
        ,HCC55          
        ,HCC56          
        ,HCC57          
        ,HCC58          
        ,HCC59          
        ,HCC60          
        ,HCC65          
        ,HCC66          
        ,HCC67          
        ,HCC68          
        ,HCC70          
        ,HCC71          
        ,HCC72          
        ,HCC73          
        ,HCC74          
        ,HCC75          
        ,HCC76          
        ,HCC77          
        ,HCC78          
        ,HCC79          
        ,HCC80          
        ,HCC82          
        ,HCC83          
        ,HCC84          
        ,HCC85          
        ,HCC86          
        ,HCC87          
        ,HCC88          
        ,HCC95          
        ,HCC96          
        ,HCC97          
        ,HCC98          
        ,HCC99          
        ,HCC100         
        ,HCC103         
        ,HCC104         
        ,HCC106         
        ,HCC107         
        ,HCC108         
        ,HCC110         
        ,HCC111         
        ,HCC112         
        ,HCC114         
        ,HCC115         
        ,HCC122         
        ,HCC124         
        ,HCC130         
        ,HCC131         
        ,HCC132         
        ,HCC133         
        ,HCC134         
        ,HCC135         
        ,HCC136         
        ,HCC137         
        ,HCC138         
        ,HCC139         
        ,HCC140         
        ,HCC141         
        ,HCC145         
        ,HCC146         
        ,HCC147         
        ,HCC148         
        ,HCC156         
        ,HCC157         
        ,HCC158         
        ,HCC159         
        ,HCC160         
        ,HCC161         
        ,HCC162         
        ,HCC163         
        ,HCC164         
        ,HCC165         
        ,HCC166         
        ,HCC167         
        ,HCC168         
        ,HCC169         
        ,HCC170         
        ,HCC173         
        ,HCC176         
        ,HCC185         
        ,HCC186         
        ,HCC187         
        ,HCC188         
        ,HCC189         
        ,HCC193         
        ,HCC206         
        ,HCC207         
        ,HCC215         
        ,HCC216         
        ,HCC225         
        ,HCC226         
        ,HCC227         
        ,HCC241         
        ,HCC243         
        ,HCC260         
        ,HCC261         
        ,HCC262         
        ,HCC263         
        ,HCC311         
        ,HCC314         
        ,HCC316         
        ,HCC355         
        ,HCC395         
        ,HCC396         
        ,HCC397         
        FROM
        (
        SELECT * 
        FROM HCC  
        PIVOT
        ( 
            min('1') FOR RXHCC_V05 IN ( 
                                        '1' AS HCC1,
                                        '2' AS HCC2,
                                        '5' AS HCC5,
                                        '6' AS HCC6,
                                        '8' AS HCC8,
                                        '9' AS HCC9,
                                        '10' AS HCC10,
                                        '11' AS HCC11,
                                        '12' AS HCC12,
                                        '15' AS HCC15,
                                        '16' AS HCC16,
                                        '17' AS HCC17,
                                        '18' AS HCC18,
                                        '19' AS HCC19,
                                        '21' AS HCC21,
                                        '22' AS HCC22,
                                        '23' AS HCC23,
                                        '27' AS HCC27,
                                        '28' AS HCC28,
                                        '29' AS HCC29,
                                        '30' AS HCC30,
                                        '31' AS HCC31,
                                        '33' AS HCC33,
                                        '34' AS HCC34,
                                        '35' AS HCC35,
                                        '39' AS HCC39,
                                        '40' AS HCC40,
                                        '41' AS HCC41,
                                        '42' AS HCC42,
                                        '43' AS HCC43,
                                        '45' AS HCC45,
                                        '46' AS HCC46,
                                        '47' AS HCC47,
                                        '48' AS HCC48,
                                        '51' AS HCC51,
                                        '52' AS HCC52,
                                        '54' AS HCC54,
                                        '55' AS HCC55,
                                        '56' AS HCC56,
                                        '57' AS HCC57,
                                        '58' AS HCC58,
                                        '59' AS HCC59 ,
                                        '60' AS HCC60 ,
                                        '65' AS HCC65 ,
                                        '66' AS HCC66 ,
                                        '67' AS HCC67 ,
                                        '68' AS HCC68 ,
                                        '70' AS HCC70 ,
                                        '71' AS HCC71 ,
                                        '72' AS HCC72 ,
                                        '73' AS HCC73 ,
                                        '74' AS HCC74 ,
                                        '75' AS HCC75 ,
                                        '76' AS HCC76 ,
                                        '77' AS HCC77 ,
                                        '78' AS HCC78 ,
                                        '79' AS HCC79 ,
                                        '80' AS HCC80 ,
                                        '82' AS HCC82 ,
                                        '83' AS HCC83 ,
                                        '84' AS HCC84 ,
                                        '85' AS HCC85 ,
                                        '86' AS HCC86 ,
                                        '87' AS HCC87 ,
                                        '88' AS HCC88 ,
                                        '95' AS HCC95 ,
                                        '96' AS HCC96 ,
                                        '97' AS HCC97 ,
                                        '98' AS HCC98 ,
                                        '99' AS HCC99 ,
                                        '100' AS HCC100 ,
                                        '103' AS HCC103 ,
                                        '104' AS HCC104 ,
                                        '106' AS HCC106 ,
                                        '107' AS HCC107 ,
                                        '108' AS HCC108 ,
                                        '110' AS HCC110 ,
                                        '111' AS HCC111 ,
                                        '112' AS HCC112 ,
                                        '114' AS HCC114 ,
                                        '115' AS HCC115 ,
                                        '122' AS HCC122 ,
                                        '124' AS HCC124 ,
                                        '130' AS HCC130 ,
                                        '131' AS HCC131 ,
                                        '132' AS HCC132 ,
                                        '133' AS HCC133 ,
                                        '134' AS HCC134 ,
                                        '135' AS HCC135 ,
                                        '136' AS HCC136 ,
                                        '137' AS HCC137 ,
                                        '138' AS HCC138 ,
                                        '139' AS HCC139 ,
                                        '140' AS HCC140 ,
                                        '141' AS HCC141 ,
                                        '145' AS HCC145 ,
                                        '146' AS HCC146 ,
                                        '147' AS HCC147 ,
                                        '148' AS HCC148 ,
                                        '156' AS HCC156 ,
                                        '157' AS HCC157 ,
                                        '158' AS HCC158 ,
                                        '159' AS HCC159 ,
                                        '160' AS HCC160 ,
                                        '161' AS HCC161 ,
                                        '162' AS HCC162 ,
                                        '163' AS HCC163 ,
                                        '164' AS HCC164 ,
                                        '165' AS HCC165 ,
                                        '166' AS HCC166 ,
                                        '167' AS HCC167 ,
                                        '168' AS HCC168 ,
                                        '169' AS HCC169 ,
                                        '170' AS HCC170 ,
                                        '173' AS HCC173 ,
                                        '176' AS HCC176 ,
                                        '185' AS HCC185 ,
                                        '186' AS HCC186 ,
                                        '187' AS HCC187 ,
                                        '188' AS HCC188 ,
                                        '189' AS HCC189 ,
                                        '193' AS HCC193 ,
                                        '206' AS HCC206 ,
                                        '207' AS HCC207 ,
                                        '215' AS HCC215 ,
                                        '216' AS HCC216 ,
                                        '225' AS HCC225 ,
                                        '226' AS HCC226 ,
                                        '227' AS HCC227 ,
                                        '241' AS HCC241 ,
                                        '243' AS HCC243 ,
                                        '260' AS HCC260 ,
                                        '261' AS HCC261 ,
                                        '262' AS HCC262 ,
                                        '263' AS HCC263 ,
                                        '311' AS HCC311 ,
                                        '314' AS HCC314 ,
                                        '316' AS HCC316 ,
                                        '355' AS HCC355 ,
                                        '395' AS HCC395 ,
                                        '396' AS HCC396 ,
                                        '397' AS HCC397   
            )
            )
            WHERE RXHCC_V05_inD = 1
        ) A
    )
)
GROUP BY 
    MDL, DL_ASSESS_SK, ASSESSMENTDATE, MEDICAID_NUM