set define '^' verify off
prompt ...wwv_flow_rest_ws
CREATE     OR REPLACE PACKAGE wwv_flow_rest_ws AS
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_rest_ws.sql
--
--    DESCRIPTION
--     Manages Processing of the ORDS based REST Workshop
--
--    NOTES
--      This API is unsupported.
--
--    MODIFIED    (MM/DD/YYYY)
--     dgault     10/27/2017 - Created
--     dgault     07/09/1028 - Added run_plsql_as_parse_as_exec to spec
--
--------------------------------------------------------------------------------\
--
-- Minimum ORDS version required to enable ORDS REST workshop
    c_ords_major CONSTANT NUMBER := 17;
    c_ords_minor CONSTANT NUMBER := 4;
    c_ords_patch CONSTANT NUMBER := 1;
    c_ords_day CONSTANT NUMBER := 353;
-----------------------------------------------------------------------
--< PUBLIC METHODS >---------------------------------------------------
-----------------------------------------------------------------------

--< PROCESS_REST_WS >-------------------------------------------------
    PROCEDURE process_rest_ws_request (
        p_request    IN VARCHAR2,
        p_parse_as   IN VARCHAR2
    );

--< ENABLE_SCHEMA >-------------------------------------------------

    PROCEDURE enable_schema (
        p_schema          IN VARCHAR2,
        p_enable_access   IN VARCHAR2,
        p_schema_alias    IN VARCHAR2,
        p_auth_required   IN VARCHAR2
    );

--< DROP_REST >-------------------------------------------------

    PROCEDURE drop_rest (
        p_schema IN VARCHAR2
    );

--< ORDS_REPO_PRESENT >-------------------------------------------------

    FUNCTION ords_repo_present RETURN VARCHAR2;

--< ORDS_MIN_VER_MET >--------------------------------------------------

    FUNCTION ords_min_ver_met (
        p_current_version IN VARCHAR2
    ) RETURN VARCHAR2;

--< ORDS_IS_183_PLUS >--------------------------------------------------

    FUNCTION ords_is_183_plus (
        p_current_version IN VARCHAR2
    ) RETURN VARCHAR2;

--< MODULE_IS_PROTECTED >-----------------------------------------------

    FUNCTION module_is_protected (
        p_module_id IN NUMBER
    ) RETURN VARCHAR2;

--< TEMPLATE_IS_PROTECTED >-----------------------------------------------

    FUNCTION template_is_protected (
        p_template_id IN NUMBER
    ) RETURN VARCHAR2;
  
--< PROCESS >-----------------------------------------------

    FUNCTION run_plsql_as_parse_as_exec (
        p_code       IN CLOB,
        p_parse_as   IN VARCHAR2
    ) RETURN VARCHAR2;

END wwv_flow_rest_ws;
/
show errors