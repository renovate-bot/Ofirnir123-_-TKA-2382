set define '^' verify off
prompt ...wwv_flow_blueprint_v3


create or replace package wwv_flow_blueprint_v3
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_blueprint_v3.plb
--
--    DESCRIPTION
--      Provide JSON support to create application wizard
--
--    RUNTIME DEPLOYMENT: 
--
--    MODIFIED  (MM/DD/YYYY)
--     mhichwa   03/13/2017 - Created
--     mhichwa   03/15/2017 - added create_blueprint_ddl and expanded save_blueprint
--     mhichwa   03/15/2017 - added load retain and delete named_blueprint procedures
--     mhichwa   03/15/2017 - added support for P_APP_COLOR_HEX
--     mhichwa   03/23/2017 - added p_schema to gen_json
--     cbcho     04/05/2017 - Renamed to v3
--     mhichwa   04/13/2017 - remove code moved to wwv_flow_app_def package
--     mhichwa   04/24/2017 - added get_session_state_from_json1 to support clob
--     mhichwa   04/24/2017 - added gen_json1
--     mhichwa   04/27/2017 - added baseTablePrefix
--     cbcho     05/09/2017 - renamed gen_json1 to gen_json
--     cbcho     05/10/2017 - added p_learn_app_def
--     cbcho     09/07/2017 - In get_session_state_from_json: added p_schema out parameter
--     cbcho     01/02/2018 - Removed rejoin sessions
--     cbcho     02/08/2018 - Removed table prefix
--     cbcho     07/18/2018 - In save_blueprint, gen_json, get_session_state_from_json: added p_built_with_love (feature #2359)
--
--------------------------------------------------------------------------------

as

g_blueprint_clob              clob;
g_blueprint_vc                varchar2(32767);

procedure save_blueprint (
    p_built_with_love         in varchar2 default null, -- P5_BUILT_WITH_LOVE
    p_learn_app_def           in varchar2 default null, -- P5_LEARN_YN
    P_APP_NAME                in varchar2 default null, -- P1_APP_NAME
    P_APP_SHORT_DESC          in varchar2 default null, -- P5_APP_SHORT_DESC
    P_APP_DESC                in varchar2 default null, -- P5_APP_DESC
    P_FEATURES                in varchar2 default null, -- P1_FEATURES
    P_THEME_STYLE             in varchar2 default null, -- P1_THEME_STYLE
    P_NAV_POSITION            in varchar2 default null, -- P1_NAV_POSITION
    P_APP_ICON_CLASS          in varchar2 default null, -- P1_APP_ICON_CLASS
    P_APP_COLOR_CLASS         in varchar2 default null, -- P1_APP_COLOR_CLASS
    P_APP_COLOR_HEX           in varchar2 default null, -- P1_APP_COLOR_HEX
    p_base_table_prefix       in varchar2 default null, -- P5_BASE_TABLE_PREFIX
    P_PRIMARY_LANGUAGE        in varchar2 default null, -- P1_PRIMARY_LANGUAGE
    P_TRANSLATED_LANGS        in varchar2 default null, -- P1_TRANSLATED_LANGS
    P_AUTHENTICATION          in varchar2 default null, -- P1_AUTHENTICATION
    P_APP_VERSION             in varchar2 default null, -- P5_APP_VERSION
    P_APP_LOGGING             in varchar2 default null, -- P5_APP_LOGGING
    P_APP_DEBUGGING           in varchar2 default null, -- P5_APP_DEBUGGING
    P_DOCUMENT_DIRECTION      in varchar2 default null, -- P5_DOCUMENT_DIRECTION
    P_DATE_FORMAT             in varchar2 default null, -- P5_DATE_FORMAT
    P_DATE_TIME_FORMAT        in varchar2 default null, -- P5_DATE_TIME_FORMAT
    P_TIMESTAMP_FORMAT        in varchar2 default null, -- P5_TIMESTAMP_FORMAT
    P_TIMESTAMP_TZ_FORMAT     in varchar2 default null, -- P5_TIMESTAMP_TZ_FORMAT
    P_DEEP_LINKING            in varchar2 default null, -- P5_DEEP_LINKING
    P_MAX_SESSION_LENGTH      in varchar2 default null, -- P5_MAX_SESSION_LENGTH
    P_MAX_SESSION_IDLE_TIME   in varchar2 default null, -- P5_MAX_SESSION_IDLE_TIME
    p_page_count              in number   default null, -- compute from collection
    p_feature_count           in number   default null) -- compute from array)
    ;

