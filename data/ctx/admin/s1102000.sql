Rem
Rem $Header: ctx_src_2/src/dr/admin/s1102000.sql /main/11 2018/07/25 13:49:08 surman Exp $
Rem
Rem s1102000.sql
Rem
Rem Copyright (c) 2008, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      s1102000.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      THE UPGRADE SCRIPTS SHOULD AVOID USING REFERENCES TO CTXSYS
Rem      PACKAGES AS THESE PACKAGES MIGHT BE INVALIDATED DURING UPGRADE.
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/s1102000.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/s1102000.sql
Rem      SQL_PHASE: UPGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/ctxu817.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to UPGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    ssethuma    08/23/12 - Bug 14393144
Rem    surman      12/21/11 - 13508115: Skip policies when dropping triggers
Rem    bhristov    11/17/11 - grant set container to ctxsys
Rem    hsarkar     08/19/11 - Bug 12867992: Grant inherit any privileges to
Rem                           ctxsys
Rem    jmadduku    03/09/11 - Proj32507: Grant Unlimited Tablespace with
Rem                           RESOURCE role
Rem    rpalakod    05/03/10 - autooptimize
Rem    surman      06/01/09 - 8323978: Ignore ORA-4080 error
Rem    surman      05/29/09 - 8323978: Drop map triggers on upgrade
Rem    rpalakod    06/07/08 - 11.2
Rem    rpalakod    06/07/08 - Created
Rem

REM ==================================================================
REM 8323978: Drop map triggers
REM ==================================================================
set serveroutput on

declare
  cursor all_indexes is
    select username, idx_name, idx_id,
           ixp_name, ixp_id
      from dba_users u, ctxsys.dr$index i, ctxsys.dr$index_partition p
      where i.idx_option not like '%O%'
        and i.idx_id = p.ixp_idx_id (+)
        and u.user_id = i.idx_owner#;

  sql_string varchar2(400);
  ptable     boolean;
  partidstr  varchar2(4);
  lpid       number;
  l_idx_owner varchar2(100);
  l_idx_name varchar2(100);
  l_pfx_type varchar(1);
  l_pfx_str  varchar(4);
  l_tname    varchar2(256);
begin
  for rec in all_indexes loop
    ptable := FALSE;
    for c1 in (select null from ctxsys.dr$index_value
                where ixv_value = '1'
                  and ixv_oat_id =
                 (select oat_id
                    from ctxsys.dr$object_attribute
                   where oat_cla_id = 7
                     and oat_obj_id = 1
                     and oat_name = 'SUBSTRING_INDEX')
                  and ixv_idx_id = rec.idx_id)
    loop
      ptable := TRUE;
    end loop;
    if (ptable) then
      if rec.ixp_name is null then
        dbms_output.put_line('dropping trigger for index ' || rec.username ||
        '.' || rec.idx_name);
      else
        dbms_output.put_line('dropping trigger for index ' || rec.username ||
        '.' || rec.idx_name || ', partition ' || rec.ixp_name);
      end if;

      lpid := rec.ixp_id;
      if(rec.username is null) then
        l_idx_owner := null;
      else
        l_idx_owner := dbms_assert.enquote_name(rec.username, FALSE);
      end if;
      l_pfx_str := 'DR';
      l_idx_name := ltrim(rtrim(dbms_assert.simple_sql_name(rec.idx_name),
                                '"'), '"');
      l_pfx_type := dbms_assert.noop('T');
      if(rec.ixp_id is null or rec.ixp_id = 0) then
        if((l_idx_owner is null)) then
          l_tname := '"' || l_pfx_str || '$' || l_idx_name || l_pfx_type;
        else
          l_tname :=  l_idx_owner || '.' || '"' || l_pfx_str || '$' || 
                        l_idx_name || l_pfx_type;
        end if;
      else
        if (lpid >= 10000) then
          lpid := lpid - 10000;
          for i in 1..4 loop
            if (mod(lpid,36) >= 27) then
              partidstr := chr(ascii('0')+mod(lpid,36)-27)||partidstr;
            else
              partidstr := chr(ascii('A')+mod(lpid,36))||partidstr;
            end if;
            lpid := trunc(lpid/36);
          end loop;
        else
          partidstr := ltrim(to_char(rec.ixp_id,'0000'));
        end if;

        if ((l_idx_owner is null)) then
          l_tname := '"' || l_pfx_str || '#' || l_idx_name || 
                       partidstr || l_pfx_type;
        else
          l_tname := l_idx_owner || '.' || '"' || l_pfx_str || '#' || 
                       l_idx_name || partidstr || l_pfx_type;
        end if;
      end if;

      sql_string := 'drop trigger ' || l_tname || 'M"';
      begin
        execute immediate sql_string;
      exception
        when others then
          if sqlcode != -4080 then
            -- ignore "trigger does not exist" error
            raise;
          end if;
      end;
    end if;
  end loop;
end;
/

REM ========================================================================
REM autooptimize
REM ========================================================================

grant select on SYS.v_$db_pipes to ctxsys;
grant create job to ctxsys;
grant manage scheduler to ctxsys;
grant resource, unlimited tablespace to ctxsys;
grant inherit any privileges to ctxsys;

declare
  already_revoked exception;
  pragma exception_init(already_revoked,-01927);
begin
  execute immediate 'revoke inherit privileges on user CTXSYS from PUBLIC';
exception
  when already_revoked then
    null;
end;
/

REM ========================================================================
REM Consolidated DB
REM ========================================================================
grant set container to ctxsys;
