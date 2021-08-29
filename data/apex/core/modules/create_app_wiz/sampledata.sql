-- drop objects
drop table AA_DEPARTMENTS cascade constraints;
drop table AA_EMPLOYEES cascade constraints;
drop table AA_SKILLS cascade constraints;
drop table AA_PROJECTS cascade constraints;
drop view AA_DEPARTMENT_EMPLOYEES;
drop view AA_EMPLOYEE_SKILLS;

-- create tables
create table AA_DEPARTMENTS (
    ID                             NUMBER not null constraint AA_DEPARTMENTS_ID_PK primary key,
    NAME                           VARCHAR2(50)
                                   constraint AA_DEPARTMENTS_NAME_UNQ unique not null,
    COST_CENTER                    VARCHAR2(4000),
    DESCRIPTION                    VARCHAR2(4000)
)
;

create table AA_EMPLOYEES (
    ID                             NUMBER not null constraint AA_EMPLOYEES_ID_PK primary key,
    DEPARTMENT_ID                  NUMBER
                                   constraint AA_EMPLOYEES_DEPARTMENT_ID_FK
                                   references AA_DEPARTMENTS on delete cascade,
    NAME                           VARCHAR2(50) not null,
    EMAIL                          VARCHAR2(255)
                                   constraint AA_EMPLOYEES_EMAIL_UNQ unique,
    CITY                           VARCHAR2(80),
    COUNTRY                        VARCHAR2(2),
    HIREDATE                       TIMESTAMP WITH LOCAL TIME ZONE,
    RESUME                         BLOB,
    RESUME_FILENAME                varchar2(512),
    RESUME_MIMETYPE                varchar2(512),
    RESUME_CHARSET                 varchar2(512),
    RESUME_LASTUPD                 TIMESTAMP WITH LOCAL TIME ZONE
)
;

create table AA_SKILLS (
    ID                             NUMBER not null constraint AA_SKILLS_ID_PK primary key,
    EMPLOYEE_ID                    NUMBER
                                   constraint AA_SKILLS_EMPLOYEE_ID_FK
                                   references AA_EMPLOYEES on delete cascade,
    SKILL                          VARCHAR2(50) not null,
    PROFICIENCY                    NUMBER constraint AA_SKILLS_PROFICIENCY_CC
                                   check (PROFICIENCY in (1, 2, 3, 4, 5)) not null
)
;

create table AA_PROJECTS (
    ID                             NUMBER not null constraint AA_PROJECTS_ID_PK primary key,
    EMPLOYEE_ID                    NUMBER
                                   constraint AA_PROJECTS_EMPLOYEE_ID_FK
                                   references AA_EMPLOYEES on delete cascade,
    PROJECT_NAME                   VARCHAR2(100),
    STATUS                         VARCHAR2(50) constraint AA_PROJECTS_STATUS_CC
                                   check (STATUS in ('ACTIVE',' PRIORITIZED',' CLOSED',' UNDER CONSIDERATION'))
)
;


-- triggers
create or replace trigger AA_DEPARTMENTS_BIU
    before insert or update 
    on AA_DEPARTMENTS
    for each row
begin
    if :new.id is null then
        :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
end;
/

create or replace trigger AA_EMPLOYEES_BIU
    before insert or update 
    on AA_EMPLOYEES
    for each row
begin
    if :new.id is null then
        :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
    :new.EMAIL := LOWER(:new.EMAIL);
end;
/

create or replace trigger AA_PROJECTS_BIU
    before insert or update 
    on AA_PROJECTS
    for each row
begin
    if :new.id is null then
        :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
end;
/

create or replace trigger AA_SKILLS_BIU
    before insert or update 
    on AA_SKILLS
    for each row
begin
    if :new.id is null then
        :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
    :new.SKILL := UPPER(:new.SKILL);
end;
/


-- indexes
create index AA_EMPLOYEES_i1 on AA_EMPLOYEES (DEPARTMENT_ID);
create index AA_EMPLOYEES_i2 on AA_EMPLOYEES (NAME);
create index AA_PROJECTS_i1 on AA_PROJECTS (EMPLOYEE_ID);
create index AA_SKILLS_i1 on AA_SKILLS (EMPLOYEE_ID);

-- comments
comment on column AA_EMPLOYEES.CITY is 'Enter the city from where the employee works';
comment on column AA_EMPLOYEES.COUNTRY is 'Use 2 character country codes';
comment on column AA_SKILLS.PROFICIENCY is 'With 5 being guru and 1 being beginner level';

-- create views
create or replace view AA_DEPARTMENT_EMPLOYEES as 
select 
    DEPARTMENTS.ID                                     DEPARTMENT_ID,
    DEPARTMENTS.NAME                                   DEPARTMENT_NAME,
    DEPARTMENTS.COST_CENTER                            COST_CENTER,
    DEPARTMENTS.DESCRIPTION                            DESCRIPTION,
    EMPLOYEES.ID                                       EMPLOYEE_ID,
    EMPLOYEES.NAME                                     EMPLOYEE_NAME,
    EMPLOYEES.EMAIL                                    EMAIL,
    EMPLOYEES.CITY                                     CITY,
    EMPLOYEES.COUNTRY                                  COUNTRY,
    EMPLOYEES.HIREDATE                                 HIREDATE,
    EMPLOYEES.RESUME                                   RESUME,
    EMPLOYEES.RESUME_FILENAME                          RESUME_FILENAME,
    EMPLOYEES.RESUME_MIMETYPE                          RESUME_MIMETYPE,
    EMPLOYEES.RESUME_CHARSET                           RESUME_CHARSET,
    EMPLOYEES.RESUME_LASTUPD                           RESUME_LASTUPD
from 
    AA_DEPARTMENTS DEPARTMENTS,
    AA_EMPLOYEES EMPLOYEES
where
    EMPLOYEES.DEPARTMENT_ID(+) = DEPARTMENTS.ID
/

create or replace view AA_EMPLOYEE_SKILLS as 
select 
    EMPLOYEES.ID                                       EMPLOYEE_ID,
    EMPLOYEES.DEPARTMENT_ID                            DEPARTMENT_ID,
    EMPLOYEES.NAME                                     NAME,
    EMPLOYEES.EMAIL                                    EMAIL,
    EMPLOYEES.CITY                                     CITY,
    EMPLOYEES.COUNTRY                                  COUNTRY,
    EMPLOYEES.HIREDATE                                 HIREDATE,
    EMPLOYEES.RESUME                                   RESUME,
    EMPLOYEES.RESUME_FILENAME                          RESUME_FILENAME,
    EMPLOYEES.RESUME_MIMETYPE                          RESUME_MIMETYPE,
    EMPLOYEES.RESUME_CHARSET                           RESUME_CHARSET,
    EMPLOYEES.RESUME_LASTUPD                           RESUME_LASTUPD,
    SKILLS.ID                                          SKILL_ID,
    SKILLS.SKILL                                       SKILL,
    SKILLS.PROFICIENCY                                 PROFICIENCY
