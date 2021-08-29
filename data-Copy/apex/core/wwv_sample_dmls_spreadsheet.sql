Rem  Copyright (c) Oracle Corporation 2010 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      wwv_sample_dmls_spreadsheet.sql
Rem
Rem    DESCRIPTION
Rem      Insert Sample datasets during APEX installation
Rem
Rem    IMPORTANT: If DML lengh > 4000, DML cannot exceed 255 chars per line.
Rem               When DML > 4000, install uses varchar2 255 array to execute DDL.
Rem

Rem    MODIFIED     (MM/DD/YYYY)
Rem    dpeake       01/10/2018 - Created
Rem    dpeake       01/26/2018 - Changed table name to TASKS_SS
Rem    dpeake       07/18/2018 - Added inserts into JSON Table (Feature #2365)
Rem    dpeake       08/03/2018 - Remove Globalizations from JSON (Feature #2365)

set define '^'
prompt ...Application Express Sample installation of datasets

prompt
prompt ...insert into wwv_sample_dmls - Spreadsheet Data
prompt

declare
  l_clob clob;
begin
    -- Insert into JSON Table
    delete from wwv_sample_json
    where wwv_sample_dataset_id = 4;

   l_clob :=q'~{
        "application": {
        "name": "Demonstration - Tasks Spreadsheet",
        "appShortDescription": "Generated based on a Sample Dataset!",
        "appDescription": "This application was generated directly from Sample Datasets. Go to SQL Workshop > Utilities > Sample Datasets to install tables, complete with meaningful data, and then create an application based on those tables.",
          "features": {
            "accessControl": true,
            "activityReporting": true,
            "configurationOptions": true,
            "feedback": true,
            "helpPages": true,
            "themeSelection": true
            },
          "appearance": {
            "themeStyle": "Vita",
            "navigation": "SIDE",
            "icon": "app-icon-todo",
            "iconBackgroundClass": "app-color-7",
            "iconColorHEX": "#5A68AD"
            },
          "settings": {
            "baseTablePrefix": "SAMPLE$",
            "primaryLanguage": "en",
            "authentication": "Application Express"
            },
          "pages": [
            {
              "page": "1",
              "pageType": "blank",
              "pageName": "Home",
              "pageIcon": "fa-home",
              "pageIsHomePage": true,
              "help": ""
            }
            ,
            {
              "page": "2",
              "pageType": "dashboard",
              "pageName": "Dashboard",
              "pageIcon": "fa-dashboard",
              "help": "",
              "dashboardWidgets": [
              {
                "name": "Project Statuses",
                "type": "pie",
                "table": "SAMPLE$TASKS_SS",
                "labelColumn": "STATUS",
                "valueColumn": "allColumns",
                "valueDerivation": "count"
              }
              ,
              {
                "name": "Project Assignments",
                "type": "bar",
                "table": "SAMPLE$TASKS_SS",
                "labelColumn": "ASSIGNED_TO",
                "valueColumn": "allColumns",
                "valueDerivation": "count"
              }
              ,
              {
                "name": "Project Budgets",
                "type": "bar",
                "table": "SAMPLE$TASKS_SS",
                "labelColumn": "PROJECT",
                "valueColumn": "BUDGET",
                "valueDerivation": "sum"
              }
              ,
              {
                "name": "Project Costs",
                "type": "bar",
                "table": "SAMPLE$TASKS_SS",
                "labelColumn": "PROJECT",
                "valueColumn": "COST",
                "valueDerivation": "sum"
              }
              ]
            }
            ,
            {
              "page": "3",
              "pageType": "calendar",
              "pageName": "Calendar",
              "pageIcon": "fa-calendar-o",
              "table": "SAMPLE$TASKS_SS",
              "calendarDisplayColumn": "TASK_NAME",
              "calendarDateColumnStart": "START_DATE",
              "calendarDateColumnEnd": "END_DATE",
              "calendarShowTime": "N",
              "help": ""
            }
            ,
            {
              "page": "4",
              "pageType": "interactiveReport",
              "pageName": "Tasks",
              "pageIcon": "fa-table",
              "reportImplementation": "TABLE",
              "table": "SAMPLE$TASKS_SS",
              "includeFormWithReport": true,
              "help": ""
            }
            ],
          "generalSettings": {
            "learnAppDefaults": false,
            "version": "Release 1.0",
            "logging": true,
            "debugging": true
            },
          "securitySettings": {
            "deepLinking": false,
            "maximumSessionSeconds": "",
            "maximumSessionIdleSeconds": ""
            }
          }
        }~';

    insert into wwv_sample_json (wwv_sample_dataset_id, language_cd, create_app_wizard_json) 
    values (  4, 'en', l_clob); 

    commit;

    -- Insert into DML Table
    delete from wwv_sample_dmls
    where wwv_sample_dataset_id = 4;

   l_clob :=q'~begin     
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('ACME Web Express Configuration','Identify server requirements',to_date('12/20/2017','MM/DD/YYYY'),to_date('12/21/2017','MM/DD/YYYY'),'Closed','John Watson','200','500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('ACME Web Express Configuration','Determine Web listener configuration(s)',to_date('12/22/2017','MM/DD/YYYY'),to_date('12/22/2017','MM/DD/YYYY'),'Closed','James Cassidy','600','500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('ACME Web Express Configuration','Run installation',to_date('12/25/2017','MM/DD/YYYY'),to_date('12/25/2017','MM/DD/YYYY'),'Closed','James Cassidy','200','200');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('ACME Web Express Configuration','Create pilot workspace',to_date('12/27/2017','MM/DD/YYYY'),to_date('12/27/2017','MM/DD/YYYY'),'Closed','John Watson','100','100');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget)
        values ('ACME Web Express Configuration','Specify security authentication scheme(s)',to_date('01/01/2018','MM/DD/YYYY'),to_date('01/01/2018','MM/DD/YYYY'),'Open','John Watson','200','300');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('ACME Web Express Configuration','Configure Workspace provisioning',to_date('01/02/2018','MM/DD/YYYY'),to_date('01/02/2018','MM/DD/YYYY'),'Open','John Watson','200','100');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('ACME Web Express Configuration','Select servers for Development, Test, Production',to_date('01/05/2018','MM/DD/YYYY'),to_date('01/07/2018','MM/DD/YYYY'),'Open','James Cassidy','200','600');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Bug Tracker','Document quality assurance procedures',to_date('11/05/2017','MM/DD/YYYY'),to_date('11/08/2017','MM/DD/YYYY'),'Closed','Myra Sutcliff','3000','2000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Bug Tracker','Review automated testing tools',to_date('11/09/2017','MM/DD/YYYY'),to_date('11/11/2017','MM/DD/YYYY'),'Closed','Myra Sutcliff','750','1500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Bug Tracker','Implement bug tracking software',to_date('11/24/2017','MM/DD/YYYY'),to_date('11/24/2017','MM/DD/YYYY'),'Closed','Myra Sutcliff','100','100');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Bug Tracker','Train developers on tracking bugs',to_date('12/01/2017','MM/DD/YYYY'),to_date('12/06/2017','MM/DD/YYYY'),'On-Hold','Myra Sutcliff','1000','2000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Bug Tracker','Measure effectiveness of improved QA',to_date('12/13/2017','MM/DD/YYYY'),to_date('12/13/2017','MM/DD/YYYY'),'Pending','Myra Sutcliff','0','500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Convert Spreadsheets','Collect mission-critical spreadsheets',to_date('12/19/2017','MM/DD/YYYY'),to_date('12/20/2017','MM/DD/YYYY'),'Closed','Pam King','2500','4000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Convert Spreadsheets','Lock spreadsheets',to_date('12/22/2017','MM/DD/YYYY'),to_date('12/22/2017','MM/DD/YYYY'),'Closed','Pam King','300','800');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Convert Spreadsheets','Create ACME Web Express applications from spreadsheets',to_date('12/30/2017','MM/DD/YYYY'),to_date('01/03/2018','MM/DD/YYYY'),'Open','Pam King','6000','10000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Convert Spreadsheets','Send links to previous spreadsheet owners',to_date('01/05/2018','MM/DD/YYYY'),to_date('01/05/2018','MM/DD/YYYY'),'Pending','Pam King','0','500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Discussion Forum','Identify owners',to_date('11/25/2017','MM/DD/YYYY'),to_date('11/25/2017','MM/DD/YYYY'),'Closed','Hank Davis','250','300');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Discussion Forum','Install ACME Web Express application on internet server',to_date('12/01/2017','MM/DD/YYYY'),to_date('12/01/2017','MM/DD/YYYY'),'Closed','Hank Davis','100','100');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Discussion Forum','Monitor participation',to_date('12/31/2017','MM/DD/YYYY'),to_date('01/01/2018','MM/DD/YYYY'),'Open','Hank Davis','450','500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Email Integration','Complete plan',to_date('12/12/2017','MM/DD/YYYY'),to_date('12/13/2017','MM/DD/YYYY'),'Closed','Bob Nile','3000','1500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Email Integration','Check software licenses',to_date('12/15/2017','MM/DD/YYYY'),to_date('12/15/2017','MM/DD/YYYY'),'Closed','Bob Nile','200','200');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Email Integration','Get RFPs for new server',to_date('12/29/2017','MM/DD/YYYY'),to_date('12/30/2017','MM/DD/YYYY'),'Closed','Bob Nile','2000','1000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Email Integration','Purchase backup server',to_date('01/15/2018','MM/DD/YYYY'),to_date('01/17/2018','MM/DD/YYYY'),'Pending','Bob Nile','0','3000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Employee Satisfaction Survey','Complete questionnaire',to_date('12/05/2017','MM/DD/YYYY'),to_date('12/06/2017','MM/DD/YYYY'),'Closed','Irene Jones','1200','800');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Employee Satisfaction Survey','Review with legal',to_date('12/07/2017','MM/DD/YYYY'),to_date('12/07/2017','MM/DD/YYYY'),'On-Hold','Irene Jones','200','400');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Employee Satisfaction Survey','Plan rollout schedule',to_date('12/08/2017','MM/DD/YYYY'),to_date('12/08/2017','MM/DD/YYYY'),'On-Hold','Irene Jones','0','750');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Client Server Conversion','Identify pilot Client Server applications',to_date('12/17/2017','MM/DD/YYYY'),to_date('12/17/2017','MM/DD/YYYY'),'Closed','Scott Spencer','200','200');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Client Server Conversion','Migrate pilot Client Server to ACME Web Express',to_date('12/19/2017','MM/DD/YYYY'),to_date('12/22/2017','MM/DD/YYYY'),'Closed','Scott Spencer','4500','5000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Client Server Conversion','Post-migration review',to_date('12/23/2017','MM/DD/YYYY'),to_date('12/23/2017','MM/DD/YYYY'),'Closed','Pam King','500','300');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Client Server Conversion','Plan migration schedule',to_date('12/26/2017','MM/DD/YYYY'),to_date('12/26/2017','MM/DD/YYYY'),'Closed','Pam King','1000','1000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Client Server Conversion','Migrate Client Server applications',to_date('12/31/2017','MM/DD/YYYY'),to_date('01/03/2018','MM/DD/YYYY'),'Open','Pam King','300','12000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Client Server Conversion','Test migrated applications',to_date('01/05/2018','MM/DD/YYYY'),to_date('01/06/2018','MM/DD/YYYY'),'Pending','Russ Saunders','0','6000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Client Server Conversion','User acceptance testing',to_date('01/09/2018','MM/DD/YYYY'),to_date('01/11/2018','MM/DD/YYYY'),'Pending','Russ Saunders','0','2500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Client Server Conversion','End-user Training',to_date('01/15/2018','MM/DD/YYYY'),to_date('01/15/2018','MM/DD/YYYY'),'Pending','Myra Sutcliff','0','2500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Client Server Conversion','Rollout migrated Client Server in ACME Web Express',to_date('01/16/2018','MM/DD/YYYY'),to_date('01/16/2018','MM/DD/YYYY'),'Pending','Pam King','0','200');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Load Packaged Apps','Identify point solutions required',to_date('12/19/2017','MM/DD/YYYY'),to_date('12/19/2017','MM/DD/YYYY'),'Closed','John Watson','200','300');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Load Packaged Apps','Install in development',to_date('12/20/2017','MM/DD/YYYY'),to_date('12/20/2017','MM/DD/YYYY'),'Closed','John Watson','100','100');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Load Packaged Apps','Customize solutions',to_date('12/23/2017','MM/DD/YYYY'),to_date('12/25/2017','MM/DD/YYYY'),'Open','John Watson','1500','4000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Load Packaged Apps','Implement in Production',to_date('12/26/2017','MM/DD/YYYY'),to_date('12/26/2017','MM/DD/YYYY'),'On-Hold','John Watson','200','1500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Load Packaged Apps','Train Administrators of Packaged Apps',to_date('12/28/2017','MM/DD/YYYY'),to_date('12/28/2017','MM/DD/YYYY'),'Pending','John Watson','0','1000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Maintain Support Systems','HR software upgrades',to_date('11/28/2017','MM/DD/YYYY'),to_date('12/01/2017','MM/DD/YYYY'),'Closed','Pam King','8000','7000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Maintain Support Systems','Apply Billing System updates',to_date('12/02/2017','MM/DD/YYYY'),to_date('12/04/2017','MM/DD/YYYY'),'Closed','Russ Saunders','9500','7000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Maintain Support Systems','Arrange for vacation coverage',to_date('12/06/2017','MM/DD/YYYY'),to_date('12/06/2017','MM/DD/YYYY'),'Open','Al Bines','300','500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Maintain Support Systems','Investigate new Virus Protection software',to_date('01/15/2018','MM/DD/YYYY'),to_date('01/16/2018','MM/DD/YYYY'),'Open','Pam King','1700','1500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate Desktop Application','Identify pilot desktop applications',to_date('12/10/2017','MM/DD/YYYY'),to_date('12/10/2017','MM/DD/YYYY'),'Closed','Bob Nile','300','500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate Desktop Application','Migrate pilot applications to ACME Web Express',to_date('12/12/2017','MM/DD/YYYY'),to_date('12/13/2017','MM/DD/YYYY'),'Closed','Bob Nile','1250','1500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate Desktop Application','Plan migration schedule',to_date('12/16/2017','MM/DD/YYYY'),to_date('12/16/2017','MM/DD/YYYY'),'Closed','Bob Nile','600','200');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate Desktop Application','Migrate desktop applications',to_date('01/08/2018','MM/DD/YYYY'),to_date('01/12/2018','MM/DD/YYYY'),'Open','Bob Nile','1000','8000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate Desktop Application','User acceptance testing',to_date('01/14/2018','MM/DD/YYYY'),to_date('01/15/2018','MM/DD/YYYY'),'Open','Bob Nile','1500','6000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate Desktop Application','End-user Training',to_date('01/18/2018','MM/DD/YYYY'),to_date('01/19/2018','MM/DD/YYYY'),'Open','John Watson','0','2000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate Desktop Application','Post-migration review',to_date('02/01/2018','MM/DD/YYYY'),to_date('02/02/2018','MM/DD/YYYY'),'Pending','Bob Nile','100','100');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate from Legacy Server','Obtain Legacy Server credentials',to_date('01/20/2018','MM/DD/YYYY'),to_date('01/20/2018','MM/DD/YYYY'),'Pending','James Cassidy','0','500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate from Legacy Server','Map data usage',to_date('01/22/2018','MM/DD/YYYY'),to_date('01/24/2018','MM/DD/YYYY'),'Pending','Bob Nile','0','8000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate from Legacy Server','Identify integration points',to_date('01/25/2018','MM/DD/YYYY'),to_date('01/26/2018','MM/DD/YYYY'),'Pending','Bob Nile','0','2000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate from Legacy Server','Create DB Connection to new server',to_date('01/25/2018','MM/DD/YYYY'),to_date('01/25/2018','MM/DD/YYYY'),'Pending','Scott Spencer','0','100');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate from Legacy Server','Migrate table structures',to_date('01/19/2018','MM/DD/YYYY'),to_date('01/20/2018','MM/DD/YYYY'),'Pending','John Watson','0','2500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate from Legacy Server','Import data',to_date('01/31/2018','MM/DD/YYYY'),to_date('02/01/2018','MM/DD/YYYY'),'Pending','John Watson','0','1000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate from Legacy Server','Convert processes',to_date('01/31/2018','MM/DD/YYYY'),to_date('02/02/2018','MM/DD/YYYY'),'Pending','Pam King','0','3000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate from Legacy Server','Notify users',to_date('02/05/2018','MM/DD/YYYY'),to_date('02/05/2018','MM/DD/YYYY'),'Pending','Bob Nile','0','200');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate from Legacy Server','Cut over to new database',to_date('02/06/2018','MM/DD/YYYY'),to_date('02/06/2018','MM/DD/YYYY'),'Pending','Bob Nile','0','1500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Migrate from Legacy Server','Decommission Legacy Server',to_date('02/20/2018','MM/DD/YYYY'),to_date('02/20/2018','MM/DD/YYYY'),'Pending','Al Bines','0','500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Public Website','Determine host server',to_date('12/05/2017','MM/DD/YYYY'),to_date('12/05/2017','MM/DD/YYYY'),'Closed','Tiger Scott','200','200');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Public Website','Check software licenses',to_date('12/05/2017','MM/DD/YYYY'),to_date('12/05/2017','MM/DD/YYYY'),'Closed','Tom Suess','100','100');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Public Website','Purchase additional software licenses, if needed',to_date('12/06/2017','MM/DD/YYYY'),to_date('12/07/2017','MM/DD/YYYY'),'On-Hold','Al Bines','300','1000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Public Website','Develop web pages',to_date('01/01/2018','MM/DD/YYYY'),to_date('01/02/2018','MM/DD/YYYY'),'Open','Tiger Scott','0','2000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Public Website','Plan rollout schedule',to_date('01/03/2018','MM/DD/YYYY'),to_date('01/03/2018','MM/DD/YYYY'),'Open','Tom Suess','0','100');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Software Project Tracking','Conduct project kickoff meeting',to_date('12/28/2017','MM/DD/YYYY'),to_date('12/28/2017','MM/DD/YYYY'),'Closed','Pam King','100','100');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Software Project Tracking','Customize Software Projects software',to_date('12/31/2017','MM/DD/YYYY'),to_date('01/01/2018','MM/DD/YYYY'),'Open','Tom Suess','600','1000');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Software Project Tracking','Enter base data (Projects, Milestones, etc.)',to_date('01/02/2018','MM/DD/YYYY'),to_date('01/02/2018','MM/DD/YYYY'),'Open','Tom Suess','200','200');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Software Project Tracking','Load current tasks and enhancements',to_date('01/04/2018','MM/DD/YYYY'),to_date('01/04/2018','MM/DD/YYYY'),'Open','Tom Suess','400','500');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Training for ACME Web Express','Create training workspace',to_date('12/17/2017','MM/DD/YYYY'),to_date('12/18/2017','MM/DD/YYYY'),'Closed','James Cassidy','500','700');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Training for ACME Web Express','Publish links to self-study courses',to_date('12/19/2017','MM/DD/YYYY'),to_date('12/19/2017','MM/DD/YYYY'),'Closed','John Watson','100','100');
        insert into sample$tasks_ss (project,task_name,start_date,end_date,status,assigned_to,cost,budget) 
        values ('Training for ACME Web Express','Publish development standards',to_date('12/19/2017','MM/DD/YYYY'),to_date('12/20/2017','MM/DD/YYYY'),'On-Hold','John Watson','1000','2000');
       
        update sample$tasks_ss
        set start_date = start_date + (SYSDATE - TO_DATE('01012018','MMDDYYYY'))
        ,   end_date = end_date + (SYSDATE - TO_DATE('01012018','MMDDYYYY'));
     end;~';

   insert into wwv_sample_dmls (wwv_sample_dataset_id, language_cd, dml_name, install_seq, dml) 
   values (  4, 'en', 'Insert tasks spreadsheet data', 10, l_clob); 

    commit;
end;
/
