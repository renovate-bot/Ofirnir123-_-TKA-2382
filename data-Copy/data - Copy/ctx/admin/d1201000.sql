Rem
Rem $Header: ctx_src_2/src/dr/admin/d1201000.sql /main/16 2018/07/25 13:49:09 surman Exp $
Rem
Rem d1201000.sql
Rem
Rem Copyright (c) 2012, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      d1201000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      downgrade from 121 to 11204
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1201000.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/d1201000.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxe112.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    rkadwe      12/22/15 - Lrg 18790794
Rem    hxzhang     08/18/15 - drop the new index type context_v2
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    aczarlin    02/26/14 - $R fix ltrim, ctxsys, index type 1
Rem    aczarlin    10/18/13 - lrg 9977398
Rem    yiqi        10/16/12 - Bug 14459127 and lrg 7293054
Rem    surman      08/24/12 - 14038163: Add a_index_clause and f_index_clause
Rem    rkadwe      07/09/12 - Bug 13942561
Rem    gauryada    07/16/12 - bug#14109170
Rem    yiqi        04/30/12 - delete sdata from path sec group
Rem    yiqi        04/17/12 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

REM
REM BEGIN creating a 11g version dummy impl. type and operator
REM

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
REM END creating a 11g version dummy impl. type  and operator
REM 
  
PROMPT DisAssociate Statistics
PROMPT

DISASSOCIATE STATISTICS FROM INDEXTYPES CONTEXT FORCE;
DISASSOCIATE STATISTICS FROM INDEXTYPES CONTEXT_V2 FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_CONTAINS FORCE;
  
DISASSOCIATE STATISTICS FROM INDEXTYPES CTXXPATH FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_XPCONTAINS FORCE;

DISASSOCIATE STATISTICS FROM INDEXTYPES CTXRULE FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_MATCHES FORCE;

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

PROMPT Create old 11g version of TextIndexMethods and TextOptStats
PROMPT 
REM    (this is copied directly from dr0type.pkh)

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
REM recreate 11g version contains and score operators
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

REM
REM == CREATE CONTAINS PRIMARY OPERATOR ==
REM

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

REM 
REM == CREATE ANCILLARY FUNCTION ==
REM

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


REM
REM == CREATE ANCILLARY SCORE OPERATOR ==
REM
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


REM
REM BEGIN DOWN-GRADING CTXCAT INDEXTYPE
REM

PROMPT Remove existing indextype operator bindings ...
PROMPT
alter indextype ctxcat add dummyop(varchar2, varchar2);
alter indextype ctxcat drop catsearch(varchar2, varchar2, varchar2);
alter indextype ctxcat drop catsearch(varchar2, clob, varchar2);
alter indextype ctxcat drop catsearch(clob, varchar2, varchar2);
alter indextype ctxcat drop catsearch(clob, clob, varchar2);

PROMPT Drop CATSEARCH operator ...
PROMPT
drop operator catsearch FORCE;
drop package ctx_catsearch;

PROMPT Shift indextype implementation to dummy implementation type
PROMPT
alter indextype ctxcat using DummyIndexMethods;

PROMPT Create old 11g version of CatIndexMethods ...
PROMPT
REM    (this is copied directly from dr0typec.pkh)

create or replace type CatIndexMethods authid current_user as object
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
   static function ODCIIndexStart(sctx in out CatIndexMethods,
                          ia sys.odciindexinfo,
                          op sys.odcipredinfo,
                          qi sys.odciqueryinfo,
                          strt number, stop number, valarg varchar2,
                          valarg2 varchar2,
                          env sys.ODCIEnv)
            return number is language C
        name "catstart"
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
               valarg2,
               valarg2 INDICATOR,
               valarg2 LENGTH,
               env,
               env INDICATOR STRUCT,
               return OCINumber
            ),
   static function ODCIIndexStart(sctx in out CatIndexMethods,
                          ia sys.odciindexinfo,
                          op sys.odcipredinfo,
                          qi sys.odciqueryinfo,
                          strt number, stop number, valarg clob,
                          valarg2 varchar2,
                          env sys.ODCIEnv)
            return number is language C
        name "catstart_clob"
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
               valarg2,
               valarg2 INDICATOR,
               valarg2 LENGTH,
               env,
               env INDICATOR STRUCT,
               return OCINumber
            ),
   member function ODCIIndexFetch(nrows number,
                          rids OUT sys.odciridlist, env SYS.ODCIEnv)
            return number is language C
            name "catfetch"
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
            name "catclose"
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
            return number
);
/
 
REM
REM create temporary CatIndexMethods body
REM