function gen_json (
    p_built_with_love         in varchar2 default null, -- P5_BUILT_WITH_LOVE
    p_learn_app_def           in varchar2 default null, -- P5_LEARN_YN
    P_APP_NAME                in varchar2 default null, -- P1_APP_NAME
    P_APP_SHORT_DESC          in varchar2 default null, -- P5_APP_SHORT_DESC
    P_APP_DESC                in varchar2 default null, -- P5_APP_DESC
    P_FEATURES                in varchar2 default null, -- P1_FEATURES
    P_THEME_STYLE             in varchar2 default null, -- P1_THEME_STYLE
    P_NAV_POSITION            in varchar2 default null, -- P1_NAV_POSITION
    P_APP_ICON_CLASS          in varchar2 default null, -- P1_APP_ICON_CLASS
    P_APP_COLOR_CLASS         in varchar2 default null, -- P1_APP_COLOR_CLASS
    P_APP_COLOR_HEX           in varchar2 default null, -- P1_APP_COLOR_HEX
    P_BASE_TABLE_PREFIX       in varchar2 default null, -- P5_BASE_TABLE_PREFIX
    P_PRIMARY_LANGUAGE        in varchar2 default null, -- P1_PRIMARY_LANGUAGE
    P_TRANSLATED_LANGS        in varchar2 default null, -- P1_TRANSLATED_LANGS
    P_AUTHENTICATION          in varchar2 default null, -- P1_AUTHENTICATION
    P_APP_VERSION             in varchar2 default null, -- P5_APP_VERSION
    P_APP_LOGGING             in varchar2 default null, -- P5_APP_LOGGING
    P_APP_DEBUGGING           in varchar2 default null, -- P5_APP_DEBUGGING
    P_DOCUMENT_DIRECTION      in varchar2 default null, -- P5_DOCUMENT_DIRECTION
    P_DATE_FORMAT             in varchar2 default null, -- P5_DATE_FORMAT
    P_DATE_TIME_FORMAT        in varchar2 default null, -- P5_DATE_TIME_FORMAT
    P_TIMESTAMP_FORMAT        in varchar2 default null, -- P5_TIMESTAMP_FORMAT
    P_TIMESTAMP_TZ_FORMAT     in varchar2 default null, -- P5_TIMESTAMP_TZ_FORMAT
    P_DEEP_LINKING            in varchar2 default null, -- P5_DEEP_LINKING
    P_MAX_SESSION_LENGTH      in varchar2 default null, -- P5_MAX_SESSION_LENGTH
    P_MAX_SESSION_IDLE_TIME   in varchar2 default null, -- P5_MAX_SESSION_IDLE_TIME
    p_schema                  in varchar2 default null  -- P1_SCHEMA
    ) return clob
    ;

procedure get_session_state_from_json (
    P_JSON_BLUEPRINT          in  clob default null, -- P150_JSON_BLUEPRINT
    p_schema                  out varchar2, -- P1_SCHEMA
    p_built_with_love         out varchar2, -- P5_BUILT_WITH_LOVE
    p_learn_app_def           out varchar2, -- P5_LEARN_YN
    P_APP_NAME                out varchar2, -- P1_APP_NAME
    P_APP_SHORT_DESC          out varchar2, -- P5_APP_SHORT_DESC
    P_APP_DESC                out varchar2, -- P5_APP_DESC
    P_FEATURES                out varchar2, -- P1_FEATURES
    P_THEME_STYLE             out varchar2, -- P1_THEME_STYLE
    P_NAV_POSITION            out varchar2, -- P1_NAV_POSITION
    P_APP_ICON_CLASS          out varchar2, -- P1_APP_ICON_CLASS
    P_APP_COLOR_CLASS         out varchar2, -- P1_APP_COLOR_CLASS
    P_APP_COLOR_HEX           out varchar2, -- P1_APP_COLOR_HEX
    P_BASE_TABLE_PREFIX       out varchar2, -- P5_BASE_TABLE_PREFIX
    P_PRIMARY_LANGUAGE        out varchar2, -- P1_PRIMARY_LANGUAGE
    P_TRANSLATED_LANGS        out varchar2, -- P1_TRANSLATED_LANGS
    P_AUTHENTICATION          out varchar2, -- P1_AUTHENTICATION
    P_APP_VERSION             out varchar2, -- P5_APP_VERSION
    P_APP_LOGGING             out varchar2, -- P5_APP_LOGGING
    P_APP_DEBUGGING           out varchar2, -- P5_APP_DEBUGGING
    P_DOCUMENT_DIRECTION      out varchar2, -- P5_DOCUMENT_DIRECTION
    P_DATE_FORMAT             out varchar2, -- P5_DATE_FORMAT
    P_DATE_TIME_FORMAT        out varchar2, -- P5_DATE_TIME_FORMAT
    P_TIMESTAMP_FORMAT        out varchar2, -- P5_TIMESTAMP_FORMAT
    P_TIMESTAMP_TZ_FORMAT     out varchar2, -- P5_TIMESTAMP_TZ_FORMAT
    P_DEEP_LINKING            out varchar2, -- P5_DEEP_LINKING
    P_MAX_SESSION_LENGTH      out varchar2, -- P5_MAX_SESSION_LENGTH
    P_MAX_SESSION_IDLE_TIME   out varchar2 -- P5_MAX_SESSION_IDLE_TIME
    );

function load_named_blueprint (
    p_blueprint_id      in number,
    p_app_user          in varchar2 default null,
    p_security_group_id in number default null
    ) return clob;

procedure retain_named_blueprint (
    p_blueprint_id      in number,
    p_app_user          in varchar2 default null,
    p_security_group_id in number default null
    );

procedure remove_blueprint (
    p_blueprint_id      in number,
    p_app_user          in varchar2 default null,
    p_security_group_id in number default null
    );


--
-- Attribute Defaults
--
--
--
--

function app_defaults_get_name return varchar2
    ;

function app_defaults_get_desc return varchar2
    ;

end wwv_flow_blueprint_v3;
/
show errors

