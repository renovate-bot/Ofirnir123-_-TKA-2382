set define off
set verify off

prompt ...wwv_flow_mail_api

create or replace package wwv_flow_mail_api
as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2012. All Rights Reserved.
--
--    NAME
--      wwv_flow_mail_api.sql
--
--    DESCRIPTION
--      This package is the public API for handling mails in Application Express.
--
--      Note: In order to call the APEX_MAIL package from outside the context of
--            an Application Express application, you must call
--            apex_util.set_security_group_id as in the following example:
--
--            declare
--                l_workspace_id number;
--            begin
--                select workspace_id
--                  into l_workspace_id
--                  from apex_applications
--                 where application_id = p_app_id;
--
--                apex_util.set_security_group_id (
--                    p_security_group_id => l_workspace_id );
--
--                apex_mail.send ( ... );
--                commit;
--            end;
--
--    MODIFIED   (MM/DD/YYYY)
--      pawolf    04/19/2012 - Created
--      pawolf    03/01/2018 - Added template based send
--
--------------------------------------------------------------------------------

--==============================================================================
-- Global types
--==============================================================================


--==============================================================================
-- Global constants
--==============================================================================

--==============================================================================
-- Global variables
--==============================================================================


--==============================================================================
-- Procedure to add a mail to the mail queue of Application Express.
--==============================================================================
procedure send (
    p_to        in varchar2,
    p_from      in varchar2,
    p_body      in varchar2,
    p_body_html in varchar2 default null,
    p_subj      in varchar2 default null,
    p_cc        in varchar2 default null,
    p_bcc       in varchar2 default null,
    p_replyto   in varchar2 default null );

procedure send (
    p_to        in varchar2,
    p_from      in varchar2,
    p_body      in clob,
    p_body_html in clob     default null,
    p_subj      in varchar2 default null,
    p_cc        in varchar2 default null,
    p_bcc       in varchar2 default null,
    p_replyto   in varchar2 default null );

--==============================================================================
-- Procedure to add a mail to the mail queue of Application Express.
--
-- The mail is based on an e-mail template where the placeholder values specified
-- as json string are substituted.
--
-- Example:
--
-- begin
--     apex_mail.send (
--         p_template_static_id => 'ORDER',
--         p_placeholders       => '{ "ORDER_NUMBER": 5321, "ORDER_DATE": "01-Feb-2018", "ORDER_TOTAL": "$12,000" }',
--         p_to                 => 'mail address' );
-- end;
--==============================================================================
procedure send (
    p_template_static_id in varchar2,
    p_placeholders       in clob,
    p_to                 in varchar2,
    p_cc                 in varchar2 default null,
    p_bcc                in varchar2 default null,
    p_from               in varchar2 default null,
    p_replyto            in varchar2 default null,
    p_application_id     in number   default wwv_flow_security.g_flow_id );

--==============================================================================
-- Function which returns a mail id after adding the mail to the mail queue of
-- Application Express. The mail id can be used in a call to add_attachment to
-- add atachments to an existing mail.
--==============================================================================
function send (
    p_to        in varchar2,
    p_from      in varchar2,
    p_body      in varchar2,
    p_body_html in varchar2 default null,
    p_subj      in varchar2 default null,
    p_cc        in varchar2 default null,
    p_bcc       in varchar2 default null,
    p_replyto   in varchar2 default null )
    return number;

function send (
    p_to        in varchar2,
    p_from      in varchar2,
    p_body      in clob,
    p_body_html in clob     default null,
    p_subj      in varchar2 default null,
    p_cc        in varchar2 default null,
    p_bcc       in varchar2 default null,
    p_replyto   in varchar2 default null )
    return number;

--==============================================================================
-- Function which returns a mail id after adding the mail to the mail queue of
-- Application Express. The mail id can be used in a call to add_attachment to
-- add atachments to an existing mail.
--
-- The mail is based on an e-mail template where the placeholder values specified
-- as json string are substituted.
--
-- Example:
--
-- declare
--     l_mail_id number;
-- begin
--     l_mail_id := apex_mail.send (
--                      p_template_static_id => 'ORDER',
--                      p_placeholders       => '{ "ORDER_NUMBER": 5321, "ORDER_DATE": "01-Feb-2018", "ORDER_TOTAL": "$12,000" }',
--                      p_to                 => 'mail address' );
--
--     apex_mail.add_attachment (
--         p_mail_id    => l_mail_id,
--         p_attachment => ... );
-- end;
--==============================================================================
function send (
    p_template_static_id in varchar2,
    p_placeholders       in clob,
    p_to                 in varchar2,
    p_cc                 in varchar2 default null,
    p_bcc                in varchar2 default null,
    p_from               in varchar2 default null,
    p_replyto            in varchar2 default null,
    p_application_id     in number   default wwv_flow_security.g_flow_id )
    return number;

--==============================================================================
-- Procedure which adds an attachment to a mail.
--==============================================================================
procedure add_attachment (
    p_mail_id    in number,
    p_attachment in blob,
    p_filename   in varchar2,
    p_mime_type  in varchar2 );

--==============================================================================
-- If email includes link to APEX instance, use this function to get the
-- instance URL.
--
-- Note: This function requires that the instance setting
--       "Application Express Instance URL" for emails is set!
--==============================================================================
function get_instance_url return varchar2;

--==============================================================================
-- If email includes APEX instance images, use this function to get the
-- image prefixed URL.
--
-- Note: This function requires that the instance setting
--       "Application Express Images URL" for emails is set!
--==============================================================================    
function get_images_url return varchar2;

--==============================================================================
-- Parameters p_smtp_hostname and p_smtp_portno remain for backward
-- compatibility.  But they are ignored.  The SMTP host name and
-- parameter are exclusively derived from system preferences
-- when sending mail.
--==============================================================================
procedure push_queue (
    p_smtp_hostname in varchar2 default null,
    p_smtp_portno   in varchar2 default null );

--==============================================================================
-- Procedure to return a formatted mail based on an e-mail template where the
-- placeholders specified as json string are substituted.
--
-- Example:
--
-- declare
--     l_subject varchar2( 4000 );
--     l_html    clob;
--     l_text    clob;
-- begin
--     apex_mail.prepare_template (
--         p_static_id    => 'ORDER',
--         p_placeholders => '{ "ORDER_NUMBER": 5321, "ORDER_DATE": "01-Feb-2018", "ORDER_TOTAL": "$12,000" }',
--         p_subject      => l_subject,
--         p_html         => l_html,
--         p_text         => l_text );
-- end;
--==============================================================================
procedure prepare_template (
    p_static_id          in     varchar2,
    p_placeholders       in     clob,
    p_application_id     in     number default wwv_flow_security.g_flow_id,
    p_subject               out varchar2,
    p_html                  out clob,
    p_text                  out clob );
--
end wwv_flow_mail_api;
/
show errors

set define '^'
