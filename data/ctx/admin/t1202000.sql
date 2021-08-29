Rem
Rem $Header: ctx_src_2/src/dr/admin/t1202000.sql /main/7 2018/07/25 13:49:09 surman Exp $
Rem
Rem t1202000.sql
Rem
Rem Copyright (c) 2013, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      t1202000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Upgrade indextypes to 12.2.0.0.0 
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/t1202000.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/t1202000.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    hxzhang     07/23/15 - New indextype CONTEXT_V2 with system partition
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    shuroy      10/06/14 - dr0type.pkh change fix
Rem    shuroy      09/23/14 - Bug 18692653: Changing TextIndexMethods type
Rem    boxia       09/11/13 - Type upgrade 12.2, add start and end scripts
Rem    boxia       09/11/13 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

PROMPT DisAssociate Statistics
PROMPT

DISASSOCIATE STATISTICS FROM INDEXTYPES CONTEXT FORCE;
DISASSOCIATE STATISTICS FROM INDEXTYPES CONTEXT_V2 FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_CONTAINS FORCE;

DISASSOCIATE STATISTICS FROM INDEXTYPES CTXXPATH FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_XPCONTAINS FORCE;

DISASSOCIATE STATISTICS FROM INDEXTYPES CTXRULE FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_MATCHES FORCE;

PROMPT ==============  ConText 11g to 12c Type Upgrade  =====================
PROMPT

PROMPT Revalidate indextype and operator
PROMPT

alter type TextOptStats compile specification reuse settings;
alter type TextIndexMethods compile specification reuse settings;
alter operator contains compile;
alter indextype context compile;

PROMPT Remove existing indextype operator bindings ...
PROMPT

alter indextype context add dummyop(varchar2, varchar2);
alter indextype context drop contains(varchar2, varchar2);
alter indextype context drop contains(varchar2, clob);
alter indextype context drop contains(clob, varchar2);
alter indextype context drop contains(clob, clob);
alter indextype context drop contains(blob, varchar2);
alter indextype context drop contains(blob, clob);
alter indextype context drop contains(bfile, varchar2);
alter indextype context drop contains(bfile, clob);
alter indextype context drop contains(sys.xmltype, varchar2);
alter indextype context drop contains(sys.xmltype, clob);
alter indextype context drop contains(sys.uritype, varchar2);
alter indextype context drop contains(sys.uritype, clob);

alter indextype context_v2 add dummyop(varchar2, varchar2);
alter indextype context_v2 drop contains(varchar2, varchar2);
alter indextype context_v2 drop contains(varchar2, clob);
alter indextype context_v2 drop contains(clob, varchar2);
alter indextype context_v2 drop contains(clob, clob);
alter indextype context_v2 drop contains(blob, varchar2);
alter indextype context_v2 drop contains(blob, clob);
alter indextype context_v2 drop contains(bfile, varchar2);
alter indextype context_v2 drop contains(bfile, clob);
alter indextype context_v2 drop contains(sys.xmltype, varchar2);
alter indextype context_v2 drop contains(sys.xmltype, clob);
alter indextype context_v2 drop contains(sys.uritype, varchar2);
alter indextype context_v2 drop contains(sys.uritype, clob);


PROMPT Drop SCORE and CONTAINS operators
PROMPT

drop operator score FORCE;
drop operator contains FORCE;
drop package ctx_contains;
drop package driscore;

PROMPT Shift indextype implementation to dummy implementation type
PROMPT
alter indextype context using DummyIndexMethods;
alter indextype context_v2 using DummyIndexMethods;

PROMPT Create new version of TextIndexMethods and TextOptStats
PROMPT
drop type TextIndexMethods;
drop type TextOptStats;

PROMPT Create 12.2 version of TextIndexMethods and TextOptStats
PROMPT
REM    (this is copied directly from old dr0type.pkh)

