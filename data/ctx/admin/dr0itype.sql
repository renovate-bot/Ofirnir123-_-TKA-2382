Rem
Rem $Header: ctx_src_2/src/dr/admin/dr0itype.sql /main/30 2018/07/17 09:35:02 snetrava Exp $
Rem
Rem dr0type.pkb
Rem
Rem Copyright (c) 1997, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      dr0itype.sql - create Index TYPE
Rem
Rem    DESCRIPTION
Rem      EIX framework interfaces body definitions
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/dr0itype.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/dr0itype.sql
Rem      SQL_PHASE: DR0ITYPE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxityp.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    snetrava    06/14/18 - Bug 28102835: NONE LOG PRAGMA
Rem    hxzhang     07/22/15 - New index type ConText_V2 with system partition
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    yiqi        04/27/12 - Bug 13806179
Rem    wclin       11/29/06 - support clob query string
Rem    wclin       02/20/06 - bug 5046136 parallel enable text operators 
Rem    wclin       02/02/06 - rm indextype public synonyms 
Rem    wclin       01/09/06 - context indextype CDI support 
Rem    gkaminag    10/27/05 - sdata update 
Rem    wclin       02/01/05 - remove grant exec to public for impl packages 
Rem    gkaminag    12/04/02 - invoker's rights
Rem    gkaminag    11/06/02 - make indextype creation dynamic for upg scripts
Rem    gkaminag    09/24/02 - security phase 3
Rem    ehuang      08/26/02 - move textoptstats body to itype
Rem    ehuang      07/31/02 - operators to itype
Rem    ehuang      07/09/02 - 
Rem    gkaminag    06/17/02 - 
Rem    gkaminag    06/14/02 - syncrn to invoker's rights
Rem    ehuang      09/29/01 - add uritype bindings.
Rem    wclin       03/09/01 - mv TextOptStats type body
Rem    gkaminag    09/19/00 - more xml support
Rem    gkaminag    08/14/00 - partition support
Rem    yucheng     07/25/00 - enable range partition
Rem    ehuang      06/20/00 - xmltype support
Rem    gkaminag    06/26/00 - latest 8.1.7 upgrade changes
Rem    salpha      03/09/00 - Add structured parameter to catsearch
Rem    gkaminag    02/22/00 - add ctxcat index
Rem    gkaminag    07/13/99 - new dr0itype.sql
Rem

@@?/rdbms/admin/sqlsessstart.sql

--------------------------------------------------------------
-- CREATE FUNCTIONAL IMPLEMENTATIONS for contains operator --
-------------------------------------------------------------
-- Since two functions cannot be overloaded if their formal 
-- parameters differ only in datatype and the different datatypes 
-- are the same family, there is only one function per datatype 
-- family. 
-- There are 4 datatype families here used by ConText, each is 
-- represented by 1 of its family members: 
--   Number family { number } is represented  by number. 
--   Character family {char, varchar2, varchar, long, long raw, 
--                     nchar, nvarchar2, raw, rowid} is represented 
--                    by varchar2.
--   Date/time family { date } is represented by date.
--   LOB family {BFILE, BLOB, CLOB, NCLOB} is represented by BLOB.
-- Where {} is a list of family members.
-- CTX 8.1 will no longer support date and number families.

create or replace package ctx_contains authid current_user as

    PRAGMA SUPPLEMENTAL_LOG_DATA(default, NONE);
    
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

    PRAGMA SUPPLEMENTAL_LOG_DATA(default, NONE);

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

declare
  x number;
begin
  select count(*) into x from dba_indextypes
  where owner = 'CTXSYS' and indextype_name = 'CONTEXT';
  if (x = 0) then
    execute immediate
'create indextype ConText                           '||
'for contains(varchar2, varchar2),                  '||
'    contains(varchar2, clob),                      '||
'    contains(clob, varchar2),                      '||
'    contains(clob, clob),                          '||
'    contains(blob, varchar2),                      '||
'    contains(blob, clob),                          '||
'    contains(bfile, varchar2),                     '||
'    contains(bfile, clob),                         '||
'    contains(sys.xmltype, varchar2),               '||
'    contains(sys.xmltype, clob),                   '||
'    contains(sys.uritype, varchar2),               '||
'    contains(sys.uritype, clob)                    '||
'using TextIndexMethods without column data         '||
'                       with array dml              '||
'                       with order by score(number) '||
'                       with rebuild online         '||
'                       with local range partition  '||
'                       with composite index   ';
  end if;
end;
/

--version2 of context index type with system managed partition
declare
  x number;
begin
  select count(*) into x from dba_indextypes
  where owner = 'CTXSYS' and indextype_name = 'CONTEXT_V2';
  if (x = 0) then
    execute immediate
'create indextype ConText_V2                        '||
'for contains(varchar2, varchar2),                  '||
'    contains(varchar2, clob),                      '||
'    contains(clob, varchar2),                      '||
'    contains(clob, clob),                          '||
'    contains(blob, varchar2),                      '||
'    contains(blob, clob),                          '||
'    contains(bfile, varchar2),                     '||
'    contains(bfile, clob),                         '||
'    contains(sys.xmltype, varchar2),               '||
'    contains(sys.xmltype, clob),                   '||
'    contains(sys.uritype, varchar2),               '||
'    contains(sys.uritype, clob)                    '||
'using TextIndexMethods without column data         '||
'                       with array dml              '||
'                       with order by score(number) '||
'                       with rebuild online         '||
'                       with local partition        '||
'                with system managed storage tables '|| 
'                       with composite index   ';
  end if;
end;
/

grant execute on ConText to public;

grant execute on ConText_V2 to public;


ASSOCIATE STATISTICS WITH INDEXTYPES ConText USING TextOptStats;

ASSOCIATE STATISTICS WITH INDEXTYPES ConText_V2 USING TextOptStats WITH SYSTEM MANAGED STORAGE TABLES;

ASSOCIATE STATISTICS WITH PACKAGES ctx_contains USING TextOptStats;

create or replace procedure syncrn (
  ownid IN binary_integer,
  oname IN varchar2,
  idxid IN binary_integer,
  ixpid IN binary_integer,
  rtabnm IN varchar2,
  srcflg IN binary_integer,
  smallr IN binary_integer       
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
    srcflg ub1,
    smallr ub1
);
/

@?/rdbms/admin/sqlsessend.sql
