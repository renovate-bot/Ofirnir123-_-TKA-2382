set define off verify off
prompt ...wwv_flow_instance_rest_admin
create or replace package wwv_flow_instance_rest_admin authid definer as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 1999 - 2016. All Rights Reserved.
--
--    NAME
--      wwv_flow_instance_rest_admin.sql
--
--    DESCRIPTION
--      APEX REST Admin Service administration
--
--    NOTES
--      This program allows to administer die REST Administration REST services 
--      for APEX
--
--    INTERNATIONALIZATION
--      unknown
--
--    MULTI-CUSTOMER
--      unknown
--
--    SCRIPT ARGUMENTS
--      none
--
--    RUNTIME DEPLOYMENT: YES
--
--    MODIFIED   (MM/DD/YYYY)
--      cczarski  04/06/2016 - Created
--      cneumuel  04/08/2016 - set define '^' at end
--------------------------------------------------------------------------------

--==============================================================================
-- remove administrative REST services from the APEX_INSTANCE_ADMIN_USER schema
--==============================================================================
    procedure remove_services;

--==============================================================================
-- create administrative REST services in the APEX_INSTANCE_ADMIN_USER schema
--==============================================================================
    procedure create_services;

--==============================================================================
-- create an OAuth client with "client_credentials" flow

-- P_CLIENT_NAME: Name for the new OAuth client
-- P_ADMIN_EMAIL: Client user email address 
-- P_CLIENT_ROLE: ORDS role to assign to the client. 
--                Currently only "ApexStatsInfoRole" is supported.
--==============================================================================
    procedure create_client(
        p_client_name    in varchar2, 
        p_admin_email    in varchar2, 
        p_client_role    in varchar2
    );

--==============================================================================
-- removes an existing OAuth Client by Client Name
--==============================================================================
    procedure remove_client(
        p_client_name    in varchar2
    );

--==============================================================================
-- removes an existing OAuth Client by ORDS internal ID
--==============================================================================
    procedure remove_client(
        p_client_ords_id in number
    );

--==============================================================================
-- removes all OAuth clients
--==============================================================================
    procedure remove_all_clients;

--==============================================================================
-- returns all registered clients in XML format
--==============================================================================
    function client_info_xml return clob;

--==============================================================================
-- checks whether environment allows Admin REST Services
-- returns true when
-- * APEX_INSTANCE_ADMIN_USER schema is present
-- * ORDS 3.0.5 or higher is installed
--==============================================================================
    function rest_services_available return boolean;

--==============================================================================
-- checks whether all admin REST services are present
--==============================================================================
    function rest_services_healthy return varchar2;

--==============================================================================
-- checks whether REST services can be upgraded
--==============================================================================
    function rest_services_current return varchar2;

--==============================================================================
-- remove everything / clear the APEX_INSTANCE_ADMIN_USER schema
--==============================================================================

    procedure remove_all;
end wwv_flow_instance_rest_admin;
/
set define '^'
