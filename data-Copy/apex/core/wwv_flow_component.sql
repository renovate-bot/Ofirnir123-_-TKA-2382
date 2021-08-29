set define '^'
set verify off
prompt ...wwv_flow_component


create or replace package wwv_flow_component
as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2013 - 2014. All Rights Reserved.
--
--    NAME
--      wwv_flow_component.sql
--
--    DESCRIPTION
--      This package provides constants for the components of APEX.
--
--    RUNTIME DEPLOYMENT: YES
--
--    MODIFIED   (MM/DD/YYYY)
--    pawolf      12/11/2013 - Init
--    pawolf      02/04/2013 - Added quick edit for IR and Classic Report columns (feature #1363)
--    pawolf      10/28/2015 - Added additional component types
--    pawolf      03/15/2016 - Added c_comp_type_ig_column
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public type definitions
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public constant definitions
--------------------------------------------------------------------------------

c_comp_type_breadcrumb         constant number := 3510;
c_comp_type_list               constant number := 3520;
c_comp_type_region             constant number := 5110;
c_comp_type_page_item          constant number := 5120;
c_comp_type_button             constant number := 5130;
c_comp_type_ir_column          constant number := 7040;
c_comp_type_classic_report     constant number := 7310;
c_comp_type_classic_rpt_column constant number := 7320;
c_comp_type_tab_form_column    constant number := 7420;
c_comp_type_ig_column          constant number := 7940;
--
end wwv_flow_component;
/
show errors
