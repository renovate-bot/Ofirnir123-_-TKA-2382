Rem
Rem $Header: ctx_src_2/src/dr/admin/d1202000.sql /main/32 2018/07/25 13:49:09 surman Exp $
Rem
Rem d1202000.sql
Rem
Rem Copyright (c) 2013, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      d1202000.sql - Downgrade from 12.2
Rem
Rem    DESCRIPTION
Rem      Downgrade from 12.2 to 12.1.0.2.0
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1202000.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/d1202000.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxe121.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    boxia       09/14/16 - Bug 24656765: fwd merge boxia_b24590462_12201
Rem                           from st_ctx_12.2.0.1.0
Rem    nspancha    08/01/16 - Bug 23501267: Granting back access on downgrade
Rem    yinlu       05/06/16 - bug 23104534: change SDS to SIDS to be consistent
Rem                           with ctxobj
Rem    aczarlin    04/13/16 - bug 23091665 max_rows
Rem    shuroy      10/21/15 - Remove NUM_ITERATIONS
Rem    rkadwe      09/23/15 - Bug 21701234
Rem    aczarlin    08/07/15 - bug 21562436 ctxagg parallel
Rem    hxzhang     07/23/15 - drop new indextype CONTEXT_V2
Rem    boxia       07/13/15 - Lrg 16100415: remove idx option 's'
Rem    shuroy      05/27/15 - Bug 20475880: long identifier downgrade changes
Rem    ataracha    05/20/15 - LRG 15809913
Rem    shuroy      05/13/15 - Bug 21086558: Removing U_TABLE_CLAUSE
Rem    rkadwe      04/21/15 - Alter index for simple syntax
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    rkadwe      01/23/15 - dataguide change
Rem    boxia       12/05/14 - Remove PRINTJOINS, SKIPJOINS for World lexer
Rem    shuroy      12/04/14 - MultiColumn Datastore changes
Rem    shuroy      11/10/14 - SENTIMENT_CLASSIFIER changes
Rem    shuroy      09/30/14 - Bug 18692653: Downgrade TextIndexMethods type
Rem    boxia       08/06/14 - Bug 19378233: correct OAT_ID by OAL_OAT_ID
Rem    thbaby      06/25/14 - 19064729: add sharing=object for dr$ tables
Rem    zliu        02/17/14 - bson enable in 12.1.0.2
Rem    zliu        02/02/14 - fix bug 1817966 use range_search_enable
Rem    boxia       11/26/13 - SDATA Project: rm S*_TABLE/INDEX_CLAUSE, and
Rem                           xml_save_copy & xml_forward_enable
Rem    shuroy      11/07/13 - Fusion Security Project: PKVAL section attribute
Rem    boxia       11/05/13 - Bug 17635127: Remove optimized_for attribute
Rem    boxia       10/24/13 - Bug 17635127: delete PJ&SJ part from d1202000.sql
Rem    hsarkar     12/26/11 - Asynchronous update project
Rem    zliu        10/20/13 - add xml_structure_enable
Rem    boxia       09/05/13 - boxia_printskipjoins: rm PRINTJOINS, SKIPJOINS
Rem                           for Japanese_Vgram_lexer
Rem    boxia       09/05/13 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

REM
REM BEGIN creating a 12.1 version dummy impl. type and operator
REM

grant select on SYS.HIST_HEAD$ to ctxsys;
grant select on SYS.USER$ to ctxsys with grant option;

create or replace type DummyindexMethods authid definer as object
(
   key          RAW(4),
   objid        RAW(4),
   tmpobjid     RAW(4),

   static function ODCIGetInterfaces(ifclist OUT sys.ODCIObjectList)
            return number
);
/

PROMPT Create dummy implementation type body
PROMPT

create or replace type body DummyIndexMethods is

static function ODCIGetInterfaces(
  ifclist out    sys.ODCIObjectList
) return number
is
begin
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2'));
  return sys.ODCIConst.Success;
end ODCIGetInterfaces;
end;
/
show errors

create or replace package ctx_dummyop authid definer as
    function dummyop(Colval in varchar2,
                             Text in varchar2, ia sys.odciindexctx,
                             sctx IN OUT DummyIndexMethods,
                             cflg number /*, env sys.ODCIEnv*/)
      return number is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
end ctx_dummyop;
/

PROMPT Create dummy operator
PROMPT

create or replace operator dummyop binding
  (varchar2, varchar2) return number
     with index context, scan context DummyIndexMethods
