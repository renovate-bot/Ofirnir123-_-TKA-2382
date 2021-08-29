Rem
Rem Copyright (c) 1998, 2017, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem  NAME
Rem    ctxpkh.sql
Rem  DESCRIPTION
rem     Package header definition
Rem  RETURNS
Rem
Rem    NOTES
Rem     
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/ctxpkh.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/ctxpkh.sql
Rem      SQL_PHASE: CTXPKH
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/catctx.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     boxia      12/08/16 - move drvutl.pkh to line before driparse.pkh
Rem     aczarlin   07/06/15 - 21378487: load drixmd before drisgp
Rem     surman     01/26/15 - 20411134: Add SQL metadata tags
Rem     shorwitz   03/03/14 - Bug 18339793: drvdml.pkh does not compile
Rem     surman     03/15/13 - 16473661: Common start and end scripts
Rem     hsarkar    06/20/11 - drvlsb.pkh
Rem     rpalakod   09/11/09 - bug 8892290
Rem     nenarkhe   06/29/09 - add dr0tree package
Rem     rpalakod   10/22/07 - drient.pkh and drientl.pkh
Rem     rpalakod   10/16/07 - dr0ent.pkh
Rem     yucheng    10/21/05 - add drvrio 
Rem     gkaminag   08/22/05 - dririo
Rem     oshiowat   08/12/05 - feature usage tracking 
Rem     smuralid   06/05/03 - add drv0ddl.pkh
Rem     smuralid   12/23/02 - add driparx
Rem     gkaminag   12/04/02 - drvutl
Rem     daliao     12/06/02 - 
Rem     daliao     10/29/02 - rename drisvm.pkh to driodm.pkh, add drvtmt.pkh
Rem     daliao     10/16/02 - add drisvm.pkh
Rem     gkaminag   09/30/02 - 
Rem     gkaminag   09/27/02 - security phase 3
Rem     gkaminag   08/06/02 - 
Rem     gkaminag   07/18/02 - shuffle
Rem     gkaminag   07/17/02 - security phase 2
Rem     ehuang     07/11/02 - ehuang_component_upgrade_020626
Rem     gkaminag   06/03/02 - new packages for security.
Rem     gkaminag   04/09/02 - removing ctxsrv.
Rem     mfaisal    03/28/02 - bug 2266717
Rem     daliao     01/29/02 - add dr0cls.pkh
Rem     gkaminag   12/18/01 - dr0repor split.
Rem     gkaminag   10/02/01 - add ctx_report.
Rem     wclin      09/25/01 - handle new xpath indextype
Rem     yucheng    09/11/01 - add driddlp package
Rem     mfaisal    12/21/00 - user-defined lexer
Rem     gkaminag   01/09/01 - remove sql*plus settings
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
Rem     gkaminag   05/22/98 - gc optimization
Rem     ehuang     05/15/98 - add driimp.pkh
Rem     ehuang     05/13/98 - rename
Rem     ehuang     05/11/98 - creation

@@?/rdbms/admin/sqlsessstart.sql

REM ===================================================================
REM When adding new packages, remember to add lines to header section,
REM body section, and synonym/grant section.  
REM ===================================================================

PROMPT ================== Package Installation ==========================

REM =====================================================================
REM Package headers 
REM =====================================================================

PROMPT
PROMPT Install Global Symbols
PROMPT

REM NOTE:  THESE HAVE TO BE BEFORE ALL OTHER PKH BECAUSE THEY CONTAIN
REM TYPE DECLARATIONS, ETC. WHICH MAY BE USED BY OTHER PKH FILES

PROMPT ... loading driobj.pkh
@@driobj.pkh
show errors
PROMPT ... loading dr0def.pkh
@@dr0def.pkh
show errors
PROMPT ...loading drig.pkh
@@drig.pkh
show errors

PROMPT
PROMPT Install DR Internal package specs
PROMPT

