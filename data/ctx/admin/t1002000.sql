Rem
Rem $Header: ctx_src_2/src/dr/admin/t1002000.sql /main/9 2018/07/25 13:49:09 surman Exp $
Rem
Rem t1002000.sql
Rem
Rem Copyright (c) 2005, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      t1002000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      This script upgrades the indextypes from 10.2.0 to latest
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/t1002000.sql
Rem      SQL_SHIPPED_FILE: ctx/admin/t1002000.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    wclin       03/28/07 - bug 5958187: remove ampersand
Rem    wclin       12/11/06 - clob query support
Rem    wclin       02/20/06 - bug 5046136 parallel enable text operators 
Rem    wclin       01/09/06 - take out CDI hack 
Rem    gkaminag    10/28/05 - new cdi method 
Rem    gkaminag    02/21/05 - gkaminag_test_050217
Rem    gkaminag    02/17/05 - Created
Rem

REM
REM  IF YOU ADD ANYTHING TO THIS FILE REMEMBER TO CHANGE DOWNGRADE SCRIPT
REM

PROMPT DisAssociate Statistics
PROMPT

DISASSOCIATE STATISTICS FROM INDEXTYPES CONTEXT FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_CONTAINS FORCE;

DISASSOCIATE STATISTICS FROM INDEXTYPES CTXXPATH FORCE;
DISASSOCIATE STATISTICS FROM PACKAGES CTX_XPCONTAINS FORCE;

PROMPT ==============  ConText 10.2 to 11 Type Upgrade  =====================
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


PROMPT Drop SCORE and CONTAINS operators ...
PROMPT

drop operator score FORCE;
drop operator contains FORCE;
drop package ctx_contains;
drop package driscore;

PROMPT Shift indextype implementation to dummy implementation type ...
PROMPT
alter indextype context using DummyIndexMethods;

PROMPT Create new version of TextIndexMethods and TextOptStats...
PROMPT
drop type TextIndexMethods;
drop type TextOptStats;
@@dr0type.pkh

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


PROMPT Shift indextype implementation to TextIndexMethods and add
PROMPT    support for composite index.
PROMPT

alter indextype context using TextIndexMethods with composite index;

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

-- Added for bug 2695369
alter indextype context using textindexmethods
  with order by score(number);

PROMPT ==============  CTXCAT 10.2 to 11 Type Upgrade   =====================
PROMPT

PROMPT Revalidate indextype and operator
PROMPT

alter type CatIndexMethods compile specification reuse settings;
alter operator catsearch compile;
alter indextype ctxcat compile;

PROMPT Remove existing indextype operator bindings ...
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

PROMPT Create new 11g version of CatIndexMethods ...
PROMPT
drop type CatIndexMethods;
@@dr0typec.pkh

REM create a dummy type body. We cannot run dr0typec.plb here because the
REM packages may not be instantiated.  (Packages cannot be instantiated
REM before this, because they depend on type .pkhs)

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

select text from dba_errors
 where owner = 'CTXSYS' and name = 'CATINDEXMETHODS';

PROMPT Shift indextype implementation to CatIndexMethods ...
PROMPT

alter indextype ctxcat using CatIndexMethods;

PROMPT Run itypc to re-create catsearch, bind operators etc.
PROMPT

@@dr0itypc.sql

PROMPT Rebind operators and remove the dummyop
PROMPT
alter indextype ctxcat add catsearch(varchar2, varchar2, varchar2);
alter indextype ctxcat add catsearch(varchar2, clob, varchar2);
alter indextype ctxcat add catsearch(clob, varchar2, varchar2);
alter indextype ctxcat add catsearch(clob, clob, varchar2);
alter indextype ctxcat drop dummyop(varchar2, varchar2);



PROMPT ==============  CTXRULE 10.2 to 11 Type Upgrade  =====================
PROMPT

PROMPT Parallel Enable Implementation functions for MATCHES_SCORE() operator
PROMPT

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



PROMPT ==============  CTXXPATH 10.2 to 11 Type Upgrade =====================
PROMPT

PROMPT Parallel Enable Implementation functions for XPCONTAINS() operator
PROMPT

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

REM Need to DisAssociate Statistics (since dr0itypx.sql was not run)
ASSOCIATE STATISTICS WITH INDEXTYPES ctxxpath USING TextOptStats;
ASSOCIATE STATISTICS WITH PACKAGES ctx_xpcontains USING TextOptStats;



