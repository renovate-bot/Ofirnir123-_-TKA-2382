Rem
Rem t0902000.sql
Rem
Rem Copyright (c) 2002, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      t0902000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      This script upgrades the indextypes from 9.2.0 to 10
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/t0902000.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/t0902000.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/10/18 - 27464252: Component specific patch phases
Rem    gkaminag    10/28/05 - create dummy .pkh directly instead of dr0type.pkh
Rem    surman      08/11/03 - 2695369: Add ALTER INDEXTYPE 
Rem    daliao      02/28/03 - ctxrule changes
Rem    gkaminag    02/24/03 - 
Rem    wclin       01/28/03 - recompile TextOptStats
Rem    gkaminag    01/24/03 - 
Rem    gkaminag    11/26/02 - fix prompts
Rem    gkaminag    11/06/02 - workaround pre-compile indextype
Rem    gkaminag    10/28/02 - security upgrade
Rem    ehuang      09/27/02 - new alter statements
Rem    ehuang      08/01/02 - Created
Rem


REM
REM  IF YOU ADD ANYTHING TO THIS FILE REMEMBER TO CHANGE DOWNGRADE SCRIPT
REM


PROMPT ==============  ConText 9.2 to 10 Type Upgrade  =====================
PROMPT

PROMPT Revalidate TextOptStats type
PROMPT

alter type TextOptStats compile specification reuse settings;

PROMPT Revalidate indextype and operator
PROMPT

alter type textindexmethods compile specification reuse settings;
alter operator contains compile;
alter indextype context compile;

PROMPT Remove existing indextype operator bindings ...
PROMPT

alter indextype context add dummyop(varchar2, varchar2);
alter indextype context drop contains(varchar2, varchar2);
alter indextype context drop contains(clob, varchar2);
alter indextype context drop contains(blob, varchar2);
alter indextype context drop contains(bfile, varchar2);
alter indextype context drop contains(sys.xmltype, varchar2);
alter indextype context drop contains(sys.uritype, varchar2);

PROMPT DisAssociate Statistics
PROMPT

DISASSOCIATE STATISTICS FROM INDEXTYPES CONTEXT FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_CONTAINS FORCE;

PROMPT Drop SCORE and CONTAINS operators ...
PROMPT

drop operator score FORCE;
drop operator contains FORCE;
drop package ctx_contains;

PROMPT Shift indextype implementation to dummy implementation type ...
PROMPT

alter indextype context using DummyIndexMethods;

PROMPT Create new 10.0 version of TextIndexMethods ...
PROMPT

drop type TextIndexMethods;
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