from 
    AA_EMPLOYEES EMPLOYEES,
    AA_SKILLS SKILLS
where
    SKILLS.EMPLOYEE_ID(+) = EMPLOYEES.ID
/

insert into AA_DEPARTMENTS (
    ID,
    NAME,
    COST_CENTER,
    DESCRIPTION
) values (
    99637641956234535927240786329809474626,
    'Customer Satisfaction',
    'CC01',
    'Eu mi a, rutrum molestie nisl. Pellentesque tempus, magna eu lobortis tincidunt, orci mi condimentum eros, quis tincidunt dolor quam in est. Aliquam vestibulum magna vel nunc volutpat sollicitudin. Cras nisl erat, egestas in tellus id, semper bibendum massa. Aenean dignissim posuere facilisis. Duis eu accumsan orci. Morbi elementum sagittis iaculis. Donec non diam.'
);

insert into AA_DEPARTMENTS (
    ID,
    NAME,
    COST_CENTER,
    DESCRIPTION
) values (
    99637641956235744853060400958984180802,
    'Finance',
    'CC02',
    'Adipiscing elit. Aenean sit amet justo metus. Aliquam nec blandit neque, eget pretium leo. Nam gravida accumsan consectetur. Proin pharetra enim velit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent viverra quam ac diam rhoncus, vel ullamcorper metus molestie. Nunc vel sapien erat. Fusce auctor tellus nibh, non vulputate neque lobortis quis. Suspendisse aliquet, lacus ut iaculis.'
);

insert into AA_DEPARTMENTS (
    ID,
    NAME,
    COST_CENTER,
    DESCRIPTION
) values (
    99637641956236953778880015588158886978,
    'Office of the CEO',
    'CC02',
    'Blandit neque, eget pretium leo. Nam gravida accumsan consectetur. Proin pharetra enim velit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent viverra quam ac diam rhoncus, vel ullamcorper metus molestie. Nunc vel sapien erat. Fusce auctor tellus nibh, non vulputate neque lobortis quis. Suspendisse aliquet, lacus ut iaculis placerat, dui lorem malesuada lorem, vel aliquet enim diam nec sem. Morbi ipsum ex, laoreet eu mi a, rutrum molestie.'
);

insert into AA_DEPARTMENTS (
    ID,
    NAME,
    COST_CENTER,
    DESCRIPTION
) values (
    99637641956238162704699630217333593154,
    'Health',
    'CC02',
    'Tellus nibh, non vulputate neque lobortis quis. Suspendisse aliquet, lacus ut iaculis.'
);

