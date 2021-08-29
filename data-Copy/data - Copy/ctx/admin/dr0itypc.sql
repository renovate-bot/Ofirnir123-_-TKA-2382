Rem
Rem dr0itypc.sql
Rem
Rem Copyright (c) 2000, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      dr0itypc.sql - create Index TYPe Ctxcat
Rem
Rem    DESCRIPTION
Rem      EIX framework interfaces body definitions
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/dr0itypc.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/dr0itypc.sql
Rem      SQL_PHASE: DR0ITYPC
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxityp.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    snetrava   06/14/18  - Bug 28102835: NONE LOG PRAGMA
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    wclin       12/11/06 - clob query support
Rem    wclin       02/20/06 - bug 5046136 parallel enable text operators 
Rem    wclin       02/02/06 - rm indextype public synonyms 
Rem    wclin       02/01/05 - remove grant exec to public for impl packages 
Rem    gkaminag    12/04/02 - security
Rem    gkaminag    11/06/02 - make indextype creation dynamic for upgrade
Rem    ehuang      07/31/02 - operators to itype
Rem    ehuang      07/09/02 - 
Rem    gkaminag    06/26/00 - creation
Rem

@@?/rdbms/admin/sqlsessstart.sql


--------------------------------------------------------------
-- CREATE FUNCTIONAL IMPLEMENTATIONS for ctxcat operator --
-------------------------------------------------------------

create or replace package ctx_catsearch authid current_user as
   
PRAGMA SUPPLEMENTAL_LOG_DATA(default, NONE);
 
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


declare
  x number;
begin
  select count(*) into x from dba_indextypes
  where owner = 'CTXSYS' and indextype_name = 'CTXCAT';
  if (x = 0) then
    execute immediate
'create indextype ctxcat                       '||
'for catsearch(varchar2, varchar2, varchar2),  '||
'    catsearch(varchar2, clob, varchar2),      '||
'    catsearch(clob, varchar2, varchar2),      '||
'    catsearch(clob, clob, varchar2)           '||
'using CatIndexMethods                         '||
' without column data                          '||
' with array dml                               '||
' with rebuild online                          ';
  end if;
end;
/

grant execute on ctxcat to public;



@?/rdbms/admin/sqlsessend.sql
