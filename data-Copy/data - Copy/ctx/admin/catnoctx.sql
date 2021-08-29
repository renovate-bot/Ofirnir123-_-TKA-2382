
Rem =======================================================================
Rem script is ALWAYS run as SYS,  must set current_schema to CTXSYS before
Rem loading context
Rem =======================================================================
ALTER SESSION SET CURRENT_SCHEMA = CTXSYS;

Rem =======================================================================
Rem signal beginning of removal
Rem =======================================================================
EXECUTE dbms_registry.removing('CONTEXT');

Rem =======================================================================
Rem drop all objects
Rem =======================================================================

PROMPT dropping all ctxsys objects...
drop public synonym ctx_doc;

drop public synonym ctx_ddl;

drop public synonym ctx_output;

drop public synonym ctx_query;

drop public synonym ctx_thes;

drop public synonym ctx_report;

drop public synonym ctx_ulexer;

drop public synonym ctx_cls;

drop public synonym ctx_entity;

drop public synonym ctx_tree;

drop public synonym ctx_anl;

drop public synonym drvodm;


REM Drop all packages
@@ctxdpkg.sql

drop public synonym ctx_parameters;

drop public synonym ctx_classes;

drop public synonym ctx_objects;

drop public synonym ctx_object_attributes;

drop public synonym ctx_object_attribute_lov;

drop public synonym ctx_preferences;

drop public synonym ctx_user_preferences;

drop public synonym ctx_preference_values;

drop public synonym ctx_user_preference_values;

drop public synonym ctx_user_indexes;

drop public synonym ctx_user_index_partitions;

drop public synonym ctx_user_index_values;

drop public synonym ctx_user_index_sub_lexers;

drop public synonym ctx_user_index_sub_lexer_vals;

drop public synonym ctx_user_index_objects;

drop public synonym ctx_sqes;

drop public synonym ctx_user_sqes;

drop public synonym ctx_thesauri;

drop public synonym ctx_user_thesauri;

drop public synonym ctx_thes_phrases;

drop public synonym ctx_user_thes_phrases;

drop public synonym ctx_section_groups;

drop public synonym ctx_user_section_groups;

drop public synonym ctx_sections;

drop public synonym ctx_user_sections;

drop public synonym ctx_stoplists;

drop public synonym ctx_user_stoplists;

drop public synonym ctx_stopwords;

drop public synonym ctx_user_stopwords;

drop public synonym ctx_sub_lexers;

drop public synonym ctx_user_sub_lexers;

drop public synonym ctx_index_sets;

drop public synonym ctx_user_index_sets;

drop public synonym ctx_index_set_indexes;

drop public synonym ctx_user_index_set_indexes;

drop public synonym ctx_user_pending;

drop public synonym ctx_user_index_errors;

drop public synonym ctx_trace_values;

drop public synonym ctx_filter_cache_statistics;

drop public synonym ctx_user_filter_by_columns;

drop public synonym ctx_user_order_by_columns;

drop public synonym ctx_user_extract_rules;

drop public synonym ctx_user_extract_stop_entities;

drop public synonym ctx_user_extract_policies;

drop public synonym ctx_user_extract_policy_values;

drop public synonym ctx_user_auto_optimize_indexes;

drop public synonym ctx_index_sections;

drop public synonym ctx_user_index_sections;

drop public synonym contains;

drop public synonym score;

drop public synonym catsearch;

drop public synonym matches;

drop public synonym match_score;

drop operator xpcontains force;

drop package ctx_xpcontains;

drop operator match_score force;

drop package driscorr;

drop operator matches force;

drop package ctx_matches;

drop operator catsearch force;

drop package ctx_catsearch;

drop procedure syncrn;

drop operator score force;

drop package driscore;

drop operator contains force;

drop package ctx_contains;

drop type xpathindexmethods force;

drop type ruleindexmethods force;

drop type catindexmethods force;

drop type textoptstats force;

drop type textindexmethods force;

drop view ctx_user_index_sections;

drop view ctx_index_sections;

drop view ctx_alexer_dicts;

drop view ctx_user_alexer_dicts;

drop view drv$tree;

drop view ctx_auto_optimize_status;

drop view ctx_user_auto_optimize_indexes;

drop view drv$autoopt;

drop view ctx_auto_optimize_indexes;

drop view ctx_user_extract_policy_values;

drop view ctx_user_extract_policies;

drop view ctx_extract_policy_values;

drop view ctx_extract_policies;

drop view drv$user_extract_entdict;

drop view drv$user_extract_tkdict;

drop view ctx_user_extract_stop_entities;

drop view drv$user_extract_stop_entity;

drop view ctx_user_extract_rules;

drop view drv$user_extract_rule;

drop view drv$sdata_update2;

drop view drv$sdata_update;