-- load data
insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956239371630519244846508299330,
    99637641956234535927240786329809474626,
    'Gricelda Luebbers',
    'gricelda.luebbers@aaab.com',
    'Tanquecitos',
    'MX',
    cast(add_months(systimestamp,-3) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-18) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956240580556338859475683005506,
    99637641956235744853060400958984180802,
    'Dean Bollich',
    'dean.bollich@aaac.com',
    'Sugarloaf',
    'US',
    cast(add_months(systimestamp,-2) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-6) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956241789482158474104857711682,
    99637641956238162704699630217333593154,
    'Milo Manoni',
    'milo.manoni@aaad.com',
    'Dale City',
    'US',
    cast(add_months(systimestamp,-5) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-14) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956242998407978088734032417858,
    99637641956238162704699630217333593154,
    'Laurice Karl',
    'laurice.karl@aaae.com',
    'Grosvenor',
    'CA',
    cast(add_months(systimestamp,-1) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-18) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956244207333797703363207124034,
    99637641956235744853060400958984180802,
    'August Rupel',
    'august.rupel@aaaf.com',
    'Riverside',
    'US',
    cast(add_months(systimestamp,-9) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-7) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956245416259617317992381830210,
    99637641956234535927240786329809474626,
    'Salome Guisti',
    'salome.guisti@aaag.com',
    'Ridgeley',
    'MX',
    cast(add_months(systimestamp,-15) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-9) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956246625185436932621556536386,
    99637641956235744853060400958984180802,
    'Lovie Ritacco',
    'lovie.ritacco@aaah.com',
    'Ashley Heights',
    'US',
    cast(add_months(systimestamp,-17) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-7) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956247834111256547250731242562,
    99637641956234535927240786329809474626,
    'Chaya Greczkowski',
    'chaya.greczkowski@aaai.com',
    'Monfort Heights',
    'CA',
    cast(add_months(systimestamp,-8) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-2) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956249043037076161879905948738,
    99637641956235744853060400958984180802,
    'Twila Coolbeth',
    'twila.coolbeth@aaaj.com',
    'Point Marion',
    'MX',
    cast(add_months(systimestamp,-14) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-19) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956250251962895776509080654914,
    99637641956236953778880015588158886978,
    'Carlotta Achenbach',
    'carlotta.achenbach@aaak.com',
    'Eldon',
    'US',
    cast(add_months(systimestamp,-4) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-21) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956251460888715391138255361090,
    99637641956236953778880015588158886978,
    'Jeraldine Audet',
    'jeraldine.audet@aaal.com',
    'Greendale',
    'MX',
    cast(add_months(systimestamp,-2) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-4) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956252669814535005767430067266,
    99637641956238162704699630217333593154,
    'August Arouri',
    'august.arouri@aaam.com',
    'Ammon',
    'CA',
    cast(add_months(systimestamp,-14) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-16) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956253878740354620396604773442,
    99637641956234535927240786329809474626,
    'Ward Stepney',
    'ward.stepney@aaan.com',
    'Wallsburg',
    'US',
    cast(add_months(systimestamp,-21) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-7) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956255087666174235025779479618,
    99637641956238162704699630217333593154,
    'Ayana Barkhurst',
    'ayana.barkhurst@aaao.com',
    'De Pue',
    'US',
    cast(add_months(systimestamp,-18) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-6) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956256296591993849654954185794,
    99637641956236953778880015588158886978,
    'Luana Berends',
    'luana.berends@aaap.com',
    'Prompton',
    'US',
    cast(add_months(systimestamp,-1) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-19) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956257505517813464284128891970,
    99637641956236953778880015588158886978,
    'Lecia Alvino',
    'lecia.alvino@aaaq.com',
    'New Rockford',
    'US',
    cast(add_months(systimestamp,-5) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-18) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956258714443633078913303598146,
    99637641956238162704699630217333593154,
    'Joleen Himmelmann',
    'joleen.himmelmann@aaar.com',
    'Tygh Valley',
    'MX',
    cast(add_months(systimestamp,-11) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-5) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956259923369452693542478304322,
    99637641956238162704699630217333593154,
    'Monty Kinnamon',
    'monty.kinnamon@aaas.com',
    'Lookout',
    'US',
    cast(add_months(systimestamp,-9) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-17) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956261132295272308171653010498,
    99637641956235744853060400958984180802,
    'Dania Grizzard',
    'dania.grizzard@aaat.com',
    'Hermiston',
    'MX',
    cast(add_months(systimestamp,-20) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-8) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956262341221091922800827716674,
    99637641956235744853060400958984180802,
    'Inez Yamnitz',
    'inez.yamnitz@aaau.com',
    'Mendota Heights',
    'US',
    cast(add_months(systimestamp,-6) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-20) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956263550146911537430002422850,
    99637641956236953778880015588158886978,
    'Fidel Creps',
    'fidel.creps@aaav.com',
    'Kernersville',
    'US',
    cast(add_months(systimestamp,-7) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-13) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956264759072731152059177129026,
    99637641956236953778880015588158886978,
    'Luis Pothoven',
    'luis.pothoven@aaaw.com',
    'North Canton',
    'US',
    cast(add_months(systimestamp,-18) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-9) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956265967998550766688351835202,
    99637641956235744853060400958984180802,
    'Bernardo Phoenix',
    'bernardo.phoenix@aaax.com',
    'El Ojo',
    'US',
    cast(add_months(systimestamp,-13) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-6) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956267176924370381317526541378,
    99637641956234535927240786329809474626,
    'Carolyne Centore',
    'carolyne.centore@aaay.com',
    'Sherrodsville',
    'US',
    cast(add_months(systimestamp,-21) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-5) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956268385850189995946701247554,
    99637641956236953778880015588158886978,
    'Cornell Pratico',
    'cornell.pratico@aaaz.com',
    'Fort Bridger',
    'CA',
    cast(add_months(systimestamp,-2) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-15) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956269594776009610575875953730,
    99637641956235744853060400958984180802,
    'Sam Rueb',
    'sam.rueb@aaa0.com',
    'Rural Retreat',
    'US',
    cast(add_months(systimestamp,-11) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-9) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956270803701829225205050659906,
    99637641956234535927240786329809474626,
    'Shakita Sablock',
    'shakita.sablock@aaa1.com',
    'Girard',
    'US',
    cast(add_months(systimestamp,-1) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-8) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956272012627648839834225366082,
    99637641956234535927240786329809474626,
    'Sandy Heffren',
    'sandy.heffren@aaa2.com',
    'South Greeley',
    'MX',
    cast(add_months(systimestamp,-6) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-16) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956273221553468454463400072258,
    99637641956234535927240786329809474626,
    'Tressa Coppens',
    'tressa.coppens@aaa3.com',
    'Marrmot Point',
    'CA',
    cast(add_months(systimestamp,-6) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-11) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956274430479288069092574778434,
    99637641956238162704699630217333593154,
    'Shira Arocho',
    'shira.arocho@aaa4.com',
    'Pointe a la Hache',
    'MX',
    cast(add_months(systimestamp,-13) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-3) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956275639405107683721749484610,
    99637641956238162704699630217333593154,
    'Carter Sacarello',
    'carter.sacarello@aaa5.com',
    'Inver Grove Heights',
    'MX',
    cast(add_months(systimestamp,-9) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-3) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956276848330927298350924190786,
    99637641956238162704699630217333593154,
    'Linda Merida',
    'linda.merida@aaa6.com',
    'Cochrane',
    'US',
    cast(add_months(systimestamp,-20) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-11) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956278057256746912980098896962,
    99637641956234535927240786329809474626,
    'Winfred Sohn',
    'winfred.sohn@aaa7.com',
    'Gainesville',
    'US',
    cast(add_months(systimestamp,-2) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-10) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956279266182566527609273603138,
    99637641956234535927240786329809474626,
    'Nestor Caparros',
    'nestor.caparros@aaa8.com',
    'Lake Norman of Catawba',
    'MX',
    cast(add_months(systimestamp,-6) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-20) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956280475108386142238448309314,
    99637641956238162704699630217333593154,
    'Brooks Craker',
    'brooks.craker@aaa9.com',
    'Natchez',
    'US',
    cast(add_months(systimestamp,-1) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-15) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956281684034205756867623015490,
    99637641956235744853060400958984180802,
    'Ruthann Nixa',
    'ruthann.nixa@aaba.com',
    'Hilshire Village',
    'US',
    cast(add_months(systimestamp,-18) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-21) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956282892960025371496797721666,
    99637641956236953778880015588158886978,
    'Kenny Campobasso',
    'kenny.campobasso@aabb.com',
    'Nickerson',
    'US',
    cast(add_months(systimestamp,-18) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-16) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956284101885844986125972427842,
    99637641956238162704699630217333593154,
    'Hildred Donnel',
    'hildred.donnel@aabc.com',
    'Woodruff',
    'US',
    cast(add_months(systimestamp,-4) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-21) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956285310811664600755147134018,
    99637641956236953778880015588158886978,
    'Luther Ardinger',
    'luther.ardinger@aabd.com',
    'Lynnfield',
    'US',
    cast(add_months(systimestamp,-4) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-5) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956286519737484215384321840194,
    99637641956234535927240786329809474626,
    'Rhoda Hasfjord',
    'rhoda.hasfjord@aabe.com',
    'Homeland',
    'MX',
    cast(add_months(systimestamp,-19) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-16) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956287728663303830013496546370,
    99637641956235744853060400958984180802,
    'Cori Ablin',
    'cori.ablin@aabf.com',
    'Castana',
    'US',
    cast(add_months(systimestamp,-11) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-21) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956288937589123444642671252546,
    99637641956238162704699630217333593154,
    'Reinaldo Feltner',
    'reinaldo.feltner@aabg.com',
    'Friedensburg',
    'US',
    cast(add_months(systimestamp,-18) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-11) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956290146514943059271845958722,
    99637641956234535927240786329809474626,
    'Coralee Acerno',
    'coralee.acerno@aabh.com',
    'Mission Bend',
    'CA',
    cast(add_months(systimestamp,-9) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-9) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956291355440762673901020664898,
    99637641956235744853060400958984180802,
    'Katherine Tagg',
    'katherine.tagg@aabi.com',
    'Maribel',
    'US',
    cast(add_months(systimestamp,-8) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-17) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956292564366582288530195371074,
    99637641956235744853060400958984180802,
    'Lenore Sullivan',
    'lenore.sullivan@aabj.com',
    'El Rio',
    'CA',
    cast(add_months(systimestamp,-13) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-8) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956293773292401903159370077250,
    99637641956236953778880015588158886978,
    'erda Sheer',
    'erda.sheer@aabk.com',
    'Brazos Bend',
    'US',
    cast(add_months(systimestamp,-12) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-6) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956294982218221517788544783426,
    99637641956238162704699630217333593154,
    'Pete Chevis',
    'pete.chevis@aabl.com',
    'Stonefort',
    'CA',
    cast(add_months(systimestamp,-5) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-4) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956296191144041132417719489602,
    99637641956235744853060400958984180802,
    'Joseph Wilke',
    'joseph.wilke@aabm.com',
    'Huntingdon',
    'US',
    cast(add_months(systimestamp,-14) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-11) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956297400069860747046894195778,
    99637641956238162704699630217333593154,
    'Nella Rupnick',
    'nella.rupnick@aabn.com',
    'Luxora',
    'US',
    cast(add_months(systimestamp,-3) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-1) as timestamp with local time zone)
);

