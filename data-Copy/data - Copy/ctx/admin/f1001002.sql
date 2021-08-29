Rem
Rem $Header: ctx_src_2/src/dr/admin/f1001002.sql /main/4 2018/07/25 13:49:09 surman Exp $
Rem
Rem f1001002.sql
Rem
Rem Copyright (c) 2005, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      f1001002.sql - downgrade utility scripts
Rem
Rem    DESCRIPTION
Rem      this creates empty indextype implementation type bodies
Rem      compatible with 10.1.0.2 for use at downgrade time
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem      SQL_SOURCE_FILE: ctx_src_2/src/dr/admin/f1001002.sql 
Rem      SQL_SHIPPED_FILE: ctx/admin/f1001002.sql
Rem      SQL_PHASE: DOWNGRADE
Rem      SQL_STARTUP_MODE: NORMAL 
Rem      SQL_IGNORABLE_ERRORS: NONE 
Rem      SQL_CALLING_FILE: ctx/admin/d1001002.sql
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    surman      05/04/18 - 27464252: Set phase to DOWNGRADE
Rem    surman      01/26/15 - 20411134: Add SQL metadata tags
Rem    gkaminag    10/07/05 - gkaminag_fixlrg_1919224
Rem    gkaminag    10/06/05 - Created
Rem

create or replace type body TextIndexMethods is

static function ODCIGetInterfaces(
  ifclist out    sys.ODCIObjectList
) return number 
is 
begin 
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2')); 
  return sys.ODCIConst.Success; 
end ODCIGetInterfaces; 

