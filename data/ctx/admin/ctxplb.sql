Rem
Rem $Header: ctx_src_2/src/dr/admin/ctxplb.sql /main/46 2017/08/30 13:48:31 aczarlin Exp $
Rem
Rem ctxplb.sql
Rem
Rem Copyright (c) 2002, 2017, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      ctxplb.sql
Rem
Rem    DESCRIPTION
Rem      create or replace public and private PL/SQL package Bodies
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxplb.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxplb.sql
Rem      SQL_PHASE: CTXPLB
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/catctx.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    aczarlin    08/25/17 - bug 25982613 dripref dependency on driutl
Rem    boxia       01/15/16 - Bug 22226636: replace user$ with _BASE_USER
Rem    yinlu       08/28/15 - lrg 18241069: grant create sequence to ctxapp
Rem    rkadwe      08/05/15 - READ privilege instead of SELECT
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    surman      03/15/13 - 16473661: Common start and end scripts
Rem    hsarkar     06/20/11 - drvlsb.pkb
Rem    rpalakod    02/07/11 - filter cache
Rem    nenarkhe    06/29/09 - add dr0tree package
Rem    wclin       01/12/09 - version 11.2.0.0.2
Rem    wclin       08/18/08 - version 11.2.0.0.1
Rem    igeller     07/15/08 - remove dr$itab0_set_t
Rem    wclin       04/22/08 - version 11.2.0.0.0
Rem    rpalakod    10/22/07 - drient.plb and drientl.plb
Rem    rpalakod    10/16/07 - dr0ent.plb
Rem    wclin       08/13/07 - 11.1.0.7.0
Rem    wclin       06/17/07 - Version to 11.1.0.6
Rem    yucheng     10/21/05 - add drvrio 
Rem    gkaminag    10/16/05 - 11.0
Rem    gkaminag    08/22/05 - dririo
Rem    oshiowat    08/12/05 - feature usage tracking 
Rem    gkaminag    05/05/05 - version to 10.2.0.1.0 
Rem    gkaminag    03/18/04 - version 
Rem    ehuang      10/24/03 - tracing 
Rem    gkaminag    08/18/03 - version change 
Rem    gkaminag    06/05/03 - version to 10.1.0.1.0
Rem    smuralid    06/05/03 - add drv0ddl.pkb
Rem    daliao      02/10/03 - grant ctx_cls to public
Rem    ehuang      01/21/03 - version to 10.1
Rem    smuralid    01/06/03 - 
Rem    smuralid    12/23/02 - grants on state types
Rem    daliao      12/04/02 - change driodm to drvodm
Rem    gkaminag    11/26/02 - version to 10
Rem    smuralid    12/03/02 - grant privs on drvparx
Rem    gkaminag    12/04/02 - drvutl
Rem    daliao      10/29/02 - rename drisvm.plb to driodm.plb, add drvtmt.plb
Rem    daliao      10/16/02 - add drisvm.plb
Rem    gkaminag    09/27/02 - security phase 3
Rem    gkaminag    07/19/02 - new packages
Rem    gkaminag    07/17/02 - security phase 2
Rem    ehuang      07/02/02 - move from dr0plb.sql
Rem    ehuang      06/17/02 - ehuang_component_upgrade
Rem    ehuang      06/11/02 - Created - component upgrade
Rem     gkaminag   06/03/02 - new packages for security .
Rem     gkaminag   04/09/02 - removing ctxsrv.
Rem     daliao     01/29/02 - add classification
Rem     gkaminag   01/22/02 - add ctx_version view recompile.
Rem     gkaminag   12/18/01 - dr0repor split.
Rem     gkaminag   10/02/01 - add ctx_report.
Rem     wclin      09/25/01 - handle new xpath indextype
Rem     yucheng    09/11/01 - add driddlp package
Rem     mfaisal    12/21/00 - user-defined lexer
Rem     gkaminag   01/09/01 - remove sql*plus settings
Rem     gkaminag   08/28/00 - add dr0proc.plb
Rem     ehuang     08/08/00 - split drixtab into drixtabc, drixtabr
Rem     salpha     06/26/00 - ctxrule implementation
Rem     gkaminag   02/22/00 - ctxcat implementation
Rem     gkaminag   04/09/99 -
Rem     gkaminag   04/05/99 - suspending longop project
Rem     adusange   04/04/99 - Fix integration problem 040299
Rem     gkaminag   03/09/99 - driths split
Rem     gkaminag   02/15/99 - driddl split up
Rem     cbhavsar   09/03/98 - CDM2 merge
Rem     gkaminag   08/11/98 - add output package
Rem     ehuang     06/02/98 - grant driimp to public
Rem     gkaminag   05/22/98 - gc optimization
Rem     ehuang     05/15/98 - add driimp.plb
Rem     ehuang     05/13/98 - rename
Rem     ehuang     05/11/98 - creation

@@?/rdbms/admin/sqlsessstart.sql