create or replace type TextIndexMethods authid current_user as object
(
   key          RAW(4),
   objid        RAW(4),
   tmpobjid     RAW(4),

   static function ODCIGetInterfaces(ifclist OUT sys.ODCIObjectList)
            return number,
   static function ODCIIndexCreate(ia sys.odciindexinfo, parms varchar2,
            env sys.ODCIEnv)
            return number,
   static function ODCIIndexAlter(ia sys.odciindexinfo,
                          parms in out varchar2,
                          altopt number, env sys.ODCIEnv)
            return number,
   static function ODCIIndexTruncate(ia sys.odciindexinfo,
            env sys.ODCIEnv)
            return number,
   static function ODCIIndexDrop(ia sys.odciindexinfo,
            env sys.ODCIEnv)
            return number,
   static function ODCIIndexInsert(
            ia sys.odciindexinfo,
            ridlist sys.odciridlist,
            env sys.odcienv)
      return number is language C
      name "insert"
      library dr$lib
      with context
      parameters(
         context,
         ia,
         ia INDICATOR STRUCT,
         ridlist,
         ridlist INDICATOR,
         env,
         env INDICATOR STRUCT,
         return OCINumber
      ),
   static function ODCIIndexUpdate(
            ia sys.odciindexinfo,
            ridlist sys.odciridlist,
            env sys.odcienv)
      return number is language C
      name "update"
      library dr$lib
      with context
      parameters(
         context,
         ia,
         ia INDICATOR STRUCT,
         ridlist,
         ridlist INDICATOR,
         env,
         env INDICATOR STRUCT,
         return OCINumber
      ),

   static function ODCIIndexDelete(
            ia sys.odciindexinfo,
            ridlist sys.odciridlist,
            env sys.odcienv)
      return number is language C
      name "delete"
      library dr$lib
      with context
      parameters(
         context,
         ia,
         ia INDICATOR STRUCT,
         ridlist,
         ridlist INDICATOR,
         env,
         env INDICATOR STRUCT,
         return OCINumber
      ),

   static function ODCIIndexStart(sctx in out TextIndexMethods,
                          ia sys.odciindexinfo,
                          op sys.odcipredinfo,
                          qi sys.odciqueryinfo,
                          strt number, stop number, valarg varchar2,
                          env SYS.ODCIEnv)
            return number is language C
            name "start"
            library dr$lib
            with context
            parameters(
               context,
               sctx,
               sctx INDICATOR STRUCT,
               ia,
               ia INDICATOR STRUCT,
               op,
               op INDICATOR STRUCT,
               qi,
               qi INDICATOR STRUCT,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               valarg,
               valarg INDICATOR,
               valarg LENGTH,
               env,
               env INDICATOR STRUCT,
               return OCINumber
            ),

   static function ODCIIndexStart(sctx in out TextIndexMethods,
                          ia sys.odciindexinfo,
                          op sys.odcipredinfo,
                          qi sys.odciqueryinfo,
                          strt number, stop number, valarg clob,
                          env SYS.ODCIEnv)
            return number is language C
            name "start_clob"
            library dr$lib
            with context
            parameters(
               context,
               sctx,
               sctx INDICATOR STRUCT,
               ia,
               ia INDICATOR STRUCT,
               op,
               op INDICATOR STRUCT,
               qi,
               qi INDICATOR STRUCT,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
            ),
   member function ODCIIndexFetch(nrows number,
                          rids OUT sys.odciridlist, env SYS.ODCIEnv)
            return number is language C
            name "fetch"
            library dr$lib
            with context
            parameters(
               context,
               self,
               self INDICATOR STRUCT,
               nrows,
               nrows INDICATOR,
               rids,
               rids INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
            ),
   member function ODCIIndexClose(env sys.ODCIEnv)
            return number is language C
            name "close"
            library dr$lib
            with context
            parameters(
               context,
               self,
               self INDICATOR STRUCT,
               env,
               env INDICATOR STRUCT,
               return OCINumber
            ),
   static function ODCIIndexGetMetaData(ia        IN  sys.odciindexinfo,
                                        version   IN  varchar2,
                                        new_block OUT PLS_INTEGER,
                                        env       IN  sys.ODCIEnv)
            return varchar2,
  static function ODCIIndexUpdPartMetaData(ia     IN  sys.odciindexinfo,
                                           palist IN   sys.ODCIPartInfoList,
                                           env    IN  sys.ODCIEnv)
            return NUMBER,
   static function ODCIIndexUtilGetTableNames(ia        IN  sys.odciindexinfo,
                                              read_only IN  PLS_INTEGER,
                                              version   IN  varchar2,
                                              context   OUT PLS_INTEGER)
            return boolean,
   static procedure ODCIIndexUtilCleanup(context IN PLS_INTEGER),
   static function ODCIIndexSplitPartition(ia         IN SYS.ODCIIndexInfo,
                                           part_name1 IN SYS.ODCIPartInfo,
                                           part_name2 IN SYS.ODCIPartInfo,
                                           parms      IN varchar2,
                                           env        IN SYS.ODCIEnv)
            return number,
   static function ODCIIndexMergePartition(ia         IN SYS.ODCIIndexInfo,
                                           part_name1 IN SYS.ODCIPartInfo,
                                           part_name2 IN SYS.ODCIPartInfo,
                                           parms      IN varchar2,
                                           env        IN SYS.ODCIEnv)
            return number,
   static function ODCIIndexExchangePartition(ia  IN SYS.ODCIIndexInfo,
                                              ia1 IN SYS.ODCIIndexInfo,
                                              env IN SYS.ODCIEnv)
            return number,
   static function ODCIIndexUpdate(ia         sys.odciindexinfo,
                                   ridlist    sys.odciridlist,
                                   oldvallist sys.odcicolarrayvallist,
                                   newvallist sys.odcicolarrayvallist,
                                   env        sys.ODCIEnv)
            return number
);
/

