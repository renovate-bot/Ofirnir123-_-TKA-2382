set define '^'
prompt ...Quick SQL Random Data

Rem  Copyright (c) Oracle Corporation 2017. All Rights Reserved.
Rem
Rem    NAME
Rem      load_random_data.sql
Rem
Rem    DESCRIPTION
Rem      Load language specific random data
Rem
Rem    MODIFIED     (MM/DD/YYYY)
Rem      cbcho       10/26/2017 - Created
Rem

-- remove
begin
    wwv_qs_data.remove( p_language => 'en');
    wwv_qs_data.remove( p_language => 'de');
    wwv_qs_data.remove( p_language => 'ko');
    wwv_qs_data.remove( p_language => 'ja');
    wwv_qs_data.remove( p_language => 'es');
    commit;
end;
/

-- load
begin
    wwv_qs_data.load('en');
    wwv_qs_data.load('de');
    wwv_qs_data.load('ko');
    wwv_qs_data.load('ja');
    wwv_qs_data.load('es');
    commit;
end;
/

set define '^'
