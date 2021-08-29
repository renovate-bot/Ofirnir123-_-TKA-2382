set define '^' verify off

Rem  Copyright (c) Oracle Corporation 2011 - 2018. All Rights Reserved.
Rem
Rem    NAME
Rem      wwv_flow_pkg_app_tab.sql
Rem
Rem    DESCRIPTION
Rem      Packaged application object creation script.  Create tables, indexes, triggers.
Rem
Rem    NOTES
Rem
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem       cbcho    10/19/2011 - Created
Rem       msewtz   10/25/2011 - Added wwv_flow_pkg_app_map
Rem       cbcho    10/27/2011 - Added additional columns in wwv_flow_pkg_applications
Rem       msewtz   10/27/2011 - Updated creation of wwv_flow_pkg_app_map to use execute immidiate, because we don not drop this table when re-applying patch
Rem       jkallman 10/28/2011 - Ignore errors if tables to be dropped dont exist, correct syntax error in wwv_flow_pkg_applications
Rem       jkallman 10/28/2011 - Added purge to drop table statements
Rem       jkallman 10/28/2011 - Removed drop table statements and made create table and create index statement re-runnable
Rem       msewtz   04/13/2012 - Added min_db_version, application_locked and unlock_allowed to wwv_flow_pkg_applications
Rem       cneumuel 04/16/2012 - Added q'{}' quotes around execute immediate string for wwv_flow_pkg_applications
Rem       cneumuel 04/18/2012 - Added q'{}' quotes around execute immediate string for wwv_flow_pkg_app_map
Rem       msewtz   04/18/2012 - Removed defaults from wwv_flow_pkg_applications and wwv_flow_pkg_app_map
Rem       hfarrell 05/21/2012 - Updated wwv_flow_pkg_app_map to support Websheets: added installed_ws_id, foreign key wwv_flow_pkg_app_map_fk2
Rem       hfarrell 05/24/2012 - Added app_type to wwv_flow_pkg_applications to distinguish between Database and Websheet applications
Rem       hfarrell 05/29/2012 - Updated check constraint on wwv_flow_pkg_applications to modify statuses to AVAILABLE, COMING_SOON, HIDDEN
Rem       pmanirah 06/18/2012 - Added new index wwv_flow_pkg_app_map_idx2 on wwv_flow_pkg_app_map table
Rem       cbcho    06/22/2012 - Added wwv_flow_pkg_app_install_log (feature #992)
Rem       cbcho    07/02/2012 - Changed wwv_flow_pkg_app_install_log trigger to get log_seq using app_id and batch_key, added index on created_on
Rem       cneumuel 07/31/2012 - Added wwv_flow_pkg_app_uk3 on wwv_flow_pkg_applications.apex_websheet_id (feature #1011)
Rem       msewtz   11/13/2012 - Added change_log to wwv_flow_pkg_applications (bug 14643161)
Rem       hfarrell 02/25/2013 - Changed wwv_flow_pkg_app_map.application_locked to be NOT NULL (bug #16389474)
Rem       hfarrell 03/19/2013 - Added build_version, app_locked, installed_build_version to wwv_flow_pkg_app_install_log (bug #16500430)
Rem       hfarrell 03/19/2013 - Added view apex_pkg_app_install_log, associated comments, synonym and grant (bug #16500430)
Rem       hfarrell 04/02/2013 - Updated synonym to be created on view apex_pkg_app_install_log and not the table wwv_flow_pkg_app_install_log (bug #16500430)
Rem       cbcho    08/19/2013 - Added wwv_flow_pkg_app_stmts (feature #1257)
Rem       cbcho    08/22/2013 - Added created_on, created_by to wwv_flow_pkg_app_stmts (feature #1257)
Rem       cbcho    08/22/2013 - Added unique index on wwv_flow_pkg_app_stmts(app_id, stmt_number, line_number) (feature #1257)
Rem       jstraub  10/21/2013 - Changed SGID 11 references to 12
Rem       cbcho    02/18/2014 - Added app_group to wwv_flow_pkg_applications, added wwv_flow_pkg_app_files (feature #1380)
Rem       cbcho    02/20/2014 - Removed size_in_mb and added required_free_kb in wwv_flow_pkg_applications (feature #1380)
Rem       cbcho    02/27/2014 - Changed app_group to default to TEMPLATE (feature #1380)
Rem       cbcho    02/27/2014 - Renamed wwv_flow_pkg_applications table row_key to app_id number (feature #1380)
Rem       cbcho    03/03/2014 - Removed security_group_id from wwv_flow_pkg_app_files as it is not needed (feature #1380)
Rem       cbcho    03/13/2014 - Added file_id in wwv_flow_pkg_app_stmts with FK to wwv_flow_pkg_app_files with index (feature #1380)
Rem       cbcho    03/14/2014 - Added wwv_flow_pkg_app_map_uk1 in wwv_flow_pkg_app_map (feature #1399)
Rem       cbcho    03/18/2014 - Changed TEMPLATE to CUSTOM
Rem       cbcho    04/17/2014 - Added is_oracle_app virtual column in wwv_flow_pkg_applications (feature #1258)
Rem       cbcho    05/16/2014 - Removed on delete cascade of category_ids in wwv_flow_pkg_applications. This way pkg apps do not get deleted when category gets removed (decision from Vald and cbcho)
Rem       cneumuel 08/07/2014 - Moved grant on apex_pkg_app_install_log to wwv_flow_upgrade
Rem       jstraub  08/20/2015 - Added security_group_id column on wwv_flow_pkg_app_categories, wwv_flow_pkg_app_files, wwv_flow_pkg_app_images, wwv_flow_pkg_applications (bug 21673469)
Rem       hfarrell 08/25/2015 - Set security_group_id in triggers to 12, for internally installed packaged applications. Customer uploaded apps should use SGID 11.
Rem       jstraub  09/03/2015 - Removed wwv_flow_pkg_app_stmts_fk1 from wwv_flow_pkg_app_stmts (bug 21779781)
Rem       cbcho    03/07/2016 - Added wwv_flow_pkg_app_authorized, apex_pkg_app_authentications, apex_pkg_apps, apex_pkg_app_activity (feature #1937)
Rem       cbcho    03/09/2016 - Changed apex_pkg_app_authentications view to use wwv_flow_platform.get_preference
Rem       cbcho    03/11/2016 - Fixed outer join issue in apex_pkg_apps, Changed apex_pkg_app_activity to use underlying table instead of apex view
Rem       cneumuel 04/18/2016 - Use wwv_flow_security.has_apex_admin_read_role_yn instead of has_apex_administrator_role_yn (feature #1993)
Rem       cbcho    07/29/2016 - Added function based unique index on wwv_flow_pkg_applications.app_name (feature #1937)
Rem       cneumuel 03/19/2018 - case sensitive comparison (bug #27716666)
Rem       cbcho    06/28/2018 - Changed apex_pkg_apps to include websheet (bug #26022011)
Rem       cbcho    07/24/2018 - Added apex_pkg_app_available, apex_pkg_app_installed (bug #26022592)



prompt ...create table wwv_flow_pkg_app_categories


begin
    execute immediate '
create table wwv_flow_pkg_app_categories (
   id                     number         not null,
   category_name          varchar2(255)  not null,
   category_desc          varchar2(4000),
   security_group_id      number,
   --
   created                date,
   created_by             varchar2(255),
   updated                date,
   updated_by             varchar2(255),
   --
   constraint wwv_flow_pkg_app_cats_pk
      primary key (id),
   constraint wwv_flow_pkg_app_cats_uk1
      unique (category_name)
   )
';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/


create or replace trigger wwv_flow_pkg_app_cats_biu
   before insert or update on wwv_flow_pkg_app_categories
   for each row
begin
   if :new.id is null then
      :new.id := wwv_flow_id.next_val;
   end if;
   if inserting then
      :new.created            := sysdate;
      :new.created_by         := lower(nvl(wwv_flow.g_user,user));
      :new.updated            := sysdate;
      :new.updated_by         := lower(nvl(wwv_flow.g_user,user));
   end if;
   if inserting or updating then
      :new.updated    := sysdate;
      :new.updated_by := lower(nvl(wwv_flow.g_user,user));
   end if;
   if :new.security_group_id is null then
      :new.security_group_id := 12;
   end if;
end;
/


prompt ...create table wwv_flow_pkg_applications

begin
    execute immediate q'{
create table wwv_flow_pkg_applications (
   id                         number         not null,
   app_id                     number         not null,
   app_name                   varchar2(255)  not null,
   app_description            varchar2(4000),
   app_type                   varchar2(2)    default 'DB' not null,
   app_group                  varchar2(255)  default 'CUSTOM'
                                  constraint wwv_flow_pkg_app_group_ck
                                  check (app_group in ('PACKAGE','SAMPLE','CUSTOM')),
   is_oracle_app              varchar2(1) generated always as (
                              case when app_type = 'DB' and app_id between 5000 and 9000 then 'Y'
                              when app_type = 'WS' and app_group != 'CUSTOM' then 'Y'
                              else 'N'
                              end
                              ) virtual,
   tags                       varchar2(255),
   apex_application_id        number,
   apex_websheet_id           number,
   image_identifier           varchar2(255),
   app_status                 varchar2(30),
   app_display_version        varchar2(255),
   app_version_date           date,
   app_category_id_1          number,
   app_category_id_2          number,
   app_category_id_3          number,
   build_version              number,
   change_log                 varchar2(4000),
   unlock_allowed             varchar2(1)
                                  constraint wwv_flow_pkg_app_unlock_ok_ck
                                  check (unlock_allowed in ('Y','N')),
   app_page_count             number,
   app_object_count           number,
   app_object_prefix          varchar2(255),
   --
   required_free_kb           number,
   languages                  varchar2(500),
   released                   date,
   min_apex_version           varchar2(255),
   min_db_version             varchar2(255),
   provider_company           varchar2(255),
   provider_email             varchar2(255),
   provider_website           varchar2(255),
   security_group_id          number,
   --
   created                    date,
   created_by                 varchar2(255),
   updated                    date,
   updated_by                 varchar2(255),
   --
   constraint wwv_flow_pkg_app_pk
      primary key (id),
   constraint wwv_flow_pkg_app_uk1
      unique (apex_application_id),
   constraint wwv_flow_pkg_app_uk2
      unique (app_id),
   constraint wwv_flow_pkg_app_uk3
      unique (apex_websheet_id),
   constraint wwv_flow_pkg_app_fk1
      foreign key (app_category_id_1) references wwv_flow_pkg_app_categories (id),
   constraint wwv_flow_pkg_app_fk2
      foreign key (app_category_id_2) references wwv_flow_pkg_app_categories (id),
   constraint wwv_flow_pkg_app_fk3
      foreign key (app_category_id_3) references wwv_flow_pkg_app_categories (id),
   constraint wwv_flow_pkg_app_cc1
      check (app_status in ('AVAILABLE','COMING_SOON','HIDDEN'))
   )
}';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

begin
    execute immediate 'create index wwv_flow_pkg_app_idx1 on wwv_flow_pkg_applications(app_category_id_1)';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/
begin
    execute immediate 'create index wwv_flow_pkg_app_idx2 on wwv_flow_pkg_applications(app_category_id_2)';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/
begin
    execute immediate 'create index wwv_flow_pkg_app_idx3 on wwv_flow_pkg_applications(app_category_id_3)';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/
begin
    execute immediate 'create unique index wwv_flow_pkg_app_idx4 on wwv_flow_pkg_applications(upper(app_name))';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/
create or replace trigger wwv_flow_pkg_app_biu
   before insert or update on wwv_flow_pkg_applications
   for each row
begin
   if :new.id is null then
      :new.id := wwv_flow_id.next_val;
   end if;
   if inserting then
      :new.created            := sysdate;
      :new.created_by         := lower(nvl(wwv_flow.g_user,user));
      :new.updated            := sysdate;
      :new.updated_by         := lower(nvl(wwv_flow.g_user,user));
   end if;
   if inserting or updating then
      :new.updated    := sysdate;
      :new.updated_by := lower(nvl(wwv_flow.g_user,user));
   end if;
   if :new.security_group_id is null then
      :new.security_group_id := 12;
   end if;
end;
/

prompt ...create table wwv_flow_pkg_app_images

begin
    execute immediate '
create table wwv_flow_pkg_app_images (
   id                         number   not null,
   app_id                     number   not null,
   title                      varchar2(1024),
   description                varchar2(4000),
   file_name                  varchar2(512),
   security_group_id          number,
   --
   created                    date,
   created_by                 varchar2(255),
   updated                    date,
   updated_by                 varchar2(255),
   --
   constraint wwv_flow_pkg_app_images_pk
      primary key (id),
   constraint wwv_flow_pkg_app_images_fk1
      foreign key (app_id) references wwv_flow_pkg_applications (id)
      on delete cascade
   )
';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

begin
    execute immediate 'create index wwv_flow_pkg_app_images_idx1 on wwv_flow_pkg_app_images(app_id)';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

create or replace trigger wwv_flow_pkg_app_images_biu
   before insert or update on wwv_flow_pkg_app_images
   for each row
begin
   if :new.id is null then
      :new.id := wwv_flow_id.next_val;
   end if;
   if inserting then
      :new.created            := sysdate;
      :new.created_by         := lower(nvl(wwv_flow.g_user,user));
      :new.updated            := sysdate;
      :new.updated_by         := lower(nvl(wwv_flow.g_user,user));
   end if;
   if inserting or updating then
      :new.updated    := sysdate;
      :new.updated_by := lower(nvl(wwv_flow.g_user,user));
   end if;
   if :new.security_group_id is null then
      :new.security_group_id := 12;
   end if;
end;
/

prompt ...create table wwv_flow_pkg_app_map

begin
    execute immediate q'{
create table wwv_flow_pkg_app_map (
   id                         number   not null,
   app_id                     number   not null,
   installed_app_id           number,
   installed_ws_id            number,
   installed_build_version    number   not null,
   application_locked         varchar2(1) not null
                                  constraint wwv_flow_pkg_app_locked_ck
                                  check (application_locked in ('Y','N')),
   security_group_id          number   not null,
   --
   created                    date,
   created_by                 varchar2(255),
   updated                    date,
   updated_by                 varchar2(255),
   --
   constraint wwv_flow_pkg_app_map_pk
      primary key (id),
   constraint wwv_flow_pkg_app_map_fk
      foreign key (installed_app_id) references wwv_flows (id)
      on delete cascade,
   constraint wwv_flow_pkg_app_map_fk2
      foreign key (installed_ws_id) references wwv_flow_ws_applications (id)
      on delete cascade,
   constraint wwv_flow_pkg_app_map_uk1
      unique (app_id, security_group_id)
   )
}';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

begin
    execute immediate 'create index wwv_flow_pkg_app_map_idx on wwv_flow_pkg_app_map(installed_app_id)';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

begin
    execute immediate 'create index wwv_flow_pkg_app_map_idx2 on wwv_flow_pkg_app_map(installed_ws_id)';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

create or replace trigger wwv_flow_pkg_app_map_biu
   before insert or update on wwv_flow_pkg_app_map
   for each row
begin
   if :new.id is null then
      :new.id := wwv_flow_id.next_val;
   end if;
   if inserting then
      :new.created            := sysdate;
      :new.created_by         := lower(nvl(wwv_flow.g_user,user));
      :new.updated            := sysdate;
      :new.updated_by         := lower(nvl(wwv_flow.g_user,user));
   end if;
   if inserting or updating then
      :new.updated    := sysdate;
      :new.updated_by := lower(nvl(wwv_flow.g_user,user));
   end if;
   if :new.security_group_id is null then
      :new.security_group_id := nvl(wwv_flow_security.g_security_group_id,0);
   end if;
end;
/


prompt ...create table wwv_flow_pkg_app_install_log

begin
    execute immediate q'{
create table wwv_flow_pkg_app_install_log (
    id                      number
                            constraint wwv_flow_pai_log_pk
                            primary key,
    batch_key               varchar2(255) not null,
    app_id                  number not null,
    app_type                varchar2(255)
                            constraint wwv_flow_pai_log_app_type_ck
                            check (app_type in (
                            'DATABASE',
                            'WEBSHEET')),
    app_version             varchar2(255) not null,
    build_version           number,
    installed_build_version number,
    app_locked              varchar2(1),
    log_seq                 number not null,
    log_event               varchar2(4000),
    log_type                varchar2(255)
                            constraint wwv_flow_pai_log_type_ck
                            check (log_type in (
                            'INFORMATION',
                            'SUCCESS',
                            'WARNING',
                            'ERROR')),
    started                 timestamp with local time zone not null,
    ended                   timestamp with local time zone,
    err_msg                 varchar2(4000),
    created_on              date,
    created_by              varchar2(255),
    updated_on              date,
    updated_by              varchar2(255),
    security_group_id       number not null
    )
}';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

begin
    execute immediate 'create index wwwv_flow_pai_log_idx1 on wwv_flow_pkg_app_install_log (batch_key)';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

begin
    execute immediate 'create index wwwv_flow_pai_log_idx2 on wwv_flow_pkg_app_install_log (created_on)';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

create or replace trigger wwv_flow_pkg_app_inst_log_t1
    before insert or update on wwv_flow_pkg_app_install_log
    for each row
begin
    if inserting then
        if :new.id is null then
            :new.id := wwv_flow_id.next_val;
        end if;
        if :new.log_seq is null then
            select nvl(max(log_seq),0) + 1 into :new.log_seq
            from wwv_flow_pkg_app_install_log
            where app_id = :new.app_id
            and batch_key = :new.batch_key;
        end if;

        :new.started := localtimestamp;
        :new.created_on := sysdate;
        :new.created_by := nvl(wwv_flow.g_user,user);
    end if;

    :new.updated_on := sysdate;
    :new.updated_by := nvl(wwv_flow.g_user,user);

    -- vpd
    --
    if :new.security_group_id is null then
       :new.security_group_id := nvl(wwv_flow_security.g_security_group_id,0);
    end if;
end;
/

prompt ...create table wwv_flow_pkg_app_files

begin
    execute immediate q'{
create table wwv_flow_pkg_app_files (
    id                         number not null
                               constraint wwv_flow_pkg_app_files_pk
                               primary key,
    app_id                     number not null
                               constraint wwv_flow_pkg_app_files_fk
                               references wwv_flow_pkg_applications(app_id)
                               on delete cascade,
    language                   varchar2(30),
    file_name                  varchar2(400),
    mime_type                  varchar2(255),
    file_charset               varchar2(128),
    blob_content               blob,
    security_group_id          number,
    --
    created                    date,
    created_by                 varchar2(255),
    updated                    date,
    updated_by                 varchar2(255)
    )
}';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

begin
    execute immediate 'create index wwv_flow_pkg_app_files_idx on wwv_flow_pkg_app_files (app_id, file_name)';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

create or replace trigger wwv_flow_pkg_app_files_biu
   before insert or update on wwv_flow_pkg_app_files
   for each row
begin
   if :new.id is null then
      :new.id := wwv_flow_id.next_val;
   end if;
   if inserting then
      :new.created            := sysdate;
      :new.created_by         := lower(nvl(wwv_flow.g_user,user));
      :new.updated            := sysdate;
      :new.updated_by         := lower(nvl(wwv_flow.g_user,user));
   end if;
   if inserting or updating then
      :new.updated    := sysdate;
      :new.updated_by := lower(nvl(wwv_flow.g_user,user));
   end if;
   if :new.security_group_id is null then
      :new.security_group_id := 12;
   end if;
end;
/

prompt ...create table wwv_flow_pkg_app_stmts

begin
    execute immediate q'{
create table wwv_flow_pkg_app_stmts
(id                 number
                    constraint wwv_flow_pkg_app_stmts_pk
                    primary key,
app_id              number not null,   -- This is either databased application ID (apex_application_id) or Websheet ID (apex_websheet_id) in WWV_FLOW_PKG_APPLICATIONS.
file_id             number not null,
stmt_number         number not null,
line_number         number not null,   -- application export file line number, not the line number within each statements
is_runnable         varchar2(1) default 'N' not null
                    constraint wwv_flow_pkg_app_stmts_r_ck
                    check (is_runnable in ('Y','N')),
line_vc2            varchar2(4000),  -- if line <= 400 save it here
line_clob           clob,            -- if line > 4000 save it here,
created_on          date,
created_by          varchar2(255)
)
}';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

begin
    execute immediate 'create unique index wwv_flow_pkg_app_stmts_idx1 on wwv_flow_pkg_app_stmts(app_id, stmt_number, line_number) compress 2';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

begin
    execute immediate 'create index wwv_flow_pkg_app_stmts_idx2 on wwv_flow_pkg_app_stmts(file_id)';
exception
    when others then
        if sqlcode = -955 then null;
        else raise;
        end if;
end;
/

create or replace trigger wwv_flow_pkg_app_stmts_biu
    before insert or update on wwv_flow_pkg_app_stmts
    for each row
begin
    if :new.id is null then
        :new.id := wwv_flow_id.next_val;
    end if;
    if inserting then
        :new.created_on := sysdate;
        :new.created_by := nvl(wwv_flow.g_user,user);
    end if;
end;
/

-- pkg apps available across the workspace
-- Note: no need to expose to public
prompt ...wwv_flow_pkg_app_authorized
create or replace view wwv_flow_pkg_app_authorized
as
select w.workspace,
       w.workspace_display_name,
       w.workspace_id,
       p.app_id                  ,
       p.app_name                ,
       p.app_status              ,
       p.app_description         ,
       p.app_type                ,
       p.app_group               ,
       p.build_version           ,
       p.app_display_version     , 
       p.app_version_date
  from wwv_flow_pkg_applications   p,
       wwv_flow_current_workspaces w
where  p.app_status  =  'AVAILABLE'
   and p.app_group   != 'CUSTOM'
/

prompt ...create view apex_pkg_app_install_log

create or replace view apex_pkg_app_install_log
as
select
    w.workspace,
    w.workspace_display_name,
    f.app_id                         application_id,
    t.app_name                       application_name,
    t.app_type                       application_type,
    t.app_description                application_description,
    f.security_group_id              workspace_id,
    --
    f.app_version                    application_version,
    f.build_version                  build_version,
    f.installed_build_version        installed_build_version,
    f.log_seq                        log_sequence,
    f.log_event                      log_event,
    f.log_type                       log_type,
    f.started                        start_time,
    f.ended                          end_time,
    f.err_msg                        error_message,
    f.created_by                     created_by,
    f.created_on                     created_on,
    f.updated_by                     updated_by,
    f.updated_on                     updated_on,
    f.id                             install_log_id
    --
from wwv_flow_pkg_applications    t,
     wwv_flow_pkg_app_install_log f,
     wwv_flow_current_workspaces  w
where f.security_group_id        =  w.workspace_id
  and f.app_id                   =  t.app_id
  and t.app_type                 =  'DB'
  and f.app_type                 =  'DATABASE'
  and (nvl(t.APP_STATUS,'x') not in ('COMING_SOON','HIDDEN'))
  and w.workspace_id not         in (0,12)
/

comment on table  apex_pkg_app_install_log                               is 'Identifies a collection of install log entries associated with packaged application installs and upgrades.';
comment on column apex_pkg_app_install_log.workspace                     is 'A work area mapped to one or more database schemas';
comment on column apex_pkg_app_install_log.workspace_display_name        is 'Display name for the workspace';
comment on column apex_pkg_app_install_log.application_id                is 'Application Primary Key, Unique over all workspaces';
comment on column apex_pkg_app_install_log.application_name              is 'Identifies the application';
comment on column apex_pkg_app_install_log.application_type              is 'Identifies the application type';
comment on column apex_pkg_app_install_log.application_description       is 'Displays a description of the application';
comment on column apex_pkg_app_install_log.workspace_id                  is 'Application Express Workspace Identifier, unique over all workspaces';
comment on column apex_pkg_app_install_log.application_version           is 'Identifies the application version';
comment on column apex_pkg_app_install_log.build_version                 is 'Identifies the build version of the application';
comment on column apex_pkg_app_install_log.installed_build_version       is 'Identifies the build version of the installed application';
comment on column apex_pkg_app_install_log.log_sequence                  is 'Identifies the sequence of the log message';
comment on column apex_pkg_app_install_log.log_event                     is 'Identifies the log event';
comment on column apex_pkg_app_install_log.log_type                      is 'Identifies the type of log message';
comment on column apex_pkg_app_install_log.start_time                    is 'Identifies the start time of the log event';
comment on column apex_pkg_app_install_log.end_time                      is 'Identifies the end time of the log event';
comment on column apex_pkg_app_install_log.error_message                 is 'Displays the error message for the log event';
comment on column apex_pkg_app_install_log.created_by                    is 'APEX developer who created the log event';
comment on column apex_pkg_app_install_log.created_on                    is 'Date of which this entry was created';
comment on column apex_pkg_app_install_log.updated_by                    is 'APEX developer who made last update';
comment on column apex_pkg_app_install_log.updated_on                    is 'Date of last update';
comment on column apex_pkg_app_install_log.install_log_id                is 'Identifies the unique ID for the log event';

-- available authentication schemes to use in packaged application
prompt ...apex_pkg_app_authentications
create or replace view apex_pkg_app_authentications
as
select wwv_flow_lang.system_message('AUTHENTICATION_NAME.'|| name_with_prefix) scheme_name,
       name_with_prefix scheme_type
  from wwv_flow_native_plugins
 where plugin_type = 'AUTHENTICATION TYPE'
   and (          name_with_prefix = 'NATIVE_APEX_ACCOUNTS'
         or (     name_with_prefix = 'NATIVE_HTTP_HEADER_VARIABLE'
              and wwv_flow_platform.get_preference('PKG_APP_AUTH_ALLOW_HHEAD') = 'Y' )
         or (     name_with_prefix = 'NATIVE_LDAP'
              and wwv_flow_platform.get_preference('PKG_APP_AUTH_ALLOW_LDAP') = 'Y' )
         or (     name_with_prefix = 'NATIVE_IAS_SSO'
              and wwv_flow_platform.get_preference('PKG_APP_AUTH_ALLOW_SSO') = 'Y' ))
union all
select wwv_flow_lang.system_message('AUTHENTICATION_NAME.NATIVE_CLOUD_IDM'),
       'NATIVE_CLOUD_IDM'
  from sys.dual
 where wwv_flow_platform.get_preference('APEX_BUILDER_AUTHENTICATION') = 'CLOUD_IDM'
/

comment on table  apex_pkg_app_authentications                is 'List of authentication schemes that can be used in packaged applications';
comment on column apex_pkg_app_authentications.scheme_name    is 'Identifies the authentication scheme name';
comment on column apex_pkg_app_authentications.scheme_type    is 'Identifies the internal code of scheme_name';


-- all available oracle provided packaged apps
prompt ...apex_pkg_apps
create or replace view apex_pkg_apps
as
with installed_app as (
    select
        a.workspace_id,
        a.workspace,
        a.workspace_display_name,
        a.app_id,
        m.installed_app_id,
        case when ( f.build_status = 'RUN_AND_HIDDEN' ) and ( a.build_version > m.installed_build_version ) then -- if locked and update available
            'Y'
        else
            'N'
        end as is_upgradable,
        case when f.build_status = 'RUN_AND_HIDDEN' then
            'Y'
        else
            'N'
        end is_locked,
        f.owner,
        a.app_display_version version_installed,
        (select name from wwv_flow_authentications where id = f.authentication_id) authentication_scheme_name,
        (select scheme_type from wwv_flow_authentications where id = f.authentication_id) authentication_sheme_type
    from wwv_flow_pkg_app_authorized a,
         wwv_flow_pkg_app_map m,
         wwv_flows f
     where a.app_id = m.app_id
     and a.workspace_id = m.security_group_id
     and m.security_group_id = f.security_group_id
     and m.installed_app_id = f.id
     and a.app_type = 'DB'
    union all
    select
        a.workspace_id,
        a.workspace,
        a.workspace_display_name,
        a.app_id,
        m.installed_ws_id,
        'N' is_upgradable,
        'N' is_locked,
        w.owner,
        a.app_display_version version_installed,
        (select name from wwv_flow_ws_custom_auth_setups where id = w.auth_id) authentication_scheme_name,
        null authentication_sheme_type
    from wwv_flow_pkg_app_authorized a,
         wwv_flow_pkg_app_map m,
         wwv_flow_ws_applications w
     where a.app_id = m.app_id
     and a.workspace_id = m.security_group_id
     and m.security_group_id = w.security_group_id
     and m.installed_ws_id = w.id
     and a.app_type = 'WS' )
select a.workspace_id,
       a.workspace,
       a.app_id                   as pkg_app_id,
       a.app_name                 as pkg_app_name,
       a.app_status               as pkg_app_status,
       a.app_description          as pkg_app_desc,
       --
       case when a.app_type = 'DB' then
           'Database'
       when a.app_type = 'WS' then
           'Websheet'
       end as pkg_app_type,
       case when a.app_group = 'SAMPLE' then
           'Sample Application'
       when a.app_group = 'PACKAGE' then
           'Packaged Application'
       end as pkg_app_group,
       a.app_group                as pkg_app_group_code,
       --
       case when i.installed_app_id is not null then
           'Y'
       else
           'N'
       end as is_installed,
       i.is_upgradable,
       i.is_locked,
       i.installed_app_id         as application_id,
       i.owner                    ,
       i.version_installed,
       --
       i.authentication_scheme_name,
       i.authentication_sheme_type
  from wwv_flow_pkg_app_authorized a,
       installed_app i
 where a.app_id = i.app_id (+)
 and   a.workspace_id = i.workspace_id (+)
/


comment on table  apex_pkg_apps                               is 'List of available packaged applications for installation in a workspace';
comment on column apex_pkg_apps.workspace_id                  is 'Primary key that identifies the workspace';
comment on column apex_pkg_apps.workspace                     is 'A work area mapped to one or more database schemas';
comment on column apex_pkg_apps.pkg_app_id                    is 'Packaged application ID';
comment on column apex_pkg_apps.pkg_app_name                  is 'Packaged application name';
comment on column apex_pkg_apps.pkg_app_status                is 'Packaged application status';
comment on column apex_pkg_apps.pkg_app_desc                  is 'Packaged application description';
comment on column apex_pkg_apps.pkg_app_type                  is 'Identifies packaged application type of database or websheet';     
comment on column apex_pkg_apps.pkg_app_group                 is 'Identifies packaged application group of sample or packaged application';
comment on column apex_pkg_apps.pkg_app_group_code            is 'Identifies the internal code of pkg_app_group';
comment on column apex_pkg_apps.is_installed                  is 'Identifies if the packaged application is installed in the workspace';      
comment on column apex_pkg_apps.is_upgradable                 is 'Identifies if the newer version of packaged application is available to upgrade';   
comment on column apex_pkg_apps.is_locked                     is 'Identifies if the packaged application is locked.  Unlocked packaged applications are ineligible for future upgrades and not supported.';    
comment on column apex_pkg_apps.application_id                is 'Installed application ID of the packaged application';   
comment on column apex_pkg_apps.owner                         is 'Identifies the database schema that the installed application will parse SQL and PL/SQL statements as';
comment on column apex_pkg_apps.version_installed             is 'The installed version of the packaged application';
comment on column apex_pkg_apps.authentication_scheme_name    is 'Identifies the current authentication method used by the installed application.';
comment on column apex_pkg_apps.authentication_sheme_type     is 'Identifies the internal code of authentication_scheme_name';

-- New in 18.2, Bug #26022592 fix
--
-- view returns unique row of available packaged apps
--
prompt ...apex_pkg_app_available
create or replace view apex_pkg_app_available
as
select p.app_id,
    p.app_name,
    p.app_description,
    p.app_type,
    case when p.app_group = 'SAMPLE' then
        'Sample Application'
    when p.app_group = 'PACKAGE' then
        'Packaged Application'
    end as app_group,
    p.app_group           as app_group_code,
    p.app_status          ,
    p.app_display_version as app_version,
    p.app_version_date    as release_date,
    case when p.app_category_id_1 is not null then     
        ( select c.category_name from wwv_flow_pkg_app_categories c where c.id = p.app_category_id_1 )
    end ||
    case when p.app_category_id_2 is not null then
        ', '||( select c.category_name from wwv_flow_pkg_app_categories c where c.id = p.app_category_id_2 )
    end ||
    case when p.app_category_id_3 is not null then
        ', '||( select c.category_name from wwv_flow_pkg_app_categories c where c.id = p.app_category_id_3 )
    end as app_category,
    p.change_log,
    p.required_free_kb,      
    p.languages,
    p.min_apex_version,
    p.min_db_version, 
    p.provider_company,
    p.provider_email,
    p.provider_website
from wwv_flow_pkg_applications p
where p.app_status = 'AVAILABLE'
and p.app_group != 'CUSTOM'
/

comment on table  apex_pkg_app_available                  is 'List of available packaged applications for installation in a workspace';
comment on column apex_pkg_app_available.app_id           is 'Packaged application ID';
comment on column apex_pkg_app_available.app_name         is 'Packaged application name';
comment on column apex_pkg_app_available.app_description  is 'Packaged application description';
comment on column apex_pkg_app_available.app_type         is 'Identifies packaged application type of database or websheet';
comment on column apex_pkg_app_available.app_group        is 'Identifies packaged application group of sample or packaged application';
comment on column apex_pkg_app_available.app_group_code   is 'Identifies packaged application group code';
comment on column apex_pkg_app_available.app_status       is 'Packaged application status';
comment on column apex_pkg_app_available.app_version      is 'The version of the packaged application';
comment on column apex_pkg_app_available.release_date     is 'The date the packaged application released';
comment on column apex_pkg_app_available.app_category     is 'Packaged application category';
comment on column apex_pkg_app_available.change_log       is 'The primary changes that have been made to the application since its previous version';
comment on column apex_pkg_app_available.required_free_kb is 'Identifies the amount of free space required to install the supporting objects associated with the application';
comment on column apex_pkg_app_available.languages        is 'The language the application is available in';
comment on column apex_pkg_app_available.min_apex_version is 'The minimum version of Oracle APEX required to install the application';
comment on column apex_pkg_app_available.min_db_version   is 'The minimum version of Oracle Database required to install the application';
comment on column apex_pkg_app_available.provider_company is 'Indicates the provider of the application';
comment on column apex_pkg_app_available.provider_email   is 'Indicates the support email address for the provider of the application';
comment on column apex_pkg_app_available.provider_website is 'Indicates the website for the provider of the application';

--
-- view returns multiple rows of installed packaged application across the workspace the current schema has access to
--
prompt ...apex_pkg_app_installed
create or replace view apex_pkg_app_installed
as
-- DB App
select
    w.workspace_id,
    w.workspace,
    w.workspace_display_name,
    p.app_id,
    p.app_name,
    p.app_status,
    p.app_description,
    'Database' app_type,
    case when p.app_group = 'SAMPLE' then
        'Sample Application'
    when p.app_group = 'PACKAGE' then
        'Packaged Application'
    end as app_group,
    p.app_group as app_group_code,
    case when ( f.build_status = 'RUN_AND_HIDDEN' ) and ( p.build_version > m.installed_build_version ) then -- if locked and update available
        'Y'
    else
        'N'
    end as is_upgradable,
    case when f.build_status = 'RUN_AND_HIDDEN' then
        'Y'
    else
        'N'
    end is_locked,
    m.installed_app_id    as installed_app_id,
    f.owner,
    p.app_display_version as version_installed,
    (select name from wwv_flow_authentications where id = f.authentication_id) as authentication_scheme_name,
    (select scheme_type from wwv_flow_authentications where id = f.authentication_id) as authentication_sheme_type
from wwv_flow_current_workspaces w,
     wwv_flow_pkg_applications p,
     wwv_flow_pkg_app_map m,
     wwv_flows f
 where w.workspace_id = m.security_group_id
 and p.app_id = m.app_id
 and p.app_status = 'AVAILABLE'
 and p.app_group != 'CUSTOM'
 and m.installed_app_id = f.id 
 and w.workspace_id = f.security_group_id
 and p.app_type = 'DB'
union all
-- Websheet App
select
    w.workspace_id,
    w.workspace,
    w.workspace_display_name,
    p.app_id,
    p.app_name,
    p.app_status,
    p.app_description,
    'Websheet' as app_type,
    case when p.app_group = 'SAMPLE' then
        'Sample Application'
    when p.app_group = 'PACKAGE' then
        'Packaged Application'
    end as app_group,
    p.app_group as app_group_code,
    'N' is_upgradable,
    'N' is_locked,
    m.installed_ws_id as installed_app_id,
    w.owner,
    p.app_display_version as version_installed,
    (select name from wwv_flow_ws_custom_auth_setups where id = w.auth_id) as authentication_scheme_name,
    null as authentication_sheme_type
from wwv_flow_current_workspaces w,
     wwv_flow_pkg_applications p,
     wwv_flow_pkg_app_map m,
     wwv_flow_ws_applications w
 where w.workspace_id = m.security_group_id
 and p.app_id = m.app_id
 and p.app_status = 'AVAILABLE'
 and p.app_group != 'CUSTOM'
 and m.installed_ws_id = w.id
 and w.workspace_id = w.security_group_id
 and p.app_type = 'WS'
/

comment on table  apex_pkg_app_installed                             is 'The installed packaged applications across the workspace the current schema has access to';
comment on column apex_pkg_app_installed.workspace_id                is 'Primary key that identifies the workspace';
comment on column apex_pkg_app_installed.workspace                   is 'A work area mapped to one or more database schemas';
comment on column apex_pkg_app_installed.workspace_display_name      is 'Display name for the workspace';
comment on column apex_pkg_app_installed.app_id                      is 'Packaged application ID';
comment on column apex_pkg_app_installed.app_name                    is 'Packaged application name';
comment on column apex_pkg_app_installed.app_status                  is 'Packaged application status';
comment on column apex_pkg_app_installed.app_description             is 'Packaged application description';
comment on column apex_pkg_app_installed.app_type                    is 'Identifies packaged application type of database or websheet';
comment on column apex_pkg_app_installed.app_group                   is 'Identifies packaged application group of sample or packaged application';
comment on column apex_pkg_app_installed.app_group_code              is 'Identifies packaged application group code';
comment on column apex_pkg_app_installed.is_upgradable               is 'Identifies if the newer version of packaged application is available to upgrade'; 
comment on column apex_pkg_app_installed.is_locked                   is 'Identifies if the packaged application is locked.  Unlocked packaged applications are ineligible for future upgrades and not supported.';
comment on column apex_pkg_app_installed.installed_app_id            is 'Installed application ID of the packaged application';
comment on column apex_pkg_app_installed.owner                       is 'Identifies the database schema that the installed application will parse SQL and PL/SQL statements as';
comment on column apex_pkg_app_installed.version_installed           is 'The installed version of the packaged application';
comment on column apex_pkg_app_installed.authentication_scheme_name  is 'Identifies the current authentication method used by the installed application';
comment on column apex_pkg_app_installed.authentication_sheme_type   is 'Identifies the internal code of authentication_scheme_name';

prompt ...apex_pkg_app_activity
create or replace view apex_pkg_app_activity
as
select a.workspace_id,
       a.workspace,
       f.id               as application_id,
       f.name             as application_name,
       a.app_id           as pkg_app_id,
       l.log_day,
       l.page_events,
       l.page_views,
       l.page_accepts,
       l.partial_page_views,
       l.rows_fetched,
       l.ir_searches,
       l.distinct_pages,
       l.distinct_users,
       l.distinct_sessions,
       l.average_render_time,   
       l.median_render_time, 
       l.maximum_render_time,
       l.total_render_time,
       l.error_count,
       l.content_length
from   wwv_flow_pkg_app_authorized a,
       wwv_flow_pkg_app_map m,
       wwv_flows f,
       wwv_flow_log_history l
where  a.app_id = m.app_id
 and   a.workspace_id = m.security_group_id
 and   a.workspace_id = f.security_group_id
 and   m.installed_app_id = f.id
 and   l.application_id = f.id
/

comment on table apex_pkg_app_activity is 'The summary of packaged application acitivity that is retained until physically purged';
comment on column apex_pkg_app_activity.workspace_id          is 'Primary key that identifies the workspace';
comment on column apex_pkg_app_activity.workspace             is 'A work area mapped to one or more database schemas';
comment on column apex_pkg_app_activity.application_id        is 'Application Primary Key, Unique over all workspaces';
comment on column apex_pkg_app_activity.application_name      is 'Identifies the application';
comment on column apex_pkg_app_activity.pkg_app_id            is 'The packaged application ID';
comment on column apex_pkg_app_activity.log_day               is 'Day that all workspace statistics are summarized for';
comment on column apex_pkg_app_activity.page_events           is 'Total number of page events logged for a given day and workspace';
comment on column apex_pkg_app_activity.page_views            is 'Total page views for a given day and workspace';
comment on column apex_pkg_app_activity.page_accepts          is 'Total page accepts for a given day and workspace';
comment on column apex_pkg_app_activity.partial_page_views    is 'Total partial page views for a given day and workspace';
comment on column apex_pkg_app_activity.rows_fetched          is 'Total rows fetched by apex reporting engines for a given day and workspace';
comment on column apex_pkg_app_activity.ir_searches           is 'Total not null interactive report search values logged to the activity log';
comment on column apex_pkg_app_activity.distinct_pages        is 'Summarized information by day and workspace';
comment on column apex_pkg_app_activity.distinct_users        is 'Summarized information by day and workspace';
comment on column apex_pkg_app_activity.distinct_sessions     is 'Summarized information by day and workspace';
comment on column apex_pkg_app_activity.average_render_time   is 'Summarized information by day and workspace';
comment on column apex_pkg_app_activity.median_render_time    is 'Summarized information by day and workspace';
comment on column apex_pkg_app_activity.maximum_render_time   is 'Summarized information by day and workspace';
comment on column apex_pkg_app_activity.total_render_time     is 'Summarized information by day and workspace';
comment on column apex_pkg_app_activity.error_count           is 'Summarized information by day and workspace';
comment on column apex_pkg_app_activity.content_length        is 'Summarized information by day and workspace';

