Rem
Rem $Header: ctx_src_2/src/dr/admin/d1002000.sql /main/34 2018/07/25 13:49:08 surman Exp $
Rem
Rem d1002000.sql
Rem
Rem Copyright (c) 2005, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      d1002000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      downgrade data dictionary from any patchset to 10.2 
Rem      first production version
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/d1002000.sql  
Rem      SQL_SHIPPED_FILE: ctx/admin/d1002000.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE
Rem      SQL_CALLING_FILE: ctx/admin/ctxe102.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    boxia       01/21/16 - Bug 22226636: replace user$ with _BASE_USER
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    rpalakod    08/06/10 - Bug 9973683
Rem    rpalakod    01/10/08 - Entity Extraction 
Rem    wclin       05/11/07 - bug5996259: support sql92 security
Rem    wclin       03/28/07 - bug 5958187: remove ampersand
Rem    ymatsuda    01/18/07 - ndata
Rem    wclin       12/11/06 - clob query support
Rem    ymatsuda    10/13/06 - remove NDATA attributes
Rem    oshiowat    10/09/06 - inxight integration (cont.)
Rem    surman      09/27/06 - 5438110: Add filename_charset
Rem    skabraha    08/24/06 - drop dr$activelogs
Rem    wclin       08/11/06 - bug5401928: fix pending view hints
Rem    skabraha    08/03/06 - drop dr$slowqrys dict table
Rem    skabraha    07/20/06 - recreate changed views
Rem    rigandhi    07/14/06 - name search 
Rem    oshiowat    06/22/06 - inxight integration 
Rem    skabraha    06/13/06 - drop dr$freqtoks dict table
Rem    ymatsuda    02/20/06 - drop sec_datatype column 
Rem    wclin       02/20/06 - bug 5046136 parallel enable text operators 
Rem    mfaisal     02/08/06 - bug 4742903 
Rem    wclin       02/03/06 - reverse dropping of indexytpe synonyms 
Rem    wclin       01/11/06 - Remove CDI for downgrade 
Rem    wclin       01/12/06 - cleanup drop dummyindexmethods 
Rem    ymatsuda    11/16/05 - lrg1969763
Rem    gkaminag    10/28/05 - new cdi method 
Rem    gkaminag    10/24/05 - sdata update 
Rem    gkaminag    10/16/05 - mdata column 
Rem    gkaminag    09/29/05 - cdi indexing 
Rem    oshiowat    08/10/05 - feature usage tracking 
Rem    gkaminag    02/21/05 - gkaminag_test_050217
Rem    gkaminag    02/18/05 - Created
Rem

REM ========================================================================
REM reversing t1002000.sql
REM ========================================================================

drop table ctxsys.dr$feature_used;

REM 
REM BEGIN creating a 10.2.0 version dummy impl. type and operator
REM 

