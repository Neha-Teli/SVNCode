DROP VIEW CHOICEBI.DIM_PROVIDER_CURR;

CREATE OR REPLACE FORCE VIEW CHOICEBI.DIM_PROVIDER_CURR AS
    SELECT *
    FROM   (SELECT a.*,
                   RANK()
                   OVER (PARTITION BY provider_id
                         ORDER BY DECODE(src_sys, 'TMG', 1, 2))
                       seq
            FROM   CHOICE.DIM_PROVIDER@DLAKE a
            WHERE  DL_ACTIVE_REC_IND = 'Y')
    WHERE  SEQ = 1;


GRANT SELECT ON CHOICEBI.DIM_PROVIDER_CURR TO MSTRSTG;
