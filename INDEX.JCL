//SBA00001 JOB 1,'PATRICK',CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),           00010000
//             NOTIFY=&SYSUID,REGION=0M                                 00020000
//********************************************************************* 00020108
//* DELETE EXISTING DATA, OTHERS & EMPLIST FILES FOR SMOOTH RERUNS.   * 00020209
//********************************************************************* 00020308
//STEP000  EXEC PGM=IEFBR14                                             00020409
//OLDDATA   DD DSN=Z13032.JCL2.DATA,                                    00020509
//             DISP=(OLD,DELETE,DELETE)                                 00020609
//OLDOTH    DD DSN=Z13032.OTHERS,                                       00020708
//             DISP=(OLD,DELETE,DELETE)                                 00020808
//OLDEMP    DD DSN=Z13032.EMPLIST,                                      00020909
//             DISP=(OLD,DELETE,DELETE)                                 00021009
//********************************************************************* 00021309
//* COPY PDS FROM PROFESSOR USING SORT. *                               00021409
//********************************************************************* 00021509
//STEP025 EXEC PGM=SORT                                                 00021609
//SYSPRINT  DD SYSOUT=*                                                 00021709
//SYSOUT    DD SYSOUT=*                                                 00021809
//SYSDUMP   DD SYSOUT=*                                                 00021909
//SORTIN    DD DSN=Z11780.JCL2.DATA,DISP=SHR                            00022009
//SORTOUT   DD DSN=Z13032.JCL2.DATA,                                    00022109
//             DISP=(NEW,CATLG,DELETE),                                 00022209
//             SPACE=(TRK,(1,1),RLSE),                                  00022309
//             UNIT=SYSDA,                                              00022409
//             DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=0)               00022509
//SORTMNGR  DD SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA                        00022609
//SORTDSGR  DD SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA                        00022709
//SORTOTHR  DD SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA                        00022809
//SYSIN     DD *                                                        00022909
    SORT FIELDS=COPY                                                    00023009
