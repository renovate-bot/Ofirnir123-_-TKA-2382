set define '^'
set verify off
prompt ...wwv_flow_ws_chart


Rem  Copyright (c) Oracle Corporation 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      wwv_flow_ws_chart.sql
Rem
Rem    DESCRIPTION
Rem      Flash charting engine
Rem
Rem    SECURITY
Rem      No grants, must be run as FLOW schema owner.
Rem
Rem    NOTES
Rem
Rem    INTERNATIONALIZATION
Rem      unknown
Rem
Rem    MULTI-CUSTOMER
Rem      unknown
Rem
Rem    CUSTOMER MAY CUSTOMIZE
Rem      NO
Rem
Rem    RUNTIME DEPLOYMENT: YES
Rem
Rem    MODIFIED (MM/DD/YYYY)
Rem    cbcho      12/17/2009 - Created
Rem    hfarrell   02/01/2018 - Renamed from wwv_flow_ws_flash_chart to wwv_flow_ws_chart (18.1 feature #1841)


create or replace package wwv_flow_ws_chart
as

procedure chart(p_section_id in number default null);

end wwv_flow_ws_chart;
/
show error;
