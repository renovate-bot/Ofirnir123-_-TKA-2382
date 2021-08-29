set define off
set verify off
set serveroutput on size 1000000
set feedback off
--
-- ORACLE
--
-- Application Express (APEX)
--
-- NOTE: This script is auto-generated. Do not edit directly!
--
prompt Set Credentials...
begin
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,12));
end;
/
begin
select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';
end;
/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';
end;
/
prompt Creating Packaged Application Wizard Information...
prompt Check Compatibility...
begin
-- This date identifies the minimum version required to import this file.
wwv_flow_team_api.check_version(p_version_yyyy_mm_dd=>'2010.05.13');
end;
/

begin wwv_flow.g_import_in_progress := true; wwv_flow.g_user := USER; end;
/

prompt ...Delete Packaged Applications and associated images
delete from wwv_flow_pkg_app_images
/
delete from wwv_flow_pkg_applications
where app_group in ('PACKAGE','SAMPLE')
/
update wwv_flow_pkg_applications
set app_category_id_1 = null, app_category_id_2 = null, app_category_id_3 = null
where app_group in ('CUSTOM')
/

prompt ...Load Packaged Application Categories

delete from wwv_flow_pkg_app_categories
/

insert into wwv_flow_pkg_app_categories (
    category_name,
    category_desc )
values (
    'Community',
    '' )
/

insert into wwv_flow_pkg_app_categories (
    category_name,
    category_desc )
values (
    'IT Management',
    '' )
/

insert into wwv_flow_pkg_app_categories (
    category_name,
    category_desc )
values (
    'Knowledge Management',
    '' )
/

insert into wwv_flow_pkg_app_categories (
    category_name,
    category_desc )
values (
    'Marketing',
    '' )
/

insert into wwv_flow_pkg_app_categories (
    category_name,
    category_desc )
values (
    'Other',
    '' )
/

insert into wwv_flow_pkg_app_categories (
    category_name,
    category_desc )
values (
    'Project Management',
    '' )
/

insert into wwv_flow_pkg_app_categories (
    category_name,
    category_desc )
values (
    'Sample',
    '' )
/

insert into wwv_flow_pkg_app_categories (
    category_name,
    category_desc )
values (
    'Software Development',
    '' )
/

insert into wwv_flow_pkg_app_categories (
    category_name,
    category_desc )
values (
    'Team Productivity',
    '' )
/

insert into wwv_flow_pkg_app_categories (
    category_name,
    category_desc )
values (
    'Template',
    '' )
/

insert into wwv_flow_pkg_app_categories (
    category_name,
    category_desc )
values (
    'Tracking',
    '' )
/

update wwv_flow_pkg_applications
set app_category_id_1 = (select id from wwv_flow_pkg_app_categories where category_name = 'Template')
where app_group in ('CUSTOM') and app_category_id_1 is null
/

prompt ...Load Packaged Applications and associated images

-- Package 7000, Online Marketing Campaign Calendar

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233009436478446041;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Marketing')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7000,
        7000,
        null,
        'Online Marketing Campaign Calendar',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '',
        '<ul>'||unistr('\000a')||
'<li>Updated mobile user interface with APEX 4.2 mobile features</li>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Set compatibility mode to 4.2</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        '',
        'HIDDEN',
        '1.0.5',
        to_date('20140328000000','YYYYMMDDHH24MISS'),
        '1',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        null,
        '18.1',
        'Oracle',
        '',
        'www.oracle.com',
        51,
        null,
        '');

null;
end;
/
-- Package 7010, Decision Manager

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233009518220446041;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Team Productivity')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_2 := c2.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7010,
        7010,
        null,
        'Decision Manager',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>Decision Manager helps you track all the important decisions you have to make.  Decision Manager allows you to classify decisions by a number of aspects, including importance, type of decision, due date and the project the decision is associated with.</p>'||unistr('\000a')||
'<p>Decision Manager allows you to include relevant materials, either as links or attachments, and each decision gives all interested parties the ability to add notes to the overall decision record.  You can make a decision with a simple click, choosing between a set of options you define.</p>'||unistr('\000a')||
'<p>You can even see a list of outstanding decisions ranked by weight, which takes into consideration factors such as the importance and due date of the decision.</p>'||unistr('\000a')||
'<p>With Decision Manager, you can not only reach effective decision productively, but maintain a record of the decision making process for later validation and enlightenment.</p>',
        '<ul>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-decision-manager',
        'AVAILABLE',
        '2.1.2',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '23',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        59,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Decision Manager',
        'Screenshot showing the dashboard home page from Decision Manager, where an overview of important application information is available, such as ''Decision Requests'', ''Decisions'' and ''Tags''.',
        'decision_manager.png');

null;
end;
/
-- Package 7020, Script Planner

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233009636446446041;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7020,
        7020,
        null,
        'Script Planner',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>The Script Planner application is an easy-to-use Web-accessible method to build, refine, and publish demo scripts. This application facilitates the pre-production, production, post-production and distribution of scripted content. Use this application to manage the life cycle of your YouTube video production. Use it to develop or optimize user experience design (UX) patterns. Use it to outline an executive keynote address. Use it to outline the clicks and commentary for product demonstrations.</p>',
        '<ul>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-script-planner',
        'AVAILABLE',
        '1.0.12',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '13',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        51,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Script Planner Home Page',
        'Screenshot showing the dashboard home page from the Script Planner application, where information such as ''How to place a call'' demo script is available.',
        'script_planner.png');

null;
end;
/
-- Package 7030, Competitive Analysis

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233009794048446041;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Marketing')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7030,
        7030,
        null,
        'Competitive Analysis',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        'Use this application to compare any number of products side by side.  Comparisons are created online in a browser, and can be completed by many users simultaneously.  Comparisons, once completed, can be published online.  Comparisons can be scored and displayed in aggregated chart form, and can be displayed in longer, more detailed text form.  The format and content attributes displayed are customizable by end users.  Filtering provides easy ability to highlight differences between products.',
        '<ul>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-competitive-analysis',
        'AVAILABLE',
        '1.1.5',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '13',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        69,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Competitive Analysis Home Page',
        'Screenshot showing the dashboard home page from Competitive Analysis.',
        'competitive-analysis.png');

null;
end;
/
-- Package 7050, Opportunity Tracker

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233009856065446041;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Team Productivity')
    loop
        l_category_2 := c2.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7050,
        7050,
        null,
        'Opportunity Tracker',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>Opportunity Tracker helps you to track your sales opportunities throughout their lifespan, while giving sales management a quick and easy tool to both see the current state of the sales pipeline and analyze past sales performance.</p>'||unistr('\000a')||
'<p>With Opportunity Tracker, you can define accounts, contacts, territories, products  and competitors and combine these to define leads and opportunities.  Opportunity Tracker includes a rich set of reports on opportunities, pipeline analysis, key accounts, projected closing dates and different snapshots of sales by rep. </p> '||unistr('\000a')||
'<p>All reports in Opportunity Tracker are completely customizable by users, allowing for extended analysis and charting based on these reports.</p>'||unistr('\000a')||
''||unistr('\000a')||
'',
        '<ul>'||unistr('\000a')||