create or replace type DummyindexMethods authid current_user as object
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

   static function ODCIIndexStart(sctx in out DummyindexMethods,
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

create or replace type body DummyIndexMethods is

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

create or replace operator dummyop binding 
  (varchar2, varchar2) return number 
     with index context, scan context DummyIndexMethods
without column data using ctx_dummyop.dummyop;

grant execute on dummyop to public;

REM 
REM END creating a 10.2.0 version dummy impl. type  and operator
REM 

PROMPT DisAssociate Statistics
PROMPT

DISASSOCIATE STATISTICS FROM INDEXTYPES CONTEXT FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_CONTAINS FORCE;

DISASSOCIATE STATISTICS FROM INDEXTYPES CTXXPATH FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_XPCONTAINS FORCE;

REM 
REM BEGIN DOWN-GRADING CONTEXT INDEXTYPE
REM 

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


PROMPT Drop SCORE and CONTAINS operators ...
PROMPT

drop operator score FORCE;
drop operator contains FORCE;
drop package ctx_contains;
drop package driscore;


PROMPT Shift indextype implementation to dummy implementation type
PROMPT and Remove support for composite index  ...
PROMPT

alter indextype context using DummyIndexMethods without composite index;

PROMPT Create old 10.2.0 version of TextIndexMethods and TextOptStats ...
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

end;
/
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
show errors;

PROMPT Shift indextype implementation to TextIndexMethods ...
PROMPT

alter indextype context using TextIndexMethods;


REM 
REM recreate 10.2.0 version contains and score operators
REM following copied directly from dr0itype.sql
REM 

create or replace package ctx_contains authid current_user as
    function Textcontains(Colval in varchar2, 
                             Text in varchar2, ia sys.odciindexctx, 
                             sctx IN OUT TextIndexMethods,
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
/*
        env,
        env  INDICATOR STRUCT,
*/
        return OCINumber
      );
    function Textcontains(Colval in clob, 
                                Text in varchar2, ia sys.odciindexctx, 
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
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
/*
        env,
        env  INDICATOR STRUCT,
*/
        return OCINumber
      );
    function Textcontains(Colval in blob, 
                                Text in varchar2, ia sys.odciindexctx, 
                                sctx IN OUT TextIndexMethods,
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
/*
        env,
        env  INDICATOR STRUCT,
*/
        return OCINumber
      );
    function Textcontains(Colval in bfile, 
                                Text in varchar2, ia sys.odciindexctx, 
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
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
/*
        env,
        env  INDICATOR STRUCT,
*/
        return OCINumber
      );

    function Textcontains(Colval in sys.xmltype,
                                Text in varchar2, ia sys.odciindexctx, 
                                sctx IN OUT TextIndexMethods,
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
/*
        env,
        env  INDICATOR STRUCT,
*/
        return OCINumber
      );

    function Textcontains(Colval in sys.uritype,
                                Text in varchar2, ia sys.odciindexctx, 
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv*/)
      return number is language C
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
/*
        env,
        env  INDICATOR STRUCT,
*/
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
  (clob, varchar2) return number 
     with index context, scan context TextIndexMethods 
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (blob, varchar2) return number 
     with index context, scan context TextIndexMethods 
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (bfile, varchar2) return number 
     with index context, scan context TextIndexMethods 
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (sys.xmltype, varchar2) return number 
     with index context, scan context TextIndexMethods 
     compute ancillary data without column data using ctx_contains.Textcontains
,
  (sys.uritype, varchar2) return number 
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
/*
        env,
        env  INDICATOR STRUCT,
*/
        return OCINumber
      );
    function TextScore(Colval in clob, 
                                Text in varchar2, ia sys.odciindexctx, 
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
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
/*
        env,
        env  INDICATOR STRUCT,
*/
        return OCINumber
      );
    function TextScore(Colval in blob, 
                                Text in varchar2, ia sys.odciindexctx, 
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
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
/*
        env,
        env  INDICATOR STRUCT,
*/
        return OCINumber
      );
    function TextScore(Colval in bfile, 
                                Text in varchar2, ia sys.odciindexctx, 
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
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
/*
        env,
        env  INDICATOR STRUCT,
*/
        return OCINumber
      );
    function TextScore(Colval in sys.xmltype, 
                                Text in varchar2, ia sys.odciindexctx, 
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
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
/*
        env,
        env  INDICATOR STRUCT,
*/
        return OCINumber
      );
    function TextScore(Colval in sys.uritype, 
                                Text in varchar2, ia sys.odciindexctx, 
                                sctx IN OUT TextIndexMethods,
                                cflg number /*, env sys.ODCIEnv */)
      return number is language C
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
/*
        env,
        env  INDICATOR STRUCT,
*/
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
                  contains(clob, varchar2), 
                  contains(blob, varchar2), 
                  contains(bfile, varchar2),
                  contains(sys.xmltype, varchar2),
                  contains(sys.uritype, varchar2)
     without column data using driscore.TextScore;

grant execute on score to public;

drop public synonym score;
create public synonym score for ctxsys.score;

PROMPT Rebind operators and remove the dummyop
PROMPT

alter indextype context add contains(varchar2, varchar2);
alter indextype context add contains(clob, varchar2);
alter indextype context add contains(blob, varchar2);
alter indextype context add contains(bfile, varchar2);
alter indextype context add contains(sys.xmltype, varchar2);
alter indextype context add contains(sys.uritype, varchar2);
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

PROMPT Create old 10.2.0 version of CatIndexMethods ...
PROMPT
REM    (this is copied directly from dr0typec.pkh)

