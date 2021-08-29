set define '^' verify off
prompt ...create provisioning objects
Rem  Copyright (c) Oracle Corporation 2001-2015. All Rights Reserved.
Rem
Rem    NAME
Rem      provisioning_tables.sql
Rem
Rem    DESCRIPTION
Rem
Rem    NOTES
Rem      project: is a way of grouping a service, it can be the same as a company
Rem      provision: the creation of a virtural private development environment
Rem
Rem    RUNTIME DEPLOYMENT: NO
Rem
Rem    MODIFIED  (MM/DD/YYYY)
Rem      mhichwa  01/23/2001 - Created
Rem      mhichwa  02/23/2001 - Changed wwv_flow_provision_company columns
Rem      mhichwa  02/24/2001 - Changed index names, added indexes
Rem      mhichwa  02/25/2001 - Removed schema list column
Rem      mhichwa  02/26/2001 - Changed spelling of requested
Rem      mhichwa  02/27/2001 - Added not null column constraints and changed trigger.
Rem      mhichwa  02/28/2001 - Added provisioning work log
Rem      mhichwa  03/03/2001 - Added wwv_flow_provision_serice_mod
Rem      sleuniss 03/19/2001 - Fixed spelling errors
Rem      sdillon  03/21/2001 - Fixed spelling errors
Rem      sdillon  03/22/2001 - Added admin_id to provision company table, altered trigger/index
Rem      mhichwa  03/27/2001 - Added requested date to provision company table
Rem      sdillon  08/22/2001 - Changed order of inserts when auto provisioning to respect new ref integrity constraints.
Rem      tmuth    08/22/2001 - Named remaining pk constraints
Rem      mhichwa  06/25/2002 - Changed database provision sizing 2meg 5meg etc
Rem      jstraub  12/18/2002 - Removed unique from index wwv_flow_prov_company_SCHEMA
Rem      jkallman 11/25/2003 - Corrected display of Taiwan (Bug 3280214)
Rem      sspadafo 09/15/2005 - Removed not null from admin_first_name/last_name/email in wwv_flow_provision_company for xe
Rem      nagkrish 01/04/2007 - Added 'Accepted' project status to check constraint "CK_FLOW_PROV_PROJ_STATUS".
Rem      jkallman 01/08/2007 - Add table wwv_flow_workspace_req_size
Rem      jkallman 01/11/2007 - Added default_size to wwv_flow_workspace_req_size
Rem      jkallman 12/11/2007 - Added administrator notification to trigger wwv_biu_flow_prov_company
Rem      jkallman 02/24/2010 - Adjust sizes of workspace request sizes
Rem      jkallman 12/15/2010 - Added index wwv_flow_provision_comp_idx1
Rem      mhichwa  04/01/2010 - added columns to wwv_flow_provision_company
Rem      mhichwa  04/01/2010 - added table wwv_flow_provision_agreement
Rem      mhichwa  04/18/2011 - added wwv_flow_prov_signup_q
Rem      mhichwa  04/20/2011 - added agreement_enabled_yn and agreement_text
Rem      jkallman 05/09/2011 - Added column database_prealloc_size to wwv_flow_provision_company
Rem      jkallman 05/10/2011 - Changed column database_prealloc_size to database_initial_size in wwv_flow_provision_company
Rem      jkallman 05/11/2011 - Permit admin_userid to be nullable in wwv_flow_provision_company
Rem      msewtz   02/24/2014 - Added justifcation_requred to wwv_flow_prov_signup_q
Rem      hfarrell 05/20/2014 - In wwv_flow_provision_company: added workspace_type and associated check constraint;
Rem                            In wwv_biu_flow_prov_company trigger: add default value for workspace_type (feature #1429)
Rem      cneumuel 09/17/2015 - Dropped wwv_flow_pick_page_views, wwv_flow_pick_end_users, wwv_flow_pick_database_size, wwv_flow_provision_agreement,
Rem                          - wwv_flow_countries, wwv_flow_company_types (bug #20197863)
Rem      cneumuel 05/03/2016 - Move insert into wwv_flow_prov_signup_q from provisioning_tables.sql to coreins3.sql
Rem      jkallman 06/07/2017 - Added ip_address to wwv_flow_provision_company
Rem      msewtz   07/16/2018 - Added pkg_app_only_ws_yn and show_schema_yn to wwv_flow_prov_signup_q (feature 2363)
Rem      msewtz   07/18/2018 - Added blocked_email_domains and blocked_email_message to wwv_flow_prov_signup_q (feature 2366)
Rem      jstraub  07/19/2018 - Added request_success_msg to wwv_flow_prov_signup_q (feature 2368)

--
-- Arguments:
--  1:
--  2:
--  3:  Flow user


prompt ...wwv_flow_provision_serice_mod


create table wwv_flow_provision_serice_mod (
    id                           number
                                 constraint wwv_flowpk_prov_service_mod
                                 primary key,
    security_group_id            number not null,
    service_name                 varchar2(255)
                                 constraint wwv_flow_ck_service_name
                                 check (service_name in (
                                 'NEW_SCHEMA',
                                 'REMOVE_EXISTING_SERVICE',
                                 'REMOVE_EXISTING_SCHEMA',
                                 'CHANGE_DB_SIZE',
                                 'CHANGE_COMPANY_NAME',
                                 'CHANGE_END_SERVICE_DATE',
                                 'CHANGE_ADMIN_EMAIL',
                                 'CHANGE_ADMIN_NAME',
                                 'CHANGE_COMPANY_ADDRESS',
                                 'CHANGE_MAX_END_USERS',
                                 'CHANGE_MAX_PG_VIEWS_DAY')),
    service_attribute_1          varchar2(4000),
    service_attribute_2          varchar2(4000),
    service_attribute_3          varchar2(4000),
    service_attribute_4          varchar2(4000),
    service_attribute_5          varchar2(4000),
    service_attribute_6          varchar2(4000),
    service_attribute_7          varchar2(4000),
    service_attribute_8          varchar2(4000),
    requested_on                 date not null,
    requested_by                 varchar2(255),
    last_status_change_on        date,
    last_status_change_by        varchar2(255),
    request_status               varchar2(255)
                                 constraint wwv_flow_ck_prov_smod_status
                                 check (request_status in (
                                 'IN_PROGRESS',
                                 'REQUESTED',
                                 'DECLINED',
                                 'APPROVED')),
    request_work_log             varchar2(4000),
    request_comments             varchar2(4000)
    )
/

create or replace trigger wwv_biu_flow_prov_comp_smod
    before insert or update on wwv_flow_provision_serice_mod
    for each row
begin
    if inserting and :new.id is null then
        :new.id := wwv_flow_id.next_val;
    end if;
    if inserting then
        :new.requested_on := sysdate;
        :new.requested_by := wwv_flow.g_user;
    end if;
    if updating then
        :new.last_status_change_on := sysdate;
        :new.last_status_change_by := wwv_flow.g_user;
    end if;
    --
    -- vpd
    --
    if :new.security_group_id is null then
       :new.security_group_id := nvl(wwv_flow_security.g_security_group_id,0);
    end if;

    if inserting then
         wwv_flow_fnd_developer_api.admin_notify_change_request(
             p_workspace_id   => :new.security_group_id,
             p_admin_userid   => :new.requested_by );
    end if;

end;
/
show errors

create index wwv_flow_prov_company_mod_idx1 on wwv_flow_provision_serice_mod (security_group_id)
/

prompt ...wwv_flow_prov_signup_q

create table wwv_flow_prov_signup_q (
    id                           number
                                 constraint pk_wwv_flow_prov_signup_q
                                 primary key,
    --
    pkg_app_only_ws_yn           varchar2(1)
                                 constraint wwv_flow_prov_signup_po
                                 check (pkg_app_only_ws_yn in ('Y','N')),
    show_schema_yn               varchar2(1)
                                 constraint wwv_flow_prov_signup_ss
                                 check (show_schema_yn in ('Y','N')),
    blocked_email_domains        varchar2(4000),
    blocked_email_message        varchar2(4000),
    justification_required_yn    varchar2(1)
                                 constraint wwv_flow_prov_signup_jr
                                 check (justification_required_yn in ('Y','N')),
    agreement_enabled_yn         varchar2(1)
                                 constraint wwv_flow_prov_signup_ae
                                 check (agreement_enabled_yn in ('Y','N')),
    agreement_text               clob,
    --
    survey_enabled_yn            varchar2(1)
                                 constraint wwv_flow_prov_signup_se
                                 check (survey_enabled_yn in ('Y','N')),
    pre_survey_text              varchar2(4000),
    post_survey_text             varchar2(4000),
    request_success_msg          varchar2(4000),
    survey_question_01           varchar2(4000),
    survey_answer_01             varchar2(4000),
    survey_question_02           varchar2(4000),
    survey_answer_02             varchar2(4000),
    survey_question_03           varchar2(4000),
    survey_answer_03             varchar2(4000),
    survey_question_04           varchar2(4000),
    survey_answer_04             varchar2(4000),
    survey_question_05           varchar2(4000),
    survey_answer_05             varchar2(4000),
    survey_question_06           varchar2(4000),
    survey_answer_06             varchar2(4000),
    survey_question_07           varchar2(4000),
    survey_answer_07             varchar2(4000),
    survey_question_08           varchar2(4000),
    survey_answer_08             varchar2(4000),
    survey_question_09           varchar2(4000),
    survey_answer_09             varchar2(4000),
    survey_question_10           varchar2(4000),
    survey_answer_10             varchar2(4000),
    --
    created                      date,
    created_by                   varchar2(255),
    updated                      date,
    updated_by                   varchar2(255)
)
/

create or replace trigger wwv_flow_prov_signup_q_trig
    before insert or update on wwv_flow_prov_signup_q
    for each row
begin
    if inserting and :new.id is null then
       :new.id := 1;
    elsif inserting and :new.id != 1 then
       RAISE_APPLICATION_ERROR(-20000,'Only valid PK for table wwv_flow_prov_signup_q is 1');
    end if;

    if user <> 'SYS' then
        :new.updated := sysdate;
        :new.updated_by := nvl(wwv_flow.g_user,user);
        if inserting then
           :new.created := sysdate;
           :new.created_by := nvl(wwv_flow.g_user,user);
        end if;
    end if;
end;
/
show errors

prompt ...wwv_flow_provision_company

create table wwv_flow_provision_company (
    id                           number
                                 constraint pk_flow_prov_project_id
                                 primary key,
    security_group_id            number not null,
    company_name                 varchar2(255) not null,
    admin_first_name             varchar2(255),
    admin_last_name              varchar2(255),
    admin_title                  varchar2(255),
    admin_email                  varchar2(255),
    admin_phone                  varchar2(255),
    admin_id                     number,
    admin_userid                 varchar2(255),
    company_address              varchar2(255),
    city                         varchar2(255),
    state                        varchar2(255),
    zip                          varchar2(255),
    country                      varchar2(30),
    company_type                 varchar2(255),
    company_website              varchar2(255),
    number_of_employees          varchar2(255),
    company_phone                varchar2(255),
    company_fax                  varchar2(255),
    oracle_partner               varchar2(255) check (oracle_partner in ('YES','NO')),
    how_did_you_hear_about_us    varchar2(255),
    service_use_status           varchar2(30) check (service_use_status in ('FULL_USE','TRIAL')),
    database_size                number,
    database_initial_size        number,
    service_start_date           date,
    service_termination_date     date,
    schema_name                  varchar2(255) not null,
    estimated_end_users          number,
    page_views_per_day           number,
    --
    survey_question_01           varchar2(4000),
    survey_answer_01             varchar2(4000),
    survey_question_02           varchar2(4000),
    survey_answer_02             varchar2(4000),
    survey_question_03           varchar2(4000),
    survey_answer_03             varchar2(4000),
    survey_question_04           varchar2(4000),
    survey_answer_04             varchar2(4000),
    survey_question_05           varchar2(4000),
    survey_answer_05             varchar2(4000),
    survey_question_06           varchar2(4000),
    survey_answer_06             varchar2(4000),
    survey_question_07           varchar2(4000),
    survey_answer_07             varchar2(4000),
    survey_question_08           varchar2(4000),
    survey_answer_08             varchar2(4000),
    survey_question_09           varchar2(4000),
    survey_answer_09             varchar2(4000),
    survey_question_10           varchar2(4000),
    survey_answer_10             varchar2(4000),
    --
    agreement_acceptance_date    date,
    agreement_name               varchar2(4000),
    agreement_user_env           varchar2(4000),
    agreement_checksum           varchar2(255),
    --
    project_description          varchar2(4000),
    project_justification        varchar2(4000),
    project_approval_date        date,
    project_actual_begin_date    date,
    project_actual_end_date      date,
    project_status               varchar2(255)
                                 constraint ck_flow_prov_proj_status
                                 check (project_status in (
                                 'IN_PROGRESS',
                                 'REQUESTED',
                                 'ACCEPTED',
                                 'DECLINED',
                                 'APPROVED',
                                 'TERMINATION_IN_PROGRESS',
                                 'TERMINATION_IN_PROGRESS2',
                                 'TERMINATION_IN_PROGRESS3',
                                 'TERMINATION_IN_PROGRESS4',
                                 'TERMINATION_IN_PROGRESS5',
                                 'TERMINATION_IN_PROGRESS6',
                                 'TERMINATED')),
    work_log                     varchar2(4000),
    request_date                 date,
    workspace_type               varchar2(20) check (workspace_type in ('BUILDER','APPS')),
    ip_address                   varchar2(4000)
    )
/


create or replace trigger wwv_biu_flow_prov_company
    before insert or update on wwv_flow_provision_company
    for each row
begin
    if inserting and :new.id is null then
        :new.id := wwv_flow_id.next_val;
    end if;
    if inserting and :new.admin_id is null then
        :new.admin_id := wwv_flow_id.next_val;
    end if;
    if inserting and :new.security_group_id is null then
        :new.security_group_id := wwv_flow_id.next_val;
    end if;
    if inserting then
        :new.request_date := sysdate;
    end if;
    :new.company_name := upper(:new.company_name);
    :new.admin_userid := upper(:new.admin_userid);
    :new.schema_name  := upper(:new.schema_name);

    if :new.workspace_type is null then
        :new.workspace_type := 'BUILDER';
    end if;

    if inserting then
         wwv_flow_fnd_developer_api.admin_notify_new_request(
             p_workspace_name => :new.company_name,
             p_schema_name    => :new.schema_name,
             p_admin_userid   => :new.admin_userid,
             p_admin_email    => :new.admin_email );
    end if;
end;
/
show errors

create unique index wwv_flow_prov_company_name on wwv_flow_provision_company (company_name);
create index wwv_flow_prov_company_SCHEMA on wwv_flow_provision_company (SCHEMA_NAME);
create unique index wwv_flow_prov_company_sgid on wwv_flow_provision_company (security_group_id);
create unique index wwv_flow_prov_company_admin_id on wwv_flow_provision_company (admin_id);
create index wwv_flow_provision_comp_idx1 on wwv_flow_provision_company( project_status );

create table wwv_flow_workspace_req_size (
    id                 number,
    request_type       varchar2(1) not null
                       constraint wwv_flow_wksp_request_type
                       check (request_type in ('N','C')),
    req_size           varchar2(30)  not null,
    display            varchar2(1) not null
                       constraint wwv_flow_wksp_req_size_display
                       check (display in ('Y','N')),
    default_size       varchar2(1) not null
                       constraint wwv_flow_wksp_req_size_default
                       check (default_size in ('Y','N'))
)
/

alter table wwv_flow_workspace_req_size add constraint wwv_flow_workspace_req_size_pk primary key (id)
/


insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 1, 'N', 10, 'Y', 'N')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 2, 'N', 25, 'Y', 'N')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 3, 'N', 100, 'Y', 'Y')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 4, 'N', 500, 'Y', 'N')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 5, 'N', 2000, 'N', 'N')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 6, 'N', 5000, 'N', 'N')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 7, 'N', 10000, 'N', 'N')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 8, 'C', 10, 'Y', 'N')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 9, 'C', 25, 'Y', 'Y')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 10, 'C', 100, 'Y', 'N')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 11, 'C', 500, 'Y', 'N')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 12, 'C', 2000, 'N', 'N')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 13, 'C', 5000, 'N', 'N')
/
insert into wwv_flow_workspace_req_size (id, request_type, req_size, display, default_size) values( 14, 'C', 10000, 'N', 'N')
/
commit;

commit;