'<li>Support Amounts can be assigned to Accounts</li>'||unistr('\000a')||
'<li>Agreements can be assigned to Accounts</li>'||unistr('\000a')||
'<li>Accounts can now be bulk uploaded (Administration > Upload Data list)</li>'||unistr('\000a')||
'<li>New Sales Leader Title application preference added. This allows an admin to define a term that best describes their LOB''s title for a Sales Leader e.g. Key Account Director.</li>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-opportunity-tracker',
        'AVAILABLE',
        '3.0.12',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '29',
        l_category_1,
        l_category_2,
        l_category_3,
        3520,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        161,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Opportunity Tracker Home Page',
        'Screenshot showing the dashboard home page from Opportunity Tracker, where an overview of important application information is available, such as ''Open Opportunities by Territory, ''Leads'', ''Open Opportunities by Account'' and ''Open Opportunities''.',
        'opportunity_tracker.png');

null;
end;
/
-- Package 7060, Bug Tracking

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233009968431446041;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Software Development')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_2 := c2.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7060,
        7060,
        null,
        'Bug Tracking',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>The Bug Tracker application is an easy-to-use Web-accessible method to enter and track bugs against various projects.</p>'||unistr('\000a')||
'<p>You can enter bugs along with a variety of information, including associated project, severity, status and who the bug has been assigned to, along with a number of attributes about the problem. You can easily view when a bug was created and last updated, along with a free form description of the bug.</p>'||unistr('\000a')||
'<p>You can customize the values for standard attributes, insuring that your Bug Tracker application will fit your particular needs. An administrator can specify products and their versions, categories, and codes for status, priority and severity.</p>'||unistr('\000a')||
'<p>Bug Tracker gives all users an easy way to view bugs, based on a variety of selection filters.</p>',
        '<ul>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-bug-tracking',
        'AVAILABLE',
        '3.1.3',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '37',
        l_category_1,
        l_category_2,
        l_category_3,
        2368,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        103,
        null,
        'EBA_BUG_');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Bug Tracking Home Page',
        'Screenshot showing the dashboard home page from the Bug Tracking application, where information such as ''Recent Bugs'', ''Severity Metrics'' and ''Assignees'' is available.',
        'bugs.png');

null;
end;
/
-- Package 7090, Group Calendar

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233010024908446041;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Team Productivity')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7090,
        7090,
        null,
        'Group Calendar',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>The Group Calendar application gives you a way to list all your events on an easy to use, Web-accessible calendar. The Home page for the Group Calendar displays events in a monthly, weekly or daily format, with embedded links to detailed information about each event. You can also create customized reports on events.</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'Each event is classified by event type and automatically displayed in an associated color. You can create your own event types or modify existing event type attributes.</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'You can send emails to individuals or groups with information about upcoming meetings, and you have the ability to create your own groups to match your needs.</p>',
        '<ul>'||unistr('\000a')||
'<li>Getting Started Wizard</li>'||unistr('\000a')||
'<li>Sample data not installed by default</li>'||unistr('\000a')||
'<li>Improved user experience</li>'||unistr('\000a')||
'<li>Updated to latest Universal Theme</li>'||unistr('\000a')||
'<li>General UI enhancements</li>'||unistr('\000a')||
'<li>Tag Plug-in added</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-group-calendar',
        'AVAILABLE',
        '2.1.6',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '26',
        l_category_1,
        l_category_2,
        l_category_3,
        1408,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        53,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Group Calendar Home',
        'Screenshot of the Group Calendar home page, showing a calendar for the current month.',
        'group_cal.png');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Group Calendar Administration',
        'Screenshot showing the Administration pages from the Group Calendar application, where you can perform Administrative tasks such as enable access control, manage sample data and set color preferences.',
        'group_cal_admin.png');

null;
end;
/
-- Package 7140, Incident Tracking

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233010199877446041;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Software Development')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'IT Management')
    loop
        l_category_2 := c2.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7140,
        7140,
        null,
        'Incident Tracking',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>The Incident Tracking application gives you a complete system for entering and tracking support incidents.  The application allows you to enter customer companies and multiple contacts for each company, specify products and categories and set up values to limit status codes, severity and urgency attributes for an incident.</p>'||unistr('\000a')||
'<p>Incident Tracking includes a wizard to enter essential information about an incident and a variety of ways to sort and report on incidents, including a time line based on when incidents were entered into the system.</p>'||unistr('\000a')||
'<p>Once a ticket is entered into the system, you can track the progress of the ticket in an update area of the ticket, or add attachments and links to the incident.  You can also use tags to further classify incidents and use the resulting tag cloud in your reports.</p>'||unistr('\000a')||
'<p>The Incident Tracking system includes robust interactive reports, which provide valuable analysis of incidents through an easy-to-use interface, including the ability to create charts.</p>',
        '<ul>'||unistr('\000a')||
'<li>Getting Started Wizard</li>'||unistr('\000a')||
'<li>Sample data not installed by default</li>'||unistr('\000a')||
'<li>Greater use of modal dialogs</li>'||unistr('\000a')||
'<li>Improved user experience</li>'||unistr('\000a')||
'<li>Updated to latest Universal Theme</li>'||unistr('\000a')||
'<li>Responsiveness of desktop pages improved, Mobile pages removed</li>'||unistr('\000a')||
'<li>Individual customization of application appearance</li>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-incident-tracking',
        'AVAILABLE',
        '2.1.2',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '22',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        78,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Incident Tracking',
        'Screenshot showing the dashboard home page of Incident Tracking, allowing the ability to search incidents and also providing important information such as ''Recent Activity'' and an incident summary.',
        'incident_tracking.png');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Incident Tracking Ticket Details Page',
        'Screenshot showing the details page for an Incident Tracking Ticket.',
        'incident_tracking2.png');

null;
end;
/
-- Package 7160, Sample Geolocation Showcase

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233010220625446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7160,
        7160,
        null,
        'Sample Geolocation Showcase',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>'||unistr('\000a')||