/*                                                                      00023109
//********************************************************************* 00024008
//* SPLIT RECORDS INTO 3 TEMP FILES MANAGERS, DESIGNRS, OTHERS.       * 00030008
//********************************************************************* 00031008
//STEP050  EXEC PGM=SORT                                                00040004
//SYSPRINT  DD SYSOUT=*                                                 00050000
//SYSOUT    DD SYSOUT=*                                                 00060000
//SYSDUMP   DD SYSOUT=*                                                 00070000
//SORTIN    DD DSN=Z13032.JCL2.DATA,DISP=SHR                            00080000
//SORTOF1   DD DSN=&&TEMP1,                                             00090002
//             DISP=(NEW,PASS),                                         00100002
//             SPACE=(TRK,(1,1),RLSE),                                  00110000
//             UNIT=SYSDA,                                              00120000
//             DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=0)               00130000
//SYSPRINT  DD SYSOUT=*                                                 00140003
//SORTOF2   DD DSN=&&TEMP2,                                             00150002
//             DISP=(NEW,PASS),                                         00160002
//             SPACE=(TRK,(1,1),RLSE),                                  00170001
//             UNIT=SYSDA,                                              00180001
//             DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=0)               00190001
//SYSPRINT  DD SYSOUT=*                                                 00200003
//SORTOF3   DD DSN=&&TEMP3,                                             00210003
//             DISP=(NEW,PASS),                                         00220002
//             SPACE=(TRK,(1,1),RLSE),                                  00230002
//             UNIT=SYSDA,                                              00240002
//             DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=0)               00250002
//SYSPRINT  DD SYSOUT=*                                                 00260003
//SYSIN     DD *                                                        00270000
    SORT FIELDS=COPY                                                    00280002
    OUTFIL FILES=1,INCLUDE=(45,8,CH,EQ,C'MANAGER')                      00290002
    OUTFIL FILES=2,INCLUDE=(45,8,CH,EQ,C'DESIGNER')                     00300002
    OUTFIL FILES=3,OMIT=(45,8,CH,EQ,C'DESIGNER',OR,                     00310003
               45,8,CH,EQ,C'MANAGER')                                   00320003
/*                                                                      00330005
//********************************************************************* 00331008
//* CREATE GENERATION OF DESIGNRS.                                    * 00340008
//********************************************************************* 00341008
//STEP400  EXEC PGM=IDCAMS                                              00350006
//DESIGNIN  DD DSN=&&TEMP2,DISP=(OLD,PASS)                              00360008
//GDGOUT    DD DSN=Z13032.DESIGN.GDG(+1),                               00370008
//             DISP=(NEW,CATLG),                                        00380007
//             SPACE=(TRK,(1,1),RLSE),                                  00390007
//             UNIT=SYSDA,                                              00400007
//             DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=0)               00410007
//SYSIN     DD *                                                        00420006
    REPRO INFILE(DESIGNIN) OUTFILE(GDGOUT)                              00430008
//SYSPRINT  DD SYSOUT=*                                                 00470006
//********************************************************************* 00470108
//* READ OTHERS CARD IMAGE INPUT INTO NEW CATALOGED DATASET.          * 00470208
//********************************************************************* 00470308
//STEP600 EXEC PGM=IEBGENER                                             00470408
//SYSIN     DD DUMMY                                                    00470508
//SYSPRINT  DD SYSOUT=*                                                 00470708
//SYSUT1    DD DSN=&&TEMP3,DISP=(OLD,PASS)                              00470808
//SYSUT2    DD DSN=Z13032.OTHERS,                                       00470908
//             DISP=(NEW,CATLG),                                        00471008
//             SPACE=(TRK,(1,1),RLSE),                                  00471108
//             UNIT=SYSDA,                                              00471208
//             DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=0)               00471308
//********************************************************************* 00472008
//* COPY TEMPORARY FILE USING SORT.                                   * 00480008
//********************************************************************* 00481008
//STEP200  EXEC PGM=SORT                                                00490005
//SYSPRINT  DD SYSOUT=*                                                 00500005
//SYSOUT    DD SYSOUT=*                                                 00510005
//SYSDUMP   DD SYSOUT=*                                                 00520005
//SORTIN    DD DSN=Z13032.DESIGN.GDG(+1),DISP=(OLD,KEEP,KEEP)           00540008
//          DD DSN=&&TEMP1,DISP=(OLD,PASS)                              00541008
//          DD DSN=Z13032.OTHERS,DISP=(OLD,KEEP,KEEP)                   00542008
//SORTOUT   DD DSN=&&SORTMNGR,                                          00550005
//             DISP=(NEW,PASS),                                         00560005
//             SPACE=(TRK,(1,1),RLSE),                                  00570005
//             UNIT=SYSDA,                                              00580005
//             DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=0)               00590005
//SYSPRINT  DD SYSOUT=*                                                 00600005
//SYSIN     DD *                                                        00610005
   SORT FIELDS=COPY                                                     00620008
//********************************************************************* 00621008
//* PRINT TEMPORARY FILE USING IDCAMS 3 DIFFERNT WAYS.                * 00630008
//********************************************************************* 00631008
//STEP300 EXEC PGM=IDCAMS                                               00632008
//SYSPRINT  DD SYSOUT=*                                                 00650005
//MNGRINPT  DD DSN=&&SORTMNGR,DISP=(OLD,PASS)                           00660008
//SYSIN     DD *                                                        00670005
   PRINT INFILE(MNGRINPT),CHAR                                          00680005
   PRINT INFILE(MNGRINPT),HEX                                           00690005
   PRINT INFILE(MNGRINPT),DUMP                                          00700005
//********************************************************************* 00700108
//* READ THE SORT OUTPUT (TEMPORARY) DATASET AND WRITE TO PRINT.      * 00700208
//********************************************************************* 00700308
//STEP500 EXEC PGM=IEBGENER                                             00701008
//SYSUT1    DD DSN=&&SORTMNGR,DISP=(OLD,PASS)                           00707108
//SYSUT2    DD SYSOUT=*                                                 00707208
//SYSPRINT  DD SYSOUT=*                                                 00707608
//SYSIN     DD DUMMY                                                    00707708
//********************************************************************* 00707808
//* READ SORT OUTPUT WRITE TO PRINT AFTER SKIPPING 4 RECORDS.         * 00707908
//********************************************************************* 00708008
//STEP700 EXEC PGM=IEBPTPCH                                             00709008
//SYSUT1    DD DSNAME=&&SORTMNGR,DISP=(OLD,PASS)                        00710108
//SYSUT2    DD SYSOUT=*                                                 00710208
//SYSIN     DD *                                                        00710308
     PRINT MAXFLDS=1,MAXLINE=55,STRTAFT=4,STOPAFT=8                     00710408
     RECORD FIELD=(80)                                                  00710508
     TITLE  ITEM=('PRINT EIGHT RECORDS AFTER SKIPPING FOUR',10)         00710608
//SYSPRINT  DD SYSOUT=*                                                 00710708
//********************************************************************* 00710808
//* SORT RECORDS INTO LASTNAME, FIRSTNAME FORMAT & WRITE TO TEMP DS.  * 00710908
//********************************************************************* 00711008
//STEP800  EXEC PGM=SORT                                                00711108
//SYSPRINT  DD SYSOUT=*                                                 00711208
//SYSOUT    DD SYSOUT=*                                                 00711308
//SYSDUMP   DD SYSOUT=*                                                 00711408
//SORTIN    DD DSN=&&SORTMNGR,DISP=(OLD,PASS)                           00711508
//SORTOUT   DD DSN=&&LNFNEMP,                                           00711709
//             DISP=(NEW,PASS),                                         00711809
//             SPACE=(TRK,(1,1),RLSE),                                  00712109
//             UNIT=SYSDA,                                              00712209
//             DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=0)               00713009
//SYSIN     DD *                                                        00713408
    SORT FIELDS=(17,27,CH,A)                                            00713509
/*                                                                      00713809
//********************************************************************* 00713909
//* PRINT LNFNEMP FROM STEP 800 USING IDCAMS REPRO COMMAND.             00714009
//********************************************************************* 00714109
//STEP900  EXEC PGM=IDCAMS                                              00714209
//EMPIN     DD DSN=&&LNFNEMP,DISP=(OLD,PASS)                            00714309
//EMPOUT    DD DSN=Z13032.EMPLIST,                                      00714409
//             DISP=(NEW,CATLG),                                        00714509
//             SPACE=(TRK,(1,1),RLSE),                                  00714609
//             UNIT=SYSDA,                                              00714709
//             DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=0)               00714809
//SYSIN     DD *                                                        00714909
    REPRO INFILE(EMPIN) OUTFILE(EMPOUT)                                 00715009
//SYSPRINT  DD SYSOUT=*                                                 00715109
//********************************************************************* 00716008
//* READ DESIGNER CARD AND CREATE GDG BASE (RUN ONCE).                * 00720008
//********************************************************************* 00721008
//                                                                      00722008
//STEP450  EXEC PGM=IDCAMS                                              00730006
//SYSPRINT  DD SYSOUT=*                                                 00740005
//MNGRINPT  DD DSN=Z13032.JCL2.DESIGNRS,DISP=SHARE                      00750005
//SYSIN     DD *                                                        00760005
    DEFINE GDG(NAME(Z13032.DESIGN.GDG) -                                00770005
    LIMIT(5) -                                                          00780005
    NOEMPTY -                                                           00790005
    SCRATCH)                                                            00800005
//                                                                      00810005
//********************************************************************* 00820000