without column data using ctx_dummyop.dummyop;

grant execute on dummyop to public;

REM
REM END creating a dummy impl. type  and operator
REM

PROMPT DisAssociate Statistics
PROMPT

DISASSOCIATE STATISTICS FROM INDEXTYPES CONTEXT FORCE;
DISASSOCIATE STATISTICS FROM INDEXTYPES CONTEXT_V2 FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_CONTAINS FORCE;


REM
REM BEGIN DOWN-GRADING CONTEXT INDEXTYPE
REM

PROMPT Remove existing indextype operator bindings
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


PROMPT Drop SCORE and CONTAINS operators
PROMPT

drop indextype context_v2;
drop operator score FORCE;
drop operator contains FORCE;
drop package ctx_contains;
drop package driscore;

PROMPT Shift indextype implementation to dummy implementation type
PROMPT

alter indextype context using DummyIndexMethods;

PROMPT Create old 12.1 version of TextIndexMethods and TextOptStats
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
   static function ODCIIndexInsert(ia sys.odciindexinfo,
                           ridlist sys.odciridlist, env sys.ODCIEnv)
            return number,

   static function ODCIIndexDelete(ia sys.odciindexinfo,
                           ridlist sys.odciridlist, env sys.ODCIEnv)
            return number,

   static function ODCIIndexUpdate(ia sys.odciindexinfo,
                           ridlist sys.odciridlist, env sys.ODCIEnv)
            return number,

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

REM
REM create temporary TextIndexMethods and TextOptStats type bodies
REM
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

