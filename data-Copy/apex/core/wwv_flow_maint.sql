set define '^'
set verify off
prompt ...wwv_flow_maint

Rem NAME
Rem      wwv_flow_maint.sql
Rem
Rem
Rem    RUNTIME DEPLOYMENT: YES
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem      jkallman  09/04/2009 - Created
Rem      jkallman  04/05/2010 - Added daily_maintenance procedure
Rem      jkallman  04/11/2017 - Added kill_network_waiting_sessions

create or replace package wwv_flow_maint
as
--  Copyright (c) Oracle Corporation 2009. All Rights Reserved.
--
--    DESCRIPTION
--      Maintenance procedures for Oracle Appliation Express
--

procedure archive_activity_summary;

procedure kill_network_waiting_sessions;

procedure daily_maintenance;

end wwv_flow_maint;

/

show error
