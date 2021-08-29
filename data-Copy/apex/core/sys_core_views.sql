set define '^' verify off
prompt ...sys_core_views.sql
--------------------------------------------------------------------------------
--
-- Copyright (c) Oracle Corporation 1999 - 2016. All Rights Reserved.
--
-- NAME
--   sys_core_views.sql
--
-- DESCRIPTION
--   APEX specific views that are installed in SYS, for core functionality
--
-- RUNTIME DEPLOYMENT: YES
-- PUBLIC:             NO
--
-- MODIFIED   (MM/DD/YYYY)
--   cneumuel  10/14/2016 - Created
--
--------------------------------------------------------------------------------

--==============================================================================
-- constraints of CURRENT_USER.
--
-- Because of bug #20618595, DBA_CONSTRAINTS returns CDB$ROOT constraint names
-- in the PDB.
--==============================================================================
create or replace force view sys.wwv_flow_cu_constraints (
    table_name,
    constraint_name,
    constraint_type )
as
select obj$.name,
       con$.name,
       decode(cdef$.type#,
              1, 'C', 2, 'P', 3, 'U',
              4, 'R', 5, 'V', 6, 'O', 7,'C', 8, 'H', 9, 'F',
              10, 'F', 11, 'F', 13, 'F', '?')
  from sys.con$,
       sys.cdef$,
       sys.obj$
 where con$.con#  = cdef$.con#
  and cdef$.obj#  = obj$.obj#
  and obj$.owner# = sys_context('userenv','current_userid')
/