----------------------------------------------
-- CREATE EIX OPTIMIZER IMPLEMENTATION TYPE --
----------------------------------------------
create or replace type TextOptStats authid definer as object
(
   stats_ctx RAW(4),
   static function ODCIGetInterfaces(ifclist OUT sys.ODCIObjectList)
       return number,
   static function ODCIStatsCollect(idx sys.ODCIIndexInfo,
                                    options sys.ODCIStatsOptions,
                                    statistics OUT RAW,
                                    env sys.ODCIEnv)
            return number is language C
            name "st_coll"
            library dr$lib
            with context
            parameters(
               context,
               idx,
               idx INDICATOR STRUCT,
               options,
               options INDICATOR STRUCT,
               statistics,
               statistics INDICATOR,
               statistics LENGTH,
               env,
               env     INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsDelete(idx sys.ODCIIndexInfo, statistics OUT RAW,
                                   env sys.ODCIEnv)
            return number is language C
            name "st_delv2"
            library dr$lib
            with context
            parameters(
               context,
               idx,
               idx INDICATOR STRUCT,
               statistics,
               statistics INDICATOR,
               statistics LENGTH,
               env,
               env     INDICATOR STRUCT,
               return OCINumber
            ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval varchar2,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval varchar2,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval clob,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval clob,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval blob,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval blob,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval bfile,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval bfile,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval sys.xmltype,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval sys.xmltype,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval sys.uritype,
                                        valarg varchar2,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR STRUCT,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsSelectivity(pred sys.ODCIPredInfo,
                                        sel  OUT NUMBER,
                                        args sys.ODCIArgDescList,
                                        strt NUMBER,
                                        stop NUMBER,
                                        colval sys.uritype,
                                        valarg clob,
                                        env  sys.ODCIEnv)
            return number is language C
            name "st_sel_clob"
            library dr$lib
            with context
            parameters(
               context,
               pred,
               pred INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               colval,
               colval INDICATOR STRUCT,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval varchar2,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval varchar2,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval clob,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval clob,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval blob,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval blob,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval bfile,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval bfile,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval sys.xmltype,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval sys.xmltype,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval sys.uritype,
                                         valarg varchar2,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR STRUCT,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsFunctionCost(func sys.ODCIFuncinfo,
                                         cost IN OUT sys.ODCICost,
                                         args sys.ODCIArgDescList,
                                         colval sys.uritype,
                                         valarg clob,
                                         env  sys.ODCIEnv)
            return number is language C
            name "st_fcost_clob"
            library dr$lib
            with context
            parameters(
               context,
               func,
               func INDICATOR STRUCT,
               cost,
               cost INDICATOR STRUCT,
               args,
               args INDICATOR,
               colval,
               colval INDICATOR STRUCT,
               valarg,
               valarg INDICATOR,
               env,
               env INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsIndexCost(idx sys.ODCIIndexInfo,
                                      sel NUMBER,
                                      cost IN OUT sys.ODCICost,
                                      qi sys.ODCIQueryInfo,
                                      pred sys.ODCIPredInfo,
                                      args sys.ODCIArgDescList,
                                      strt NUMBER,
                                      stop NUMBER,
                                      valarg varchar2,
                                      env  sys.ODCIEnv)
            return number is language C
            name "st_icost"
            library dr$lib
            with context
            parameters(
               context,
               idx,
               idx INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               cost,
               cost INDICATOR STRUCT,
               qi,
               qi INDICATOR STRUCT,
               pred,
               pred INDICATOR STRUCT,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env    INDICATOR STRUCT,
               return OCINumber
             ),

   static function ODCIStatsIndexCost(idx sys.ODCIIndexInfo,
                                      sel NUMBER,
                                      cost IN OUT sys.ODCICost,
                                      qi sys.ODCIQueryInfo,
                                      pred sys.ODCIPredInfo,
                                      args sys.ODCIArgDescList,
                                      strt NUMBER,
                                      stop NUMBER,
                                      valarg clob,
                                      env  sys.ODCIEnv)
            return number is language C
            name "st_icost_clob"
            library dr$lib
            with context
            parameters(
               context,
               idx,
               idx INDICATOR STRUCT,
               sel,
               sel INDICATOR,
               cost,
               cost INDICATOR STRUCT,
               qi,
               qi INDICATOR STRUCT,
               pred,
               pred INDICATOR STRUCT,
               args,
               args INDICATOR,
               strt,
               strt INDICATOR,
               stop,
               stop INDICATOR,
               valarg,
               valarg INDICATOR,
               env,
               env    INDICATOR STRUCT,
               return OCINumber
             ),

  pragma restrict_references(ODCIStatsSelectivity, WNDS, WNPS),
  pragma restrict_references(ODCIStatsFunctionCost, WNDS, WNPS),
  pragma restrict_references(ODCIStatsIndexCost, WNDS, WNPS)
);
/


REM create a dummy type body.  We cannot run dr0type.plb here because the
REM packages may not be instantiated.  (Packages cannot be instantiated
    REM before this, because they depend on type .pkhs)

create or replace type body TextIndexMethods is

static function ODCIGetInterfaces(
  ifclist out    sys.ODCIObjectList
) return number
is
begin
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2'));
  return sys.ODCIConst.Success;
end ODCIGetInterfaces;

static function ODCIIndexCreate(
  ia      in     sys.odciindexinfo,
  parms   in     varchar2,
  env     in     sys.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexCreate;

static function ODCIIndexAlter(
  ia      in     sys.odciindexinfo,
  parms   in out varchar2,
  altopt  in     number,
  env     in     sys.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexAlter;

static function ODCIIndexTruncate(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexTruncate;

static function ODCIIndexDrop(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexDrop;

static function ODCIIndexGetMetaData(
  ia        in  sys.odciindexinfo,
  version   in  varchar2,
  new_block out PLS_INTEGER,
  env       in  sys.ODCIEnv
) return varchar2
is
begin
  return sys.odciconst.fatal;
end ODCIIndexGetMetaData;

static function ODCIIndexUpdPartMetaData(
  ia      in  sys.odciindexinfo,
  palist  in  sys.ODCIPartInfoList,
  env     in  sys.ODCIEnv
) return NUMBER
is
begin
 return sys.odciconst.fatal;
end ODCIIndexUpdPartMetaData;

static function ODCIIndexUtilGetTableNames(
  ia        IN  sys.odciindexinfo,
  read_only IN  PLS_INTEGER,
  version   IN  varchar2,
  context   OUT PLS_INTEGER)
return boolean
is
begin
  Return FALSE;
end ODCIIndexUtilGetTableNames;

static procedure ODCIIndexUtilCleanup(
 context IN PLS_INTEGER)
is
begin
  null;
end ODCIIndexUtilCleanup;

static function ODCIIndexSplitPartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexSplitPartition;

static function ODCIIndexMergePartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexMergePartition;

static function ODCIIndexExchangePartition(
  ia  IN SYS.ODCIIndexInfo,
  ia1 IN SYS.ODCIIndexInfo,
  env IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexExchangePartition;

static function ODCIIndexUpdate(
  ia         sys.odciindexinfo,
  ridlist    sys.odciridlist,
  oldvallist sys.odcicolarrayvallist,
  newvallist sys.odcicolarrayvallist,
  env        sys.ODCIEnv)
return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexUpdate;

end;
/

select text from dba_errors
 where owner = 'CTXSYS' and name = 'TEXTINDEXMETHODS';

show errors;

create or replace type body TextOptStats is

   static function ODCIGetInterfaces(ifclist OUT sys.ODCIObjectList)
       return number is
   begin
       ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCISTATS2'));
       return ODCIConst.Success;
   end ODCIGetInterfaces;

end;
/

select text from dba_errors
 where owner = 'CTXSYS' and name = 'TEXTOPTSTATS';

show errors;

PROMPT Shift indextype implementation to TextIndexMethods and add
PROMPT    support for composite index.
PROMPT

alter indextype context using TextIndexMethods;
alter indextype context_v2 using TextIndexMethods;

PROMPT Run itype to re-create contains, bind operators, assoc stats etc.
PROMPT

@@dr0itype.sql

PROMPT Rebind operators and remove the dummyop
PROMPT

alter indextype context add contains(varchar2, varchar2);
alter indextype context add contains(varchar2, clob);
alter indextype context add contains(clob, varchar2);
alter indextype context add contains(clob, clob);
alter indextype context add contains(blob, varchar2);
alter indextype context add contains(blob, clob);
alter indextype context add contains(bfile, varchar2);
alter indextype context add contains(bfile, clob);
alter indextype context add contains(sys.xmltype, varchar2);
alter indextype context add contains(sys.xmltype, clob);
alter indextype context add contains(sys.uritype, varchar2);
alter indextype context add contains(sys.uritype, clob);
alter indextype context drop dummyop(varchar2, varchar2);

alter indextype context_v2 add contains(varchar2, varchar2);
alter indextype context_v2 add contains(varchar2, clob);
alter indextype context_v2 add contains(clob, varchar2);
alter indextype context_v2 add contains(clob, clob);
alter indextype context_v2 add contains(blob, varchar2);
alter indextype context_v2 add contains(blob, clob);
alter indextype context_v2 add contains(bfile, varchar2);
alter indextype context_v2 add contains(bfile, clob);
alter indextype context_v2 add contains(sys.xmltype, varchar2);
alter indextype context_v2 add contains(sys.xmltype, clob);
alter indextype context_v2 add contains(sys.uritype, varchar2);
alter indextype context_v2 add contains(sys.uritype, clob);
alter indextype context_v2 drop dummyop(varchar2, varchar2);

-- Added for bug 2695369
alter indextype context using textindexmethods
  with order by score(number);
alter indextype context_v2 using textindexmethods
  with order by score(number);


@?/rdbms/admin/sqlsessend.sql