static function ODCIIndexCreate(
  ia      in     sys.odciindexinfo, 
  parms   in     varchar2,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexCreate;

static function ODCIIndexAlter(
  ia      in     sys.odciindexinfo, 
  parms   in out varchar2,
  altopt  in     number,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexAlter;

static function ODCIIndexTruncate(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexTruncate;

static function ODCIIndexDrop(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexDrop;

static function ODCIIndexInsert(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexInsert;
   
static function ODCIIndexDelete(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexDelete;

static function ODCIIndexUpdate(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexUpdate;

static function ODCIIndexGetMetaData(
  ia        in  sys.odciindexinfo, 
  version   in  varchar2,
  new_block out PLS_INTEGER,
  env       in  sys.ODCIEnv
) return varchar2
is
begin
  return sys.odciconst.fatal;
end ODCIIndexGetMetaData;

static function ODCIIndexUtilGetTableNames(
  ia        IN  sys.odciindexinfo,
  read_only IN  PLS_INTEGER,
  version   IN  varchar2,
  context   OUT PLS_INTEGER)
return boolean
is
begin
  Return FALSE;
end ODCIIndexUtilGetTableNames;

static procedure ODCIIndexUtilCleanup(
 context IN PLS_INTEGER)
is
begin
  null;
end ODCIIndexUtilCleanup;

static function ODCIIndexSplitPartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexSplitPartition;

static function ODCIIndexMergePartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexMergePartition;

static function ODCIIndexExchangePartition(
  ia  IN SYS.ODCIIndexInfo,
  ia1 IN SYS.ODCIIndexInfo,
  env IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexExchangePartition;

end;
/
show errors;

/*==========================================================================*/

create or replace type body CatIndexMethods is

static function ODCIGetInterfaces(
  ifclist out    sys.ODCIObjectList
) return number 
is 
begin 
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2')); 
  return sys.ODCIConst.Success; 
end ODCIGetInterfaces; 

static function ODCIIndexCreate(
  ia      in     sys.odciindexinfo, 
  parms   in     varchar2,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexCreate;

static function ODCIIndexAlter(
  ia      in     sys.odciindexinfo, 
  parms   in out varchar2,
  altopt  in     number,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexAlter;

static function ODCIIndexTruncate(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexTruncate;

static function ODCIIndexDrop(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexDrop;

static function ODCIIndexInsert(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexInsert;
   
static function ODCIIndexDelete(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexDelete;

static function ODCIIndexUpdate(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexUpdate;

static function ODCIIndexGetMetaData(
  ia        in  sys.odciindexinfo, 
  version   in  varchar2,
  new_block out PLS_INTEGER,
  env       in  sys.ODCIEnv
) return varchar2
is
begin
  return sys.odciconst.fatal;
end ODCIIndexGetMetaData;

static function ODCIIndexUtilGetTableNames(
  ia        IN  sys.odciindexinfo,
  read_only IN  PLS_INTEGER,
  version   IN  varchar2,
  context   OUT PLS_INTEGER)
return boolean
is
begin
  Return FALSE;
end ODCIIndexUtilGetTableNames;

static procedure ODCIIndexUtilCleanup(
 context IN PLS_INTEGER)
is
begin
  null;
end ODCIIndexUtilCleanup;

static function ODCIIndexSplitPartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexSplitPartition;

static function ODCIIndexMergePartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexMergePartition;

static function ODCIIndexExchangePartition(
  ia  IN SYS.ODCIIndexInfo,
  ia1 IN SYS.ODCIIndexInfo,
  env IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexExchangePartition;

end;
/
show errors;

/*==========================================================================*/

create or replace type body RuleIndexMethods is

static function ODCIGetInterfaces(
  ifclist out    sys.ODCIObjectList
) return number 
is 
begin 
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2')); 
  return sys.ODCIConst.Success; 
end ODCIGetInterfaces; 

static function ODCIIndexCreate(
  ia      in     sys.odciindexinfo, 
  parms   in     varchar2,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexCreate;

static function ODCIIndexAlter(
  ia      in     sys.odciindexinfo, 
  parms   in out varchar2,
  altopt  in     number,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexAlter;

static function ODCIIndexTruncate(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexTruncate;

static function ODCIIndexDrop(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexDrop;

static function ODCIIndexInsert(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexInsert;
   
static function ODCIIndexDelete(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexDelete;

static function ODCIIndexUpdate(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexUpdate;

static function ODCIIndexGetMetaData(
  ia        in  sys.odciindexinfo, 
  version   in  varchar2,
  new_block out PLS_INTEGER,
  env       in  sys.ODCIEnv
) return varchar2
is
begin
  return sys.odciconst.fatal;
end ODCIIndexGetMetaData;

static function ODCIIndexUtilGetTableNames(
  ia        IN  sys.odciindexinfo,
  read_only IN  PLS_INTEGER,
  version   IN  varchar2,
  context   OUT PLS_INTEGER)
return boolean
is
begin
  Return FALSE;
end ODCIIndexUtilGetTableNames;

static procedure ODCIIndexUtilCleanup(
 context IN PLS_INTEGER)
is
begin
  null;
end ODCIIndexUtilCleanup;

static function ODCIIndexSplitPartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexSplitPartition;

static function ODCIIndexMergePartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexMergePartition;

static function ODCIIndexExchangePartition(
  ia  IN SYS.ODCIIndexInfo,
  ia1 IN SYS.ODCIIndexInfo,
  env IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexExchangePartition;

end;
/
show errors;

/*==========================================================================*/

create or replace type body XpathIndexMethods is

static function ODCIGetInterfaces(
  ifclist out    sys.ODCIObjectList
) return number 
is 
begin 
  ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2')); 
  return sys.ODCIConst.Success; 
end ODCIGetInterfaces; 

static function ODCIIndexCreate(
  ia      in     sys.odciindexinfo, 
  parms   in     varchar2,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexCreate;

static function ODCIIndexAlter(
  ia      in     sys.odciindexinfo, 
  parms   in out varchar2,
  altopt  in     number,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexAlter;

static function ODCIIndexTruncate(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexTruncate;

static function ODCIIndexDrop(
  ia      in     sys.odciindexinfo,
  env     in     sys.ODCIEnv
) return number 
is
begin
  return sys.odciconst.fatal;
end ODCIIndexDrop;

static function ODCIIndexInsert(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexInsert;
   
static function ODCIIndexDelete(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexDelete;

static function ODCIIndexUpdate(
  ia      in sys.odciindexinfo,
  ridlist in sys.odciridlist, 
  env     in sys.odcienv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexUpdate;

static function ODCIIndexGetMetaData(
  ia        in  sys.odciindexinfo, 
  version   in  varchar2,
  new_block out PLS_INTEGER,
  env       in  sys.ODCIEnv
) return varchar2
is
begin
  return sys.odciconst.fatal;
end ODCIIndexGetMetaData;

static function ODCIIndexUtilGetTableNames(
  ia        IN  sys.odciindexinfo,
  read_only IN  PLS_INTEGER,
  version   IN  varchar2,
  context   OUT PLS_INTEGER)
return boolean
is
begin
  Return FALSE;
end ODCIIndexUtilGetTableNames;

static procedure ODCIIndexUtilCleanup(
 context IN PLS_INTEGER)
is
begin
  null;
end ODCIIndexUtilCleanup;

static function ODCIIndexSplitPartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexSplitPartition;

static function ODCIIndexMergePartition(
  ia         IN SYS.ODCIIndexInfo,
  part_name1 IN SYS.ODCIPartInfo,
  part_name2 IN SYS.ODCIPartInfo,
  parms      IN varchar2,
  env        IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexMergePartition;

static function ODCIIndexExchangePartition(
  ia  IN SYS.ODCIIndexInfo,
  ia1 IN SYS.ODCIIndexInfo,
  env IN SYS.ODCIEnv
) return number
is
begin
  return sys.odciconst.fatal;
end ODCIIndexExchangePartition;

end;
/
show errors;
