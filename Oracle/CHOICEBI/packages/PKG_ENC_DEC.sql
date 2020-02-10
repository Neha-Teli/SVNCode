CREATE OR REPLACE PACKAGE enc_dec
AS
   FUNCTION encrypt (p_plainText VARCHAR2) RETURN RAW DETERMINISTIC;
   FUNCTION decrypt (p_encryptedText RAW) RETURN VARCHAR2 DETERMINISTIC;
END;
/

CREATE OR REPLACE PACKAGE BODY enc_dec
AS
     encryption_type    PLS_INTEGER := DBMS_CRYPTO.ENCRYPT_DES
                                     + DBMS_CRYPTO.CHAIN_CBC
                                     + DBMS_CRYPTO.PAD_PKCS5;
     /*
       ENCRYPT_DES is the encryption algorithem. Data Encryption Standard. Block cipher. 
       Uses key length of 56 bits.
       CHAIN_CBC Cipher Block Chaining. Plaintext is XORed with the previous ciphertext 
       block before it is encrypted.
       PAD_PKCS5 Provides padding which complies with the PKCS #5: Password-Based 
       Cryptography Standard
     */
     encryption_key     RAW (32) := UTL_RAW.cast_to_raw('CHOICEAnalytics');
     -- The encryption key for DES algorithem, should be 8 bytes or more.

     FUNCTION encrypt (p_plainText VARCHAR2) RETURN RAW DETERMINISTIC
     IS
        encrypted_raw      RAW (2000);
     BEGIN
        encrypted_raw := DBMS_CRYPTO.ENCRYPT
        (
           src => UTL_RAW.CAST_TO_RAW (p_plainText),
           typ => encryption_type,
           key => encryption_key
        );
       RETURN encrypted_raw;
     END encrypt;
     FUNCTION decrypt (p_encryptedText RAW) RETURN VARCHAR2 DETERMINISTIC
     IS
        decrypted_raw      RAW (2000);
     BEGIN
        decrypted_raw := DBMS_CRYPTO.DECRYPT
        (
            src => p_encryptedText,
            typ => encryption_type,
            key => encryption_key
        );
        RETURN (UTL_RAW.CAST_TO_VARCHAR2 (decrypted_raw));
     END decrypt;
END;
/
