set define '^' verify off
prompt ...create wwv_qs_random_names_biu trigger

Rem  Copyright (c) Oracle Corporation 2017 - 2017. All Rights Reserved.
Rem
Rem    NAME
Rem      wwv_qs_random_names_biu.sql
Rem
Rem    DESCRIPTION
Rem      Provide sample data trigger to create a sample data table for Quick SQL functionality from within APEX
Rem
Rem    NOTES
Rem
Rem    REQUIRMENTS
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem    mhichwa     10/12/2017 - Created
Rem    hfarrell    10/27/2017 - Resolved public synonym dependency issues in Hudson: prefixed occurrence of dbms_random with sys.

create or replace trigger wwv_qs_random_names_biu
    before insert or update 
    on wwv_qs_random_names
    for each row
declare
   i              integer := 0;
   l_email        varchar2(255) := null;
   l_phone_number varchar2(30)  := null;
   l_num_1_100    integer;
   l_num_1_10     integer;  
   r              number;
   l_guid         varchar2(100) := null;
   l_profile      varchar(4000) := null;
   x              number;
   
   function wwv_qs_rand_text (
       p_language in varchar2 default 'en',
       p_words in number default 10)
       return varchar2
   is
   begin
       return wwv_qs_data.get_random_text(p_language=>NVL(p_language,'en'), p_words=>p_words);
   end wwv_qs_rand_text;

   function compress_int (n in integer ) return varchar2
   as
      ret       varchar2(30);
      quotient  integer;
      remainder integer;
      digit     char(1);
   begin
      ret := null; quotient := n;
      while quotient > 0
      loop
          remainder := mod(quotient, 10 + 26);
          quotient := floor(quotient  / (10 + 26));
          if remainder < 26 then
              digit := chr(ascii('A') + remainder);
          else
              digit := chr(ascii('0') + remainder - 26);
          end if;
          ret := digit || ret;
      end loop ;
      if length(ret) < 5 then ret := lpad(ret, 4, 'A'); end if ;
      return upper(ret);
   end compress_int;
begin
    if :new.id is null then
        :new.id := to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    end if;
    if inserting then
       if :new.first_name is null then :new.first_name := substr(:new.full_name,1,instr(:new.full_name,' ')-1); end if;
       if :new.last_name  is null then :new.last_name  := substr(:new.full_name,instr(:new.full_name,' ')+1); end if; 
       l_email         := lower(:new.first_name||'.'||replace(:new.last_name,' ','_')||'@'||compress_int(wwv_qs_RANDOM_NAMES_SEQ.nextval)||'.com');
       if :new.email is null then :new.email := l_email; end if;
       r               := sys.DBMS_RANDOM.value(low => 1, high => 9999999999);
       l_phone_number  := rpad(replace(to_char(r),'.',null),10,'000000000000');
       l_phone_number  := substr(l_phone_number,1,3)||'-'||substr(l_phone_number,4,3)||'-'||substr(l_phone_number,7);
       if :new.phone_number is null then :new.phone_number := l_phone_number; end if;
       l_num_1_100     := sys.DBMS_RANDOM.value(low => 1, high => 100);
       l_num_1_10      := sys.DBMS_RANDOM.value(low => 1, high => 10);

       :new.project_name := wwv_qs_data.get_random_project(p_language => :new.language);
       :new.job := wwv_qs_data.get_random_job(p_language => :new.language);
       :new.department_name := wwv_qs_data.get_random_dept_name(p_language => :new.language);
       :new.tags := wwv_qs_data.get_random_tags(p_language => :new.language);
       --
       --
       if :new.tswtz is null then :new.tswtz := SYSTIMESTAMP; end if;
       if :new.tswltz is null then :new.tswltz := LOCALTIMESTAMP; end if;
       if :new.d is null then :new.d := sysdate; end if;
       :new.num_1_100  := l_num_1_100;
       :new.num_1_10   := l_num_1_10;
       :new.words_1    := initcap(replace(replace(wwv_qs_rand_text(:new.language,2),'.',null),',',null));
       :new.words_2    := initcap(replace(replace(wwv_qs_rand_text(:new.language,3),'.',null),',',null));
       :new.words_3    := initcap(replace(replace(wwv_qs_rand_text(:new.language,4),'.',null),',',null));
       :new.words_4    := initcap(replace(replace(wwv_qs_rand_text(:new.language,5),'.',null),',',null));
       :new.words_1_60  := substr(wwv_qs_rand_text(:new.language,trunc(sys.DBMS_RANDOM.value(low => 2, high => 60 ))),1,4000);
       :new.words_1_100 := substr(wwv_qs_rand_text(:new.language,trunc(sys.DBMS_RANDOM.value(low => 2, high => 100))),1,4000);
       l_guid          := sys_guid();
       :new.guid       := l_guid;
       l_profile       := substr(wwv_qs_rand_text(:new.language,60),1,4000);
       :new.profile    := l_profile;
       if :new.seq is null then :new.seq := wwv_qs_random_names_seq.nextval; end if;
    end if;
end;
/
show errors

set define '^' 