drop view ctx_user_order_by_columns;

drop view ctx_order_by_columns;

drop view ctx_user_filter_by_columns;

drop view ctx_filter_by_columns;

drop view ctx_filter_cache_statistics;

drop view ctx_trace_values;

drop view ctx_version;

drop function dri_version;

drop view ctx_user_index_errors;

drop view ctx_index_errors;

drop view drv$unindexed2;

drop view drv$unindexed;

drop view drv$delete2;

drop view drv$delete;

drop view drv$online_pending;

drop view drv$waiting;

drop view ctx_user_pending;

drop view ctx_pending;

drop view drv$pending;

drop view ctx_user_index_set_indexes;

drop view ctx_index_set_indexes;

drop view ctx_user_index_sets;

drop view ctx_index_sets;

drop view ctx_user_sub_lexers;

drop view ctx_sub_lexers;

drop view ctx_user_stopwords;

drop view ctx_stopwords;

drop view ctx_user_stoplists;

drop view ctx_stoplists;

drop view ctx_user_sections;

drop view ctx_sections;

drop view ctx_user_section_groups;

drop view ctx_section_groups;

drop view ctx_user_thes_phrases;

drop view ctx_thes_phrases;

drop view ctx_user_thesauri;

drop view ctx_thesauri;

drop view ctx_user_sqes;

drop view ctx_sqes;

drop view ctx_user_index_objects;

drop view ctx_index_objects;

drop view ctx_user_index_sub_lexer_vals;

drop view ctx_index_sub_lexer_values;

drop view ctx_user_index_sub_lexers;

drop view ctx_index_sub_lexers;

drop function dri_sublxv_lang;

drop view ctx_user_index_values;

drop view ctx_index_values;

drop view ctx_user_index_partitions;

drop view ctx_index_partitions;

drop view ctx_user_indexes;

drop view ctx_indexes;

drop view ctx_user_preference_values;

drop view ctx_preference_values;

drop view ctx_user_preferences;

drop view ctx_preferences;

drop view ctx_object_attribute_lov;

drop view ctx_object_attributes;

drop view ctx_objects;

drop view ctx_classes;

drop view ctx_parameters;

drop table dr$idx_dictionaries;

drop table dr$dictionary;

drop table dr$autoopt;

drop table dr$tree;

drop table dr$user_extract_entdict;

drop table dr$user_extract_tkdict;

drop table dr$user_extract_stop_entity;

drop table dr$user_extract_rule;

drop table dr$activelogs;

drop index idx1_dr$slowqrys;

drop table dr$slowqrys;

drop index idx2_dr$freqtoks;

drop index idx1_dr$freqtoks;

drop table dr$freqtoks;

drop table dr$feature_used;

drop table dr$sdata_update;

drop table dr$index_cdi_column;

drop table dr$nvtab;

drop type ctx_feedback_type;

drop type ctx_feedback_item_type;

drop sequence ths_seq;

drop sequence mesg_id_seq;

drop sequence dr_id_seq;

drop table dr$dbo;

drop table dr$number_sequence;

drop table dr$stats;

drop table dr$parallel;

drop table dr$index_error;

drop table dr$unindexed;

drop table dr$delete;

drop table dr$online_pending;

drop table dr$waiting;

drop table dr$pending;

drop table dr$index_set_index;

drop table dr$index_set;

drop index drx$slx_sub_pre_id;

drop table dr$sub_lexer;

drop table dr$stopword;

drop table dr$stoplist;

drop table dr$section_attribute;

drop index drx$sec_name;

drop index drx$sec_tag;

drop table dr$section;

drop table dr$section_group_attribute;

drop table dr$section_group;

drop index dr_ths_bt;

drop index dr_uniq_ths_bt;

drop table dr$ths_bt;

drop table dr$ths_fphrase;

drop index dr_ths_ringid;

drop table dr$ths_phrase;

drop table dr$ths;

drop table dr$sqe;

drop table dr$index_object;

drop table dr$policy_tab;

drop index drx$ixv_key;

drop table dr$index_value;

drop index drx$ixp_name;

drop table dr$index_partition;

drop index drc$idx_column;

drop table dr$index;

drop table dr$preference_value;

drop table dr$preference;

drop index drx$oal_id;

drop table dr$object_attribute_lov;

drop table dr$object_attribute;

drop table dr$object;

drop table dr$class;

drop table dr$parameter;


Rem =======================================================================
Rem signal end of removal
Rem =======================================================================
EXECUTE dbms_registry.removed('CONTEXT');

Rem =======================================================================
Rem now drop ctxsys itself
Rem =======================================================================
ALTER SESSION SET CURRENT_SCHEMA = SYS;

PROMPT dropping user ctxsys...

drop role CTXAPP;
drop user ctxsys cascade;