' This application demonstrates Spatial capabilities of the Oracle database. It has 3 main areas: Addresses, Images and Areas Of Interest.</p>'||unistr('\000a')||
'<ul>'||unistr('\000a')||
'<li><b>Addresses</b> allows to add postal addresses which can be geocoded (converted to a coordinate) and then be displayed on the map.</li>'||unistr('\000a')||
'<li><b>Images</b> allows to upload images. If an image (e.g. a smartphone image) contains a location, it will be automatically extracted and being stored in the database.</li>'||unistr('\000a')||
'<li><b>Areas Of Interest</b> are polygons which can be drawn on the map and then be stored into the database</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'Based on this data, the application offers 3 kinds of spatial analysis'||unistr('\000a')||
'</p> '||unistr('\000a')||
'<ul>'||unistr('\000a')||
'<li><b>Within Distance Search</b>: After clicking a position on the map and adjusting the "distance slider", the application will return all images and addresses, which are located within that area.</li>'||unistr('\000a')||
'<li><b>Nearest Neighbor Search</b>: After selecting an address, a maximum distance and the maximum number of results, the application will show N images which are closest to the selected address.</li>'||unistr('\000a')||
'<li><b>Area Of Interest Search</b>: Allows to choose one of the previously created Areas Of Interest - the application will return all images and addresses within that area.</li>'||unistr('\000a')||
'</ul>',
        '<ul>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-sample-geolocation',
        'AVAILABLE',
        '1.1.11',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '12',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        26,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Geolocation Showcase',
        'Screenshot showing the Home page for the ''Sample Geolocation Showcase'', listing the available sample options such as ''Areas of Interest'', and ''Nearest-Neighbor Search'' are available.',
        'sample_geolocation.png');

null;
end;
/
-- Package 7170, Customer Tracker

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233010307444446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Marketing')
    loop
        l_category_2 := c2.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7170,
        7170,
        null,
        'Customer Tracker',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>Customer Tracker helps you improve your customer interactions by offering a centralized repository of information about your customers.</p>'||unistr('\000a')||
'<p>Each customer can have multiple contacts and be associated with multiple products.  Each contact has a variety of standard attributes, such as category, geography, industry and status, as well as the ability to add tags to a customer for further ad hoc classification.  You can indicate the reference status for a customer and enter free form text as a customer profile.</p>'||unistr('\000a')||
'<p>You can create activity records to log interactions with each customer.  Customer Tracker includes a variety of reports which let you view recent activities, status changes and tags.  You can also use interactive reports to give your users the ability to filter and shape customer, contact, activity and interaction data.</p>'||unistr('\000a')||
'<p>Customer Tracker gives you the ability to define your own standards for attributes such as categories, statuses, customer and activity types, and products, allowing you to create a customized version of Customer Tracker to meet your own needs.</p>',
        '<ul>'||unistr('\000a')||
'<li>New JET chart functionality</li>'||unistr('\000a')||
'<li>Getting Started Wizard</li>'||unistr('\000a')||
'<li>Sample data not installed by default</li>'||unistr('\000a')||
'<li>Greater use of modal dialogs</li>'||unistr('\000a')||
'<li>Improved user experience</li>'||unistr('\000a')||
'<li>Updated to latest Universal Theme</li>'||unistr('\000a')||
'<li>Responsiveness of desktop pages improved, Mobile pages removed</li>'||unistr('\000a')||
'<li>Extended functionality</li>'||unistr('\000a')||
'<li>General UI enhancements</li>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-customer-tracker',
        'AVAILABLE',
        '4.1.5',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '31',
        l_category_1,
        l_category_2,
        l_category_3,
        1856,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        143,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Home Page',
        'Screenshot showing the dashboard home page from Customer Tracker, where an overview of important application information is available, such as ''Customers'', ''Updates'' and ''Tags''.',
        'custtrack.png');

null;
end;
/
-- Package 7220, P-Track

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233010414713446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Project Management')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Team Productivity')
    loop
        l_category_2 := c2.id;
    end loop;

    for c3 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_3 := c3.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7220,
        7220,
        null,
        'P-Track',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>P-Track is an application that allows you to track the status of your projects over time.  </p><p>A project in P-Track has a number of attributes, including one or more owners, a status indication, and a set of milestones and action items.  You can submit status updates for a project and create status reports based on a selection of updates.  Projects are assigned to a category, and a project can be the parent of one or more child projects.  You can also add tags to a project to allow for more informal groups of projects.</p><p>All projects allow you to add annotations, such as links to other resources or files, to the project for consolidated access to all information relating to a project.</p><p>Each project has a set of milestones, which can be viewed in a report, a calendar view, or in a Gantt chart format.  </p><p>Each project has a set of action items, which can be viewed in a report or a calendar view.  P-Track includes a set of high level analysis reports on action items, for a quick review of assigned tasks.</p><p>P-Track also includes built-in integration with email.  You can request status updates through an email message, and team members who receive this type of message can directly update status, milestones or action items, as well as add annotations to a project.</p>',
        '<ul>'||unistr('\000a')||
'<li>Add tags to project updates, issues and links</li>'||unistr('\000a')||
'<li>Enhanced delete options when deleting Milestones with associated Action Items</li>'||unistr('\000a')||
'<li>Optional ability to specify a headline for a project</li>'||unistr('\000a')||
'<li>Additional optional people attributes including background checks, skill sets, team groups, and HIPPA certification attributes</li>'||unistr('\000a')||
'<li>General bug fixes including fixes to the display of Gantt charts</li>'||unistr('\000a')||
'<li>Improved build option management, build options are now organized by type</li>'||unistr('\000a')||
'<li>Ability to customize the label of categories; e.g. you can use application settings to set</li>'||unistr('\000a')||
'<li>New headlines report, click reports then headlines report; requires headlines build option to be enabled</li>'||unistr('\000a')||
'<li>New button links on home page to view dashboard and projects report</li>'||unistr('\000a')||
'<li>Milestone''s "Adjust Dates" functionality now allows for changing a milestone''s start date as well as its due date.</li>'||unistr('\000a')||
'<li>Flex Column form element''s label alignment fixed</li>'||unistr('\000a')||
'<li>Optional ability to specify a project logo image when editing a project</li>'||unistr('\000a')||
'<li>Action Item status color fixed in Milestones region of project details page</li>'||unistr('\000a')||
'<li>Link for personal Action Items fixed in cards view of home page</li>'||unistr('\000a')||
'<li>Issues no longer default owner to user currently logged in</li>'||unistr('\000a')||
'<li>Terse Past Due Action Items link fixed in project status email</li>'||unistr('\000a')||
'<li>Start dates can now be assigned to projects</li>'||unistr('\000a')||
'<li>An alternative help url can be defined as an administrative application setting. When defined, the new help link will appear in the bottom left-hand corner of the help modal window for all end-users to see.</li>'||unistr('\000a')||
'<li>Oracle Text based searching has been removed</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-p-track',
        'AVAILABLE',
        '6.4.7',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '101',
        l_category_1,
        l_category_2,
        l_category_3,
        150,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        233,
        null,
        'ptrack');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'P-Track Home Page',
        'Screenshot showing the dashboard home page from P-Track, where an overview of important application information is available, such as ''Project Milestones'', ''Recently Edited'' and ''Project Statuses''.',
        'ptrack1.png');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Project Details Page',
        'Screenshot showing project details, from P-Track.',
        'ptrack2.png');

null;
end;
/
-- Package 7230, Data Model Repository Viewer

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233010542483446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Software Development')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7230,
        7230,
        null,
        'Data Model Repository Viewer',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Set compatibility mode to 4.2</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        '',
        'HIDDEN',
        '',
        null,
        '1',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        null,
        '18.1',
        '',
        '',
        '',
        null,
        null,
        '');