insert into AA_EMPLOYEES (
    ID,
    DEPARTMENT_ID,
    NAME,
    EMAIL,
    CITY,
    COUNTRY,
    HIREDATE,
    RESUME,
    RESUME_FILENAME,
    RESUME_MIMETYPE,
    RESUME_CHARSET,
    RESUME_LASTUPD
) values (
    99637641956298608995680361676068901954,
    99637641956234535927240786329809474626,
    'Azalee Goodwater',
    'azalee.goodwater@aabo.com',
    'Yardville',
    'MX',
    cast(add_months(systimestamp,-5) as timestamp with local time zone),
    null,
    null,
    null,
    null,
    cast(add_months(systimestamp,-6) as timestamp with local time zone)
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956299817921499976305243608130,
    99637641956287728663303830013496546370,
    'ABCS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956301026847319590934418314306,
    99637641956257505517813464284128891970,
    'SQL',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956302235773139205563593020482,
    99637641956261132295272308171653010498,
    'DEVOPS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956303444698958820192767726658,
    99637641956262341221091922800827716674,
    'CLOUD',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956304653624778434821942432834,
    99637641956280475108386142238448309314,
    'CLOUD',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956305862550598049451117139010,
    99637641956282892960025371496797721666,
    'ABCS',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956307071476417664080291845186,
    99637641956270803701829225205050659906,
    'JAVA',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956308280402237278709466551362,
    99637641956246625185436932621556536386,
    'CLOUD',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956309489328056893338641257538,
    99637641956282892960025371496797721666,
    'DEVOPS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956310698253876507967815963714,
    99637641956298608995680361676068901954,
    'DEVOPS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956311907179696122596990669890,
    99637641956257505517813464284128891970,
    'CLOUD',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956313116105515737226165376066,
    99637641956274430479288069092574778434,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956314325031335351855340082242,
    99637641956239371630519244846508299330,
    'SQL',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956315533957154966484514788418,
    99637641956241789482158474104857711682,
    'JAVA',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956316742882974581113689494594,
    99637641956280475108386142238448309314,
    'CLOUD',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956317951808794195742864200770,
    99637641956242998407978088734032417858,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956319160734613810372038906946,
    99637641956240580556338859475683005506,
    'DEVOPS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956320369660433425001213613122,
    99637641956265967998550766688351835202,
    'APEX',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956321578586253039630388319298,
    99637641956249043037076161879905948738,
    'SQL',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956322787512072654259563025474,
    99637641956285310811664600755147134018,
    'ABCS',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956323996437892268888737731650,
    99637641956293773292401903159370077250,
    'SQL',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956325205363711883517912437826,
    99637641956276848330927298350924190786,
    'PERL',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956326414289531498147087144002,
    99637641956286519737484215384321840194,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956327623215351112776261850178,
    99637641956294982218221517788544783426,
    'ABCS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956328832141170727405436556354,
    99637641956281684034205756867623015490,
    'CLOUD',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956330041066990342034611262530,
    99637641956281684034205756867623015490,
    'JS',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956331249992809956663785968706,
    99637641956275639405107683721749484610,
    'PERL',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956332458918629571292960674882,
    99637641956286519737484215384321840194,
    'ABCS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956333667844449185922135381058,
    99637641956275639405107683721749484610,
    'JS',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956334876770268800551310087234,
    99637641956287728663303830013496546370,
    'DEVOPS',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956336085696088415180484793410,
    99637641956258714443633078913303598146,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956337294621908029809659499586,
    99637641956297400069860747046894195778,
    'JS',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956338503547727644438834205762,
    99637641956276848330927298350924190786,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956339712473547259068008911938,
    99637641956298608995680361676068901954,
    'JS',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956340921399366873697183618114,
    99637641956251460888715391138255361090,
    'JS',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956342130325186488326358324290,
    99637641956292564366582288530195371074,
    'PERL',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956343339251006102955533030466,
    99637641956241789482158474104857711682,
    'JS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956344548176825717584707736642,
    99637641956296191144041132417719489602,
    'CLOUD',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956345757102645332213882442818,
    99637641956255087666174235025779479618,
    'APEX',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956346966028464946843057148994,
    99637641956256296591993849654954185794,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956348174954284561472231855170,
    99637641956282892960025371496797721666,
    'JS',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956349383880104176101406561346,
    99637641956269594776009610575875953730,
    'CLOUD',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956350592805923790730581267522,
    99637641956294982218221517788544783426,
    'APEX',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956351801731743405359755973698,
    99637641956290146514943059271845958722,
    'APEX',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956353010657563019988930679874,
    99637641956245416259617317992381830210,
    'JS',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956354219583382634618105386050,
    99637641956274430479288069092574778434,
    'DEVOPS',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956355428509202249247280092226,
    99637641956247834111256547250731242562,
    'JAVA',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956356637435021863876454798402,
    99637641956264759072731152059177129026,
    'APEX',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956357846360841478505629504578,
    99637641956297400069860747046894195778,
    'APEX',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956359055286661093134804210754,
    99637641956278057256746912980098896962,
    'APEX',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956360264212480707763978916930,
    99637641956298608995680361676068901954,
    'CLOUD',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956361473138300322393153623106,
    99637641956240580556338859475683005506,
    'JS',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956362682064119937022328329282,
    99637641956279266182566527609273603138,
    'JAVA',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956363890989939551651503035458,
    99637641956258714443633078913303598146,
    'JS',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956365099915759166280677741634,
    99637641956264759072731152059177129026,
    'SQL',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956366308841578780909852447810,
    99637641956264759072731152059177129026,
    'DEVOPS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956367517767398395539027153986,
    99637641956264759072731152059177129026,
    'JS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956368726693218010168201860162,
    99637641956272012627648839834225366082,
    'JS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956369935619037624797376566338,
    99637641956241789482158474104857711682,
    'JAVA',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956371144544857239426551272514,
    99637641956263550146911537430002422850,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956372353470676854055725978690,
    99637641956293773292401903159370077250,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956373562396496468684900684866,
    99637641956263550146911537430002422850,
    'APEX',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956374771322316083314075391042,
    99637641956286519737484215384321840194,
    'APEX',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956375980248135697943250097218,
    99637641956264759072731152059177129026,
    'JS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956377189173955312572424803394,
    99637641956256296591993849654954185794,
    'PERL',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956378398099774927201599509570,
    99637641956250251962895776509080654914,
    'ABCS',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956379607025594541830774215746,
    99637641956244207333797703363207124034,
    'JAVA',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956380815951414156459948921922,
    99637641956275639405107683721749484610,
    'APEX',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956382024877233771089123628098,
    99637641956247834111256547250731242562,
    'JS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956383233803053385718298334274,
    99637641956290146514943059271845958722,
    'JAVA',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956384442728873000347473040450,
    99637641956251460888715391138255361090,
    'PERL',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956385651654692614976647746626,
    99637641956261132295272308171653010498,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956386860580512229605822452802,
    99637641956251460888715391138255361090,
    'SQL',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956388069506331844234997158978,
    99637641956287728663303830013496546370,
    'JS',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956389278432151458864171865154,
    99637641956282892960025371496797721666,
    'CLOUD',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956390487357971073493346571330,
    99637641956256296591993849654954185794,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956391696283790688122521277506,
    99637641956247834111256547250731242562,
    'DEVOPS',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956392905209610302751695983682,
    99637641956250251962895776509080654914,
    'JAVA',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956394114135429917380870689858,
    99637641956258714443633078913303598146,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956395323061249532010045396034,
    99637641956264759072731152059177129026,
    'JS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956396531987069146639220102210,
    99637641956263550146911537430002422850,
    'ABCS',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956397740912888761268394808386,
    99637641956267176924370381317526541378,
    'PERL',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956398949838708375897569514562,
    99637641956252669814535005767430067266,
    'JS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956400158764527990526744220738,
    99637641956278057256746912980098896962,
    'CLOUD',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956401367690347605155918926914,
    99637641956241789482158474104857711682,
    'ABCS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956402576616167219785093633090,
    99637641956272012627648839834225366082,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956403785541986834414268339266,
    99637641956265967998550766688351835202,
    'APEX',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956404994467806449043443045442,
    99637641956262341221091922800827716674,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956406203393626063672617751618,
    99637641956292564366582288530195371074,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956407412319445678301792457794,
    99637641956282892960025371496797721666,
    'ABCS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956408621245265292930967163970,
    99637641956239371630519244846508299330,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956409830171084907560141870146,
    99637641956296191144041132417719489602,
    'APEX',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956411039096904522189316576322,
    99637641956297400069860747046894195778,
    'CLOUD',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956412248022724136818491282498,
    99637641956268385850189995946701247554,
    'ABCS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956413456948543751447665988674,
    99637641956239371630519244846508299330,
    'ABCS',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956414665874363366076840694850,
    99637641956285310811664600755147134018,
    'PERL',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956415874800182980706015401026,
    99637641956284101885844986125972427842,
    'CLOUD',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956417083726002595335190107202,
    99637641956249043037076161879905948738,
    'PERL',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956418292651822209964364813378,
    99637641956278057256746912980098896962,
    'PERL',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956419501577641824593539519554,
    99637641956276848330927298350924190786,
    'PERL',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956420710503461439222714225730,
    99637641956276848330927298350924190786,
    'JS',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956421919429281053851888931906,
    99637641956280475108386142238448309314,
    'JAVA',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956423128355100668481063638082,
    99637641956293773292401903159370077250,
    'CLOUD',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956424337280920283110238344258,
    99637641956252669814535005767430067266,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956425546206739897739413050434,
    99637641956279266182566527609273603138,
    'JAVA',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956426755132559512368587756610,
    99637641956244207333797703363207124034,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956427964058379126997762462786,
    99637641956249043037076161879905948738,
    'APEX',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956429172984198741626937168962,
    99637641956281684034205756867623015490,
    'ABCS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956430381910018356256111875138,
    99637641956282892960025371496797721666,
    'CLOUD',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956431590835837970885286581314,
    99637641956285310811664600755147134018,
    'JS',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956432799761657585514461287490,
    99637641956294982218221517788544783426,
    'ABCS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956434008687477200143635993666,
    99637641956291355440762673901020664898,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956435217613296814772810699842,
    99637641956298608995680361676068901954,
    'SQL',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956436426539116429401985406018,
    99637641956258714443633078913303598146,
    'JS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956437635464936044031160112194,
    99637641956250251962895776509080654914,
    'PERL',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956438844390755658660334818370,
    99637641956286519737484215384321840194,
    'PERL',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956440053316575273289509524546,
    99637641956282892960025371496797721666,
    'APEX',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956441262242394887918684230722,
    99637641956267176924370381317526541378,
    'PERL',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956442471168214502547858936898,
    99637641956262341221091922800827716674,
    'DEVOPS',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956443680094034117177033643074,
    99637641956245416259617317992381830210,
    'CLOUD',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956444889019853731806208349250,
    99637641956245416259617317992381830210,
    'ABCS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956446097945673346435383055426,
    99637641956284101885844986125972427842,
    'DEVOPS',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956447306871492961064557761602,
    99637641956249043037076161879905948738,
    'CLOUD',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956448515797312575693732467778,
    99637641956297400069860747046894195778,
    'JAVA',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956449724723132190322907173954,
    99637641956261132295272308171653010498,
    'PERL',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956450933648951804952081880130,
    99637641956251460888715391138255361090,
    'CLOUD',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956452142574771419581256586306,
    99637641956253878740354620396604773442,
    'SQL',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956453351500591034210431292482,
    99637641956281684034205756867623015490,
    'CLOUD',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956454560426410648839605998658,
    99637641956285310811664600755147134018,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956455769352230263468780704834,
    99637641956258714443633078913303598146,
    'CLOUD',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956456978278049878097955411010,
    99637641956253878740354620396604773442,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956458187203869492727130117186,
    99637641956291355440762673901020664898,
    'SQL',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956459396129689107356304823362,
    99637641956247834111256547250731242562,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956460605055508721985479529538,
    99637641956293773292401903159370077250,
    'JAVA',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956461813981328336614654235714,
    99637641956288937589123444642671252546,
    'ABCS',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956463022907147951243828941890,
    99637641956240580556338859475683005506,
    'PERL',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956464231832967565873003648066,
    99637641956285310811664600755147134018,
    'CLOUD',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956465440758787180502178354242,
    99637641956297400069860747046894195778,
    'JS',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956466649684606795131353060418,
    99637641956285310811664600755147134018,
    'CLOUD',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956467858610426409760527766594,
    99637641956264759072731152059177129026,
    'SQL',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956469067536246024389702472770,
    99637641956247834111256547250731242562,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956470276462065639018877178946,
    99637641956288937589123444642671252546,
    'JAVA',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956471485387885253648051885122,
    99637641956249043037076161879905948738,
    'DEVOPS',
     2
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956472694313704868277226591298,
    99637641956256296591993849654954185794,
    'ABCS',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956473903239524482906401297474,
    99637641956269594776009610575875953730,
    'CLOUD',
     5
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956475112165344097535576003650,
    99637641956252669814535005767430067266,
    'JAVA',
     4
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956476321091163712164750709826,
    99637641956256296591993849654954185794,
    'APEX',
    1
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956477530016983326793925416002,
    99637641956264759072731152059177129026,
    'SQL',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956478738942802941423100122178,
    99637641956245416259617317992381830210,
    'DEVOPS',
     3
);