create or replace type body CatIndexMethods is

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

end;
/
show errors;

select text from dba_errors
 where owner = 'CTXSYS' and name = 'CATINDEXMETHODS';

PROMPT Shift indextype implementation to CatIndexMethods ...
PROMPT

alter indextype ctxcat using CatIndexMethods;

REM
REM recreate 11g version catsearch operators
REM following copied directly from dr0itypec.sql
REM

create or replace package ctx_catsearch authid current_user as
function catsearch(
  Colval  in     varchar2,
  Text    in     varchar2,
  condcls in     varchar2,
  ia      in     sys.odciindexctx,
  sctx    in out CatIndexMethods,
  cflg    in     number
) 
  return number parallel_enable is language C
  name "catsearch"
  library dr$lib 
  with context   
  parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        condcls,
        condcls INDICATOR,
        condcls LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );

function catsearch(
  Colval  in     varchar2,
  Text    in     clob, 
  condcls in     varchar2,
  ia      in     sys.odciindexctx,
  sctx    in out CatIndexMethods,
  cflg    in     number
) 
  return number parallel_enable is language C
  name "catsearch_clob"
  library dr$lib
  with context
  parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        condcls,
        condcls INDICATOR,
        condcls LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );

function catsearch(
  Colval  in     clob,
  Text    in     varchar2,
  condcls in     varchar2,
  ia      in     sys.odciindexctx,
  sctx    in out CatIndexMethods,
  cflg    in     number
)
  return number parallel_enable is language C
  name "catsearch"
  library dr$lib
  with context
  parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text LENGTH,
        condcls,
        condcls INDICATOR,
        condcls LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );

function catsearch(
  Colval  in     clob,
  Text    in     clob,
  condcls in     varchar2,
  ia      in     sys.odciindexctx,
  sctx    in out CatIndexMethods,
  cflg    in     number
)
  return number parallel_enable is language C
  name "catsearch_clob"
  library dr$lib
  with context
  parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        condcls,
        condcls INDICATOR,
        condcls LENGTH,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
end ctx_catsearch;
/ 
  
REM       
REM == CREATE CATSEARCH PRIMARY OPERATOR ==
REM 

create  operator catsearch binding
  (varchar2, varchar2, varchar2) return number
     with index context, scan context CatIndexMethods
     without column data using ctx_catsearch.catsearch,
  (varchar2, clob, varchar2) return number
     with index context, scan context CatIndexMethods
     without column data using ctx_catsearch.catsearch,
  (clob, varchar2, varchar2) return number
     with index context, scan context CatIndexMethods
     without column data using ctx_catsearch.catsearch,
  (clob, clob, varchar2) return number
     with index context, scan context CatIndexMethods
     without column data using ctx_catsearch.catsearch
;

grant execute on catsearch to public;

drop public synonym catsearch;
create public synonym catsearch for ctxsys.catsearch;

grant execute on ctxcat to public;

PROMPT Rebind operators and remove the dummyop
PROMPT

alter indextype ctxcat add catsearch(varchar2, varchar2, varchar2);
alter indextype ctxcat add catsearch(varchar2, clob, varchar2);
alter indextype ctxcat add catsearch(clob, varchar2, varchar2);
alter indextype ctxcat add catsearch(clob, clob, varchar2);
alter indextype ctxcat drop dummyop(varchar2, varchar2);

REM
REM END DOWN-GRADING CTXCAT INDEXTYPE
REM 

REM
REM BEGIN DOWN-GRADING CTXRULE INDEXTYPE
REM

PROMPT Remove existing indextype operator bindings ...
PROMPT

alter indextype ctxrule add dummyop(varchar2, varchar2);
alter indextype ctxrule drop matches(varchar2, varchar2);
alter indextype ctxrule drop matches(clob, varchar2);
alter indextype ctxrule drop matches(blob, varchar2);
alter indextype ctxrule drop matches(varchar2, clob);
alter indextype ctxrule drop matches(clob, clob);
alter indextype ctxrule drop matches(blob, clob);

drop operator match_score FORCE;
drop operator matches FORCE;
drop package ctx_matches;
drop package driscorr;

PROMPT Shift indextype implementation to dummy implementation type ...
PROMPT

alter indextype ctxrule using DummyIndexMethods;

