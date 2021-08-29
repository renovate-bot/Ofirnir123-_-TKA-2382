Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxval.sql /main/8 2017/02/06 21:05:03 stanaya Exp $
Rem
Rem ctxval.sql
Rem
Rem Copyright (c) 2004, 2017, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxval.sql - create validation procedure
Rem
Rem    DESCRIPTION
Rem      create the ctx validation procedure
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxval.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxval.sql
Rem      SQL_PHASE: CTXVAL
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/catctx.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    boxia       01/15/16 - Bug 22226636: replace user$ with _BASE_USER
Rem    shuroy      05/27/15 - Bug 20468735
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    ssethuma    06/14/13 - Bug 16936854
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    surman      12/18/08 - 7426207: Add dbms_assert calls
Rem    gkaminag    10/11/04 - gkaminag_bug-3936626
Rem    gkaminag    10/07/04 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

ALTER SESSION SET CURRENT_SCHEMA = SYS;

create or replace procedure validate_context
is
  l_type#       binary_integer;
  l_owner#      binary_integer;
  l_ltype       varchar2(30) := 'FIRST';
  l_status      binary_integer;
  l_compile_sql varchar2(2000);
  l_dbo_name    varchar2(130);
  l_errcnt      number := 0;
  l_upg_mode    boolean := FALSE;
begin

  select user# into l_owner# from sys."_BASE_USER" where name = 'CTXSYS';
  for c1 in (select dbo_name, dbo_type
               from ctxsys.dr$dbo
              where dbo_type != 'PUBLIC SYNONYM'
              order by dbo_type, dbo_name)
  loop
    if (c1.dbo_type != l_ltype) then
      select decode(c1.dbo_type, 'INDEX',         1,
                                 'TABLE',         2,
                                 'VIEW',          4,
                                 'SEQUENCE',      6,
                                 'PROCEDURE',     7,
                                 'FUNCTION',      8,
                                 'PACKAGE',       9,
                                 'PACKAGE BODY', 11,
                                 'TYPE',         13,
                                 'TYPE BODY',    14,
                                 'LIBRARY',      22,
                                 'INDEXTYPE',    32,
                                 'OPERATOR',     33,
                                 0) 
        into l_type#
        from dual;
      l_ltype := c1.dbo_type;
    end if;

    l_status := -1;
    for c2 in (select status from sys.obj$
                where owner# = l_owner#
                  and name = c1.dbo_name
                  and type# = l_type#)
    loop
      l_status := c2.status;
    end loop;
   
    if (l_status != 1) then
      -- 3591109: Attempt to recompile invalid objects before issuing the
      -- failure notice
      l_dbo_name := dbms_assert.enquote_name(c1.dbo_name);
      l_compile_sql :=
        case c1.dbo_type
          when 'VIEW' then 
            'alter view ctxsys.' || l_dbo_name || ' compile'
          when 'PROCEDURE' then
            'alter procedure ctxsys.' || l_dbo_name || ' compile'
          when 'FUNCTION' then
            'alter function ctxsys.' || l_dbo_name || ' compile'
          when 'PACKAGE' then 
            'alter package ctxsys.' || l_dbo_name || ' compile'
          when 'PACKAGE BODY' then
            'alter package ctxsys.' || l_dbo_name || ' compile body'
          when 'TYPE' then 
            'alter type ctxsys.' || l_dbo_name || ' compile'
          when 'TYPE BODY' then 
            'alter type ctxsys.' || l_dbo_name || ' compile body'
          when 'INDEXTYPE' then 
            'alter indextype ctxsys.' || l_dbo_name || ' compile'
          when 'OPERATOR' then 
            'alter operator ctxsys.' || l_dbo_name || ' compile'
          else null
        end;

      if l_compile_sql is null then
        dbms_output.put_line(
          'FAILED CHECK FOR '||c1.dbo_type||' '||c1.dbo_name);
        dbms_registry.invalid('CONTEXT');
        goto endfunc;
      else
        begin
          execute immediate l_compile_sql;
        exception
          when others then
            dbms_output.put_line(
              'FAILED CHECK FOR '||c1.dbo_type||' '||c1.dbo_name);
            dbms_registry.invalid('CONTEXT');
            goto endfunc;
        end;
      end if;
    end if;
  end loop;

  /* Bug 16936854 : Check if there were any errors during CONTEXT upgrade */
  l_upg_mode := sys.dbms_registry.is_in_upgrade_mode();
  if (l_upg_mode = TRUE) then
    select count(*) into l_errcnt 
       from sys.registry$error 
      where identifier = 'CONTEXT';
    if (l_errcnt != 0) then
      dbms_registry.invalid('CONTEXT');
      goto endfunc;
    end if;
  end if;

  dbms_registry.valid('CONTEXT');

<<endfunc>>
  null;
  
exception
  when others then
    ctxsys.drue.text_on_stack(sqlerrm, 'validate_context');
    dbms_registry.invalid('CONTEXT');
    ctxsys.drue.raise;
end validate_context;
/

grant execute on validate_context to ctxsys;

ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

@?/rdbms/admin/sqlsessend.sql