PROMPT ... loading driacc.pkh 
@@driacc.pkh
show errors
PROMPT ... loading driacchelp.pkh 
@@driacchelp.pkh
show errors
PROMPT ... loading dricon.pkh
@@dricon.pkh
show errors
PROMPT ... loading dridisp.pkh
@@dridisp.pkh
show errors
PROMPT ... loading dridml.pkh
@@dridml.pkh
show errors
PROMPT ... loading dridoc.pkh
@@dridoc.pkh
show errors
PROMPT ... loading drierr.pkh
@@drierr.pkh
show errors
PROMPT ... loading driexp.pkh
@@driexp.pkh
show errors
PROMPT ... loading driimp.pkh
@@driimp.pkh
show errors
PROMPT ... loading driixs.pkh
@@driixs.pkh
show errors
PROMPT ... loading drilist.pkh
@@drilist.pkh
show errors
PROMPT ... loading driload.pkh
@@driload.pkh
show errors
PROMPT ... loading drimlx.pkh
@@drimlx.pkh
show errors
PROMPT ... loading driopt.pkh
@@driopt.pkh
show errors
PROMPT ... loading drvutl.pkh
@@drvutl.pkh
show errors
PROMPT ... loading driparse.pkh
@@driparse.pkh
show errors
PROMPT ... loading dripref.pkh
@@dripref.pkh
show errors
PROMPT ... loading drirec.pkh
@@drirec.pkh
show errors
PROMPT ... loading drirep.pkh
@@drirep.pkh
show errors
PROMPT ... loading drirepm.pkh
@@drirepm.pkh
show errors
PROMPT ... loading drirepz.pkh
@@drirepz.pkh
show errors
PROMPT ... loading dririo.pkh
@@dririo.pkh
show errors
PROMPT ... loading drixmd.pkh
@@drixmd.pkh
show errors
PROMPT ... loading drisgp.pkh
@@drisgp.pkh
show errors
PROMPT ... loading drispl.pkh
@@drispl.pkh
show errors
PROMPT ... loading driths.pkh
@@driths.pkh
show errors
PROMPT ... loading drithsc.pkh
@@drithsc.pkh
show errors
PROMPT ... loading drithsd.pkh
@@drithsd.pkh
show errors
PROMPT ... loading drithsl.pkh
@@drithsl.pkh
show errors
PROMPT ... loading drithsx.pkh
@@drithsx.pkh
show errors
PROMPT ... loading driutl.pkh 
@@driutl.pkh
show errors
PROMPT ... loading drival.pkh
@@drival.pkh
show errors
PROMPT ... loading drifeat.pkh
@@drifeat.pkh
show errors
PROMPT ... loading drient.pkh
@@drient.pkh
show errors
PROMPT ... loading drientl.pkh
@@drientl.pkh
show errors

PROMPT
PROMPT Install ConText internal invoker's rights packages 
PROMPT

PROMPT ... loading drvdisp.pkh
@@drvdisp.pkh
show errors
PROMPT ... loading drvddl.pkh 
@@drvddl.pkh
show errors
PROMPT ... loading drvddlc.pkh 
@@drvddlc.pkh
show errors
PROMPT ... loading drvddlr.pkh 
@@drvddlr.pkh
show errors
PROMPT ... loading drvddlx.pkh 
@@drvddlx.pkh
show errors
PROMPT ... loading drvdml.pkh 
@@drvdml.pkh
show errors
PROMPT ... loading drvdoc.pkh 
@@drvdoc.pkh
show errors
PROMPT ... loading drverr.pkh
@@drverr.pkh
show errors
PROMPT ... loading drvimr.pkh
@@drvimr.pkh
show errors
PROMPT ... loading driparx.pkh
@@driparx.pkh
show errors
PROMPT ... loading drvodm.pkh
@@drvodm.pkh
show errors
PROMPT ... loading drvparx.pkh
@@drvparx.pkh
show errors
PROMPT ... loading drvtmt.pkh
@@drvtmt.pkh
show errors
PROMPT ... loading drvxmd.pkh
@@drvxmd.pkh
show errors
PROMPT ... loading drvxtab.pkh
@@drvxtab.pkh
show errors
PROMPT ... loading drvxtabc.pkh
@@drvxtabc.pkh
show errors
PROMPT ... loading drvxtabr.pkh
@@drvxtabr.pkh
show errors
PROMPT ... loading drvxtabx.pkh
@@drvxtabx.pkh
show errors
PROMPT ... loading drvrio.pkh
@@drvrio.pkh
show errors
PROMPT ... loading drvlsb.pkh
@@drvlsb.pkh
show errors
PROMPT ... loading drv0ddl.pkh
@@drv0ddl.pkh
show errors
PROMPT ... loading drvanl.pkh
@@drvanl.pkh
show errors

PROMPT
PROMPT Install ConText public API specs
PROMPT

PROMPT ... loading dr0adm.pkh
@@dr0adm.pkh
show errors
PROMPT ... loading dr0ddl.pkh
@@dr0ddl.pkh
show errors
PROMPT ... loading dr0doc.pkh
@@dr0doc.pkh
show errors
PROMPT ... loading dr0out.pkh
@@dr0out.pkh
show errors
PROMPT ... loading dr0query.pkh
@@dr0query.pkh
show errors
PROMPT ... loading dr0thes.pkh
@@dr0thes.pkh
show errors
PROMPT ... loading dr0repor.pkh
@@dr0repor.pkh
show errors
PROMPT ... loading dr0ulex.pkh
@@dr0ulex.pkh
show errors
PROMPT ... loading dr0cls.pkh
@@dr0cls.pkh
show errors
PROMPT ... loading dr0ent.pkh
@@dr0ent.pkh
PROMPT ... loading dr0tree.pkh
@@dr0tree.pkh
show errors
PROMPT ... loading dr0anl.pkh
@@dr0anl.pkh
show errors


@?/rdbms/admin/sqlsessend.sql