REM create a dummy type body.  We can't run dr0type.plb here because the
REM packages may not be instantiated.  (Packages cannot be instantiated
REM before this, because they depend on type .pkh's)

create or replace type body TextIndexMethods is
static function ODCIGetInterfaces(ifclist out    sys.ODCIObjectList) 
return number is begin
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2')); 
  return sys.ODCIConst.Success; 
end ODCIGetInterfaces; 
static function ODCIIndexCreate(ia in sys.odciindexinfo, parms in varchar2,
env in sys.ODCIEnv) return number 
is begin return sys.ODCIConst.Success; end ODCIIndexCreate;
static function ODCIIndexAlter(ia in sys.odciindexinfo, parms in out varchar2,
altopt in number, env in sys.ODCIEnv) return number 
is begin  return sys.ODCIConst.Success; end ODCIIndexAlter;
static function ODCIIndexTruncate(ia in sys.odciindexinfo, env in sys.ODCIEnv
) return number is begin  return sys.odciconst.success; end ODCIIndexTruncate;
static function ODCIIndexDrop(ia in sys.odciindexinfo, env in sys.ODCIEnv
) return number is begin  return sys.odciconst.success; end ODCIIndexDrop;
static function ODCIIndexInsert(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.odcienv) return number
is begin  return sys.odciconst.success; end ODCIIndexInsert;
static function ODCIIndexDelete(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexDelete;
static function ODCIIndexUpdate(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexUpdate;
static function ODCIIndexGetMetaData(ia in sys.odciindexinfo, 
version in varchar2, new_block out PLS_INTEGER, env in sys.ODCIEnv
) return varchar2 is begin  return null; end ODCIIndexGetMetaData;
static function ODCIIndexUtilGetTableNames(ia IN sys.odciindexinfo,
read_only IN PLS_INTEGER, version IN varchar2, context OUT PLS_INTEGER)
return boolean is begin  return null;  end ODCIIndexUtilGetTableNames;
static procedure ODCIIndexUtilCleanup(context IN PLS_INTEGER)
is begin  null; end ODCIIndexUtilCleanup;
static function ODCIIndexSplitPartition(ia IN SYS.ODCIIndexInfo, 
part_name1 IN SYS.ODCIPartInfo, part_name2 IN SYS.ODCIPartInfo,
parms IN varchar2, env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexSplitPartition;
static function ODCIIndexMergePartition(ia IN SYS.ODCIIndexInfo,
part_name1 IN SYS.ODCIPartInfo, part_name2 IN SYS.ODCIPartInfo,
parms IN varchar2, env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexMergePartition;
static function ODCIIndexExchangePartition(ia IN SYS.ODCIIndexInfo,
ia1 IN SYS.ODCIIndexInfo,env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexExchangePartition;
end;
/
select text from dba_errors 
 where owner = 'CTXSYS' and name = 'TEXTINDEXMETHODS';

PROMPT Shift indextype implementation to TextIndexMethods ...
PROMPT

alter indextype context using TextIndexMethods;

PROMPT Run itype to re-create contains, bind operators etc.

@@dr0itype.sql

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

PROMPT ========================================================================
PROMPT CTXCAT 9.2 to 10.0 Type Upgrade
PROMPT ========================================================================

PROMPT Revalidate indextype and operator
PROMPT

alter type catindexmethods compile specification reuse settings;
alter operator catsearch compile;
alter indextype ctxcat compile;

PROMPT Remove existing ctxcat operator bindings ...
PROMPT

alter indextype ctxcat add dummyop(varchar2, varchar2);
alter indextype ctxcat drop catsearch(varchar2, varchar2, varchar2);
alter indextype ctxcat drop catsearch(clob, varchar2, varchar2);

PROMPT Drop CATSEARCH operators ...
PROMPT

drop operator catsearch FORCE;
drop package ctx_catsearch;

PROMPT Shift indextype implementation to dummy implementation type ...
PROMPT

alter indextype ctxcat using DummyIndexMethods;

PROMPT Create new 10.0 version of CatIndexMethods ...
PROMPT

drop type CatIndexMethods;
@@dr0typec.pkh

REM create a dummy type body.  We can't run dr0typec.plb here because the
REM packages may not be instantiated.  (Packages cannot be instantiated
REM before this, because they depend on type .pkh's)

create or replace type body CatIndexMethods is
static function ODCIGetInterfaces(ifclist out    sys.ODCIObjectList) 
return number is begin
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2')); 
  return sys.ODCIConst.Success; 
end ODCIGetInterfaces; 
static function ODCIIndexCreate(ia in sys.odciindexinfo, parms in varchar2,
env in sys.ODCIEnv) return number 
is begin return sys.ODCIConst.Success; end ODCIIndexCreate;
static function ODCIIndexAlter(ia in sys.odciindexinfo, parms in out varchar2,
altopt in number, env in sys.ODCIEnv) return number 
is begin  return sys.ODCIConst.Success; end ODCIIndexAlter;
static function ODCIIndexTruncate(ia in sys.odciindexinfo, env in sys.ODCIEnv
) return number is begin  return sys.odciconst.success; end ODCIIndexTruncate;
static function ODCIIndexDrop(ia in sys.odciindexinfo, env in sys.ODCIEnv
) return number is begin  return sys.odciconst.success; end ODCIIndexDrop;
static function ODCIIndexInsert(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.odcienv) return number
is begin  return sys.odciconst.success; end ODCIIndexInsert;
static function ODCIIndexDelete(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexDelete;
static function ODCIIndexUpdate(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexUpdate;
static function ODCIIndexGetMetaData(ia in sys.odciindexinfo, 
version in varchar2, new_block out PLS_INTEGER, env in sys.ODCIEnv
) return varchar2 is begin  return null; end ODCIIndexGetMetaData;
static function ODCIIndexUtilGetTableNames(ia IN sys.odciindexinfo,
read_only IN PLS_INTEGER, version IN varchar2, context OUT PLS_INTEGER)
return boolean is begin  return null;  end ODCIIndexUtilGetTableNames;
static procedure ODCIIndexUtilCleanup(context IN PLS_INTEGER)
is begin  null; end ODCIIndexUtilCleanup;
static function ODCIIndexSplitPartition(ia IN SYS.ODCIIndexInfo, 
part_name1 IN SYS.ODCIPartInfo, part_name2 IN SYS.ODCIPartInfo,
parms IN varchar2, env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexSplitPartition;
static function ODCIIndexMergePartition(ia IN SYS.ODCIIndexInfo,
part_name1 IN SYS.ODCIPartInfo, part_name2 IN SYS.ODCIPartInfo,
parms IN varchar2, env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexMergePartition;
static function ODCIIndexExchangePartition(ia IN SYS.ODCIIndexInfo,
ia1 IN SYS.ODCIIndexInfo,env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexExchangePartition;
end;
/
select text from dba_errors 
 where owner = 'CTXSYS' and name = 'CATINDEXMETHODS';

PROMPT Shift indextype implementation to CatIndexMethods ...
PROMPT

alter indextype ctxcat using CatIndexMethods;

PROMPT Re-bind operators to indextype  ...
PROMPT

@@dr0itypc.sql

alter indextype ctxcat add catsearch(varchar2, varchar2, varchar2);
alter indextype ctxcat add catsearch(clob, varchar2, varchar2);
alter indextype ctxcat drop dummyop(varchar2, varchar2);

alter package ctx_catsearch compile;
alter operator catsearch compile;
alter indextype ctxcat compile;

PROMPT ========================================================================
PROMPT CTXRULE 9.2 to 10.0 Type Upgrade
PROMPT ========================================================================

alter type ruleindexmethods compile specification reuse settings;
alter operator matches compile;
alter indextype ctxrule compile;

PROMPT Remove existing ctxrule operator bindings ...
PROMPT

alter indextype ctxrule add dummyop(varchar2, varchar2);
alter indextype ctxrule drop matches(varchar2, varchar2);
alter indextype ctxrule drop matches(clob, varchar2);
alter indextype ctxrule drop matches(varchar2, clob);
alter indextype ctxrule drop matches(clob, clob);

PROMPT Drop MATCHES operators ...
PROMPT

rem drop match_score operator if it exists (it can exist during multi-
rem version upgrade because 8.1.7 -> 9.0.1 will run the 10i dr0itypr.sql
rem script)

begin
execute immediate 'drop operator match_score force';
exception when others then
if (sqlcode != -29807) then raise_application_error(-20000, sqlerrm); end if;
end;
/

drop operator matches FORCE;
drop package ctx_matches;

PROMPT Shift indextype implementation to dummy implementation type ...
PROMPT

alter indextype ctxrule using DummyIndexMethods;

PROMPT Create new 10.0 version of RuleIndexMethods ...
PROMPT

drop type RuleIndexMethods;
@@dr0typer.pkh

REM create a dummy type body.  We can't run dr0typer.plb here because the
REM packages may not be instantiated.  (Packages cannot be instantiated
REM before this, because they depend on type .pkh's)

create or replace type body RuleIndexMethods is
static function ODCIGetInterfaces(ifclist out    sys.ODCIObjectList) 
return number is begin
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2')); 
  return sys.ODCIConst.Success; 
end ODCIGetInterfaces; 
static function ODCIIndexCreate(ia in sys.odciindexinfo, parms in varchar2,
env in sys.ODCIEnv) return number 
is begin return sys.ODCIConst.Success; end ODCIIndexCreate;
static function ODCIIndexAlter(ia in sys.odciindexinfo, parms in out varchar2,
altopt in number, env in sys.ODCIEnv) return number 
is begin  return sys.ODCIConst.Success; end ODCIIndexAlter;
static function ODCIIndexTruncate(ia in sys.odciindexinfo, env in sys.ODCIEnv
) return number is begin  return sys.odciconst.success; end ODCIIndexTruncate;
static function ODCIIndexDrop(ia in sys.odciindexinfo, env in sys.ODCIEnv
) return number is begin  return sys.odciconst.success; end ODCIIndexDrop;
static function ODCIIndexInsert(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.odcienv) return number
is begin  return sys.odciconst.success; end ODCIIndexInsert;
static function ODCIIndexDelete(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexDelete;
static function ODCIIndexUpdate(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexUpdate;
static function ODCIIndexGetMetaData(ia in sys.odciindexinfo, 
version in varchar2, new_block out PLS_INTEGER, env in sys.ODCIEnv
) return varchar2 is begin  return null; end ODCIIndexGetMetaData;
static function ODCIIndexUtilGetTableNames(ia IN sys.odciindexinfo,
read_only IN PLS_INTEGER, version IN varchar2, context OUT PLS_INTEGER)
return boolean is begin  return null;  end ODCIIndexUtilGetTableNames;
static procedure ODCIIndexUtilCleanup(context IN PLS_INTEGER)
is begin  null; end ODCIIndexUtilCleanup;
static function ODCIIndexSplitPartition(ia IN SYS.ODCIIndexInfo, 
part_name1 IN SYS.ODCIPartInfo, part_name2 IN SYS.ODCIPartInfo,
parms IN varchar2, env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexSplitPartition;
static function ODCIIndexMergePartition(ia IN SYS.ODCIIndexInfo,
part_name1 IN SYS.ODCIPartInfo, part_name2 IN SYS.ODCIPartInfo,
parms IN varchar2, env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexMergePartition;
static function ODCIIndexExchangePartition(ia IN SYS.ODCIIndexInfo,
ia1 IN SYS.ODCIIndexInfo,env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexExchangePartition;
end;
/
select text from dba_errors 
 where owner = 'CTXSYS' and name = 'RULEINDEXMETHODS';

PROMPT Shift indextype implementation to RuleIndexMethods ...
PROMPT

alter indextype ctxrule using RuleIndexMethods;

PROMPT Re-bind operators to indextype  ...
PROMPT

@@dr0itypr.sql

alter indextype ctxrule add matches(varchar2, varchar2);
alter indextype ctxrule add matches(clob, varchar2);
alter indextype ctxrule add matches(blob, varchar2);
alter indextype ctxrule add matches(varchar2, clob);
alter indextype ctxrule add matches(clob, clob);
alter indextype ctxrule add matches(blob, clob);
alter indextype ctxrule drop dummyop(varchar2, varchar2);
alter indextype ctxrule using RuleIndexMethods with order by match_score(number);

alter package ctx_matches compile;
alter operator matches compile;
alter indextype ctxrule compile;

PROMPT ========================================================================
PROMPT CTXXPATH 9.2 to 10.0 Type Upgrade
PROMPT ========================================================================

alter type xpathindexmethods compile specification reuse settings;
alter operator xpcontains compile;
alter indextype ctxxpath compile;

PROMPT Remove existing ctxxpath operator bindings ...
PROMPT

alter indextype ctxxpath add dummyop(varchar2, varchar2);
alter indextype ctxxpath drop xpcontains(sys.xmltype, varchar2);

PROMPT Drop CATSEARCH operators ...
PROMPT

drop operator xpcontains FORCE;
drop package ctx_xpcontains;

PROMPT Shift indextype implementation to dummy implementation type ...
PROMPT

alter indextype ctxxpath using DummyIndexMethods;

PROMPT Create new 10.0 version of XpathIndexMethods ...
PROMPT

drop type XpathIndexMethods;
@@dr0typex.pkh

REM create a dummy type body.  We can't run dr0typer.plb here because the
REM packages may not be instantiated.  (Packages cannot be instantiated
REM before this, because they depend on type .pkh's)

create or replace type body XpathIndexMethods is
static function ODCIGetInterfaces(ifclist out    sys.ODCIObjectList) 
return number is begin
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2')); 
  return sys.ODCIConst.Success; 
end ODCIGetInterfaces; 
static function ODCIIndexCreate(ia in sys.odciindexinfo, parms in varchar2,
env in sys.ODCIEnv) return number 
is begin return sys.ODCIConst.Success; end ODCIIndexCreate;
static function ODCIIndexAlter(ia in sys.odciindexinfo, parms in out varchar2,
altopt in number, env in sys.ODCIEnv) return number 
is begin  return sys.ODCIConst.Success; end ODCIIndexAlter;
static function ODCIIndexTruncate(ia in sys.odciindexinfo, env in sys.ODCIEnv
) return number is begin  return sys.odciconst.success; end ODCIIndexTruncate;
static function ODCIIndexDrop(ia in sys.odciindexinfo, env in sys.ODCIEnv
) return number is begin  return sys.odciconst.success; end ODCIIndexDrop;
static function ODCIIndexInsert(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.odcienv) return number
is begin  return sys.odciconst.success; end ODCIIndexInsert;
static function ODCIIndexDelete(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexDelete;
static function ODCIIndexUpdate(ia sys.odciindexinfo, ridlist sys.odciridlist, 
env sys.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexUpdate;
static function ODCIIndexGetMetaData(ia in sys.odciindexinfo, 
version in varchar2, new_block out PLS_INTEGER, env in sys.ODCIEnv
) return varchar2 is begin  return null; end ODCIIndexGetMetaData;
static function ODCIIndexUtilGetTableNames(ia IN sys.odciindexinfo,
read_only IN PLS_INTEGER, version IN varchar2, context OUT PLS_INTEGER)
return boolean is begin  return null;  end ODCIIndexUtilGetTableNames;
static procedure ODCIIndexUtilCleanup(context IN PLS_INTEGER)
is begin  null; end ODCIIndexUtilCleanup;
static function ODCIIndexSplitPartition(ia IN SYS.ODCIIndexInfo, 
part_name1 IN SYS.ODCIPartInfo, part_name2 IN SYS.ODCIPartInfo,
parms IN varchar2, env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexSplitPartition;
static function ODCIIndexMergePartition(ia IN SYS.ODCIIndexInfo,
part_name1 IN SYS.ODCIPartInfo, part_name2 IN SYS.ODCIPartInfo,
parms IN varchar2, env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexMergePartition;
static function ODCIIndexExchangePartition(ia IN SYS.ODCIIndexInfo,
ia1 IN SYS.ODCIIndexInfo,env IN SYS.ODCIEnv) return number
is begin  return sys.odciconst.success; end ODCIIndexExchangePartition;
end;
/
select text from dba_errors 
 where owner = 'CTXSYS' and name = 'XPATHINDEXMETHODS';

PROMPT Shift indextype implementation to XpathIndexMethods ...
PROMPT

alter indextype ctxxpath using XpathIndexMethods;

PROMPT Re-bind operators to indextype  ...
PROMPT

@@dr0itypx.sql

alter indextype ctxxpath add xpcontains(sys.xmltype, varchar2);
alter indextype ctxxpath drop dummyop(varchar2, varchar2);

alter package ctx_xpcontains compile;
alter operator xpcontains compile;
alter indextype ctxxpath compile;


REM ======================================================================

REM now we are at current version