create type CatIndexMethods authid current_user as object
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

PROMPT Shift indextype implementation to CatIndexMethods ...
PROMPT

alter indextype ctxat using CatIndexMethods;

REM 
REM recreate 10.2.0 version catsearch operators
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
  return number is language C
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
  Text    in     varchar2, 
  condcls in     varchar2,
  ia      in     sys.odciindexctx, 
  sctx    in out CatIndexMethods,
  cflg    in     number
)
  return number is language C
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
end ctx_catsearch;
/

REM 
REM == CREATE CATSEARCH PRIMARY OPERATOR ==
REM 

create  operator catsearch binding 
  (varchar2, varchar2, varchar2) return number 
     with index context, scan context CatIndexMethods 
     without column data using ctx_catsearch.catsearch,
  (clob, varchar2, varchar2) return number 
     with index context, scan context CatIndexMethods 
     without column data using ctx_catsearch.catsearch
;

grant execute on catsearch to public;

drop public synonym catsearch;
create public synonym catsearch for ctxsys.catsearch;

PROMPT Rebind operators and remove the dummyop
PROMPT

alter indextype ctxcat add catsearch(varchar2, varchar2, varchar2);
alter indextype ctxcat add catsearch(clob, varchar2, varchar2);
alter indextype ctxcat drop dummyop(varchar2, varchar2);

REM 
REM END DOWN-GRADING CTXCAT INDEXTYPE
REM 


REM 
REM BEGIN DOWN-GRADING CTXRULE INDEXTYPE
REM 

REM note: indextype not changed, only Implementation functions 
REM       for MATCHES() MATCHES_SCORE() operators are changed.

PROMPT Disable Parallel Implementation functions for MATCHES() operator
PROMPT

create or replace package ctx_matches authid current_user as
    
function  matches(
  Colval  in     varchar2, 
  Text    in     varchar2, 
  ia      in     sys.odciindexctx, 
  sctx    in out RuleIndexMethods,
  cflg    in     number
)
  return number is language C
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
  return number is language C
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
  return number is language C
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
  return number is language C
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
  return number is language C
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
  return number is language C
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

PROMPT Disable Parallel Implementation functions for MATCHES_SCORE() operator
PROMPT

create or replace package driscorr authid definer as
function  RuleScore(
  Colval  in     varchar2, 
  Text    in     varchar2, 
  ia      in     sys.odciindexctx, 
  sctx    in out RuleIndexMethods,
  cflg    in     number
)
  return number is language C
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
  return number is language C
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
  return number is language C
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
  return number is language C
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
  return number is language C
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
  return number is language C
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

REM 
REM END DOWN-GRADING CTXRULE INDEXTYPE
REM 

REM 
REM BEGIN DOWN-GRADING CTXXPATH INDEXTYPE
REM 

REM note: indextype not changed, only Implementation functions 
REM       for XPCONTAINS() operator are changed.

PROMPT Disable Parallel Implementation functions for XPCONTAINS() operator
PROMPT

create or replace package ctx_xpcontains authid current_user as
    
function xpcontains(
  Colval  in     sys.xmltype, 
  Text    in     varchar2, 
  ia      in     sys.odciindexctx, 
  sctx    in out XpathIndexMethods,
  cflg    in     number
)
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

end ctx_xpcontains;
/

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



REM ========================================================================
REM reversing u1002000.sql
REM ========================================================================

REM CDI
drop table dr$index_cdi_column;
drop view ctx_filter_by_columns;
drop view ctx_user_filter_by_columns;
drop public synonym ctx_user_filter_by_columns;
drop view ctx_order_by_columns;
drop view ctx_user_order_by_columns;
drop public synonym ctx_user_order_by_columns;


delete from dr$object_attribute where oat_id = 90109;
delete from dr$object_attribute 
where oat_id in (50108, 50208, 50308, 50508, 50608, 50708, 50808);
delete from dr$object_attribute 
where oat_id in (50109, 50209, 50309, 50509, 50609, 50709, 50809);
delete from dr$object_attribute 
where oat_id in (50210, 50310, 50510, 50610);
delete from dr$object_attribute 
where oat_id in (50211, 50311, 50511, 50611);
delete from dr$object_attribute 
where oat_id in (70110, 70111, 70112, 70113);
delete from dr$object_attribute
where oat_id between 61201 and 61299;
delete from dr$object_attribute
where oat_id between 1061200 and 2061253;

