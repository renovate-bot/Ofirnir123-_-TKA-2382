set define off verify off
prompt ...create Quick SQL objects

Rem  Copyright (c) Oracle Corporation 2017 - 2017. All Rights Reserved.
Rem
Rem    NAME
Rem      wwv_qs_tables.sql
Rem
Rem    DESCRIPTION
Rem      Creates the tables required to run Quick SQL functionality from within APEX
Rem
Rem    NOTES
Rem
Rem    REQUIRMENTS
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem    mhichwa     10/12/2017 - Created
Rem    hfarrell    10/27/2017 - Resolved public synonym dependency issues in Hudson: prefixed occurrence of dual with sys.
Rem    jstraub     08/22/2018 - Replaced timestamp with local timezone with date (Bug 28538783)


create sequence WWV_QS_seq  minvalue 1000 maxvalue 999999999999999999999999999 increment by 1 start with 1000 cache 20 noorder  nocycle;

create table WWV_QS_errors (
    id                 number not null
                       constraint WWV_QS_errors_pk
                       primary key,
    err_time           date
                       default sysdate
                       not null,
    app_id             number,
    app_page_id        number,
    app_user           varchar2(512),
    user_agent         varchar2(4000),
    ip_address         varchar2(512), -- As reported by owa_util.get_cgi_env
    ip_address2       varchar2(512), -- As reported by sys_context
    -- From APEX_ERROR.T_ERROR:
    message           varchar2(4000), /* Displayed error message */
    page_item_name    varchar2(255),  /* Associated page item name */
    region_id         number,         /* Associated tabular form region id of the primary application */
    column_alias      varchar2(255),  /* Associated tabular form column alias */
    row_num           number,         /* Associated tabular form row */
    apex_error_code   varchar2(255),  /* Contains the system message code if it''s an error raised by APEX */
    ora_sqlcode       number,         /* SQLCODE on exception stack which triggered the error, NULL if the error was not raised by an ORA error */
    ora_sqlerrm       varchar2(4000), /* SQLERRM which triggered the error, NULL if the error was not raised by an ORA error */
    error_backtrace   varchar2(4000)  /* Output of dbms_utility.format_error_backtrace or dbms_utility.format_call_stack */
    -- END APEX_ERROR.T_ERROR
);

create index WWV_QS_errors_i1 on WWV_QS_errors( err_time );

create or replace trigger bi_WWV_QS_errors
    before insert or update on WWV_QS_errors
    for each row
begin
    if :new.id is null then
        select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') into :new.id from sys.dual;
    end if;
end;
/
show errors


CREATE TABLE WWV_QS_MODELS (
    id                      number primary key,
    name                    varchar2(255) not null,
    description             varchar2(4000),
    model_type              varchar2(60),
    identifier              varchar2(255),
    --
    quick_sql               clob,
    generated_sql           clob,
    --
    ERD                     blob,
    ERD_filename            varchar2(512),
    ERD_mimetype            varchar2(512),
    ERD_charset             varchar2(512),
    ERD_lastupd             date,
    --
    published_yn            varchar2(1) default 'N',
    --
    created                 date,
    created_by              varchar2(255),
    updated                 date,
    updated_by              varchar2(255)
    )
/


create or replace trigger biu_wwv_qs_models
before insert or update on wwv_qs_models
for each row
begin
    if inserting then
        if :new.id is null then
            :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
        end if;
        :new.created_by         := nvl(v('APP_USER'), USER);
        :new.created            := sysdate;
    end if;
    :new.identifier := lower(:new.identifier);
    :NEW.UPDATED := sysdate;
    :NEW.UPDATED_BY := nvl(v('APP_USER'),USER);
    if :new.published_yn is null then
       :new.published_yn := 'N';
    end if;
end;
/
show errors

create unique index WWV_QS_models_i1 on WWV_QS_models(identifier)
/

create table WWV_QS_RANDOM_NAMES (
    ID                             NUMBER not null constraint WWV_QS_RANDOM_ID_PK primary key,
    seq                            integer,
    language                       varchar2(30) default 'en',
    FIRST_NAME                     VARCHAR2(255),
    LAST_NAME                      VARCHAR2(255),
    FULL_NAME                      VARCHAR2(255),
    EMAIL                          VARCHAR2(255),
    profile                        varchar2(4000),
    job                            varchar2(100),
    guid                           varchar2(255),
    phone_number                   varchar2(30),
    num_1_100                      integer,
    num_1_10                       integer,
    words_1                        varchar2(100),
    words_2                        varchar2(100),
    words_3                        varchar2(255),
    words_4                        varchar2(255),
    words_1_60                     varchar2(4000),
    words_1_100                    varchar2(4000),
    project_name                   varchar2(100),
    department_name                varchar2(100),
    city                           varchar2(100),
    country                        varchar2(50),
    tswtz                          timestamp with time zone,
    tswltz                         date,
    d                              date,
    tags                           varchar2(4000)
)
;

create sequence WWV_QS_RANDOM_NAMES_SEQ;

create table WWV_QS_SAVED_MODELS (
    ID                             NUMBER not null primary key,
    ROW_VERSION                    INTEGER not null,
    NAME                           VARCHAR2(255),
    IDENTIFIER                     VARCHAR2(50),
    model_version                  varchar2(50),
    description                    varchar2(4000),
    settings                       varchar2(4000),
    IS_PUBLIC_YN                   varchar2(1) default 'N',
    MODEL                          CLOB,
    CREATED                        date not null,
    CREATED_BY                     VARCHAR2(255) not null,
    UPDATED                        date not null,
    UPDATED_BY                     VARCHAR2(255) not null
)
;

create or replace trigger wwv_qs_saved_models_biu
    before insert or update
    on WWV_QS_SAVED_MODELS
    for each row
begin
    if :new.id is null then
        :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
    if inserting then
        :new.ROW_VERSION := 1;
    elsif updating then
        :new.ROW_VERSION := NVL(:old.ROW_VERSION,0) + 1;
    end if;
    if inserting then
        :new.created := sysdate;
        :new.created_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),user);
    end if;
    :new.updated := sysdate;
    :new.updated_by := NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),user);
end;
/

create unique index WWV_QS_SAVED_MODELS_i1 on WWV_QS_SAVED_MODELS(IDENTIFIER);

set define '^'
