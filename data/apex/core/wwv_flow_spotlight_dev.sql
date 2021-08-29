set define off
set verify off

prompt ...wwv_flow_property_dev

create or replace package wwv_flow_spotlight_dev as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2009 - 2017. All Rights Reserved.
--
--    NAME
--      wwv_flow_spotlight_dev.sql
--
--    DESCRIPTION
--      This package is for Spotlight Search in App Builder
--
--    MODIFIED   (MM/DD/YYYY)
--    xhu         08/01/2017 - Created
--    hfarrell    08/22/2017 - Added set define at end of file (resolving Hudson install issue)
--    xhu         01/01/2018 - Added custom entries defined in App 4411 > Shared Components > Lists
--                             Added wwv_flow_list_items.list_text_10 as tokens
--
--------------------------------------------------------------------------------
--
--
--==============================================================================
-- Emit a JSON structure of Nav menus, apps and pages
--==============================================================================
procedure emit_spotlight_index(
    p_app_id            in number  default null,
    p_is_page_designer  in boolean default false );

end wwv_flow_spotlight_dev;
/
show errors

set define '^'