null;
end;
/
-- Package 7240, Checklist Manager

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233010669900446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Team Productivity')
    loop
        l_category_2 := c2.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7240,
        7240,
        null,
        'Checklist Manager',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>Checklist Manager gives you a way to manage the components of a larger task.  A checklist contains multiple steps, and each step can be marked with different levels of completion.  With Checklist Manager, you can track your progress on any task, quickly and easily.</p><p>You can create a checklist type with a name and the items, or columns, which make up the overall checklist.  You define whether you want to allow partial completion of each item or simply mark them as complete when finished.  You can also add text fields for each checklist.</p><p>Once you define a checklist type, users can add checklists to the overall type.  Checklist Manager automatically tracks the completion of the overall task and of each item over all checklists, on the overview page of the checklist type.</p><p>You can drill down to an individual checklist, which can include columns which are not shown on the overview page, to display more detailed information on the checklist. </p><p>Checklist Manager supports different levels of privileges, including administrators, who can create checklist types, contributors, who can add checklists to a type, and users, who can view and modify existing checklists.</p>',
        '<ul>'||unistr('\000a')||
'<li>Getting Started Wizard</li>'||unistr('\000a')||
'<li>Sample data not installed by default</li>'||unistr('\000a')||
'<li>New Interactive Grid functionality</li>'||unistr('\000a')||
'<li>Greater use of modal dialogs</li>'||unistr('\000a')||
'<li>Improved user experience</li>'||unistr('\000a')||
'<li>Updated to latest Universal Theme</li>'||unistr('\000a')||
'<li>Responsiveness of desktop pages improved, Mobile pages removed</li>'||unistr('\000a')||
'<li>General UI enhancements</li>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-checklist-manager',
        'AVAILABLE',
        '2.1.2',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '26',
        l_category_1,
        l_category_2,
        l_category_3,
        576,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        58,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Checklist Manager',
        'Screenshot showing the main page for the ''Checklist Manager'', listing the available sample checklists.',
        'checklist.png');

null;
end;
/
-- Package 7250, Data Reporter

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233010711608446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Knowledge Management')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_2 := c2.id;
    end loop;

    for c3 in (select id from wwv_flow_pkg_app_categories where category_name =  'Project Management')
    loop
        l_category_3 := c3.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7250,
        7250,
        null,
        'Data Reporter',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>Data Reporter lets end-users easily create and share reports based on available data.  Data can be from your own SQL (Structured Query Language) select statements or from Data Sources.  Data Sources provide a way for more SQL-savvy users to pre-create queries based on available data including Websheet Data Grid data. Report types include Interactive, Calendar, Dashboard, and PDF and reports can link to each other (providing drill down capabilities) or to outside URLs.  Reports can be accessible to all or limited to a specific set of users.   Data can also be all accessible to the schema the application is installed in or you can create a whitelist to limit data access.</p>',
        '<ul>'||unistr('\000a')||
'<li>New JET chart functionality</li>'||unistr('\000a')||
'<li>Getting Started Wizard</li>'||unistr('\000a')||
'<li>Sample data not installed by default</li>'||unistr('\000a')||
'<li>Greater use of modal dialogs</li>'||unistr('\000a')||
'<li>Improved user experience</li>'||unistr('\000a')||
'<li>Updated to latest Universal Theme</li>'||unistr('\000a')||
'<li>Responsiveness of desktop pages improved, Mobile pages removed</li>'||unistr('\000a')||
'<li>General UI enhancements</li>'||unistr('\000a')||
'<li>Bug fixes</li>'||unistr('\000a')||
'<li>Performance improvements</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-data-reporter',
        'AVAILABLE',
        '2.2.9',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '22',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        135,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Data Reporter',
        'Screenshot showing the dashboard home page from Data Reporter, where an overview of important application information is available.',
        'data_reporter.png');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Data Reporter Filter Report',
        'Screenshot showing a sample Filter Report from Data Reporter.',
        'data_reporter2.png');

null;
end;
/
-- Package 7260, Application Standards Tracker

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233010810908446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Knowledge Management')
    loop
        l_category_2 := c2.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7260,
        7260,
        null,
        'Application Standards Tracker',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        'This application is designed to assist teams in developing applications which conform to a standard set of best practices. Developers can create tests against the Oracle Application Express (APEX) Data Dictionary for compliance, and group them into Standards; the tests are then run automatically against the registered applications.',
        '<ul>'||unistr('\000a')||
'<li>Getting Started Wizard</li>'||unistr('\000a')||
'<li>Sample data not installed by default</li>'||unistr('\000a')||
'<li>Greater use of modal dialogs</li>'||unistr('\000a')||
'<li>Improved user experience</li>'||unistr('\000a')||
'<li>Updated to latest Universal Theme</li>'||unistr('\000a')||
'<li>Responsiveness of desktop pages improved, Mobile pages removed</li>'||unistr('\000a')||
'<li>General UI enhancements</li>'||unistr('\000a')||
'<li>Bug fixes</li>'||unistr('\000a')||
'<li>Performance improvements</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-application-standards-tracker',
        'AVAILABLE',
        '2.1.6',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '17',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        46,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Application Standards Tracker Homepage',
        'Screenshot showing the dashboard home page for the Application Standards Tracker application, where information such as ''Total Applications'', ''All Standards'' and ''Standards with Automated Tests'' is available.',
        'standards_tester_app.png');

null;
end;
/
-- Package 7270, APEX Application Archive

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233010968549446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Software Development')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7270,
        7270,
        null,
        'APEX Application Archive',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>The APEX Application Archive makes it easy for you to archive your applications, providing safety for your work and productivity for your development efforts.</p>'||unistr('\000a')||
'<p>You can archive your Oracle Application Express applications into tables within your Database Cloud Service. Your archives can be full or incremental backups, and you can specify which applications should be included in either type of backup.  You can restore any application from any archive or download the application through the Application Archive.</p>'||unistr('\000a')||
'<p>You can easily see all of your archives and drill down to see the applications included in the archive.  You can restore individual applications from any archive.  The APEX Application Archive automatically tracks application versions and gives you a high level view showing when each of your apps has been most recently backed up.</p>'||unistr('\000a')||
'<p>The APEX Application Archive lets you specify the number of version you want to keep of any application and to purge older application versions.  You can also search your archives and report on their contents.</p>'||unistr('\000a')||
'<p>By keeping your archives in database tables, the APEX Application Archive insures that your applications will be backed up just like your data.  By automating the backup process, the APEX Application Archive makes it easy for you to keep multiple versions of your applications, increasing your flexibility without impacting your productivity.</p>',
        '<ul>'||unistr('\000a')||