create or replace type RuleIndexMethods authid current_user as object
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

   static function ODCIIndexStart(sctx in out RuleIndexMethods,
                          ia sys.odciindexinfo,
                          op sys.odcipredinfo,
                          qi sys.odciqueryinfo,
                          strt number, stop number, valarg varchar2,
                          env SYS.ODCIEnv)
            return number is language C
        name "rulestart"
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
        static function ODCIIndexStart(sctx in out RuleIndexMethods,
                          ia sys.odciindexinfo,
                          op sys.odcipredinfo,
                          qi sys.odciqueryinfo,
                          strt number, stop number, valarg clob,
                          env SYS.ODCIEnv)
            return number is language C
        name "rulecstart"
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
            name "rulefetch"
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
            name "ruleclose"
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
            return number
);
/

SHOW ERRORS;

create or replace type body RuleIndexMethods is
  
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
  
end;
/ 
show errors;

select text from dba_errors
 where owner = 'CTXSYS' and name = 'RULEINDEXMETHODS';
  
alter indextype ctxrule using RuleIndexMethods;

create or replace package ctx_matches authid current_user as

function  matches(
  Colval  in     varchar2,
  Text    in     varchar2,
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
)
  return number parallel_enable is language C
  name "rulematches"
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

function matches(
  Colval  in     clob,
  Text    in     varchar2,
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
)
  return number parallel_enable is language C
  name "rulematches"
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

function matches(
  Colval  in     blob,
  Text    in     varchar2, 
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
) 
  return number parallel_enable is language C
  name "rulematches"
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

function matches(
  Colval  in     varchar2,
  Text    in     clob, 
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
) 
  return number parallel_enable is language C
  name "rulematches"
  library dr$lib
  with context
  parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text CHARSETID,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );

function matches(
  Colval  in     clob,
  Text    in     clob, 
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
) 
  return number parallel_enable is language C
  name "rulematches"
  library dr$lib
  with context
  parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text CHARSETID,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );

function matches(
  Colval  in     blob,
  Text    in     clob,
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
)
  return number parallel_enable is language C
  name "rulematches"
  library dr$lib
  with context
  parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text CHARSETID,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
end ctx_matches;
/

SHOW ERROR;

create  or replace operator matches binding
  (varchar2, varchar2) return number
     with index context, scan context RuleIndexMethods
     without column data using ctx_matches.matches,
  (clob, varchar2) return number
     with index context, scan context RuleIndexMethods
     without column data using ctx_matches.matches,
  (blob, varchar2) return number
     with index context, scan context RuleIndexMethods
     without column data using ctx_matches.matches,
  (varchar2, clob) return number
     with index context, scan context RuleIndexMethods
     without column data using ctx_matches.matches,
  (clob, clob) return number
     with index context, scan context RuleIndexMethods
     without column data using ctx_matches.matches,
  (blob, clob) return number
     with index context, scan context RuleIndexMethods
     without column data using ctx_matches.matches
;

grant execute on matches to public;

drop public synonym matches;
create public synonym matches for ctxsys.matches;

create or replace package driscorr authid definer as
function  RuleScore(
  Colval  in     varchar2,
  Text    in     varchar2, 
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
)
  return number parallel_enable is language C
  name "rulematches"
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

function RuleScore(
  Colval  in     clob,
  Text    in     varchar2, 
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
)
  return number parallel_enable is language C
  name "rulematches"
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

function RuleScore(
  Colval  in     blob, 
  Text    in     varchar2, 
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
) 
  return number parallel_enable is language C
  name "rulematches"
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

function RuleScore(
  Colval  in     varchar2,
  Text    in     clob, 
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
) 
  return number parallel_enable is language C
  name "rulematches"
  library dr$lib
  with context
  parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text CHARSETID,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );

function RuleScore(
  Colval  in     clob,
  Text    in     clob,
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
)
  return number parallel_enable is language C
  name "rulematches"
  library dr$lib
  with context
  parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text CHARSETID,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );

function RuleScore(
  Colval  in     blob,
  Text    in     clob, 
  ia      in     sys.odciindexctx,
  sctx    in out RuleIndexMethods,
  cflg    in     number
) 
  return number parallel_enable is language C
  name "rulematches"
  library dr$lib
  with context
  parameters(
        context,
        Colval,
        Colval INDICATOR,
        Text,
        Text INDICATOR,
        Text CHARSETID,
        ia,
        ia INDICATOR STRUCT,
        sctx,
        sctx INDICATOR STRUCT,
        cflg,
        cflg INDICATOR,
        return OCINumber
      );
end driscorr;
/

SHOW ERROR;

create or replace operator match_score binding
   (number) return number
     ancillary to matches(varchar2, varchar2),
                  matches(clob,     varchar2),
                  matches(blob,     varchar2),
                  matches(varchar2, clob),
                  matches(clob,     clob),
                  matches(blob,     clob)
     without column data using driscorr.RuleScore;