static function ODCIIndexInsert(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist,
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexInsert;
static function ODCIIndexDelete(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist,
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexDelete;

static function ODCIIndexUpdate(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist,
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexUpdate;

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

PROMPT Shift indextype implementation to TextIndexMethods ...
PROMPT

alter indextype context using TextIndexMethods;

REM
REM recreate 12c version contains and score operators
REM following copied directly from dr0itype.sql
REM

create or replace package ctx_contains authid current_user as
    -- varchar2 column type, varchar2 query string type
    function Textcontains(Colval in varchar2,
                             Text in varchar2, ia sys.odciindexctx,
                             sctx IN OUT TextIndexMethods,
                             cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- varchar2 column type, clob query string type
    function Textcontains(Colval in varchar2,
                             Text in clob, ia sys.odciindexctx,
                             sctx IN OUT TextIndexMethods,
                             cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- clob column type, varchar2 query string type
    function Textcontains(Colval in clob,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- clob column type, clob query string type
    function Textcontains(Colval in clob,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- blob column type, varchar2 query string type
    function Textcontains(Colval in blob,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- blob column type, clob query string type
    function Textcontains(Colval in blob,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- bfile column type, varchar2 query string type
    function Textcontains(Colval in bfile,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- bfile column type, clob query string type
    function Textcontains(Colval in bfile,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- Xmltype column type, varchar2 query string type
    function Textcontains(Colval in sys.xmltype,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- Xmltype column type, clob query string type
    function Textcontains(Colval in sys.xmltype,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- Uritype column type, varchar2 query string type
    function Textcontains(Colval in sys.uritype,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR STRUCT,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    -- Uritype column type, clob query string type
    function Textcontains(Colval in sys.uritype,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR STRUCT,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );

end ctx_contains;
/

--------------------------------------
-- CREATE CONTAINS PRIMARY OPERATOR --
--------------------------------------
---  CREATE TEXT OPERATOR
create or replace operator contains binding
  (varchar2, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (varchar2, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (clob, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (clob, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (blob, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (blob, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (bfile, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (bfile, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (sys.xmltype, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (sys.xmltype, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (sys.uritype, varchar2) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (sys.uritype, clob) return number
     with index context, scan context TextIndexMethods
     compute ancillary data without column data using ctx_contains.Textcontains
;

grant execute on contains to public;

drop public synonym contains;
create public synonym contains for ctxsys.contains;

-------------------------------
-- CREATE ANCILLARY FUNCTION --
-------------------------------
create or replace package driscore authid current_user as
    function TextScore(Colval in varchar2,
                             Text in varchar2, ia sys.odciindexctx,
                             sctx IN OUT TextIndexMethods,
                             cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in varchar2,
                             Text in clob, ia sys.odciindexctx,
                             sctx IN OUT TextIndexMethods,
                             cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in clob,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in clob,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in blob,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in blob,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in bfile,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in bfile,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in sys.xmltype,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in sys.xmltype,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in sys.uritype,
                                Text in varchar2, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR STRUCT,
        Text,
        Text INDICATOR,
        Text LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
    function TextScore(Colval in sys.uritype,
                                Text in clob, ia sys.odciindexctx,
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number parallel_enable is language C
      name "contains_clob"
      library dr$lib
      with context
      parameters(
        context,
        Colval,
        Colval INDICATOR STRUCT,
        Text,
        Text INDICATOR,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
end driscore;
/

-------------------------------
-- CREATE ANCILLARY OPERATOR --
-------------------------------
---  CREATE Score OPERATOR
create or replace operator score binding
   (number) return number
     ancillary to contains(varchar2, varchar2),
                  contains(varchar2, clob),
                  contains(clob, varchar2),
                  contains(clob, clob),
                  contains(blob, varchar2),
                  contains(blob, clob),
                  contains(bfile, varchar2),
                  contains(bfile, clob),
                  contains(sys.xmltype, varchar2),
                  contains(sys.xmltype, clob),
                  contains(sys.uritype, varchar2),
                  contains(sys.uritype, clob)
     without column data using driscore.TextScore;

grant execute on score to public;

drop public synonym score;
create public synonym score for ctxsys.score;

grant execute on ConText to public;

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

-- Added for bug 2695369
alter indextype context using textindexmethods
  with order by score(number);

REM RE-ASSOCIATE EIX OPTIMIZER IMPLEMENTATION TYPE
ASSOCIATE STATISTICS WITH INDEXTYPES ConText USING TextOptStats;
ASSOCIATE STATISTICS WITH PACKAGES ctx_contains USING TextOptStats;

REM
REM END DOWN-GRADING CONTEXT INDEXTYPE
REM

----------------------------------------------------------------------
-- for JSON_ENABLE
-- added in dr0obj.txt, generated in ctxobj.sql as 50817
-- 17 is defined in drn.c, 50817 is referenced in drisgp.pkb
-- JSON_ENABLE is needed in 12.1.0.2, so we can not delete it
----------------------------------------------------------------------
/*
delete from dr$object_attribute
  where oat_id=50817 and oat_cla_id=5 and oat_obj_id=8 and oat_att_id=17
    and oat_name='JSON_ENABLE';
*/

----------------------------------------------------------------------
-- for BSON_ENABLE
-- added in dr0obj.txt, generated in ctxobj.sql as 50819
-- 19 is defined in drn.c, 50819 is referenced in drisgp.pkb
-- JSON_ENABLE is needed in 12.1.0.2, so we can not delete it
----------------------------------------------------------------------
/*
delete from dr$object_attribute
  where oat_id=50819 and oat_cla_id=5 and oat_obj_id=8 and oat_att_id=19
    and oat_name='BSON_ENABLE';
*/

----------------------------------------------------------------------
-- RANGE_SEARCH_ENABLE support
-- for xml enabled text index and json enabled text index
-- added in dr0obj.txt, generated in ctxobj.sql as 50818
-- 18 is defined in drn.c, 50818 is referenced in drisgp.pkb
----------------------------------------------------------------------
delete from dr$object_attribute
  where oat_id=50818 and oat_cla_id=5 and oat_obj_id=8 and oat_att_id=18
    and oat_name='RANGE_SEARCH_ENABLE';

commit;

REM ------------------------------------------------------------------
REM  drop column del_updated dr$delete
REM ------------------------------------------------------------------

declare
  errnum number;
begin
  execute immediate('
  alter table dr$delete drop (del_updated)');
exception
  when others then
    errnum := SQLCODE;
    if (errnum = -00904) then
      null;
    else
      raise;
    end if;
end;
/

REM ------------------------------------------------------------------
REM  Drop PKVAL Section Attribute
REM ------------------------------------------------------------------


delete from dr$object_attribute 
where oat_id = 240111 and oat_cla_id = 24 and oat_att_id = 11
and oat_name = 'PKVAL';

commit;

----------------------------------------------------------------------
-- SDATA: rm attribute OPTIMIZED_FOR, add SORTABLE & SEARCHABLE
----------------------------------------------------------------------
delete from dr$object_attribute
  where oat_id=240110 and oat_cla_id=24 and oat_obj_id=1 and oat_att_id=10
    and oat_name='OPTIMIZED_FOR';

delete from dr$object_attribute_lov where oal_oat_id = 240110;

commit;

begin
insert into dr$object_attribute values
  (240110, 24, 1, 10,
   'SEARCHABLE', 'SDATA values stored in the $Sn tables',
   'N', 'N', 'Y', 'B',
   'FALSE', null, null, 'N');
commit;
exception
  when dup_val_on_index then
    null;
end;
/

begin
insert into dr$object_attribute values
  (240111, 24, 1, 11,
   'SORTABLE', 'SDATA values stored in the $S table',
   'N', 'N', 'Y', 'B',
   'TRUE', null, null, 'N');

commit;
exception
  when dup_val_on_index then
    null;
end;
/

----------------------------------------------------------------------
-- SDATA: rm S*_TABLE_CLAUSE & S*_INDEX_CLAUSE
----------------------------------------------------------------------
delete from dr$object_attribute
  where oat_id = 90132 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 32
    and oat_name = 'SV_TABLE_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90133 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 33
    and oat_name = 'SV_INDEX_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90134 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 34
    and oat_name = 'SD_TABLE_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90135 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 35
    and oat_name = 'SD_INDEX_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90136 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 36
    and oat_name = 'SR_TABLE_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90137 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 37
    and oat_name = 'SR_INDEX_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90138 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 38
    and oat_name = 'SBF_TABLE_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90139 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 39
    and oat_name = 'SBF_INDEX_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90140 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 40
    and oat_name = 'SBD_TABLE_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90141 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 41
    and oat_name = 'SBD_INDEX_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90142 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 42
    and oat_name = 'ST_TABLE_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90143 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 43
    and oat_name = 'ST_INDEX_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90144 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 44
    and oat_name = 'STZ_TABLE_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90145 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 45
    and oat_name = 'STZ_INDEX_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90146 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 46
    and oat_name = 'SIYM_TABLE_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90147 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 47
    and oat_name = 'SIYM_INDEX_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90148 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 48
    and oat_name = 'SIDS_TABLE_CLAUSE';

delete from dr$object_attribute
  where oat_id = 90149 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 49
    and oat_name = 'SIDS_INDEX_CLAUSE';

commit;

----------------------------------------------------------------------
-- SDATA: rm storage attribute xml_save_copy & xml_forward_enable
----------------------------------------------------------------------
delete from dr$object_attribute
  where oat_id = 90151 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 51
    and oat_name = 'XML_SAVE_COPY';

delete from dr$object_attribute
  where oat_id = 90152 and oat_cla_id = 9 and oat_obj_id = 1 and oat_att_id = 52
    and oat_name = 'XML_FORWARD_ENABLE';


-- Dataguide
delete from dr$object_attribute
  where oat_id = 50820 and oat_cla_id = 5 and oat_obj_id = 8 and oat_att_id = 20
    and oat_name = 'DATAGUIDE';

-- Text
delete from dr$object_attribute
  where oat_id = 50821 and oat_cla_id = 5 and oat_obj_id = 8 and oat_att_id = 21
    and oat_name = 'TEXT';

-- alter_index_transition
delete from dr$object_attribute
  where oat_id = 50822 and oat_cla_id = 5 and oat_obj_id = 8 and oat_att_id = 22
    and oat_name = 'ALTER_INDEX_TRANSITION';

commit;

---------------------------------------------------------------------------
--- rm SENTIMENT_CLASSIFIER and related attributes
---------------------------------------------------------------------------
delete from dr$object
  where obj_cla_id = 12 and obj_id = 3
    and obj_name = 'SENTIMENT_CLASSIFIER';

delete from dr$object_attribute
  where oat_id = 120301 and oat_cla_id = 12 and oat_obj_id = 3 and oat_att_id = 1
   and oat_name = 'MAX_DOCTERMS';

delete from dr$object_attribute
  where oat_id = 120302 and oat_cla_id = 12 and oat_obj_id = 3 and oat_att_id = 2
   and oat_name = 'MAX_FEATURES';

delete from dr$object_attribute
  where oat_id = 120303 and oat_cla_id = 12 and oat_obj_id = 3 and oat_att_id = 3
   and oat_name = 'THEME_ON';

delete from dr$object_attribute
  where oat_id = 120304 and oat_cla_id = 12 and oat_obj_id = 3 and oat_att_id = 4
   and oat_name = 'TOKEN_ON';

delete from dr$object_attribute
  where oat_id = 120305 and oat_cla_id = 12 and oat_obj_id = 3 and oat_att_id = 5
   and oat_name = 'STEM_ON';

delete from dr$object_attribute
  where oat_id = 120306 and oat_cla_id = 12 and oat_obj_id = 3 and oat_att_id = 6
   and oat_name = 'MEMORY_SIZE';

delete from dr$object_attribute
  where oat_id = 120307 and oat_cla_id = 12 and oat_obj_id = 3 and oat_att_id = 7
   and oat_name = 'SECTION_WEIGHT';

delete from dr$object_attribute
  where oat_id = 120308 and oat_cla_id = 12 and oat_obj_id = 3 and oat_att_id = 8
   and oat_name = 'NUM_ITERATIONS';

-- Remove default sentiment classifier
delete from dr$parameter where par_name = 'DEFAULT_SENT_CLASSIFIER';

commit;

----------------------------------------------------------------------------
-- Remove NUM_ITERATIONS from SVM Classifier
----------------------------------------------------------------------------
delete from dr$object_attribute
  where oat_id = 120208 and oat_cla_id = 12 and oat_obj_id = 2 and oat_att_id = 8
   and oat_name = 'NUM_ITERATIONS';
commit;

-----------------------------------------------------------------------------
--- Downgrade prv_value from varchar2(4000) to varchar2(500)
-----------------------------------------------------------------------------
declare
  errnum number;
begin
  execute immediate('
  alter table dr$preference_value  modify prv_value varchar2(500)');
exception
  when others then
    null;
end;
/


-----------------------------------------------------------------------------
--- Downgrade ixv_value from varchar2(4000) to varchar2(500)
-----------------------------------------------------------------------------
declare
  errnum number;
begin
  execute immediate('
  alter table dr$index_value  modify ixv_value varchar2(500)');
exception
  when others then
    null;
end;
/

-----------------------------------------------------------------------------
--- Downgrade COLUMNS attribute size to varchar2(500)
-----------------------------------------------------------------------------
BEGIN
update dr$object_attribute
set oat_val_max = 500
where oat_id = 10701 and oat_name = 'COLUMNS';
END;
/
commit;

----------------------------------------------------------------------
-- rm Printjoins & Skipjoins for WORLD_LEXER 
----------------------------------------------------------------------
delete from dr$object_attribute
  where oat_id=61102 and oat_cla_id=6 and oat_obj_id=11 and oat_att_id=2
    and oat_name='PRINTJOINS';

delete from dr$object_attribute
  where oat_id=61103 and oat_cla_id=6 and oat_obj_id=11 and oat_att_id=3
    and oat_name='SKIPJOINS';

commit;


-------------------------------------------------------------------------
-- Remove U_TABLE_CLAUSE
-------------------------------------------------------------------------
delete from dr$object_attribute
  where oat_id=90154 and oat_cla_id=9  and oat_obj_id=1 and oat_att_id=54
    and oat_name='U_TABLE_CLAUSE';

commit;

-------------------------------------------------------------------------
-- Remove Single Byte Indexing option
-------------------------------------------------------------------------
delete from dr$object_attribute
  where oat_id=90153 and oat_cla_id=9 and oat_obj_id=1 and oat_att_id=53
    and oat_name='SINGLE_BYTE';

commit;

--------------------------------------------------------------------------
-- Long Identifier Downgrade Changes for CTX objects
--------------------------------------------------------------------------
-- dr$parameter
declare
  errnum number;
begin
  execute immediate('
  alter table dr$parameter modify par_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$class
declare
  errnum number;
begin
  execute immediate('
  alter table dr$class modify cla_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$object
declare
  errnum number;
begin
  execute immediate('
  alter table dr$object modify obj_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$object_attribute
declare
  errnum number;
begin
  execute immediate('
  alter table dr$object_attribute modify oat_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$object_attribute_lov
declare
  errnum number;
begin
  execute immediate('
  alter table dr$object_attribute_lov modify oal_label varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$preference
declare
  errnum number;
begin
  execute immediate('
  alter table dr$preference modify pre_name varchar2(30)');
exception
  when others then
    null;
end;
/
-- dr$index
declare
  errnum number;
begin
  execute immediate('
  alter table dr$index modify idx_name varchar2(30)');
exception
  when others then
    null;
end;
/

declare
  errnum number;
begin
  execute immediate('
  alter table dr$index modify idx_sync_jobname varchar2(50)');
exception
  when others then
    null;
end;
/

declare
  errnum number;
begin
  execute immediate('
  alter table dr$index modify idx_src_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$index_partition

declare
  errnum number;
begin
  execute immediate('
  alter table dr$index_partition modify ixp_name varchar2(30)');
exception
  when others then
    null;
end;
/

declare
  errnum number;
begin
  execute immediate('
  alter table dr$index_partition modify ixp_sync_jobname varchar2(50)');
exception
  when others then
    null;
end;
/

-- dr$sqe
declare
  errnum number;
begin
  execute immediate('
  alter table dr$sqe modify sqe_name varchar2(30)');
exception
  when others then
    null;
end;
/
-- dr$ths
declare
  errnum number;
begin
  execute immediate('
  alter table dr$ths modify ths_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$section_group
declare
  errnum number;
begin
  execute immediate('
  alter table dr$section_group modify sgp_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$section
declare
  errnum number;
begin
  execute immediate('
  alter table dr$section modify sec_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$stoplist
declare
  errnum number;
begin
  execute immediate('
  alter table dr$stoplist modify spl_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$index_set
declare
  errnum number;
begin
  execute immediate('
  alter table dr$index_set modify ixs_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$online_pending
declare
  errnum number;
begin
  execute immediate('
  alter table dr$online_pending modify onl_indexpartition varchar2(30)');
exception
  when others then
    null;
end;
/
-- dr$parallel
declare
  errnum number;
begin
  execute immediate('
  alter table dr$parallel modify p_partition varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$dbo
declare
  errnum number;
begin
  execute immediate('
  alter table dr$dbo modify dbo_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$index_cdi_column
declare
  errnum number;
begin
  execute immediate('
  alter table dr$index_cdi_column modify cdi_section_name varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$autoopt
declare
  errnum number;
begin
  execute immediate('
  alter table dr$autoopt modify aoi_ownname varchar2(30)');
exception
  when others then
    null;
end;
/

declare
  errnum number;
begin
  execute immediate('
  alter table dr$autoopt modify aoi_idxname varchar2(30)');
exception
  when others then
    null;
end;
/

declare
  errnum number;
begin
  execute immediate('
  alter table dr$autoopt modify aoi_partname varchar2(30)');
exception
  when others then
    null;
end;
/

-- dr$dictionary
declare
  errnum number;
begin
  execute immediate('
  alter table dr$dictionary modify dict_name varchar2(30)');
exception
  when others then
    null;
end;
/

----------------------------------------------------------------------
-- Index Option, remove 's', DRDPL_OPT_SORTSTAB
----------------------------------------------------------------------
declare
  sql_q varchar2(100);
begin
  for r in (select idx_id, idx_option from dr$index
             where idx_option like '%s%')
  loop
    sql_q := 'update dr$index set idx_option=''' ||
             replace(r.idx_option, 's') || '''' ||
             ' where idx_id=' || r.idx_id;
    execute immediate(sql_q);
  end loop;
exception
  when others then
    null;
end;
/


----------------------------------------------------------------------
-- Remove storage option for stage itab max rows
----------------------------------------------------------------------
delete from dr$object_attribute
where oat_id = 90128  and oat_cla_id = 9 and oat_obj_id = 1 and
      oat_att_id = 28 and oat_name = 'STAGE_ITAB_MAX_ROWS';
commit;

----------------------------------------------------------------------
-- Add storage option for stage itab target size
----------------------------------------------------------------------
BEGIN
insert into dr$object_attribute values
  (90128, 9, 1, 28,
   'STAGE_ITAB_TARGET_SIZE', '',
   'N', 'N', 'Y', 'I',
   '0', null, null, 'N');
EXCEPTION
  when dup_val_on_index then
    null;
END;
/

----------------------------------------------------------------------
-- Remove storage option for stage itab parallel degree
----------------------------------------------------------------------
begin
  delete from dr$object_attribute
  where oat_id = 90155  and oat_cla_id = 9 and oat_obj_id = 1 and 
        oat_att_id = 55 and oat_name = 'STAGE_ITAB_PARALLEL';

  commit;
exception
when dup_val_on_index then
  null;
end;
/

-- Bug 21701234
REM ===================================================================
REM REVOKE DBMS_PRIV_CAPTURE from ctxsys
REM ===================================================================
revoke execute on DBMS_PRIV_CAPTURE from ctxsys;