'<li>Getting Started Wizard</li>'||unistr('\000a')||
'<li>Sample data not installed by default</li>'||unistr('\000a')||
'<li>Greater use of modal dialogs</li>'||unistr('\000a')||
'<li>Improved user experience</li>'||unistr('\000a')||
'<li>Updated to latest Universal Theme</li>'||unistr('\000a')||
'<li>Responsiveness of desktop pages improved, Mobile pages removed</li>'||unistr('\000a')||
'<li>General UI enhancements</li>'||unistr('\000a')||
'<li>Bug fixes</li>'||unistr('\000a')||
'<li>Performance improvements</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-apex-application-archive',
        'AVAILABLE',
        '2.0.9',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '14',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        48,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Application Archive',
        'Screenshot showing the dashboard home page from Application Archive, where an overview of important application information is available, such as ''Recent Activity'' and ''Archive Repository History''.',
        'archive_sample.png');

null;
end;
/
-- Package 7280, Survey Builder

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233011093111446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Knowledge Management')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Marketing')
    loop
        l_category_2 := c2.id;
    end loop;

    for c3 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_3 := c3.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7280,
        7280,
        null,
        'Survey Builder',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>Survey Builder manages the process of conducting survey research.  It provides a simple user interface for creating great looking web based questionnaires, supporting both random sample and self selected survey types. There are a number of options to control the style and format of the questionnaires which work on a wide range of browsers on mobile, tablet, and desktop platforms. Survey builder can distribute the questionnaire by sending a URL to the questionnaire via email. It can also send reminder and thank you emails.  Once your survey is complete, you can use the included reports to review the results and download for further analysis.'||unistr('\000a')||
'</p>',
        '<ul>'||unistr('\000a')||
'<li>New JET chart functionality</li>'||unistr('\000a')||
'<li>Greater use of modal dialogs</li>'||unistr('\000a')||
'<li>Improved user experience</li>'||unistr('\000a')||
'<li>Updated to latest Universal Theme</li>'||unistr('\000a')||
'<li>Getting Started Wizard</li>'||unistr('\000a')||
'<li>Sample data not installed by default</li>'||unistr('\000a')||
'<li>General UI enhancements</li>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-survey-builder',
        'AVAILABLE',
        '2.1.4',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '23',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        96,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Survey Builder',
        'Screenshot showing the Questionnaire page from Survey Builder, displaying a number of questions and possible answers for a sample questionnaire, and application options to allow the editing or creation of questions and answers for the questionnaire.',
        'survey_builder.png');

null;
end;
/
-- Package 7290, Meeting Minutes

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233011161278446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Team Productivity')
    loop
        l_category_2 := c2.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7290,
        7290,
        null,
        'Meeting Minutes',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>'||unistr('\000a')||
'      The "Meeting Minutes" application is used to store meeting agenda information for a meeting organizer, assigned presenters, and other attendees.'||unistr('\000a')||
'    </p>'||unistr('\000a')||
'    <p>'||unistr('\000a')||
'      It is a collaborative environment for meeting participants to simultaneously review agenda items, and add relevant attachment files, action items, decisions, and/or notes.'||unistr('\000a')||
'    </p>'||unistr('\000a')||
'    <p>'||unistr('\000a')||
'      Each meeting will always contain:'||unistr('\000a')||
'      <ul>'||unistr('\000a')||
'        <li>Details (name, description, start and end times, location, etc...)</li>'||unistr('\000a')||
'        <li>Agenda</li>'||unistr('\000a')||
'        <li>Organizer</li>'||unistr('\000a')||
'      </ul>'||unistr('\000a')||
'    </p>'||unistr('\000a')||
''||unistr('\000a')||
'    <p>'||unistr('\000a')||
'      Each meeting may also contain:'||unistr('\000a')||
'      <ul>'||unistr('\000a')||
'        <li>Presenters</li>'||unistr('\000a')||
'        <li>Attendees</li>'||unistr('\000a')||
'        <li>Attachments</li>'||unistr('\000a')||
'        <li>Action Items</li>'||unistr('\000a')||
'        <li>Decisions</li>'||unistr('\000a')||
'        <li>Notes</li>'||unistr('\000a')||
'      </ul>'||unistr('\000a')||
'    </p>',
        '<ul>'||unistr('\000a')||
'<li>Getting Started Wizard</li>'||unistr('\000a')||
'<li>Sample data not installed by default</li>'||unistr('\000a')||
'<li>Updated to latest Universal Theme</li>'||unistr('\000a')||
'<li>Greater use of modal dialogs</li>'||unistr('\000a')||
'<li>Improved user experience</li>'||unistr('\000a')||
'<li>Responsiveness of desktop pages improved, Mobile pages removed</li>'||unistr('\000a')||
'<li>General UI enhancements</li>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-meeting-minutes',
        'AVAILABLE',
        '1.1.3',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '16',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        40,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Home Page',
        'Screenshot showing a breakdown of meetings, in the Meeting Minutes application.',
        'meeting_minutes.png');

null;
end;
/
-- Package 7340, Live Poll

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233011275172446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Marketing')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Tracking')
    loop
        l_category_2 := c2.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7340,
        7340,
        null,
        'Live Poll',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>This application allows you to conduct a simple poll or quiz.  Results of the poll or quiz can be displayed in real time.  You can use live poll during meetings or presentations to get instant feedback and to facilitate discussions.</p>',
        '<ul>'||unistr('\000a')||
'<li>Getting Started Wizard</li>'||unistr('\000a')||
'<li>Sample data not installed by default</li>'||unistr('\000a')||
'<li>Updated to latest Universal Theme</li>'||unistr('\000a')||
'<li>New publish poll wizard</li>'||unistr('\000a')||
'<li>Support for unauthenticated polls with attribution</li>'||unistr('\000a')||
'<li>Greater use of modal dialogs</li>'||unistr('\000a')||
'<li>General UI enhancements</li>'||unistr('\000a')||
'<li>Improved user experience</li>'||unistr('\000a')||
'<li>Responsiveness of desktop pages improved, Mobile pages removed</li>'||unistr('\000a')||
'<li>Bug fixes</li>'||unistr('\000a')||
'<li>Performance improvements</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-live-poll',
        'AVAILABLE',
        '3.2.2',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '27',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        106,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Live Poll',
        'Screenshot showing the results for a sample poll conducted with Live Poll, where information such as total number of responses, and a visual representation of the responses to two questions is available.'||unistr('\000a')||
'',
        'live_poll.png');

null;
end;
/
-- Package 7600, Sample Access Control

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233011354766446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7600,
        7600,
        null,
        'Sample Access Control',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Set compatibility mode to 4.2</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-access-control',
        'HIDDEN',
        '',
        null,
        '1',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        null,
        '18.1',
        '',
        '',
        '',
        null,
        null,
        '');

null;
end;
/
-- Package 7610, Sample Build Options

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233011473595446042;

    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7610,
        7610,
        null,
        'Sample Build Options',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Set compatibility mode to 4.2</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-build-options',
        'HIDDEN',
        '',
        null,
        '1',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        null,
        '18.1',
        '',
        '',
        '',
        null,
        null,
        '');