REM ===================================================================
REM When adding new packages, remember to add lines to header section,
REM body section, and synonym/grant section.  
REM ===================================================================

PROMPT ================== Package Installation ==========================

REM =====================================================================
REM Package bodies
REM =====================================================================

PROMPT
PROMPT Install DR Internal package bodies
PROMPT

PROMPT ... loading driacc.plb 
@@driacc.plb
show errors
PROMPT ... loading driacchelp.plb 
@@driacchelp.plb
show errors
PROMPT ... loading dricon.plb
@@dricon.plb
show errors
PROMPT ... loading dridisp.plb
@@dridisp.plb
show errors
PROMPT ... loading dridml.plb
@@dridml.plb
show errors
PROMPT ... loading dridoc.plb
@@dridoc.plb
show errors
PROMPT ... loading drierr.plb
@@drierr.plb
show errors
PROMPT ... loading driexp.plb
@@driexp.plb
show errors
PROMPT ... loading driimp.plb
@@driimp.plb
show errors
PROMPT ... loading driixs.plb
@@driixs.plb
show errors
PROMPT ... loading driload.plb
@@driload.plb
show errors
PROMPT ... loading drimlx.plb
@@drimlx.plb
show errors
PROMPT ... loading driopt.plb
@@driopt.plb
show errors
PROMPT ... loading driparse.plb
@@driparse.plb
show errors
PROMPT ... loading driutl.plb
@@driutl.plb
show errors
PROMPT ... loading dripref.plb
@@dripref.plb
show errors
PROMPT ... loading drirec.plb
@@drirec.plb
show errors
PROMPT ... loading drirep.plb
@@drirep.plb
show errors
PROMPT ... loading drirepm.plb
@@drirepm.plb
show errors
PROMPT ... loading drirepz.plb
@@drirepz.plb
show errors
PROMPT ... loading dririo.plb
@@dririo.plb
show errors
PROMPT ... loading drisgp.plb
@@drisgp.plb
show errors
PROMPT ... loading drispl.plb
@@drispl.plb
show errors
PROMPT ... loading driths.plb
@@driths.plb
show errors
PROMPT ... loading drithsc.plb
@@drithsc.plb
show errors
PROMPT ... loading drithsd.plb
@@drithsd.plb
show errors
PROMPT ... loading drithsl.plb
@@drithsl.plb
show errors
PROMPT ... loading drithsx.plb
@@drithsx.plb
show errors
PROMPT ... loading drival.plb
@@drival.plb
show errors
PROMPT ... loading drixmd.plb
@@drixmd.plb
show errors
PROMPT ... loading drifeat.plb
@@drifeat.plb      
show errors
PROMPT ... loading drient.plb
@@drient.plb
show errors
PROMPT ... loading drientl.plb
@@drientl.plb
show errors

PROMPT
PROMPT Install DR internal invoker's rights bodies
PROMPT

PROMPT ... loading drvdisp.plb
@@drvdisp.plb
show errors
PROMPT ... loading drvddl.plb 
@@drvddl.plb
show errors
PROMPT ... loading drvddlc.plb 
@@drvddlc.plb
show errors
PROMPT ... loading drvddlr.plb 
@@drvddlr.plb
show errors
PROMPT ... loading drvddlx.plb 
@@drvddlx.plb
show errors
PROMPT ... loading drvdml.plb 
@@drvdml.plb
show errors
PROMPT ... loading drvdoc.plb 
@@drvdoc.plb
show errors
PROMPT ... loading drverr.plb
@@drverr.plb
show errors
PROMPT ... loading drvimr.plb
@@drvimr.plb
show errors
PROMPT ... loading driparx.plb
@@driparx.plb
show errors
PROMPT ... loading drvodm.plb
@@drvodm.plb
show errors
PROMPT ... loading drvparx.plb
@@drvparx.plb
show errors
PROMPT ... loading drvtmt.plb
@@drvtmt.plb
show errors
PROMPT ... loading drvutl.plb
@@drvutl.plb
show errors
PROMPT ... loading drvxmd.plb
@@drvxmd.plb
show errors
PROMPT ... loading drvxtab.plb
@@drvxtab.plb
show errors
PROMPT ... loading drvxtabc.plb
@@drvxtabc.plb
show errors
PROMPT ... loading drvxtabr.plb
@@drvxtabr.plb
show errors
PROMPT ... loading drvxtabx.plb
@@drvxtabx.plb
show errors
PROMPT ... loading drvrio.plb
@@drvrio.plb
show errors
PROMPT ... loading drvlsb.plb
@@drvlsb.plb
show errors
PROMPT ... loading drv0ddl.plb
@@drv0ddl.plb
show errors
PROMPT ... loading drvanl.plb 
@@drvanl.plb
show errors

REM DRIPROC SHOULD GO AFTER ALL OTHER DRI* 

PROMPT ... loading driproc.plb
@@driproc.plb
show errors