REM 5438110: Add filename_charset
delete from dr$object_attribute
where oat_id = 10302;

delete from dr$object_attribute_lov 
where oal_oat_id in (61202,61205,60120);

delete from dr$object where obj_cla_id = 6 and obj_id = 12;

commit;
alter table dr$section modify(sec_tag varchar2(64));
alter table dr$section drop column sec_datatype;


create or replace view ctx_sections as
select
   u.name            sec_owner,
   sgp_name          sec_section_group,
   decode(sec_type, 1, 'ZONE', 2, 'FIELD', 3, 'SPECIAL', 4, 'STOP', 
                    5, 'ATTR', 7, 'MDATA', null)
                     sec_type,
   sec_id            sec_id,
   decode(sec_type, 4, null, sec_name)
                     sec_name,
   sec_tag           sec_tag,
   sec_visible       sec_visible
from dr$section sec, dr$section_group sgp, sys."_BASE_USER" u
where sgp.sgp_id = sec.sec_sgp_id
  and sgp_owner# = u.user#
/

create or replace view ctx_user_sections as
select
   sgp_name          sec_section_group,
   decode(sec_type, 1, 'ZONE', 2, 'FIELD', 3, 'SPECIAL', 4, 'STOP', 
                    5, 'ATTR', 7, 'MDATA', null)
                     sec_type,
   sec_id            sec_id,
   decode(sec_type, 4, null, sec_name)
                     sec_name,
   sec_tag           sec_tag,
   sec_visible       sec_visible
from dr$section sec, dr$section_group sgp
where sgp.sgp_id = sec.sec_sgp_id
  and sgp_owner# = userenv('SCHEMAID')
/

REM CTX_INDEXES and CTX_USER_INDEXES have changed

create or replace view ctx_indexes as
select
  idx_id
 ,u.name                 idx_owner
 ,idx_name               idx_name
 ,u2.name                idx_table_owner
 ,o.name                 idx_table
 ,idx_key_name           idx_key_name
 ,idx_text_name          idx_text_name
 ,idx_docid_count        idx_docid_count
 ,idx_status             idx_status
 ,idx_language_column    idx_language_column
 ,idx_format_column      idx_format_column
 ,idx_charset_column     idx_charset_column
 ,decode(idx_type, 0, 'CONTEXT', 1, 'CTXCAT', 2, 'CTXRULE') idx_type
 ,idx_sync_type          idx_sync_type
 ,idx_sync_memory        idx_sync_memory
 ,idx_sync_para_degree   idx_sync_para_degree
 ,idx_sync_interval      idx_sync_interval
 ,idx_sync_jobname       idx_sync_jobname
 from dr$index, sys."_BASE_USER" u, sys.obj$ o, sys."_BASE_USER" u2
where idx_owner# = u.user#
  and idx_table_owner# = u2.user#
  and idx_table# = o.obj#
/

create or replace view ctx_user_indexes as
select
  idx_id
 ,idx_name               idx_name
 ,u.name                 idx_table_owner
 ,o.name                 idx_table
 ,idx_key_name           idx_key_name
 ,idx_text_name          idx_text_name
 ,idx_docid_count        idx_docid_count
 ,idx_status             idx_status
 ,idx_language_column    idx_language_column
 ,idx_format_column      idx_format_column
 ,idx_charset_column     idx_charset_column
 ,decode(idx_type, 0, 'CONTEXT', 1, 'CTXCAT', 2, 'CTXRULE') idx_type
 ,idx_sync_type          idx_sync_type
 ,idx_sync_memory        idx_sync_memory
 ,idx_sync_para_degree   idx_sync_para_degree
 ,idx_sync_interval      idx_sync_interval
 ,idx_sync_jobname       idx_sync_jobname
 from dr$index, sys."_BASE_USER" u, sys.obj$ o
where idx_owner# = userenv('SCHEMAID')
  and idx_table_owner# = u.user#
  and idx_table# = o.obj#