null;
end;
/
-- Package 7800, Brookstrut Sample Application

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233011555157446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7800,
        7800,
        null,
        'Brookstrut Sample Application',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>This application is a hyper simplified retail sales analysis portal designed to illustrate and highlight various Oracle Application Express capabilities including integration with Google Maps.  Use this application to generate random sales transaction data and visualize this information on maps, reports, and charts.</p>',
        '<ul>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-sample-brookstrut',
        'AVAILABLE',
        '1.1.10',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '13',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        45,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Brookstrut Sample Application',
        'Screenshot showing the Sales Dashboard page from the Brookstrut Sample Application, where information such as regional and annual sales figures, and a regional ''Sales'' area chart are available.',
        'brookstrut_sample_app.png');

null;
end;
/
-- Package 7810, Sample Reporting

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233011606441446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7810,
        7810,
        null,
        'Sample Reporting',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>This application highlights the two primary reporting engines of Oracle Application Express Interactive Reports and Classic Reports. The interactive report sample pages highlight the following declarative features</p>'||unistr('\000a')||
'<ul>'||unistr('\000a')||
'<li>column filtering</li>'||unistr('\000a')||
'<li>column sorting</li>'||unistr('\000a')||
'<li>row high lighting</li>'||unistr('\000a')||
'<li>drill down reporting</li>'||unistr('\000a')||
'<li>saved reports</li>'||unistr('\000a')||
'<li>report column selection</li>'||unistr('\000a')||
'<li>row and detail views</li>'||unistr('\000a')||
'<li>column formatting</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'<br />'||unistr('\000a')||
'<p>The classic report sample pages highlight:</p>'||unistr('\000a')||
'<ul>'||unistr('\000a')||
'<li>row linking</li>'||unistr('\000a')||
'<li>column formatting</li>'||unistr('\000a')||
'<li>column sorting</li>'||unistr('\000a')||
'<li>referencing field values in report SQL using bind variables</li>'||unistr('\000a')||
'</ul>',
        '<ul>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-sample-reporting',
        'AVAILABLE',
        '1.2.24',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '17',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        39,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Reporting',
        'Screenshot showing an Interactive Report page in the Sample Reporting application.',
        'reporting_sample.png');

null;
end;
/
-- Package 7820, Sample Calendar

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233011770622446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7820,
        7820,
        null,
        'Sample Calendar',
        'SAMPLE',
        'DB',
        '11.1',
        'Y',
        '<p>This application highlights the native calendaring capabilities of Oracle Application Express.  It features a monthly calendar with stylized daily tasks.  The dates can be changed using drag and drop, which is all declarative and easily created using native Application Express wizards.  The calendar also features custom PL/SQL calendar control examples that show data in a vertical timeline, as well as a CSS Gantt chart also based on PL/SQL code.</p><p>Use this application to familiarize yourself with monthly calendars, drag and drop, monthly calendar styling, and custom PL/SQL driven calendar rendering techniques.  The CSS required is included in the "HTML Header" attribute of each page.  This makes the CSS easy to integrate into your own application.</p>',
        '<ul>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-sample-calendar',
        'AVAILABLE',
        '1.2.5',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '17',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        36,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Calendar',
        'Screenshot showing a monthly calendar page in the Sample Calendar application.',
        'calendar_sample.png');

null;
end;
/
-- Package 7830, Sample Charts

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233011819691446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7830,
        7830,
        null,
        'Sample Charts',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>This application highlights the charting capabilities of Oracle Application Express (APEX). It demonstrates how you can enhance your applications to visually represent your data, using declarative and plug-in based charting solutions. Supported chart types include Area, Bar, Box Plot, Bubble, Combination, Donut, Dial, Funnel, Gantt, Line, Line with Area, Pie, Polar, Pyramid, Radar, Range, Stock, and Scatter. It features a number of our new native charts, based on Oracle JavaScript Extension Toolkit (JET) Data Visualizations. The charts can be easily created and modified using native Oracle APEX wizards. Chart attributes such as color, formatting, axes and legend settings can be easily modified to suit your requirements. This application also contains a number of plug-in based alternative charting solutions.</p><p>Use this application to familiarize yourself with the various charting options available.',
        '<ul>'||unistr('\000a')||
'<li>Examples of our new native charts, based on Oracle JavaScript Extension Toolkit(JET)</li>'||unistr('\000a')||
'<li>New Oracle JET Legend plug-in</li>'||unistr('\000a')||
'<li>New examples demonstrating new data densification handling of multi-series charts with differing series lengths</li>'||unistr('\000a')||
'<li>New Reference page, to easily browse for specific examples such as Dynamic Action examples, and custom JavaScript Code</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-charts',
        'AVAILABLE',
        '1.0.32',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '27',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        44,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Charts',
        'Screenshot showing a chart page with a combination chart, where 2 data series are displayed in an ''Annual Stock Valuations'' chart, from the Sample Charts application.',
        'chart_sample.png');

null;
end;
/
-- Package 7840, Sample Dynamic Actions

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233011957938446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7840,
        7840,
        null,
        'Sample Dynamic Actions',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>This application demonstrates a number of different dynamic actions that can be incorporated into an application. These declarative client-side behaviors include simple examples for manipulating the display of components, style examples for changing the appearance of components, and server-side examples which interact with the database. Some of the examples include plug-ins which further extend the capabilities of dynamic actions.</p>',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-dynamic-actions',
        'AVAILABLE',
        '1.0.16',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '16',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        27,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Dynamic Actions',
        'Screenshot showing a sample report page, from the Dynamic Actions sample application.',
        'dyn_actions_sample.png');

null;
end;
/
-- Package 7850, Sample Data Loading

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233012007164446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7850,
        7850,
        null,
        'Sample Data Loading',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>The data loading sample application is built on simple EMP and DEPT tables to highlight how developers can define pages to allow end users to upload spreadsheet data into an existing table. The example includes column lookups on the Manager and Department columns such that the users can specify names instead of numbers when uploading. For example, the end user would know an employee belongs to the Accounting department but may not know that Accounting is department number 10. Similarly instead of specify a manager as employee number 7839 they can specify the employee name of King.</p>',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-data-loading',
        'AVAILABLE',
        '1.0.14',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '14',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        10,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Data Loading',
        'Screenshot showing the 1st page of a data load wizard where the user selects the ''Data Load Source'', from the Sample Data Loading application.',
        'data_load_sample.png');

null;
end;
/
-- Package 7860, Sample Master Detail

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233012108231446042;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7860,
        7860,
        null,
        'Sample Master Detail',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>This application highlights the native master detail capabilities of Oracle Application Express.  The application contains four different master detail page layouts.  The first two layouts display master detail in a single page using editable Interactive Grids.  You can build unlimited level of master detail layouts of any complexity using Interactive Grids.   The user has option of interacting with either the master or the detail without leaving the page.  The last two layouts display master detail in two pages with mix of editable Interactive Grids, form items, classic reports and modal popups.  Use this application to better understand the native and declarative master detail functionality of Oracle Application Express.</p>',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-master-detail',
        'AVAILABLE',
        '1.1.3',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '19',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        34,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Master Detail',
        'Screenshot showing master detail in multiple different page layouts, where master ''Project" information and its detail table rows can be edited, in the Sample Master Detail application.',
        'md_sample.png');