grant execute on match_score to public;

drop public synonym match_score;
create public synonym match_score for ctxsys.match_score;

alter indextype ctxrule add matches(varchar2, varchar2);
alter indextype ctxrule add matches(clob, varchar2);
alter indextype ctxrule add matches(blob, varchar2);
alter indextype ctxrule add matches(varchar2, clob);
alter indextype ctxrule add matches(clob, clob);
alter indextype ctxrule add matches(blob, clob);
alter indextype ctxrule drop dummyop(varchar2, varchar2);

associate statistics with indextypes CTXRULE default cost (1,0,0);
associate statistics with packages ctx_matches default 
cost (1000,10000000000,0);

REM 
REM END DOWN-GRADING CTXRULE INDEXTYPE
REM
REM

REM
REM BEGIN DOWN-GRADING CTXXPATH INDEXTYPE
REM

PROMPT Remove existing ctxxpath operator bindings, etc.
PROMPT
alter indextype ctxxpath add dummyop(varchar2, varchar2);
alter indextype ctxxpath drop xpcontains(sys.xmltype, varchar2);

PROMPT Drop operator and package
PROMPT
drop operator xpcontains FORCE;
drop package ctx_xpcontains;

alter indextype ctxxpath using DummyIndexMethods;

create or replace type XPathIndexMethods authid current_user as object
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
   static function ODCIIndexStart(sctx in out XpathIndexMethods,
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
            return number
);
/

create or replace type body XpathIndexMethods is

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
  
end;
/ 
show errors;

select text from dba_errors
 where owner = 'CTXSYS' and name = 'XPATHINDEXMETHODS';
  
alter indextype ctxxpath using XPathIndexMethods;

create or replace package ctx_xpcontains authid current_user as

function xpcontains(
  Colval  in     sys.xmltype,
  Text    in     varchar2,
  ia      in     sys.odciindexctx,
  sctx    in out XpathIndexMethods,
  cflg    in     number
)
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

end ctx_xpcontains;
/

create  or replace operator xpcontains binding
  (sys.xmltype, varchar2) return number 
     with index context, scan context XpathIndexMethods 
     without column data using ctx_xpcontains.xpcontains
;

create or replace procedure syncrn (
  ownid IN binary_integer,
  oname IN varchar2,
  idxid IN binary_integer,
  ixpid IN binary_integer,
  rtabnm IN varchar2,
  srcflg IN binary_integer
)
  authid definer
  as external
  name "comt_cb"
  library dr$lib
  with context
  parameters(
    context,
    ownid  ub4,
    oname  OCISTRING,
    idxid  ub4,
    ixpid  ub4,
    rtabnm OCISTRING,
    srcflg ub1
);
/

grant execute on xpcontains to public;

grant execute on ctxxpath to public;

alter indextype ctxxpath add xpcontains(sys.xmltype, varchar2);
alter indextype ctxxpath drop dummyop(varchar2, varchar2);

REM RE-ASSOCIATE EIX OPTIMIZER IMPLEMENTATION TYPE

ASSOCIATE STATISTICS WITH INDEXTYPES ctxxpath USING TextOptStats;
ASSOCIATE STATISTICS WITH PACKAGES ctx_xpcontains USING TextOptStats;


REM
REM END DOWN-GRADING CTXXPATH INDEXTYPE
REM


REM
REM DROP the dummy operator/type
REM

drop operator dummyop;
drop package ctx_dummyop;
drop type DummyIndexMethods;

REM ===================================================================
REM Bug 13610777: Default value of read_only should be FALSE
REM ===================================================================

update dr$object_attribute
  set oat_default = 'TRUE'
  where oat_id = 240106;

REM ===================================================================
REM Bug 9950719: fuzzy_score has a mininum value of 1
REM ===================================================================

update dr$object_attribute
  set oat_val_min = 0
  where oat_id = 70103;

-- 13431201: Remove functional_cache_size
DELETE FROM dr$parameter WHERE par_name = 'FUNCTIONAL_CACHE_SIZE';

delete from dr$object_attribute
  where oat_name = 'XML_ENABLE';

delete from dr$object_attribute
  where oat_name = 'NS_ENABLE';

delete from dr$object_attribute
  where oat_name = 'E_TABLE_CLAUSE';

delete from dr$object_attribute
  where oat_name = 'PREFIX_NS_MAPPING';

-------------------------------------------------------------------------
--- dr$section_group_attribute
-------------------------------------------------------------------------
declare
  stmt varchar2(4000);
  cnt  number;
