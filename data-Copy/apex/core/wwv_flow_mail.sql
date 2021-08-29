set define '^' verify off
prompt ...wwv_flow_mail
create or replace package wwv_flow_mail as
--------------------------------------------------------------------------------
--
--  Copyright (c) Oracle Corporation 2000 - 2018. All Rights Reserved.
--
--    NAME
--      wwv_flow_mail
--
--    DESCRIPTION
--      Flows generic mail routines
--
--    SECURITY
--
--    RUNTIME DEPLOYMENT: YES
--
--    MODIFIED   (MM/DD/YYYY)
--      jkallman  11/01/2000 - Created (from tkyte/clbeck source)
--      tmuth     02/28/2000 - Modified to include ability to send html
--      jkallman  10/17/2002 - Added send procedure with CLOB body
--      jkallman  12/08/2005 - Change p_smtp_hostname and p_smtp_portno parameters to have default null values (Bug 4863562)
--      jkallman  01/24/2006 - Support no Reply-To via p_reply parameter in send() procedure
--      jkallman  02/15/2006 - Change p_replyto to varchar2, add overloaded specifications for p_replyto
--      jkallman  02/09/2007 - Added push_queue_background
--      jkallman  11/08/2007 - Added add_attachment
--      jkallman  09/15/2011 - Added push_queue_immediate
--      cbcho     04/17/2012 - Added get_instance_url, get_images_url (feature #549)
--      vuvarov   06/25/2012 - Moved convert_urls_to_links() and convert_txt_to_html() from wwv_flow_fnd_developer_api
--      jkallman  07/25/2012 - Add p_force_yn to push_queue_immediate
--      xhu       10/11/2016 - Added apex_email_message
--      cneumuel  10/16/2017 - In send, add_attachment: added p_security_group_id (bug #25974912)
--      sbkenned  02/02/2018 - added get_default_html_template
--      pawolf    03/01/2018 - Added template based send
--
--------------------------------------------------------------------------------

type t_purge is record (
    workspace_name     varchar2(255),
    url                varchar2(512),
    dont_purge_url     varchar2(4000),
    purge_date         varchar2(100),
    days_msg           number);

--==============================================================================
procedure send (
    p_to                in varchar2,
    p_from              in varchar2,
    p_body              in varchar2,
    p_body_html         in varchar2  default NULL,
    p_subj              in varchar2  default NULL,
    p_cc                in varchar2  default NULL,
    p_bcc               in varchar2  default NULL,
    p_replyto           in varchar2  default null,
    p_security_group_id in number    default wwv_flow_security.g_security_group_id );

--==============================================================================
procedure send (
    p_to                in varchar2,
    p_from              in varchar2,
    p_body              in clob,
    p_body_html         in clob      default NULL,
    p_subj              in varchar2  default NULL,
    p_cc                in varchar2  default NULL,
    p_bcc               in varchar2  default NULL,
    p_replyto           in varchar2  default null,
    p_security_group_id in number    default wwv_flow_security.g_security_group_id );

--==============================================================================
procedure send (
    p_template_static_id in varchar2,
    p_placeholders       in clob,
    p_to                 in varchar2,
    p_cc                 in varchar2 default null,
    p_bcc                in varchar2 default null,
    p_from               in varchar2 default null,
    p_replyto            in varchar2 default null,
    p_application_id     in number   default wwv_flow_security.g_flow_id,
    p_security_group_id  in number   default wwv_flow_security.g_security_group_id );

--==============================================================================
function send (
    p_to            in varchar2,
    p_from          in varchar2,
    p_body          in varchar2,
    p_body_html     in varchar2 default NULL,
    p_subj          in varchar2 default NULL,
    p_cc            in varchar2 default NULL,
    p_bcc           in varchar2 default NULL,
    p_replyto       in varchar2 default null,
    p_security_group_id in number    default wwv_flow_security.g_security_group_id )
    return number;

--==============================================================================
function send (
    p_to                in varchar2,
    p_from              in varchar2,
    p_body              in clob,
    p_body_html         in clob      default NULL,
    p_subj              in varchar2  default NULL,
    p_cc                in varchar2  default NULL,
    p_bcc               in varchar2  default NULL,
    p_replyto           in varchar2  default null,
    p_security_group_id in number    default wwv_flow_security.g_security_group_id )
    return number;

--==============================================================================
function send (
    p_template_static_id in varchar2,
    p_placeholders       in clob,
    p_to                 in varchar2,
    p_cc                 in varchar2 default null,
    p_bcc                in varchar2 default null,
    p_from               in varchar2 default null,
    p_replyto            in varchar2 default null,
    p_application_id     in number   default wwv_flow_security.g_flow_id,
    p_security_group_id  in number   default wwv_flow_security.g_security_group_id )
    return number;

--==============================================================================
procedure add_attachment (
    p_mail_id           in number,
    p_attachment        in blob,
    p_filename          in varchar2,
    p_mime_type         in varchar2,
    p_security_group_id in number    default wwv_flow_security.g_security_group_id );


--==============================================================================
--
-- Parameters p_smtp_hostname and p_smtp_portno remain for backward
-- compatibility.  But they are ignored.  The SMTP host name and
-- parameter are exclusively derived from system preferences
-- when sending mail.
--
--==============================================================================
procedure background( p_id in number,
                      p_smtp_hostname in varchar2 default null,
                      p_smtp_portno   in varchar2 default null );

--==============================================================================
--
-- Parameters p_smtp_hostname and p_smtp_portno remain for backward
-- compatibility.  But they are ignored.  The SMTP host name and
-- parameter are exclusively derived from system preferences
-- when sending mail.
--
--==============================================================================
procedure push_queue( p_smtp_hostname in varchar2 default null,
                      p_smtp_portno   in varchar2 default null );

--==============================================================================
--
-- Will submit a one-time database job to push the mail queue
--
--==============================================================================
procedure push_queue_background;

--==============================================================================
procedure push_queue_immediate( p_force_yn in varchar2 default 'N');

--==============================================================================
--
-- If email includes link to APEX instance, use this function to get the instance URL
--
--==============================================================================
function get_instance_url (
    p_security_group_id in number default null )
    return varchar2;

--==============================================================================
--
-- If email includes APEX instance images, use this function to get the image prefixed URL
--
--==============================================================================
function get_images_url (
    p_security_group_id in number default null )
    return varchar2;

--==============================================================================
--
-- Converts plain-text URLs (e.g. http://www.oracle.com) to HTML hyperlinks (e.g.
-- <a href="http://www.oracle.com">http://www.oracle.com</a>).
--
--==============================================================================
function convert_urls_to_links (
    p_string in varchar2 )
    return varchar2;

--==============================================================================
--
-- Converts plain-text input into basic HTML, while adding APEX logo and converting
-- URLs to HTML hyperlinks.
--
--==============================================================================
function convert_txt_to_html (
    p_txt_message       in varchar2,
    p_security_group_id in number default null )
    return varchar2;

--==============================================================================
--
-- Sends a formatted APEX email message
--
-- statuses: approved, declined, ready, purged
--==============================================================================
procedure get_formatted_message (
    p_provision_id      in number,
    p_message_type      in varchar2,
    p_custom_msg        in varchar2 default null,
    p_purge_values      in t_purge default null,
    out_html           out varchar2,
    out_plain          out varchar2 );

--==============================================================================
-- Returns the plain text and html code of an e-mail which is based on an
-- e-mail template where the passed in placeholders are replaced.
--==============================================================================
procedure prepare_template (
    p_static_id          in     varchar2,
    p_placeholders       in     clob,
    p_application_id     in     number default wwv_flow_security.g_flow_id,
    p_security_group_id  in     number default wwv_flow_security.g_security_group_id,
    p_subject               out varchar2,
    p_html                  out clob,
    p_text                  out clob );

--==============================================================================
--
-- Returns current, default html email template
--
--==============================================================================
function get_default_html_template
   return clob;

end wwv_flow_mail;
/
show errors