null;
end;
/
-- Package 7870, Sample Projects

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233012267171446043;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7870,
        7870,
        null,
        'Sample Projects',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>The Sample Projects application is an application that highlights the new features in Oracle Application Express 18.1, such as Interactive Grid and JET charts. It includes dedicated pages for team members, projects, milestones, tasks, attachment, and links, as well as demonstrating the use of reports, charts, calendar, map, and tree.<p>',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-sample-projects',
        'AVAILABLE',
        '1.0.7',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '8',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        42,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Projects',
        'Screenshot showing the Home page for the ''Sample Projects'', listing the available sample options such as ''Recent Projects'', and ''My Outstanding Tasks'' are available.',
        'projects_sample.png');

null;
end;
/
-- Package 7880, Sample Interactive Grids

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233012320849446043;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7880,
        7880,
        null,
        'Sample Interactive Grids',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>This application highlights the features and functionality of the new Oracle Application Express Interactive Grid. The interactive grid sample pages highlight the following declarative features</p>'||unistr('\000a')||
'<ul>'||unistr('\000a')||
'<li>Reporting capabilities</li>'||unistr('\000a')||
'<li>Pagination options</li>'||unistr('\000a')||
'<li>Editing capabilities</li>'||unistr('\000a')||
'<li>Advanced techniques</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'<br />',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-ig',
        'AVAILABLE',
        '1.0.4',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '7',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        48,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Interactive Grids',
        'Screenshot showing the Home page for the ''Sample Interactive Grids'', listing the available sample options such as ''Read Only Reports'', ''Pagination'', and ''Editing'' are available.',
        'ig_sample.png');

null;
end;
/
-- Package 7900, Sample Dialog

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233012423152446045;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7900,
        7900,
        null,
        'Sample Dialog',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>See how you can leverage jQuery to launch basic, model, and stylized dialogs from within Oracle Application Express.  View the sample dialogs and see and copy the implemenation.</p>',
        '<ul>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-dialog',
        'AVAILABLE',
        '1.0.12',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '14',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        11,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Dialog',
        'Screenshot showing a sample modal dialog used to edit simple ''Department'' information, from the Sample Dialog application.',
        'sample_dialog.png');

null;
end;
/
-- Package 7910, Sample Trees

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233012594455446045;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7910,
        7910,
        null,
        'Sample Trees',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>Learn how to create a tree control using a SQL query.  This application shows various methods of integrating tree controls into your Oracle Application Express application.</p>',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-trees',
        'AVAILABLE',
        '1.0.14',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '13',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        11,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Trees',
        'Screenshot showing a tree page containing ''Project'' tree nodes and ''Task'' and ''Subtask'' leaf nodes under these ''Projects'', from the Sample Trees application.',
        'sample_trees.png');

null;
end;
/
-- Package 7930, Sample REST Services

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233012671810446045;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7930,
        7930,
        null,
        'Sample REST Services',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>This application showcases how to access external REST services from Oracle Application Express pages. The pages work on the sample RESTful Service, oracle.example.hr. The examples in this application illustrate how to create a simple tabular report on REST service data, how to filter, and how to add pagination. REST data can also be downloaded and staged into a local table for further processing, analysis and usage in Oracle Application Express components.'||unistr('\000a')||
'</p>'||unistr('\000a')||
'<br />'||unistr('\000a')||
'<p><b>Pre-requisites</b></p>'||unistr('\000a')||
'<p>To successfully run this application, the following pre-requisites must be met:</p>'||unistr('\000a')||
'<ul>'||unistr('\000a')||
'<li>RESTful Services must be configured on the instance.  To learn more, see the <a href="http://www.oracle.com/technetwork/developer-tools/apex/documentation/index.html">Oracle Application Express Installation Guide</a>.</li>'||unistr('\000a')||
'<li>Network Services must be enabled in the database.  To learn more, see <b>Enable Network Services in Oracle Database 11g</b> in the <a href="http://www.oracle.com/technetwork/developer-tools/apex/documentation/index.html">Oracle Application Express Installation Guide</a>.</li>'||unistr('\000a')||
'<li>''Enable RESTful Services'' must be set to ''Yes'' at both instance and workspace level.  See <i>Administration > Manage Instance > Feature Configuration</i>.</li>'||unistr('\000a')||
'<li>''Allow RESTful Access'' must be set to ''Yes'' at instance level.  To learn more, see <b>Controlling RESTful Access</b> in the <a href="http://www.oracle.com/technetwork/developer-tools/apex/documentation/index.html">Oracle Application Express Installation Guide</a></li>'||unistr('\000a')||
'<li>The sample RESTful service, oracle.example.hr, must be installed. To install, go to <strong>SQL Workshop > RESTful Services > Reset Sample Data</strong>.</li>'||unistr('\000a')||
'</ul>',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-restful-services',
        'AVAILABLE',
        '2.0.1',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '8',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        19,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample REST Services',
        '',
        'sample_restful_services.png');

null;
end;
/
-- Package 7940, Sample Collections

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233012730508446045;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7940,
        7940,
        null,
        'Sample Collections',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>Sample Collections enables you to store rows of data for use within a Oracle Application Express session. This database application illustrates how to use PL/SQL to create and manage collection-based session state.<p>',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-collections',
        'AVAILABLE',
        '1.1.11',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '14',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        14,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample Collections',
        'Sample Collections',
        'sample_collections.png');

null;
end;
/
-- Package 7950, Sample Timezone

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233012830963446045;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7950,
        7950,
        null,
        'Sample Timezone',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Set compatibility mode to 4.2</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-timezone',
        'HIDDEN',
        '',
        null,
        '1',
        l_category_1,
        l_category_2,
        l_category_3,
        null,
        'English',
        null,
        '18.1',
        '',
        '',
        '',
        null,
        null,
        '');

null;
end;
/
-- Package 7960, Sample File Upload and Download

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233012950966446045;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7960,
        7960,
        null,
        'Sample File Upload and Download',
        'SAMPLE',
        'DB',
        '11.1',
        'Y',
        '<p>Learn how to create Oracle Application Express applications that include file upload and download. Upload files using dialogs as well as dedicated pages. See how to download files stored in Oracle database BLOB columns within database tables. Specifically see how to produce file download links from interactive reports, classic reports, forms, and dynamically created HTML content.</p>',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-file-upload-download',
        'AVAILABLE',
        '2.0.7',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '15',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        13,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Sample File Upload and Download',
        'Screenshot showing a dashboard page with ''Project Summary'' information, and any recent files relating to that ''Project'' with a link to download those files, from the Sample File Upload and Download application.',
        'sample_file.png');