PROMPT
PROMPT Install ConText public API bodies
PROMPT

PROMPT ... loading dr0adm.plb
@@dr0adm.plb
show errors
PROMPT ... loading dr0ddl.plb
@@dr0ddl.plb
show errors
PROMPT ... loading dr0doc.plb
@@dr0doc.plb
show errors
PROMPT ... loading dr0out.plb
@@dr0out.plb
show errors
PROMPT ... loading dr0query.plb
@@dr0query.plb
show errors
PROMPT ... loading dr0thes.plb
@@dr0thes.plb
show errors
PROMPT ... loading dr0repor.plb
@@dr0repor.plb
show errors
PROMPT ... loading dr0cls.plb
@@dr0cls.plb
show errors
PROMPT ... loading dr0ent.plb
@@dr0ent.plb
show errors
PROMPT ... loading dr0tree.plb
@@dr0tree.plb
show errors
PROMPT ... loading dr0anl.plb
@@dr0anl.plb
show errors


REM =====================================================================
REM execute grants on public interface
REM =====================================================================

create or replace public synonym ctx_doc for ctxsys.ctx_doc;
grant execute on ctx_doc to public;

create or replace public synonym ctx_ddl for ctxsys.ctx_ddl;
grant execute on ctx_ddl to ctxapp;

create or replace public synonym ctx_output for ctxsys.ctx_output;
grant execute on ctx_output to ctxapp;

create or replace public synonym ctx_query for ctxsys.ctx_query;
grant execute on ctx_query to public;

create or replace public synonym ctx_thes for ctxsys.ctx_thes;
grant execute on ctx_thes to ctxapp;

create or replace public synonym ctx_report for ctxsys.ctx_report;
grant execute on ctx_report to public;

create or replace public synonym ctx_ulexer for ctxsys.ctx_ulexer;
grant execute on ctx_ulexer to ctxapp;

create or replace public synonym ctx_cls for ctxsys.ctx_cls;
grant execute on ctx_cls to public;

create or replace public synonym ctx_entity for ctxsys.ctx_entity;
grant execute on ctx_entity to ctxapp;

create or replace public synonym ctx_tree for ctxsys.ctx_tree;
grant execute on ctx_tree to ctxapp;

create or replace public synonym ctx_anl for ctxsys.ctx_anl;
grant execute on ctx_anl to ctxapp;

REM =====================================================================
REM execute grants on private interface
REM =====================================================================

grant execute on driload to public;
grant execute on drithsx to public;
grant execute on drithsl to ctxapp;
grant execute on drientl to ctxapp;
grant execute on driimp to public;

grant execute on drvdml to public;
grant execute on drvimr to public;
grant execute on drvxmd to public;
grant execute on drvparx to public;
grant execute on dr$session_state_t to public;
grant execute on dr$optim_state_t to public;
grant execute on dr$popindex_state_t to public;
grant execute on dr$createindex_state_t to public;
grant execute on drv0ddl to public;

create or replace public synonym drvodm for ctxsys.drvodm;
grant execute on drvodm to public;

REM =====================================================================
REM grant misc privileges to ctxapp
REM =====================================================================

grant create sequence to ctxapp;

PROMPT ========================================================

rem ctx_trace_values
rem this view depends on drvparx, so we have to create it here

CREATE OR REPLACE VIEW ctx_trace_values AS
select trc.trc_id, trc.trc_value
  from TABLE(ctxsys.drvparx.TraceGetTrace) trc;
grant read on ctx_trace_values to public;

rem ctx_filter_cache_statistics
rem this view depends on drvparx, so we have to create it here

create or replace view ctx_filter_cache_statistics as
select u1.name     fcs_index_owner,
       i.idx_name  fcs_index_name,
       p.ixp_name  fcs_partition_name,
       ctxsys.drvparx.GetFilterCacheSize     fcs_size,
       ctxsys.drvparx.GetFilterCacheEntries  fcs_entries,
       ctxsys.drvparx.GetFilterCacheRequests fcs_requests,
       ctxsys.drvparx.GetFilterCacheHits     fcs_hits
  from ctxsys.dr$index i, ctxsys.dr$index_partition p, sys."_BASE_USER" u1
       where i.idx_owner# = u1.user# and
             i.idx_option like '%U%' and
             i.idx_id = 
               ctxsys.drvparx.FilterCacheGetStats(i.idx_id, i.idx_owner#,
                                                  u1.name, i.idx_name, 
                                                  p.ixp_name) and 
             i.idx_id = p.ixp_idx_id (+);

rem ctx_version
rem the reason ctx_version recompile is here is because new install,
rem major version upgrade, patchset upgrade, and downgrade reload all run 
rem ctxplb.sql.

CREATE OR REPLACE VIEW ctx_version AS
select substr(dri_version,1,10) ver_dict, 
substr(dri_version,1,10) ver_code from dual;


@?/rdbms/admin/sqlsessend.sql