/

CREATE OR REPLACE VIEW ctx_pending AS
select /*+ ORDERED USE_NL(i p) */
       u.name      pnd_index_owner,
       idx_name    pnd_index_name,
       ixp_name    pnd_partition_name,
       pnd_rowid,
       pnd_timestamp
  from dr$pending, dr$index i, dr$index_partition p, sys."_BASE_USER" u
 where idx_owner# = u.user#
   and idx_id = ixp_idx_id
   and pnd_pid = ixp_id
   and pnd_pid != 0
   and pnd_cid = idx_id
UNION ALL
select /*+ ORDERED USE_NL(i) */
       u.name      pnd_index_owner,
       idx_name    pnd_index_name,
       null        pnd_partition_name,
       pnd_rowid,
       pnd_timestamp
  from dr$pending, dr$index i, sys."_BASE_USER" u
 where idx_owner# = u.user#
   and pnd_pid = 0
   and pnd_cid = idx_id
/

CREATE OR REPLACE VIEW ctx_user_pending AS
select /*+ ORDERED USE_NL(i p)*/
       idx_name  pnd_index_name,
       ixp_name  pnd_partition_name,
       pnd_rowid,
       pnd_timestamp
  from dr$pending, dr$index i, dr$index_partition p
 where idx_id = ixp_idx_id
   and pnd_pid = ixp_id
   and pnd_cid != 0
   and pnd_cid = idx_id
   and idx_owner# = userenv('SCHEMAID')
UNION ALL
select /*+ ORDERED USE_NL(i) */
       idx_name  pnd_index_name,
       null      pnd_partition_name,
       pnd_rowid,
       pnd_timestamp
  from dr$pending, dr$index i
 where pnd_pid = 0
   and pnd_cid = idx_id
   and idx_owner# = userenv('SCHEMAID')
/

drop table dr$sdata_update;
drop view drv$sdata_update;
drop view drv$sdata_update2;

-- undo fix for bug 5996259
revoke select on drv$unindexed2 from public;

create or replace procedure syncrn (
  ownid IN binary_integer,
  oname IN varchar2,
  idxid IN binary_integer,
  ixpid IN binary_integer,
  rtabnm IN varchar2
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
    rtabnm OCISTRING
);
/

create or replace public synonym context for ctxsys.context;
create or replace public synonym ctxcat for ctxsys.ctxcat;
create or replace public synonym ctxrule for ctxsys.ctxrule;
create or replace public synonym ctxxpath for ctxsys.ctxxpath;

-- drop the dictionary tables created for query stats
drop table dr$freqtoks;
drop table dr$slowqrys;
drop table dr$activelogs;

REM 
REM WILDCARD_MAXTERMS
REM 

update dr$object_attribute
  set oat_default = 5000
  where oat_id = 70106;
update dr$object_attribute
  set oat_val_max = 15000
  where oat_id = 70106;
commit;

REM 
REM dr$sqe - reverse clob support
REM 

alter table dr$sqe rename to dr$sqe_sav;