null;
end;
/
-- Package 7980, REST Client Assistant

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233013052154446045;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'IT Management')
    loop
        l_category_1 := c1.id;
    end loop;

    for c2 in (select id from wwv_flow_pkg_app_categories where category_name =  'Software Development')
    loop
        l_category_2 := c2.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        7980,
        7980,
        null,
        'REST Client Assistant',
        'PACKAGE',
        'DB',
        '11.2',
        'Y',
        '<p>This application highlights the RESTful Service capabilities of Oracle Application Express. This application enables you to access RESTful services defined in your workspace as well as public services. The application provides metadata-driven mapping from service response data to SQL result set columns. Generated SQL and PL/SQL code can be and used in own applications.</p>'||unistr('\000a')||
'<br />'||unistr('\000a')||
'<p><b>Pre-requisites</b></p>'||unistr('\000a')||
'<p>To successfully run this application, the following pre-requisites must be met:</p>'||unistr('\000a')||
'<ol>'||unistr('\000a')||
'<li>RESTful Services must be configured on the instance.  To learn more, see the <a href="http://www.oracle.com/technetwork/developer-tools/apex/documentation/index.html">Oracle Application Express Installation Guide</a>.</li>'||unistr('\000a')||
'<li>Network Services must be enabled in the database.  To learn more, see <b>Enable Network Services in Oracle Database 11g</b> in the <a href="http://www.oracle.com/technetwork/developer-tools/apex/documentation/index.html">Oracle Application Express Installation Guide</a>.</li>'||unistr('\000a')||
'<li>''Enable RESTful Services'' must be set to ''Yes'' at both instance and workspace level.  See <i>Administration > Manage Instance > Feature Configuration</i>.</li>'||unistr('\000a')||
'<li>''Allow RESTful Access'' must be set to ''Yes'' at instance level.  To learn more, see <b>Controlling RESTful Access</b> in the <a href="http://www.oracle.com/technetwork/developer-tools/apex/documentation/index.html">Oracle Application Express Installation Guide</a></li>'||unistr('\000a')||
'</ol>',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'</ul>',
        '',
        'app-restful-services',
        'HIDDEN',
        '1.0.4',
        to_date('20170608000000','YYYYMMDDHH24MISS'),
        '5',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20170608000000','YYYYMMDDHH24MISS'),
        '18.1',
        'Oracle',
        '',
        'http://www.oracle.com',
        23,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Developers'' RESTful Service Assistant',
        'Screenshot showing a page from the Developers'' RESTful Service Assistant application.',
        'restful_services.png');

null;
end;
/
-- Package 8940, Universal Theme Sample Application

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233013165863446045;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        8940,
        8940,
        null,
        'Universal Theme Sample Application',
        'SAMPLE',
        'DB',
        '11.2',
        'Y',
        '<p>Universal Theme is an all-new user interface for your Application Express apps. This app introduces you to Universal Theme by providing an easy way to browse through the various templates, template options, and theme styles.</p>'||unistr('\000a')||
'<p>Install this application to view all the component templates that can be incorporated into an application with the new theme.  The examples demonstrate how you can easily control the layout of your pages, to create a great looking application.</p>',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-universal-theme',
        'AVAILABLE',
        '1.2.0.0.5',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '15',
        l_category_1,
        l_category_2,
        l_category_3,
        0,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        125,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Universal Theme Sample Application',
        'Application homepage introducing the Universal Theme and how to best use it.',
        'universal_theme_app.png');

null;
end;
/
-- Package 8950, Sample Database Application

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233013223032446045;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        change_log,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        8950,
        8950,
        null,
        'Sample Database Application',
        'SAMPLE',
        'DB',
        '11.1',
        'Y',
        '<p>The Sample Database Application is an application that highlights common design concepts. It includes dedicated pages for customers, products, and orders as well as demonstrates the use of reports, charts, calendar, map, and tree.<p>',
        '<ul>'||unistr('\000a')||
'<li>Bug fixes and minor functional improvements</li>'||unistr('\000a')||
'<li>Universal Theme refreshed</li>'||unistr('\000a')||
'<li>Requires Oracle APEX 18.2 or greater</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'',
        '',
        'app-sample-database-application',
        'AVAILABLE',
        '18.2',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '22',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        44,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Product Portal',
        'Product Portal',
        'product_portal.png');

null;
end;
/
-- Package 1097894920371103914, Sample Websheet - AnyCo IT Department

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233013367055446046;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        1097894920371103914,
        null,
        1097894920371103914,
        'Sample Websheet - AnyCo IT Department',
        'SAMPLE',
        'WS',
        '11.2',
        'Y',
        '<p>AnyCo IT Department highlights how to use the features and capabilities of Websheets for Web-based content sharing and reporting on business critical data. This sample Websheet application contains several data grids and demonstrates how to include data in embedded reports and charts.<p>',
        '',
        'app-websheet-any-co',
        'AVAILABLE',
        'anyco_it 18.2',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '6',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        6,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'AnyCo IT Department',
        'AnyCo IT Department',
        'anyco_it.png');

null;
end;
/
-- Package 1097895031667104017, Sample Websheet Application - Big Cats

declare
    l_id number         := null;
    l_category_1 number := null;
    l_category_2 number := null;
    l_category_3 number := null;
begin
    l_id := 233013491414446046;
    for c1 in (select id from wwv_flow_pkg_app_categories where category_name =  'Sample')
    loop
        l_category_1 := c1.id;
    end loop;


    insert into wwv_flow_pkg_applications (
        id,
        app_id,
        apex_application_id,
        apex_websheet_id,
        app_name,
        app_group,
        app_type,
        min_db_version,
        unlock_allowed,
        app_description,
        tags,
        image_identifier,
        app_status,
        app_display_version,
        app_version_date,
        build_version,
        app_category_id_1,
        app_category_id_2,
        app_category_id_3,
        required_free_kb,
        languages,
        released,
        min_apex_version,
        provider_company,
        provider_email,
        provider_website,
        app_page_count,
        app_object_count,
        app_object_prefix)
    values (
        l_id,
        1097895031667104017,
        null,
        1097895031667104017,
        'Sample Websheet Application - Big Cats',
        'SAMPLE',
        'WS',
        '11.2',
        'Y',
        '<p>Big Cats highlights many features and capabilities of Websheets, including embedding images and page links.<p>',
        '',
        'app-websheet-big-cats',
        'AVAILABLE',
        'big_cats 18.2',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '6',
        l_category_1,
        l_category_2,
        l_category_3,
        100,
        'English',
        to_date('20180907000000','YYYYMMDDHH24MISS'),
        '18.2',
        'Oracle',
        '',
        'http://oracle.com',
        10,
        null,
        '');

-- Application Image

    insert into wwv_flow_pkg_app_images (
        app_id,
        title,
        description,
        file_name)
    values (
        l_id,
        'Big Cats',
        'Big Cats',
        'big_cats.png');

null;
end;
/
commit;

begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
prompt ...done