begin
  stmt := 'select count(*) from user_tables where table_name=''' || 
          'DR$SECTION_GROUP_ATTRIBUTE' ||
          '''';
  execute immediate stmt into cnt;
  if (cnt = 1) then
    stmt := 'drop table dr$section_group_attribute';
    execute immediate stmt;
  end if;
  exception 
    when others then
      null;
end;
/

------------------------------------------------------------------------
-- ATG Objects
------------------------------------------------------------------------
drop view CTX_USER_ALEXER_DICTS;

drop view CTX_ALEXER_DICTS;

drop table DR$DICTIONARY;

drop table DR$IDX_DICTIONARIES;

delete from dr$object_attribute where
   oat_cla_id = 6 and 
   oat_obj_id = 12 and
   oat_name in ('PRINTJOINS', 'SKIPJOINS');

delete from dr$object_attribute where
   oat_cla_id = 6 and
   oat_obj_id = 12 and
   oat_name in
   ('ARABIC_DICTIONARY','CATALAN_DICTIONARY',
    'SIMP_CHINESE_DICTIONARY','TRAD_CHINESE_DICTIONARY',
    'CROATIAN_DICTIONARY', 'CZECH_DICTIONARY', 
    'DANISH_DICTIONARY','DUTCH_DICTIONARY',
    'ENGLISH_DICTIONARY','FINNISH_DICTIONARY',
    'FRENCH_DICTIONARY','GERMAN_DICTIONARY', 'GREEK_DICTIONARY',
    'HEBREW_DICTIONARY','HUNGARIAN_DICTIONARY','ITALIAN_DICTIONARY',
    'JAPANESE_DICTIONARY','KOREAN_DICTIONARY','BOKMAL_DICTIONARY',
    'NYNORSK_DICTIONARY','PERSIAN_DICTIONARY','POLISH_DICTIONARY',
    'PORTUGUESE_DICTIONARY','ROMANIAN_DICTIONARY','RUSSIAN_DICTIONARY',
    'SERBIAN_DICTIONARY','SLOVAK_DICTIONARY','SLOVENIAN_DICTIONARY',
    'SPANISH_DICTIONARY','SWEDISH_DICTIONARY','THAI_DICTIONARY',
    'TURKISH_DICTIONARY');

BEGIN
   insert into dr$object_attribute values
     (61299, 6, 12, 99, 'ARABIC_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061200, 6, 12, 100, 'CATALAN_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061201, 6, 12, 101, 'SIMP_CHINESE_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061202, 6, 12, 102, 'TRAD_CHINESE_SENTENCE_STARTS',
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061203, 6, 12, 103, 'CROATIAN_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061204, 6, 12, 104, 'CZECH_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061205, 6, 12, 105, 'DANISH_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061206, 6, 12, 106, 'DUTCH_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061207, 6, 12, 107, 'ENGLISH_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061208, 6, 12, 108, 'FINNISH_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061209, 6, 12, 109, 'FRENCH_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061210, 6, 12, 110, 'GERMAN_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061211, 6, 12, 111, 'GREEK_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061212, 6, 12, 112, 'HEBREW_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061213, 6, 12, 113, 'HUNGARIAN_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061214, 6, 12, 114, 'ITALIAN_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061215, 6, 12, 115, 'JAPANESE_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061216, 6, 12, 116, 'KOREAN_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061217, 6, 12, 117, 'BOKMAL_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061218, 6, 12, 118, 'NYNORSK_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061219, 6, 12, 119, 'PERSIAN_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061220, 6, 12, 120, 'POLISH_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061221, 6, 12, 121, 'PORTUGUESE_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061222, 6, 12, 122, 'ROMANIAN_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061223, 6, 12, 123, 'RUSSIAN_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061224, 6, 12, 124, 'SERBIAN_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061225, 6, 12, 125, 'SLOVAK_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061226, 6, 12, 126, 'SLOVENIAN_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061227, 6, 12, 127, 'SPANISH_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061228, 6, 12, 128, 'SWEDISH_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061229, 6, 12, 129, 'THAI_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
BEGIN
   insert into dr$object_attribute values
     (1061230, 6, 12, 130, 'TURKISH_SENTENCE_STARTS', 
      'Space-delimited list of sentence_starts', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061263, 6, 12, 163, 'ARABIC_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061264, 6, 12, 164, 'CATALAN_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061265, 6, 12, 165, 'SIMP_CHINESE_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061266, 6, 12, 166, 'TRAD_CHINESE_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061267, 6, 12, 167, 'CROATIAN_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061268, 6, 12, 168, 'CZECH_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061269, 6, 12, 169, 'DANISH_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061270, 6, 12, 170, 'DUTCH_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061271, 6, 12, 171, 'ENGLISH_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061272, 6, 12, 172, 'FINNISH_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061273, 6, 12, 173, 'FRENCH_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061274, 6, 12, 174, 'GERMAN_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061275, 6, 12, 175, 'GREEK_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061276, 6, 12, 176, 'HEBREW_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061277, 6, 12, 177, 'HUNGARIAN_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061278, 6, 12, 178, 'ITALIAN_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061279, 6, 12, 179, 'JAPANESE_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061280, 6, 12, 180, 'KOREAN_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061281, 6, 12, 181, 'BOKMAL_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061282, 6, 12, 182, 'NYNORSK_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061283, 6, 12, 183, 'PERSIAN_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061284, 6, 12, 184, 'POLISH_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061285, 6, 12, 185, 'PORTUGUESE_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061286, 6, 12, 186, 'ROMANIAN_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061287, 6, 12, 187, 'RUSSIAN_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061288, 6, 12, 188, 'SERBIAN_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061289, 6, 12, 189, 'SLOVAK_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061290, 6, 12, 190, 'SLOVENIAN_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061291, 6, 12, 191, 'SPANISH_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061292, 6, 12, 192, 'SWEDISH_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061293, 6, 12, 193, 'THAI_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061294, 6, 12, 194, 'TURKISH_ABBR_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/
   
BEGIN
insert into dr$object_attribute values
(61210, 6, 12, 10,
 'SENTENCE_TOKEN_LIMIT', 'The Maximum number of tokens allowed in a sentence', 
 'N', 'N', 'Y', 'I', '100', null, null, 'N');
 EXCEPTION
   when dup_val_on_index then
     null;
 END;
/

BEGIN
   insert into dr$object_attribute values
     (1061295, 6, 12, 163, 'ARABIC_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061296, 6, 12, 164, 'CATALAN_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061297, 6, 12, 165, 'SIMP_CHINESE_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061298, 6, 12, 166, 'TRAD_CHINESE_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (1061299, 6, 12, 167, 'CROATIAN_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061200, 6, 12, 169, 'DANISH_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061201, 6, 12, 170, 'DUTCH_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061202, 6, 12, 171, 'ENGLISH_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061203, 6, 12, 172, 'FINNISH_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061204, 6, 12, 173, 'FRENCH_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061205, 6, 12, 174, 'GERMAN_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061206, 6, 12, 178, 'ITALIAN_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061207, 6, 12, 179, 'JAPANESE_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061208, 6, 12, 180, 'KOREAN_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061209, 6, 12, 181, 'BOKMAL_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061210, 6, 12, 182, 'NYNORSK_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061211, 6, 12, 183, 'PERSIAN_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061212, 6, 12, 185, 'PORTUGUESE_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061213, 6, 12, 187, 'RUSSIAN_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061214, 6, 12, 189, 'SLOVAK_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061215, 6, 12, 190, 'SLOVENIAN_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061216, 6, 12, 191, 'SPANISH_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061217, 6, 12, 192, 'SWEDISH_TAG_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061218, 6, 12, 218, 'ARABIC_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061219, 6, 12, 219, 'CATALAN_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061220, 6, 12, 220, 'SIMP_CHINESE_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061221, 6, 12, 221, 'TRAD_CHINESE_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061222, 6, 12, 222, 'CROATIAN_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061241, 6, 12, 241, 'CZECH_STEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061223, 6, 12, 223, 'DANISH_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061224, 6, 12, 224, 'DUTCH_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061225, 6, 12, 225, 'ENGLISH_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061226, 6, 12, 226, 'FINNISH_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061227, 6, 12, 227, 'FRENCH_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061228, 6, 12, 228, 'GERMAN_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061242, 6, 12, 242, 'GREEK_STEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061243, 6, 12, 243, 'HEBREW_STEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061244, 6, 12, 244, 'HUNGARIAN_STEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061229, 6, 12, 229, 'ITALIAN_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061230, 6, 12, 230, 'JAPANESE_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061231, 6, 12, 231, 'KOREAN_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061232, 6, 12, 232, 'BOKMAL_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061233, 6, 12, 233, 'NYNORSK_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061234, 6, 12, 234, 'PERSIAN_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061245, 6, 12, 245, 'POLISH_STEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061235, 6, 12, 235, 'PORTUGUESE_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061246, 6, 12, 246, 'ROMANIAN_STEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061236, 6, 12, 236, 'RUSSIAN_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061247, 6, 12, 247, 'SERBIAN_STEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061237, 6, 12, 237, 'SLOVAK_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061238, 6, 12, 238, 'SLOVENIAN_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061239, 6, 12, 239, 'SPANISH_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061240, 6, 12, 240, 'SWEDISH_TAGSTEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061248, 6, 12, 248, 'THAI_STEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061249, 6, 12, 249, 'TURKISH_STEM_DICT', 
      'Name of abbreviation dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061250, 6, 12, 250, 'SIMP_CHINESE_CCJT_DICT', 
      'Name of CCJT dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061251, 6, 12, 251, 'TRAD_CHINESE_CCJT_DICT', 
      'Name of CCJT dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/


BEGIN
   insert into dr$object_attribute values
     (2061252, 6, 12, 252, 'JAPANESE_CCJT_DICT', 
      'Name of CCJT dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

BEGIN
   insert into dr$object_attribute values
     (2061253, 6, 12, 253, 'THAI_CCJT_DICT', 
      'Name of CCJT dictionary', 'N', 'N', 'Y', 'S', 
      'NONE', null, null, 'N');
  EXCEPTION
   when dup_val_on_index then
     null;
END;
/

REM ==================================================================
REM Reverse Change from partition specific stage_itab enhancements
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90128 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=28
   and OAT_NAME='STAGE_ITAB_TARGET_SIZE';
commit;

REM ==================================================================
REM Reverse Change from $R contention improvement
REM ==================================================================

delete from dr$object_attribute
  where OAT_ID=90129 and OAT_CLA_ID=9 and OAT_OBJ_ID=1 and OAT_ATT_ID=29
   and OAT_NAME='SMALL_R_ROW';
commit;

REM ==================================================================
REM Reverse Change from $R add PK
REM ==================================================================

SET SERVEROUTPUT ON;

DECLARE
 sqlstmt    varchar2(1000);
 sqlstmt2   varchar2(1000);
 cnstraint  varchar2(1000);
 charend    varchar2(1000);
 tname      varchar2(1000);
 errnum     number;
 errtxt     varchar2(1000);

 partidstr  varchar2(4);
 lpid       number;
 l_idx_owner varchar2(100);
 l_idx_name varchar2(100);
 l_pfx_type varchar(1);
 l_pfx_str  varchar(4);
 lvl        number;
 tlen       number;
 clen       number;
 badchar    number;

 only_one_primary_key EXCEPTION;
 PRAGMA EXCEPTION_INIT(only_one_primary_key, -2260);

 TYPE dollar_r
 IS RECORD(idx_id     number,
           idx_owner  varchar2(1000),
           ixp_id     number,
           idx_name   varchar2(1000),
           idx_table  varchar2(1000));
 rtab dollar_r;

 CURSOR dollar_r_cur
 IS
 select i.idx_id, ci.idx_owner, ip.ixp_id, ci.idx_name,ci.idx_table
 from ctxsys.ctx_indexes ci
 left join ctxsys.dr$index_partition ip
 on ci.idx_id = ip.ixp_idx_id
 left join ctxsys.dr$index i
 on ci.idx_id = i.idx_id
 where ci.idx_type = 'CONTEXT'
 and ci.idx_owner != 'CTXSYS'
 and ci.idx_status != 'NO_INDEX'
 order by i.idx_id, ip.ixp_id;

 BEGIN
  OPEN dollar_r_cur;
  LOOP
    FETCH dollar_r_cur INTO rtab;
    EXIT WHEN dollar_r_cur%NOTFOUND;

    /* get constraint name  */

    lpid := rtab.ixp_id;
    l_idx_owner := dbms_assert.enquote_name(rtab.idx_owner, FALSE);
    l_pfx_str := 'DRC';
    l_idx_name := 
        ltrim(rtrim(dbms_assert.simple_sql_name(rtab.idx_name),'"'),'"');

    /* event checking does not work during downgrade.  However check for
       Bug 13783516 by seeing if index name contains ']' */
    badchar := instr(l_idx_name, ']');

   /* driutl.make_pfx */

   if (lpid is null or lpid = 0) then
       cnstraint :=  '"' || l_pfx_str || '$' || l_idx_name || l_pfx_type;
   else
     if (lpid >= 10000) then
       lpid := lpid - 10000;
       partidstr := '';

       if (badchar != 0) then
        for i in 1..4 loop
          -- Bug 13783516: avoid generating a ']' character in the name.
          -- Note the computation made here must match the similar
          -- computation performed in dret.c/dretGetName.
          if (mod(lpid,36) >= 26) then
            partidstr := chr(ascii('0')+mod(lpid,36)-26)||partidstr;
          else
            partidstr := chr(ascii('A')+mod(lpid,36))||partidstr;
          end if;
          lpid := trunc(lpid/36);
        end loop;
       else
        for i in 1..4 loop
         if (mod(lpid,36) >= 27) then
           partidstr := chr(ascii('0')+mod(lpid,36)-27)||partidstr;
         else
           partidstr := chr(ascii('A')+mod(lpid,36))||partidstr;
         end if;
        lpid := trunc(lpid/36);
       end loop;
      end if;

     else  /* not (lpid >= 10000) */
       partidstr := ltrim(to_char(lpid,'0000'));
     end if;

    cnstraint := '"' || l_pfx_str || '#' || l_idx_name || 
                        partidstr || l_pfx_type;
   end if;

   /* end of drutil.make_pfx */

   /* 'proposed' constraint name, use it to get tab name */
   cnstraint := cnstraint || '$R' || '"';
   cnstraint := rtrim(ltrim(cnstraint,'"'), '"');
   clen := length(cnstraint);

   /* table name from constraint: remove leading 'DRC' */
   /* will already have correct leading '$' or '#'     */

   tname := 'DR' || substr(cnstraint, 4);
   tname := DBMS_ASSERT.ENQUOTE_NAME(tname,FALSE);
   tlen := length(tname);

   /* set schema to owner before drop/add contraint */
   sqlstmt := 'alter session set current_schema = ' 
                   || DBMS_ASSERT.ENQUOTE_NAME(rtab.idx_owner,FALSE);
   BEGIN
   EXECUTE immediate sqlstmt;
   EXCEPTION
    when others then
      null;
   END;

   /* construct final constraint name.  Need to check length */
 
   if (clen >= (24 + 6)) then 
     /* strip lagging 'R' */
     clen := length(cnstraint);
     charend := substr(cnstraint, clen);

     if ('R' = charend) then
       cnstraint := rtrim(cnstraint, 'R');
       clen := length(cnstraint);
     end if;
   end if;

   if (clen = (24 + 6)) then
     /* strip lagging '$' */
     clen := length(cnstraint);
     charend := substr(cnstraint, clen);

     if ('$' = charend) then
       cnstraint := rtrim(cnstraint, '$');
       clen := length(cnstraint);
     end if;

   end if;

   cnstraint := DBMS_ASSERT.ENQUOTE_NAME(cnstraint,FALSE);

   sqlstmt2 := 'alter table ' || tname || ' drop constraint '|| cnstraint;

   DBMS_OUTPUT.PUT_LINE(sqlstmt2);  

   BEGIN
     EXECUTE immediate sqlstmt2;
     commit;

   EXCEPTION
     when dup_val_on_index then
       continue;
     when no_data_found then
       continue;
     when only_one_primary_key then
       dbms_output.put_line('Table already has primary key');
       continue;
     when others then
       dbms_output.put_line('Hit an exception ...');
       DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM,1,255));
       continue;
    END;

  END LOOP;
  CLOSE dollar_r_cur;
 END;
 /

 alter session set current_schema = CTXSYS;

REM ==================================================================
REM Delete sdata from path sec group
REM ==================================================================

delete from dr$object_attribute
  where oat_id = 50810;
commit;

REM ===================================================================
REM Revoke SET CONTAINER privilege granted to ctxsys 
REM ===================================================================
revoke set container from ctxsys;

REM ===================================================================
REM Reset default value of 'DEFAULT_INDEX_MEMORY' to 12 MB 
REM ===================================================================
update dr$parameter set par_value=12582912
                    where par_name='DEFAULT_INDEX_MEMORY';
                    
REM -------------------------------------------------------------------
REM  14038163: a_index_clause and f_index_clause
REM -------------------------------------------------------------------
delete from dr$object_attribute where oat_id = 90130 or oat_id = 90131;

REM
REM Post type upgrade stuff..
REM 
 
create or replace public synonym context for ctxsys.context;
create or replace public synonym ctxcat for ctxsys.ctxcat;
create or replace public synonym ctxrule for ctxsys.ctxrule;
create or replace public synonym ctxxpath for ctxsys.ctxxpath;

alter type TextIndexMethods compile;
alter type CatIndexMethods compile;
alter type RuleIndexMethods compile;
alter type XpathIndexMethods compile;
alter type TextOptStats  compile;

alter package ctx_contains compile;
alter package driscore compile;
alter package ctx_catsearch compile;
alter package ctx_matches  compile;
alter package driscorr compile;
alter package ctx_xpcontains  compile;   

-- drop synonym CTX_ANL
 
drop public synonym CTX_ANL;

