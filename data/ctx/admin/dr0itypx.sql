Rem
Rem $Header: ctx_src_2/src/dr/admin/dr0itypx.sql /main/13 2018/07/17 09:35:02 snetrava Exp $
Rem
Rem dr0itypx.sql
Rem
Rem Copyright (c) 2001, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      dr0itypx.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/dr0itypx.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/dr0itypx.sql
Rem      SQL_PHASE: DR0ITYPX
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxityp.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    snetrava    06/14/18 - Bug 28102835: NONE LOG PRAGMA
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    wclin       02/20/06 - bug 5046136 parallel enable text operators 
Rem    wclin       02/02/06 - rm indextype public synonyms 
Rem    wclin       02/01/05 - remove grant exec to public for impl packages 
Rem    gkaminag    12/04/02 - security
Rem    gkaminag    11/06/02 - make indextype creation dynamic for upgrade
Rem    ehuang      07/31/02 - operators to itype
Rem    ehuang      07/09/02 - 
Rem    wclin       11/12/01 - associate statistics
Rem    wclin       09/25/01 - ctxxpath
Rem    wclin       09/25/01 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

--------------------------------------------------------------
-- CREATE FUNCTIONAL IMPLEMENTATIONS for matches operator --
-------------------------------------------------------------

create or replace package ctx_xpcontains authid current_user as

PRAGMA SUPPLEMENTAL_LOG_DATA(default, NONE);
    
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

grant execute on xpcontains to public;


declare
  x number;
begin
  select count(*) into x from dba_indextypes
  where owner = 'CTXSYS' and indextype_name = 'CTXXPATH';
  if (x = 0) then
    execute immediate
'create indextype ctxxpath             '||
'for xpcontains(sys.xmltype, varchar2) '||
'using XPathIndexMethods               '||
' without column data                  '||
' with array dml                       '||
' with rebuild online                  ';
  end if;
end;
/

grant execute on ctxxpath to public;

ASSOCIATE STATISTICS WITH INDEXTYPES ctxxpath USING TextOptStats;

ASSOCIATE STATISTICS WITH PACKAGES ctx_xpcontains USING TextOptStats;


@?/rdbms/admin/sqlsessend.sql