insert into AA_SKILLS (
    ID,
    EMPLOYEE_ID,
    SKILL,
    PROFICIENCY
) values (
    99637641956479947868622556052274828354,
    99637641956293773292401903159370077250,
    'JS',
     4
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956481156794442170681449534530,
    99637641956252669814535005767430067266,
    'Aztec',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956482365720261785310624240706,
    99637641956256296591993849654954185794,
    'Coulist',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956483574646081399939798946882,
    99637641956272012627648839834225366082,
    'Muntjac',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956484783571901014568973653058,
    99637641956292564366582288530195371074,
    'Yapok',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956485992497720629198148359234,
    99637641956270803701829225205050659906,
    'Artus',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956487201423540243827323065410,
    99637641956259923369452693542478304322,
    'Jugges',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956488410349359858456497771586,
    99637641956282892960025371496797721666,
    'Aztec',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956489619275179473085672477762,
    99637641956284101885844986125972427842,
    'Rhodell',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956490828200999087714847183938,
    99637641956297400069860747046894195778,
    'Quinnat',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956492037126818702344021890114,
    99637641956298608995680361676068901954,
    'Xenurine',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956493246052638316973196596290,
    99637641956270803701829225205050659906,
    'Scarlet',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956494454978457931602371302466,
    99637641956275639405107683721749484610,
    'Skellerpa',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956495663904277546231546008642,
    99637641956278057256746912980098896962,
    'Zokor',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956496872830097160860720714818,
    99637641956292564366582288530195371074,
    'Hydra',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956498081755916775489895420994,
    99637641956252669814535005767430067266,
    'Tilter',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956499290681736390119070127170,
    99637641956251460888715391138255361090,
    'Muntjac',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956500499607556004748244833346,
    99637641956247834111256547250731242562,
    'Yapok',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956501708533375619377419539522,
    99637641956242998407978088734032417858,
    'Artostme',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956502917459195234006594245698,
    99637641956272012627648839834225366082,
    'Issuestro',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956504126385014848635768951874,
    99637641956262341221091922800827716674,
    'Langur',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956505335310834463264943658050,
    99637641956293773292401903159370077250,
    'Artostme',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956506544236654077894118364226,
    99637641956284101885844986125972427842,
    'Populver',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956507753162473692523293070402,
    99637641956287728663303830013496546370,
    'Tilter',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956508962088293307152467776578,
    99637641956255087666174235025779479618,
    'Tilter',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956510171014112921781642482754,
    99637641956259923369452693542478304322,
    'Hydra',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956511379939932536410817188930,
    99637641956247834111256547250731242562,
    'Coulist',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956512588865752151039991895106,
    99637641956250251962895776509080654914,
    'Bulbul',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956513797791571765669166601282,
    99637641956268385850189995946701247554,
    'Docena',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956515006717391380298341307458,
    99637641956247834111256547250731242562,
    'Muntjac',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956516215643210994927516013634,
    99637641956287728663303830013496546370,
    'Hydra',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956517424569030609556690719810,
    99637641956253878740354620396604773442,
    'Tilter',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956518633494850224185865425986,
    99637641956247834111256547250731242562,
    'Anhinga',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956519842420669838815040132162,
    99637641956262341221091922800827716674,
    'Populver',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956521051346489453444214838338,
    99637641956291355440762673901020664898,
    'Rhodell',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956522260272309068073389544514,
    99637641956251460888715391138255361090,
    'Acipenser',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956523469198128682702564250690,
    99637641956280475108386142238448309314,
    'Rhodell',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956524678123948297331738956866,
    99637641956245416259617317992381830210,
    'Quinnat',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956525887049767911960913663042,
    99637641956240580556338859475683005506,
    'Bulbul',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956527095975587526590088369218,
    99637641956279266182566527609273603138,
    'Xeme',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956528304901407141219263075394,
    99637641956239371630519244846508299330,
    'Squarks',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956529513827226755848437781570,
    99637641956267176924370381317526541378,
    'Bulbul',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956530722753046370477612487746,
    99637641956256296591993849654954185794,
    'Anhinga',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956531931678865985106787193922,
    99637641956292564366582288530195371074,
    'Yapok',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956533140604685599735961900098,
    99637641956280475108386142238448309314,
    'Dhole',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956534349530505214365136606274,
    99637641956272012627648839834225366082,
    'Rhodell',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956535558456324828994311312450,
    99637641956241789482158474104857711682,
    'Artus',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956536767382144443623486018626,
    99637641956253878740354620396604773442,
    'Squarks',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956537976307964058252660724802,
    99637641956294982218221517788544783426,
    'Bulbul',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956539185233783672881835430978,
    99637641956276848330927298350924190786,
    'Muntjac',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956540394159603287511010137154,
    99637641956241789482158474104857711682,
    'Dhole',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956541603085422902140184843330,
    99637641956263550146911537430002422850,
    'Xeme',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956542812011242516769359549506,
    99637641956255087666174235025779479618,
    'Acipenser',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956544020937062131398534255682,
    99637641956276848330927298350924190786,
    'Hydra',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956545229862881746027708961858,
    99637641956288937589123444642671252546,
    'Jugges',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956546438788701360656883668034,
    99637641956286519737484215384321840194,
    'Docena',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956547647714520975286058374210,
    99637641956239371630519244846508299330,
    'Dhole',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956548856640340589915233080386,
    99637641956286519737484215384321840194,
    'Artostme',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956550065566160204544407786562,
    99637641956274430479288069092574778434,
    'Quinnat',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956551274491979819173582492738,
    99637641956284101885844986125972427842,
    'Rhodell',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956552483417799433802757198914,
    99637641956240580556338859475683005506,
    'Xenurine',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956553692343619048431931905090,
    99637641956244207333797703363207124034,
    'Artostme',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956554901269438663061106611266,
    99637641956278057256746912980098896962,
    'Coulist',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956556110195258277690281317442,
    99637641956279266182566527609273603138,
    'Docena',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956557319121077892319456023618,
    99637641956293773292401903159370077250,
    'Rhodell',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956558528046897506948630729794,
    99637641956272012627648839834225366082,
    'Aztec',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956559736972717121577805435970,
    99637641956275639405107683721749484610,
    'Coulist',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956560945898536736206980142146,
    99637641956256296591993849654954185794,
    'Xenurine',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956562154824356350836154848322,
    99637641956298608995680361676068901954,
    'Populver',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956563363750175965465329554498,
    99637641956251460888715391138255361090,
    'Xeme',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956564572675995580094504260674,
    99637641956290146514943059271845958722,
    'Videst',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956565781601815194723678966850,
    99637641956296191144041132417719489602,
    'Docena',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956566990527634809352853673026,
    99637641956298608995680361676068901954,
    'Dhole',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956568199453454423982028379202,
    99637641956284101885844986125972427842,
    'Populver',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956569408379274038611203085378,
    99637641956250251962895776509080654914,
    'Tilter',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956570617305093653240377791554,
    99637641956269594776009610575875953730,
    'Docena',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956571826230913267869552497730,
    99637641956250251962895776509080654914,
    'Dhole',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956573035156732882498727203906,
    99637641956272012627648839834225366082,
    'Artostme',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956574244082552497127901910082,
    99637641956274430479288069092574778434,
    'Videst',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956575453008372111757076616258,
    99637641956273221553468454463400072258,
    'Squarks',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956576661934191726386251322434,
    99637641956256296591993849654954185794,
    'Jugges',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956577870860011341015426028610,
    99637641956262341221091922800827716674,
    'Aztec',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956579079785830955644600734786,
    99637641956272012627648839834225366082,
    'Hydra',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956580288711650570273775440962,
    99637641956257505517813464284128891970,
    'Artostme',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956581497637470184902950147138,
    99637641956246625185436932621556536386,
    'Artus',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956582706563289799532124853314,
    99637641956250251962895776509080654914,
    'Docena',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956583915489109414161299559490,
    99637641956256296591993849654954185794,
    'Jugges',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956585124414929028790474265666,
    99637641956293773292401903159370077250,
    'Docena',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956586333340748643419648971842,
    99637641956241789482158474104857711682,
    'Acipenser',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956587542266568258048823678018,
    99637641956281684034205756867623015490,
    'Jugges',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956588751192387872677998384194,
    99637641956242998407978088734032417858,
    'Xeme',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956589960118207487307173090370,
    99637641956285310811664600755147134018,
    'Populver',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956591169044027101936347796546,
    99637641956239371630519244846508299330,
    'Rhodell',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956592377969846716565522502722,
    99637641956240580556338859475683005506,
    'Issuestro',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956593586895666331194697208898,
    99637641956292564366582288530195371074,
    'Rhodell',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956594795821485945823871915074,
    99637641956278057256746912980098896962,
    'Jugges',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956596004747305560453046621250,
    99637641956280475108386142238448309314,
    'Videst',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956597213673125175082221327426,
    99637641956247834111256547250731242562,
    'Quinnat',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956598422598944789711396033602,
    99637641956291355440762673901020664898,
    'Xeme',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956599631524764404340570739778,
    99637641956261132295272308171653010498,
    'Xeme',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956600840450584018969745445954,
    99637641956255087666174235025779479618,
    'Populver',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956602049376403633598920152130,
    99637641956288937589123444642671252546,
    'Artus',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956603258302223248228094858306,
    99637641956258714443633078913303598146,
    'Aztec',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956604467228042862857269564482,
    99637641956286519737484215384321840194,
    'Docena',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956605676153862477486444270658,
    99637641956246625185436932621556536386,
    'Hydra',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956606885079682092115618976834,
    99637641956262341221091922800827716674,
    'Jugges',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956608094005501706744793683010,
    99637641956267176924370381317526541378,
    'Artus',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956609302931321321373968389186,
    99637641956282892960025371496797721666,
    'Aztec',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956610511857140936003143095362,
    99637641956286519737484215384321840194,
    'Acipenser',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956611720782960550632317801538,
    99637641956294982218221517788544783426,
    'Populver',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956612929708780165261492507714,
    99637641956250251962895776509080654914,
    'Acipenser',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956614138634599779890667213890,
    99637641956276848330927298350924190786,
    'Coulist',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956615347560419394519841920066,
    99637641956275639405107683721749484610,
    'Dhole',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956616556486239009149016626242,
    99637641956286519737484215384321840194,
    'Aztec',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956617765412058623778191332418,
    99637641956276848330927298350924190786,
    'Videst',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956618974337878238407366038594,
    99637641956281684034205756867623015490,
    'Rhodell',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956620183263697853036540744770,
    99637641956246625185436932621556536386,
    'Dhole',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956621392189517467665715450946,
    99637641956270803701829225205050659906,
    'Xeme',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956622601115337082294890157122,
    99637641956246625185436932621556536386,
    'Quinnat',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956623810041156696924064863298,
    99637641956286519737484215384321840194,
    'Anhinga',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956625018966976311553239569474,
    99637641956272012627648839834225366082,
    'Tilter',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956626227892795926182414275650,
    99637641956270803701829225205050659906,
    'Shoup',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956627436818615540811588981826,
    99637641956281684034205756867623015490,
    'Zokor',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956628645744435155440763688002,
    99637641956244207333797703363207124034,
    'Coulist',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956629854670254770069938394178,
    99637641956282892960025371496797721666,
    'Coulist',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956631063596074384699113100354,
    99637641956265967998550766688351835202,
    'Videst',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956632272521893999328287806530,
    99637641956270803701829225205050659906,
    'Jugges',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956633481447713613957462512706,
    99637641956285310811664600755147134018,
    'Squarks',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956634690373533228586637218882,
    99637641956270803701829225205050659906,
    'Dhole',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956635899299352843215811925058,
    99637641956294982218221517788544783426,
    'Hydra',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956637108225172457844986631234,
    99637641956278057256746912980098896962,
    'Quinnat',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956638317150992072474161337410,
    99637641956272012627648839834225366082,
    'Zokor',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956639526076811687103336043586,
    99637641956297400069860747046894195778,
    'Quinnat',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956640735002631301732510749762,
    99637641956264759072731152059177129026,
    'Docena',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956641943928450916361685455938,
    99637641956262341221091922800827716674,
    'Xenurine',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956643152854270530990860162114,
    99637641956253878740354620396604773442,
    'Hydra',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956644361780090145620034868290,
    99637641956252669814535005767430067266,
    'Videst',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956645570705909760249209574466,
    99637641956267176924370381317526541378,
    'Bulbul',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956646779631729374878384280642,
    99637641956264759072731152059177129026,
    'Bulbul',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956647988557548989507558986818,
    99637641956249043037076161879905948738,
    'Dhole',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956649197483368604136733692994,
    99637641956264759072731152059177129026,
    'Aztec',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956650406409188218765908399170,
    99637641956249043037076161879905948738,
    'Skellerpa',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956651615335007833395083105346,
    99637641956269594776009610575875953730,
    'Dhole',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956652824260827448024257811522,
    99637641956258714443633078913303598146,
    'Acipenser',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956654033186647062653432517698,
    99637641956282892960025371496797721666,
    'Langur',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956655242112466677282607223874,
    99637641956274430479288069092574778434,
    'Rhodell',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956656451038286291911781930050,
    99637641956258714443633078913303598146,
    'Videst',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956657659964105906540956636226,
    99637641956275639405107683721749484610,
    'Dhole',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956658868889925521170131342402,
    99637641956250251962895776509080654914,
    'Artostme',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956660077815745135799306048578,
    99637641956239371630519244846508299330,
    'Langur',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956661286741564750428480754754,
    99637641956280475108386142238448309314,
    'Docena',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956662495667384365057655460930,
    99637641956284101885844986125972427842,
    'Aztec',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956663704593203979686830167106,
    99637641956239371630519244846508299330,
    'Tilter',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956664913519023594316004873282,
    99637641956275639405107683721749484610,
    'Xeme',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956666122444843208945179579458,
    99637641956249043037076161879905948738,
    'Coulist',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956667331370662823574354285634,
    99637641956256296591993849654954185794,
    'Xeme',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956668540296482438203528991810,
    99637641956262341221091922800827716674,
    'Issuestro',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956669749222302052832703697986,
    99637641956268385850189995946701247554,
    'Populver',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956670958148121667461878404162,
    99637641956249043037076161879905948738,
    'Langur',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956672167073941282091053110338,
    99637641956294982218221517788544783426,
    'Artostme',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956673375999760896720227816514,
    99637641956290146514943059271845958722,
    'Rhodell',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956674584925580511349402522690,
    99637641956264759072731152059177129026,
    'Skellerpa',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956675793851400125978577228866,
    99637641956281684034205756867623015490,
    'Xeme',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956677002777219740607751935042,
    99637641956274430479288069092574778434,
    'Squarks',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956678211703039355236926641218,
    99637641956286519737484215384321840194,
    'Aztec',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956679420628858969866101347394,
    99637641956284101885844986125972427842,
    'Artostme',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956680629554678584495276053570,
    99637641956292564366582288530195371074,
    'Coulist',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956681838480498199124450759746,
    99637641956256296591993849654954185794,
    'Issuestro',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956683047406317813753625465922,
    99637641956285310811664600755147134018,
    'Langur',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956684256332137428382800172098,
    99637641956273221553468454463400072258,
    'Hydra',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956685465257957043011974878274,
    99637641956261132295272308171653010498,
    'Tilter',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956686674183776657641149584450,
    99637641956261132295272308171653010498,
    'Acipenser',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956687883109596272270324290626,
    99637641956268385850189995946701247554,
    'Aztec',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956689092035415886899498996802,
    99637641956273221553468454463400072258,
    'Populver',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956690300961235501528673702978,
    99637641956251460888715391138255361090,
    'Issuestro',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956691509887055116157848409154,
    99637641956245416259617317992381830210,
    'Aztec',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956692718812874730787023115330,
    99637641956273221553468454463400072258,
    'Issuestro',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956693927738694345416197821506,
    99637641956265967998550766688351835202,
    'Tilter',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956695136664513960045372527682,
    99637641956256296591993849654954185794,
    'Anhinga',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956696345590333574674547233858,
    99637641956256296591993849654954185794,
    'Dhole',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956697554516153189303721940034,
    99637641956247834111256547250731242562,
    'Langur',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956698763441972803932896646210,
    99637641956253878740354620396604773442,
    'Langur',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956699972367792418562071352386,
    99637641956281684034205756867623015490,
    'Aztec',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956701181293612033191246058562,
    99637641956288937589123444642671252546,
    'Artostme',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956702390219431647820420764738,
    99637641956275639405107683721749484610,
    'Aztec',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956703599145251262449595470914,
    99637641956290146514943059271845958722,
    'Issuestro',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956704808071070877078770177090,
    99637641956249043037076161879905948738,
    'Anhinga',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956706016996890491707944883266,
    99637641956241789482158474104857711682,
    'Xenurine',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956707225922710106337119589442,
    99637641956239371630519244846508299330,
    'Aztec',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956708434848529720966294295618,
    99637641956282892960025371496797721666,
    'Shoup',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956709643774349335595469001794,
    99637641956253878740354620396604773442,
    'Tilter',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956710852700168950224643707970,
    99637641956245416259617317992381830210,
    'Hydra',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956712061625988564853818414146,
    99637641956251460888715391138255361090,
    'Docena',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956713270551808179482993120322,
    99637641956269594776009610575875953730,
    'Shoup',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956714479477627794112167826498,
    99637641956282892960025371496797721666,
    'Coulist',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956715688403447408741342532674,
    99637641956279266182566527609273603138,
    'Tilter',
    'ACTIVE'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956716897329267023370517238850,
    99637641956290146514943059271845958722,
    'Xenurine',
    ' UNDER CONSIDERATION'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956718106255086637999691945026,
    99637641956291355440762673901020664898,
    'Tilter',
    ' CLOSED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956719315180906252628866651202,
    99637641956290146514943059271845958722,
    'Jugges',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956720524106725867258041357378,
    99637641956249043037076161879905948738,
    'Hydra',
    ' PRIORITIZED'
);