CREATE TABLE dr$sqe(
 sqe_owner#               NUMBER         NOT NULL,
 sqe_name                 VARCHAR2(30)   NOT NULL,
 sqe_query                VARCHAR2(2000) NOT NULL,
 PRIMARY KEY (sqe_owner#, sqe_name)
)
organization index overflow
/

insert into dr$sqe n select sqe_owner#, sqe_name, to_clob(sqe_query)
  from dr$sqe_sav o where dbms_lob.getlength(o.sqe_query) <= 2000;
commit;

drop table dr$sqe_sav purge;

create or replace view ctx_sqes as
select u.name     sqe_owner,
       sqe_name,
       sqe_query
  from dr$sqe sqe, sys."_BASE_USER" u
 where sqe_owner# = u.user# 
/

create or replace view ctx_user_sqes as
select u.name     sqe_owner,
       sqe_name,
       sqe_query
  from dr$sqe sqe, sys."_BASE_USER" u
 where sqe_owner# = u.user#
   and u.user# = userenv('SCHEMAID')
/

rem
rem NDATA
rem
BEGIN
  EXECUTE IMMEDIATE 'revoke select on dr$ths from public';
EXCEPTION
  WHEN OTHERS THEN
    IF ( SQLCODE = -1927 ) THEN NULL;
    ELSE RAISE;
    END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'revoke select on dr$ths_phrase from public';
EXCEPTION
  WHEN OTHERS THEN
    IF ( SQLCODE = -1927 ) THEN NULL;
    ELSE RAISE;
    END IF;
END;
/


REM ========================================================================
REM post-downgrade stuff
REM ========================================================================

REM create empty type bodies for the four index types
@@f1001002.sql

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

REM ================================================================== 
REM Reverse Entity Extraction Changes
REM ==================================================================

REM delete default extract lexer

begin
  delete from dr$preference where pre_id = 1024;
  delete from dr$preference_value where prv_pre_id = 1024;
  delete from dr$parameter where par_name='DEFAULT_EXTRACT_LEXER';
  commit;
end;
/

REM delete default extraction engines
begin
  delete from dr$preference where PRE_OBJ_ID=4 and PRE_CLA_ID=9;
  delete from dr$preference_value where PRV_OAT_ID=90401;
  delete from dr$preference_value where PRV_OAT_ID=90402;
  commit;
end;
/

REM delete default extraction dictionary policy object
declare
 l_owner# number;
 l_pol_id number;
begin
  select user# into l_owner# from sys."_BASE_USER" where name='CTXSYS';
  select idx_id into l_pol_id from dr$index where
    idx_name = 'ENT_EXT_DICT_OBJ' and
    idx_owner# = l_owner#;
  delete from dr$index_object where ixo_idx_id = l_pol_id;
  delete from dr$index_value where ixv_idx_id = l_pol_id;
  delete from dr$index where idx_id = l_pol_id;
  delete from dr$stats where idx_id = l_pol_id;
  delete from dr$index_error where err_idx_id = l_pol_id;
  commit;
exception
  when no_data_found then
    null;
  when others then
    raise;
end;
/

delete from dr$object_attribute
  where OAT_ID=90401 and OAT_CLA_ID=9 and OAT_OBJ_ID=4 and OAT_ATT_ID=1
    and OAT_NAME='INCLUDE_DICTIONARY';

delete from dr$object_attribute
  where OAT_ID=90401 and OAT_CLA_ID=9 and OAT_OBJ_ID=4 and OAT_ATT_ID=2
    and OAT_NAME='INCLUDE_RULES';


delete from dr$object
  where OBJ_CLA_ID=9 and OBJ_ID=4 and OBJ_NAME='ENTITY_STORAGE';

drop public synonym ctx_user_extract_rules;
drop public synonym ctx_user_extract_stop_entities;
drop public synonym ctx_user_extract_policies;
drop public synonym ctx_user_extract_policy_values;
drop view ctx_user_extract_rules;
drop view drv$user_extract_rule;
drop view ctx_user_extract_stop_entities;
drop view drv$user_extract_stop_entity;
drop view drv$user_extract_tkdict;
drop view drv$user_extract_entdict;
drop view ctx_extract_policies;
drop view ctx_extract_policy_values;
drop view ctx_user_extract_policies;
drop view ctx_user_extract_policy_values;
drop table dr$user_extract_rule;
drop table dr$user_extract_stop_entity;
drop table dr$user_extract_tkdict;
drop table dr$user_extract_entdict;


commit;
 

REM ==================================================================
REM Reverse Changes from stop_opt_list
REM ==================================================================

declare
 l_owner# number;
 l_pol_id number;
begin
  select user# into l_owner# from sys."_BASE_USER" where name='CTXSYS';
  select idx_id into l_pol_id from dr$index where
    idx_name = 'STOP_OPT_LIST' and
    idx_owner# = l_owner#;
  delete from dr$index_object where ixo_idx_id = l_pol_id;
  delete from dr$index_value where ixv_idx_id = l_pol_id;
  delete from dr$index where idx_id = l_pol_id;
  delete from dr$stats where idx_id = l_pol_id;
  delete from dr$index_error where err_idx_id = l_pol_id;
  commit;
exception
  when no_data_found then
    null;
  when others then
    raise;
end;
/