insert into AA_PROJECTS (
    ID,
    EMPLOYEE_ID,
    PROJECT_NAME,
    STATUS
) values (
    99637641956721733032545481887216063554,
    99637641956249043037076161879905948738,
    'Aztec',
    ' CLOSED'
);

 
-- Generated by Quick SQL Friday March 17, 2017  22:19:53
 
/*
# drop: true, prefix: aa, PK: TRIG, date: TIMESTAMP WITH LOCAL TIME ZONE, auditCols: false

departments /insert 4
  name vc50 /nn /unique
  cost center /values CC01, CC02
  employees /insert 50 
    name vc50 /nn /index
    email /lower /unique
    city vc80 [Enter the city from where the employee works]
    country vc2 /values US, US, US, MX, CA [Use 2 character country codes]
    skills /insert 150  
       skill vc50 /nn /upper  /values java, java, java, JS, JS, cloud, devops, perl, apex, sql, abcs
       proficiency num /nn /check 1, 2, 3, 4, 5  [With 5 being guru and 1 being beginner level]
    projects /insert 200
       project name vc100
       status vc50 /check active, prioritized, closed, under consideration
    hiredate
    resume file
  description

view department_employees departments employees
view employee_skills employees skills

# settings = { prefix: "AA", PK: "TRIG", date: "TIMESTAMP WITH LOCAL TIME ZONE", drop: true }
*/
