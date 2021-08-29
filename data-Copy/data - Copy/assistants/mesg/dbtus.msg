
/ 
/ Error Codes of AssistantsCommon, DBCA and DBUA
/ ---Range---
/ DBT-00001 to DBT-10000: AssistantsCommon Error Codes
/ DBT-10001 to DBT-30000: DBCA Error Codes
/ DBT-30001 to DBT-50000: DBUA Error Codes

/-------------------------------------------------------------------------------
00002, 0,"The file %s is not accessible."
// *Cause: Current user may not have read permission.
// *Action: Ensure that the current user has permission to read the file %s.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.FILE_NOT_ACCESSIBLE_ERR
/-------------------------------------------------------------------------------
00003, 0,"The file %s is not valid."
// *Cause: Syntactically incorrect response file. Either unexpected variables are specified or expected variables are not specified in the file.
// *Action: Refer the latest product specific response file template
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.INVALID_FILE_ERR
/-------------------------------------------------------------------------------
00004, 0,"The file %s is not found."
// *Cause: The file %s is either not accessible or does not exist.
// *Action: Give a correct file location. (Note: relative path is not supported)
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.FILE_NOT_FOUND_ERR
/-------------------------------------------------------------------------------
00005, 0,"The format of the given response file is not supported."
// *Cause: The response file format was incorrect or not supported.
// *Action: Use response files of type %s.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.UNKNOWN_RESPONSE_FILE_FORMAT_ERR
/-------------------------------------------------------------------------------
00006, 0,"The logging directory could not be created."
// *Cause: %s does not have the required privileges or is invalid.
// *Action: Verify path is valid and has the right privileges.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.LOGGINGDIR_CREATION_FAILED_ERR
/-------------------------------------------------------------------------------
00007, 0,"User does not have the appropiate write privileges."
// *Cause: User does not have the required write privileges on %s .
// *Action: Verify user privileges.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.USER_INSUFFICIENT_WRITE_PRIVILEGES_ERR
/-------------------------------------------------------------------------------
00008, 0,"Current user %s is not an administrator user."
// *Cause: The user running the assistant application does not have administrator privilege.
// *Action: Run the assistant application with an administrator user.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.USER_IS_NOT_ADMIN_ERR
/-------------------------------------------------------------------------------
00009, 0,"Unable to configure logging for the application."
// *Cause: The logging directory is either null or empty.
// *Action: n/a
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.LOGGINGDIR_NULL_ERR
/-------------------------------------------------------------------------------
0001, 0,"Error encountered in initialization of configuration tool."
// *Cause: An unexpected error occured while initializing the configuration tool.
// *Action: Refer to the logs or contact Oracle Support Services.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.ASSISTANT_TOOL_INIT_FAILED_ERR
/-------------------------------------------------------------------------------
00101, 0,"The variable (%s) cannot be removed."
// *Cause: The specified variable has been referred in the value of one or more input fields. One such referenced value is: %s
// *Action: Either update the value of all referenced input fields to appropriate value or retain the variable.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.REFERENCE_FOUND_FOR_REMOVED_VARIABLE_ERR
/-------------------------------------------------------------------------------
00102, 0,"Incorrect format is used to reference a variable in the value (%s). Use %s<variable_name>%s format to refer variables in the value."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.INCORRECT_VARIABLE_FORMAT_FOUND_ERR
/-------------------------------------------------------------------------------
00103, 0,"The referenced variable (%s) is not defined."
// *Cause: Either invalid variable name is used in the value (%s) or the specified variable is not defined.
// *Action: Use already defined variables to specify a value.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.UNKNOWN_VARIABLE_FOUND_ERR
/-------------------------------------------------------------------------------
00104, 0,"Unable to load the variables from the specified file (%s)."
// *Cause: Either specified file doesnt have readable permission or the file is not in properties file format.
// *Action: Refer to the logs to correct the issue or specify alternative variables file location.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.UNABLE_TO_LOAD_VARIABLES_FROM_FILE_ERR
/-------------------------------------------------------------------------------
00105, 0,"Invalid initialization parameters xml file ({0}). Either application could not detect initialization parameters xml file or contains syntactically incorrect information"
// *Cause: n/a
// *Action: Contact Oracle Support Services or refer to the software manual.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.INVALID_INIT_PARAMS_XML_ERR
/-------------------------------------------------------------------------------
00106, 0,"Error in loading the Initialization parameters file."
// *Cause: n/a
// *Action: Contact Oracle Support Services or refer to the software manual.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.INIT_PARAMS_XML_LOAD_ERR
/-------------------------------------------------------------------------------
00108, 0,"Incorrect value passed to a command line argument."
// *Cause: Exception encountered : %s
// *Action: n/a
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.INCORRECT_ARGUMENT_VALUE_ERR
/-------------------------------------------------------------------------------
00201, 0,"Invalid database credentials wallet location %s."
// *Cause: The specified database credentials wallet location does not exist, is not a directory, or has no files in it.
// *Action: Specify a valid location for the database credentials wallet. This location must be a directory containing the wallet files.
// *FQN: oracle.assistants.common.base.resource.AssistantBaseErrorCode.INVALID_DB_CREDENTIALS_WALLET_LOCATION_ERR
/-------------------------------------------------------------------------------
01402, 0,"Unable to check whether the specified node (%s) is part of any existing server pools in the Oracle Grid Infrastructure."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_GET_SERVER_POOLS_FOR_NODE_WARN
/-------------------------------------------------------------------------------
01403, 0,"Creation of server pool (%s) will have effect on the following resources - %s."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.SERVER_POOL_CREATION_EFFECTS_RESOURCES_ERR
/-------------------------------------------------------------------------------
05501, 0,"There are no Admin Managed databases detected on the system."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ERROR_GETTING_ADMIN_MANAGED_DBS_WARN
/-------------------------------------------------------------------------------
05502, 0,"There are no Single Instance databases detected on the system."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ERROR_GETTING_SI_DBS_WARN
/-------------------------------------------------------------------------------
05503, 0,"The Oracle Grid Infrastructure is not running on the system."
// *Cause: The Oracle Grid Infrastructure is not configured or not running on the system.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.GRID_INFRASTRUCTURE_IS_NOT_RUNNING_WARN
/-------------------------------------------------------------------------------
05504, 0,"Unable to create sql script output file under the directory (%s)."
// *Cause: The specified location is not a directory or user does not have a write permission to create log file.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INVALID_SQL_OUTPUT_LOG_DIR_ERR
/-------------------------------------------------------------------------------
05505, 0,"Unable to execute sql script: (%s)."
// *Cause: n/a
// *Action: Refer to the log file for more information.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_EXECUTE_QUERY_OR_COULD_NOT_CONNECT_ERR
/-------------------------------------------------------------------------------
05506, 0,"Unable to load the details of the database (%s)."
// *Cause: Unable to connect to the database or unable to execute sql statements.
// *Action: Refer to the log file for more information.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_LOAD_DBDETAILS_ERR
/-------------------------------------------------------------------------------
05507, 0,"Unable to detect the configured redo log groups for the database instance (%s)."
// *Cause: Error occurred while loading the configured redo log groups details.
// *Action: Ensure that the database is running.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_DETECT_REDO_LOG_GROUPS_WARN
/-------------------------------------------------------------------------------
05508, 0,"Unable to detect the configured undo tablespace for the database instance (%s)."
// *Cause: Error occurred while loading the configured undo tablespace details.
// *Action: Ensure that the database is running.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_DETECT_UNDO_TABLESPACE_WARN
/-------------------------------------------------------------------------------
05509, 0,"Failed to connect to the specified database (%s)."
// *Cause: OS Authentication might be disabled for this database (%s).
// *Action: Specify a valid sysdba user name and password to connect to the database.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.FAILED_TO_CONNECT_TO_DB_WARN
/-------------------------------------------------------------------------------
05510, 0,"Clone template cannot be created with remotely running databases."
// *Cause: n/a
// *Action: Specify the SID of locally running database to create a clone template.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.REMOTE_CONN_NOT_ALLOWED_FOR_CLONE_TEMPLATE_ERR
/-------------------------------------------------------------------------------
05511, 0,"Specified database (%s) does not exist."
// *Cause: n/a
// *Action: Provide an existing database.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.DB_DOES_NOT_EXIST_ERR
/-------------------------------------------------------------------------------
05512, 0,"Unable to detect Cluster managed databases on the system."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ERROR_GETTING_CLUSTER_MANAGED_DBS_WARN
/-------------------------------------------------------------------------------
05513, 0,"Failed to connect to the database (%s)."
// *Cause: Specified database credential is not valid to connect to the database (%s).
// *Action: Specify a valid sysdba user name and password to connect to the database.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.FAILED_TO_CONNECT_TO_DB_USING_CREDENTIALS_WARN
/-------------------------------------------------------------------------------
05514, 0,"Failed to connect to the database (%s)."
// *Cause: Specified connection string (%s) or SYSDBA credential is not valid to connect to the database.
// *Action: Specify a valid connection string or SYSDBA credential to connect to the database.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.FAILED_TO_CONNECT_TO_DB_USING_CONNECTION_STRING_ERR
/-------------------------------------------------------------------------------
05515, 0,"Failed to load the control file attributes."
// *Cause: Error occured while loading the control file attributes from the database.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_GET_CONTROLFILE_ATTRIBUTES_WARN
/-------------------------------------------------------------------------------
05516, 0,"Failed to load database details."
// *Cause: Database info object is null.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INVALID_DBINFO_OBJECT_ERR
/-------------------------------------------------------------------------------
05517, 0,"Unable to execute script (%s)."
// *Cause: n/a
// *Action: Refer to the log file for more information.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_EXECUTE_SCRIPT_ERR
/-------------------------------------------------------------------------------
05518, 0,"The tablespace selected (%s) does not exist in the database."
// *Cause: n/a
// *Action: Select an existing tablespace.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.TABLESPACE_NOT_EXIST_ERR
/-------------------------------------------------------------------------------
05519, 0,"Failed to connect to the database using the dblink (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.FAILED_TO_CONNECT_TO_DB_USING_DBLINK_ERR
/-------------------------------------------------------------------------------
05520, 0,"Failed to drop the database link (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.FAILED_TO_DROP_DBLINK_ERR
/-------------------------------------------------------------------------------
05601, 0,"The list of nodes in the Oracle Grid Infrastructure could not be retrieved."
// *Cause: n/a
// *Action: Verify if the Oracle Grid Infrastructure is configured and running on the system.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.NODES_RETRIEVAL_WARN
/-------------------------------------------------------------------------------
05602, 0,"Unable to determine the cluster mode of the configured Oracle Grid Infrastructure."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.CLUSTER_MODE_RETRIEVAL_ERR
/-------------------------------------------------------------------------------
05603, 0,"The list of hub nodes in the Oracle Grid Infrastructure could not be retrieved."
// *Cause: n/a
// *Action: Verify if Oracle Grid Infrastructure is configured and running on the system.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.HUB_NODES_RETRIEVAL_ERR
/-------------------------------------------------------------------------------
05604, 0,"Unable to retrieve the cluster node numbers from the Oracle Grid Infrastructure."
// *Cause: n/a
// *Action: Ensure that Oracle Grid Infrastructure is running on the local node.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.NODE_NUMBER_RETRIEVAL_WARN
/-------------------------------------------------------------------------------
05605, 0,"The list of Leaf nodes in the Oracle Grid Infrastructure could not be retrieved."
// *Cause: n/a
// *Action: Verify if Oracle Grid Infrastructure is configured with leaf nodes and running on the system.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.LEAF_NODES_RETRIEVAL_WARN
/-------------------------------------------------------------------------------
05701, 0,"The Oracle home user account verification failed."
// *Cause: n/a
// *Action: Use valid Oracle home user account credentials.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.VALID_WINDOWS_USER_WARN
/-------------------------------------------------------------------------------
05751, 0,"'%s' did not resolve to an IP address."
// *Cause: Unable to detect the IP address for the host name.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INVALID_HOST_NAME_ERR
/-------------------------------------------------------------------------------
05752, 0,"'%s' could not be resolved using TCP/IP host name lookup."
// *Cause: n/a
// *Action: Provide valid host name that is resolvable using TCP/IP host name lookup.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.HOST_NAME_NOT_RESOLVED_ERR
/-------------------------------------------------------------------------------
05801, 0,"There are no ASM disk groups detected."
// *Cause: ASM may not be configured, or ASM disk groups are not created yet.
// *Action: Create ASM disk groups, or change the storage location to File System.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ASM_NOT_CONFIGURED_ERR
/-------------------------------------------------------------------------------
05802, 0,"Creating password file on diskgroup (%s) would fail since it requires compatible.asm of version (%s) or higher. Current compatible.asm version is '%s'."
// *Cause: n/a
// *Action: Choose a diskgroup with correct value for compatible.asm attribute.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INCOMPATIBLE_ASM_DISKGROUP_VERSION_ERR
/-------------------------------------------------------------------------------
05803, 0,"Unable to connect to ASM instance using connection string (%s)."
// *Cause: The specified ASMNMP password is incorrect or the ASM instance is not running.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.FAILED_TO_CONNECT_TO_ASM_ERR
/-------------------------------------------------------------------------------
05804, 0,"The selected diskgroup (%s) is not compatible to place the database related files."
// *Cause: The diskgroup (%s) is having \compatible.rdbms\ attribute set to %s. But database can be created on a diskgroup which has this attribute set to '%s' or lower version.
// *Action: Update the \compatible.rdbms\ attribute in the diskgroup selected or specify a different diskgroup.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INCOMPATIBLE_RDBMS_VERSION_OF_DISKGROUP_ERR
/-------------------------------------------------------------------------------
05805, 0,"The value (%s) specified for the initialization parameter 'compatible' is lower than the RDBMS compatibility (%s) set in the ASM disk group (%s)."
// *Cause: n/a
// *Action: Choose a template with correct value for the 'compatible' initialization parameter.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INCOMPATIBLE_INIT_PARAM_VERSION_ERR
/-------------------------------------------------------------------------------
05806, 0,"An older ASM instance was found."
// *Cause: Automatic Storage Management (ASM) %s instance is found.
// *Action: Upgrade the existing ASM instance to version %s..
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.OLDER_ASM_INSTANCE_VERSION_FOUND
/-------------------------------------------------------------------------------
05900, 0,"Unable to check if Oracle home user password is required or not."
// *Cause: n/a
// *Action: Check the configuration of the Oracle home user in the Oracle home.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ORACLE_HOME_USER_PASSWORD_REQUIREMENT_CHECK_ERR
/-------------------------------------------------------------------------------
05901, 0,"Unable to detect Oracle home user."
// *Cause: n/a
// *Action: Check the configuration of the Oracle home user in the Oracle home.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ORACLE_HOME_USER_RETRIEVAL_ERR
/-------------------------------------------------------------------------------
05902, 0,"The owner of the Oracle home (%s) could not be determined."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ORACLE_HOME_USER_NOT_FOUND_ERR
/-------------------------------------------------------------------------------
06001, 0,"'%s' cannot be empty."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.EMPTY_OR_NULL_VALUE_ERR
/-------------------------------------------------------------------------------
06002, 0,"Selected disk group (%s) is not found."
// *Cause: n/a
// *Action: Specify a disk group that is accessible from the system.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ASM_DISK_GROUP_NOT_FOUND_ERR
/-------------------------------------------------------------------------------
06003, 0,"The selected disk group (%s) does not have sufficient space available."
// *Cause: The selected disk group has only (%s%s) of space.
// *Action: Use Automatic Storage Management Configuration Assistant to add more disks to the selected disk group, or create a new disk group with at least (%s%s) of space.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INSUFFICIENT_SPACE_IN_ASM_DISKGROUP_ERR
/-------------------------------------------------------------------------------
06004, 0,"The File System type of the specified location (%s) is not supported."
// *Cause: Current Oracle home is not an Enterprise Edition home. Only ACFS location or ASM storage are supported to create database in a non-Enterprise Edition Oracle home.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.FS_LOCATION_NOT_SUPPORTED_FOR_NON_EE_HOME_ERR
/-------------------------------------------------------------------------------
06005, 0,"'%s' contains invalid characters."
// *Cause: n/a
// *Action: Choose a '%s' containing only alphanumeric characters and a few additional characters that are allowed for your platform.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ASSISTANT_COMMON_BADCHARS_ERR
/-------------------------------------------------------------------------------
06006, 0,"Unable to create directory: (%s)."
// *Cause: Proper permissions are not granted to create the directory or there is no space left in the volume.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ASSISTANT_COMMON_DIRECTORY_CREATION_ERR
/-------------------------------------------------------------------------------
06007, 0,"The specified location (%s) is invalid."
// *Cause: The specified location is not found on the system or is detected to be a file.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ASSISTANT_COMMON_INVALID_FILE_STORAGE_LOCATION_ERR
/-------------------------------------------------------------------------------
06008, 0,"The path specified for '%s' is invalid."
// *Cause: Path specified for '%s' contains one or more directories which exceeds maximum folder name length.
// *Action: Specify the location with directory name that is not greater than (%s) characters.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ASSISTANT_COMMON_FOLDER_NAME_LENGTH_EXCEEDED_ERR
/-------------------------------------------------------------------------------
06009, 0,"The location specified (%s) for '%s' is not shared across cluster nodes (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ASSISTANT_COMMON_FILE_STORAGE_LOCATION_NOT_SHARED_ERR
/-------------------------------------------------------------------------------
06010, 0,"The specified location (%s) is on Oracle Clustered File System."
// *Cause: n/a
// *Action: Oracle Clustered File System is not a supported file system for Oracle RAC database.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ASSISTANTS_COMMON_LOCATION_ON_OCFS_ERR
/-------------------------------------------------------------------------------
06011, 0,"'%s' specified (%s) is on ASM. Custom sub directories cannot be created on ASM for this configuration."
// *Cause: n/a
// *Action: Specify ASM diskgroup without sub directories for '%s'.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ASSISTANT_COMMON_INVALID_ASM_STORAGE_LOCATION_ERR
/-------------------------------------------------------------------------------
06012, 0,"The current user does not have permissions to operate the ACFS resource for location (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.CURRENT_USER_HAS_NO_PERMISSION_ON_ACFS_ERR
/-------------------------------------------------------------------------------
06101, 0,"There is no available free port in the range (%s)-(%s) across the cluster nodes: (%s)."
// *Cause: n/a
// *Action: Verify the availability of free port across cluster nodes.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.NO_AVAILABLE_FREE_PORT_IN_RANGE_ERR
/-------------------------------------------------------------------------------
06102, 0,"Unable to retrieve database common name from the wallet folder: (%s)."
// *Cause: n/a
// *Action: Refer to the log file for more information.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_GET_DATABASE_CN_FROM_WALLET_ERR
/-------------------------------------------------------------------------------
06103, 0,"The port (%s) is already in use."
// *Cause: n/a
// *Action: Specify a free port.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PORT_NOT_AVAILABLE_ERR
/-------------------------------------------------------------------------------
06104, 0,"Unable to retrieve configured listeners from Oracle Grid Infrastucture home."
// *Cause: n/a
// *Action: Refer log file for more information.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_GET_GRID_HOME_LISTENERS_WARN
/-------------------------------------------------------------------------------
06201, 0,"'%s' password cannot be empty."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PASSWORD_NOT_SUPPLIED_ERR
/-------------------------------------------------------------------------------
06202, 0,"'%s' password and '%s' confirm password do not match."
// *Cause: n/a
// *Action: Ensure that both '%s' password and '%s' confirm password are same.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PASSWORDS_NOT_MATCH_ERR
/-------------------------------------------------------------------------------
06203, 0,"'%s' is not specified."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ARG_VALUE_NOT_SUPPLIED_ERR
/-------------------------------------------------------------------------------
06204, 0,"The specified DBSNMP password is not valid. Verify and try again."
// *Cause: Unable to connect to the database with the specified password.
// *Action: Verify the correctness of the password and the database status.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INVALID_DBSNMP_PASSWORD_ERR
/-------------------------------------------------------------------------------
06205, 0,"The '%s' password cannot be empty."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PASSWORD_IS_EMPTY_ERR
/-------------------------------------------------------------------------------
06206, 0,"The '%s' password length cannot exceed %s characters."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PASSWORD_EXCEED_LENGTH_ERR
/-------------------------------------------------------------------------------
06207, 0,"The '%s' password entered is invalid."
// *Cause: Passwords should not contain %s.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PASSWORD_INVALID_ERR
/-------------------------------------------------------------------------------
06208, 0,"The '%s' password entered does not conform to the Oracle recommended standards."
// *Cause: 
//         a. Oracle recommends that the password entered should be at least %s characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9].
//         b.The password entered is a keyword that Oracle does not recommend to be used as password
// *Action: Specify a strong password. If required refer Oracle documentation for guidelines.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PASSWORD_COMPLEXITY_ERR
/-------------------------------------------------------------------------------
06209, 0,"The specified ASMSNMP password is not valid. Verify and try again."
// *Cause: Unable to connect to the ASM instance with the specified password.
// *Action: Verify the correctness of the password and the status of the ASM instance.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INVALID_ASMSNMP_PASSWORD_ERR
/-------------------------------------------------------------------------------
06211, 0,"Oracle home value is not specified."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ORACLE_HOME_IS_EMPTY_ERR
/-------------------------------------------------------------------------------
06212, 0,"The %s password entered does not conform to the Oracle recommended standards."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PASSWORD_IS_NOT_COMPLEX_BY_ORAPWD_ERR
/-------------------------------------------------------------------------------
06301, 0,"Unable to check if the location specified (%s) is on shared file system."
// *Cause: The location specified might not have the required permissions or the location is not shared across the cluster nodes (%s).
// *Action: Specify a valid shared location across cluster nodes.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_CHECK_SHARED_LOCATION_WARN
/-------------------------------------------------------------------------------
06302, 0,"Unable to check for available free space on ACFS mount point (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_RETRIEVE_ACFS_FREESPACE_ERR
/-------------------------------------------------------------------------------
06303, 0,"Unable to check if location (%s) is on ACFS."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_CHECK_IF_LOC_ON_ACFS_WARN
/-------------------------------------------------------------------------------
06304, 0,"Incompatible ADVM version at location (%s)."
// *Cause: The specified location is detected as an Oracle ACFS location. The value set for COMPATIBLE.ADVM attribute in the disk group associated with this location is not compatible to place the database files.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ADVM_COMPATIBILITY_ERR
/-------------------------------------------------------------------------------
06305, 0,"The location is not registered as a resource in the Oracle Grid Infrastructure."
// *Cause: The specified location (%s) is detected as an Oracle ACFS location that is not registered as a resource in the Oracle Grid Infrastructure.
// *Action: Register the ACFS location as a resource in the Oracle Grid Infrastructure.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ACFS_UNREGISTERED_WITH_SRVCTL
/-------------------------------------------------------------------------------
06306, 0,"Unable to check if the specified location (%s) is Direct NFS(dNFS) enabled or not."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_CHECK_IF_LOC_dNFS_ENABLED_WARN
/-------------------------------------------------------------------------------
06307, 0,"Specified location (%s) is Direct NFS(dNFS) enabled."
// *Cause: Direct NFS(dNFS) enabled location is not supported for storing database related files.
// *Action: Specify a location that is not Direct NFS(dNFS) enabled.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.LOC_IS_dNFS_ENABLED_ERR
/-------------------------------------------------------------------------------
06308, 0,"Unable to get ACFS mount point from the path (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_GET_ACFS_MOUNTPOINT_ERR
/-------------------------------------------------------------------------------
06309, 0,"Oracle ACFS location (%s) is not supported for database files (password file, spfile, data files and redo logs ) in an Oracle Restart (standalone server) configuration."
// *Cause: Oracle ACFS is configured on Oracle Restart (standalone server) environment. It is not supported to use for database files.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ACFS_LOCATION_NOT_ALLOWED_IN_SIHA_ENV_ERR
/-------------------------------------------------------------------------------
06401, 0,"Unable to detect the cardinality of configured server pool(s): (%s)."
// *Cause: Error occurred while loading the server pool details.
// *Action: Ensure that the specified server pool(s) are accessible.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_GET_SERVER_POOL_CARDINALITY_WARN
/-------------------------------------------------------------------------------
06601, 0,"The specified file location (%s) is not writable."
// *Cause: n/a
// *Action: Ensure that the location (%s) is writable.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ASSISTANT_COMMON_FILE_NOT_WRITABLE_ERR
/-------------------------------------------------------------------------------
06602, 0,"Unable to check existence of directory (%s) on remote node (%s)."
// *Cause: User equivalence may not be setup between the local node and the remote nodes or sufficient file permissions are not set.
// *Action: Verify user equivalence across nodes and ensure sufficient file permissions are set.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNEXPECTED_REMOTE_DIR_CHECK_FAILURE_ERR
/-------------------------------------------------------------------------------
06603, 0,"Insufficient permissions granted for directory (%s) on node (%s)."
// *Cause: n/a
// *Action: Ensure that the directory (%s) has the required write permissions. Alternatively, choose another location.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.DIRECTORY_NOT_WRITABLE_ON_NODE_ERR
/-------------------------------------------------------------------------------
06604, 0,"The location specified for '%s' has insufficient free space."
// *Cause: Only (%s%s) free space is available on the location (%s).
// *Action: Choose a '%s' that has enough space (minimum of (%s%s)) or free up space on the specified location.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INSUFFICIENT_DISK_SPACE_ERR
/-------------------------------------------------------------------------------
06605, 0,"The data file location (%s) already exists."
// *Cause: This configuration	is going to create the data file location (%s). But it is detected that there is an existing database using this data file location or the data files from a previous configuration may be left behind.
// *Action: Clean up the existing data files, or use a different diskgroup, or provide a different db_unique_name.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ASM_DATA_FILE_ALREADY_EXISTS_ERR
/-------------------------------------------------------------------------------
06606, 0,"Current Oracle home user is unable to read the file (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.FILE_NOT_READABLE_BY_OHUSER_ERR
/-------------------------------------------------------------------------------
06607, 0,"The data file (%s) already exists on the file system."
// *Cause: This configuration	is going to create the data file location (%s). But it is detected that there is an existing database using this data file location or the data files from a previous configuration may be left behind.
// *Action: Clean up the existing data files, or provide a different db_unique_name.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.FS_DATA_FILE_ALREADY_EXISTS_ERR
/-------------------------------------------------------------------------------
06608, 0,"The specified audit file destination (%s) is not writable."
// *Cause: n/a
// *Action: Ensure that the audit file destination (%s) is writable.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.AUDIT_FILE_DEST_NOT_WRITABLE_ERR
/-------------------------------------------------------------------------------
06609, 0,"Unable to verify the readability of file (%s) for the current Oracle home user (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_CHECK_PERM_FOR_OHUSER_ERR
/-------------------------------------------------------------------------------
06610, 0,"Unable to retrieve the current Oracle home user credentials."
// *Cause: n/a
// *Action: Verify the correctness of the Oracle home user configuration.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_RETRIEVE_OHUSER_ERR
/-------------------------------------------------------------------------------
06801, 0,"Specified Fast Recovery Area size (%s%s) is less than the recommended value."
// *Cause: Fast Recovery Area size should at least be three times the database size (%s%s).
// *Action: Specify Fast Recovery Area Size to be at least three times the database size.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.FRA_SIZE_SHOULD_BE_THREE_TIMES_DB_SIZE_WARN
/-------------------------------------------------------------------------------
06802, 0,"Archive log location cannot be empty."
// *Cause: When archiving is enabled and Fast Recovery Area is not specified, at least one Archive Log Destination must be specified.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.EITHER_FRA_OR_ARCHIVE_LOG_LOCATION_SHOULD_BE_SPECIFIED_ERR
/-------------------------------------------------------------------------------
06803, 0,"Archive format entered (%s) is invalid."
// *Cause: n/a
// *Action: Specify a valid archive format.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INVALID_ARCHIVE_FORMAT_ERR
/-------------------------------------------------------------------------------
06804, 0,"Specified Archive log location is invalid."
// *Cause: Archive log location value is specified as USE_DB_RECOVERY_FILE_DEST but Fast Recovery Area (FRA) option is not selected.
// *Action: Specify valid location for Archive log location or select FRA option.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INVALID_ARCHIVE_LOG_DEST_ERR
/-------------------------------------------------------------------------------
06901, 0,"Unable to replace variables in string (%s)."
// *Cause: n/a
// *Action: Make sure that the specified string is syntactically correct and the variables  used in this string are defined.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_REPLACE_VARIABLES_ERR
/-------------------------------------------------------------------------------
07001, 0,"Specified credentials for Enterprise Manager Cloud Control configuration are invalid."
// *Cause: Unable to establish connection to the Enterprise Manager Cloud Control using the credentials- OMS host: %s, OMS port: %s, Admin user: %s and the specified password.
// *Action: Verify the details specified for Enterprise Manager Cloud Control configuration.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INVALID_OMS_CREDENTIALS_ERR
/-------------------------------------------------------------------------------
07101, 0,"Unable to load the pdb metadata file (%s)."
// *Cause: n/a
// *Action: Check the existence and the validity of the pdb metadata file.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_LOAD_PDB_XML_ERR
/-------------------------------------------------------------------------------
07201, 0,"Unable to retrieve database instances running on node (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_RETRIEVE_INSTANCES_ERR
/-------------------------------------------------------------------------------
07501, 0,"Unable to check permissions of Oracle home (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_CHECK_LSNR_HOME_PERMS_ERR
/-------------------------------------------------------------------------------
07502, 0,"Selected listener (%s) is not running."
// *Cause: n/a
// *Action: Specify a listener which is running.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.SELECTED_LISTENER_NOT_RUNNING_ERR
/-------------------------------------------------------------------------------
07503, 0,"A listener with name (%s) already exists."
// *Cause: n/a
// *Action: Specify a different name for listener.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.LISTENER_ALREADY_EXISTS_ERR
/-------------------------------------------------------------------------------
07504, 0,"Selected listener (%s) cannot be used for database registration as there is a name conflict with the listeners on the target Oracle home."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.LISTENER_NAME_CONFLICT_ERR
/-------------------------------------------------------------------------------
07505, 0,"Selected listener (%s) does not exist."
// *Cause: n/a
// *Action: Specify an existing listener.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.SELECTED_LISTENER_NON_EXISTENT
/-------------------------------------------------------------------------------
07506, 0,"Unable to start the listener (%s) in the Oracle home."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_START_LISTENER_WARN
/-------------------------------------------------------------------------------
07507, 0,"Unable to detect SCAN listeners."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_DETECT_SCAN_LISTENERS_WARN
/-------------------------------------------------------------------------------
07508, 0,"Unable to detect if SCAN listener is running."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_DETECT_SCAN_LISTENER_RUNNING_WARN
/-------------------------------------------------------------------------------
08001, 0,"Invalid directory service credentials."
// *Cause: n/a
// *Action: Verify the directory service credentials and the correctness of the configuration file (ldap.ora).
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.DS_AUTHENTICATION_ERR
/-------------------------------------------------------------------------------
08002, 0,"Unable to establish connection with the directory server."
// *Cause: An access violation occurred while connecting to the directory server using the user distinguished name (%s).
// *Action: Verify the directory service credentials and the correctness of the configuration file (ldap.ora).
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.DIR_SERVICE_ACCESS_ERR
/-------------------------------------------------------------------------------
08003, 0,"Unable to establish connection with the directory server."
// *Cause: Unknown error occurred while trying to access the directory service using the user distinguished name (%s).
// *Action: Verify the directory service credentials and the correctness of the configuration file (ldap.ora).
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNKNOWN_DIR_SERVICE_ACCESS_ERR
/-------------------------------------------------------------------------------
08004, 0,"Directory service is not configured in the Oracle home."
// *Cause: The directory service configuration file (ldap.ora) is not found or not configured correctly in the Oracle home.
// *Action: Verify the correctness of the directory service configuration. If required, use Network Configuration Assistant (NetCA) to perform the configuration.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.DIR_SERVICE_NOT_CONFIGURED_ERR
/-------------------------------------------------------------------------------
08005, 0,"Directory service user distinguished name and/or directory service password cannot be empty."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.DIR_SERVICE_NAME_OR_PASSWORD_NULL_ERR
/-------------------------------------------------------------------------------
08006, 0,"Invalid wallet password."
// *Cause: Wallet password found in the wallet location is not matching with the specified password.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INVALID_WALLET_PASSWORD_ERR
/-------------------------------------------------------------------------------
08007, 0,"Wallet password specified is not as per Oracle recommended standards."
// *Cause: Wallet password must have a minimum length of eight characters and contain alphabets combined with numbers or special characters.
// *Action: Specify a strong password. If required, refer Oracle documentation for the guidelines.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.WALLET_PASSWORD_NOT_PER_POLICY_ERR
/-------------------------------------------------------------------------------
08008, 0,"The version of schema or context of directory service installed is not compatible for database configuration."
// *Cause: n/a
// *Action: Refer the log file for more details on the detected configuration.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.OID_VERSION_NOT_COMPATIBLE_WARN
/-------------------------------------------------------------------------------
08010, 0,"A database with name (%s) is already registered with Directory service. Proceeding with this name will overwrite the existing configuration details in the Directory service."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.DB_ALREADY_REGISTERED_WITH_DIR_SERVICE_WARN
/-------------------------------------------------------------------------------
08011, 0,"The specified database (%s) is not registered with Directory service to perform the unregistration operation."
// *Cause: n/a
// *Action: Verify the existence of the Directory service configuration and the specified credentials.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.DB_NOT_REGISTERED_WITH_DIR_SERVICE_ERR
/-------------------------------------------------------------------------------
08012, 0,"A database with name (%s) is already registered with Directory service."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.DB_ALREADY_REGISTERED_WITH_DIR_SERVICE_ERR
/-------------------------------------------------------------------------------
08013, 0,"Invalid LDAP access type value."
// *Cause: The value provided for LDAP access type is not valid for configuring the directory service.
// *Action: Specify a valid value for LDAP access type: %s or %s.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INVALID_LDAP_ACCESS_TYPE_ERR
/-------------------------------------------------------------------------------
08014, 0,"The selected Container database (%s) is not configured with Active Directory."
// *Cause: Directory Service Integration can be configured in PDB only when it is configured in the Container database.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.CDB_NOT_CONFIGURED_WITH_AD_ERR
/-------------------------------------------------------------------------------
08020, 0,"Unable to get the assigned servers for the server pool (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_GET_ASSIGNED_NODES_FOR_SERVERPOOL_ERR
/-------------------------------------------------------------------------------
08021, 0,"Unable to get free servers for server pool creation."
// *Cause: n/a
// *Action: Verify the availability of free servers in the Oracle Grid Infrastructure configuration.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_GET_FREE_NODES_FOR_SERVERPOOL_ERR
/-------------------------------------------------------------------------------
08022, 0,"Unable to check if the specified server pool (%s) exists."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_CHECK_IF_SERVER_POOL_EXISTS_ERR
/-------------------------------------------------------------------------------
08030, 0,"Unable to check if the current user has Oracle Grid Infrastructure admin privileges."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_CHECK_CRS_ADMIN_PRIV_ERR
/-------------------------------------------------------------------------------
08051, 0,"Unable to check if node (%s) is a Leaf node."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_CHECK_IF_NODE_IS_LEAF_ERR
/-------------------------------------------------------------------------------
08052, 0,"Unable to check the node role for (%s)."
// *Cause: Add instance can be performed on hub nodes only, but unable to determine the role of the specified node.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_CHECK_IF_NODE_IS_HUB_ADD_INST_ERR
/-------------------------------------------------------------------------------
08053, 0,"Unable to check the node role for (%s)."
// *Cause: Admin managed database can be created on hub nodes only, but unable to determine the role of the specified node.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_CHECK_IF_NODE_IS_HUB_ADMIN_DB_ERR
/-------------------------------------------------------------------------------
08101, 0,"The selected PDB (%s) is not open."
// *Cause: PDB has to be open in READ WRITE mode to perform the configuration.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PDB_NOT_OPEN_ERR
/-------------------------------------------------------------------------------
08102, 0,"The selected PDB(s) (%s) do not exist."
// *Cause: n/a
// *Action: Select existing PDB(s) in the container database %s.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.NON_EXISTENT_PDB_SELECTED_ERR
/-------------------------------------------------------------------------------
08103, 0,"PDB name has to be specified for PDB management operation."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.NO_PDB_SELECTED_ERR
/-------------------------------------------------------------------------------
08104, 0,"The selected PDB (%s) is in (%s) status. PDB operations can be performed only in NORMAL status."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PDB_STATUS_NOT_NORMAL_ERR
/-------------------------------------------------------------------------------
08105, 0,"The selected PDB (%s) is in restricted mode. PDB operations cannot be performed in restricted mode."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PDB_RESTRICTED_MODE_ERR
/-------------------------------------------------------------------------------
08106, 0,"Specified Remote PDB (%s) does not exist."
// *Cause: n/a
// *Action: Specify existing Remote PDB from the container database.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.NON_EXISTENT_REMOTE_PDB_SELECTED_ERR
/-------------------------------------------------------------------------------
09101, 0,"Target environment does not meet some mandatory requirements."
// *Cause: Some of the mandatory prerequisites are not met. See logs for details. %s
// *Action: Find the appropriate configuration from the log file or from the installation guide to meet the prerequisites and fix this manually.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PREREQS_MANDATORY_PREREQUISITES_NOT_MET_ERR
/-------------------------------------------------------------------------------
09102, 0,"Target environment does not meet some optional requirements."
// *Cause: Some of the optional prerequisites are not met. See logs for details.
// *Action: Find the appropriate configuration from the log file or from the installation guide to meet the prerequisites and fix this manually.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.PREREQS_OPTIONAL_PREREQUISITES_NOT_MET_WARN
/-------------------------------------------------------------------------------
09250, 0,"There are no registered listeners for the selected Container database. EM DB Express URL will not be accessible."
// *Cause: There is no registered listener running with the database.
// *Action: Register the database with a listener.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.EM_DB_EXPRESS_URL_UNAVAILABLE_NO_LISTENER_REGISTERED_TO_DB_WARN
/-------------------------------------------------------------------------------
09251, 0,"The listener configuration is not selected for the database. EM DB Express URL will not be accessible."
// *Cause: The database should be registered with a listener in order to access the EM DB Express URL.
// *Action: Select a listener to be registered or created with the database.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.EM_DB_EXPRESS_URL_UNAVAILABLE_NO_LISTENER_REGISTRATION_OR_CREATION_WARN
/-------------------------------------------------------------------------------
09300, 0,"Value for the initialization parameter '%s' cannot be empty."
// *Cause: n/a
// *Action: Provide a value for the Initialization parameter '%s'.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INIT_PARAM_EMPTY_ERR
/-------------------------------------------------------------------------------
09301, 0,"Unable to create the initialization parameter file."
// *Cause: Initialization parameter file path is empty.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INIT_PARAM_FILE_EMPTY_ERR
/-------------------------------------------------------------------------------
09302, 0,"Unable to write into the initialization parameter file %s."
// *Cause: An exception occurred while creating the initialization parameter file.
// *Action: Verify the file permissions for the current user.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.UNABLE_TO_WRITE_INTO_INIT_FILE_ERR
/-------------------------------------------------------------------------------
09350, 0,"ASM Cluster File System (ACFS) mount point location is not specified."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.ACFS_MOUNTPOINT_PATH_NULL_ERR
/-------------------------------------------------------------------------------
09351, 0,"The file (%s) is not found in the Oracle home."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.FILE_NOT_FOUND_ERR
/-------------------------------------------------------------------------------
09352, 0,"Error in validating %s credentials."
// *Cause: n/a
// *Action: Specify valid credentials.
// *FQN: oracle.assistants.common.resource.AssistantErrorCode.INVALID_CREDENTIALS_ERR
/-------------------------------------------------------------------------------
10001, 0,"In a Flex Cluster environment, DBCA can be invoked only from a Hub node."
// *Cause: n/a
// *Action: Invoke DBCA from one of the configured Hub nodes.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.FLEX_CLUSTER_LOCAL_NODE_NOT_HUB_NODE_ERR
/-------------------------------------------------------------------------------
10002, 0,"DBCA does not support this operation in a Grid Infrastructure Oracle home."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DBCA_NOTSUPPORTED_IN_GRID_HOME_ERR
/-------------------------------------------------------------------------------
10003, 0,"Delete operation for Oracle Grid Infrastructure Management Repository (GIMR) cannot be performed on the current node (%s)."
// *Cause: Oracle GIMR is running on a remote node (%s).
// *Action: Invoke DBCA on the remote node (%s) to delete Oracle GIMR.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DELETE_MGMTDB_RUNNING_FROM_REMOTE_NODE_ERR
/-------------------------------------------------------------------------------
10004, 0,"DBCA failed to detect options for this Oracle installation. 
//         
//         %s
//         
//         Some DBCA features may not be available."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DBCA_HOME_INIT_FAILED_WARN
/-------------------------------------------------------------------------------
10005, 0,"DBCA failed to retrieve the current user. Oracle home owner check cannot be performed."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.UNABLE_TO_VERIFY_OWNER_OF_ORACLE_HOME_WARN
/-------------------------------------------------------------------------------
10006, 0,"DBCA supported operations can be performed only by the Oracle home owner (%s). User running DBCA (%s) is not the owner of the Oracle home (%s)."
// *Cause: n/a
// *Action: Invoke DBCA with the same user as the Oracle home owner.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DBCA_INCORRECT_USER_EXECUTING_ERR
/-------------------------------------------------------------------------------
10201, 0,"%s operation cannot be performed."
// *Cause: There are no databases present on the system.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_DB_AVAILABLE_ERR
/-------------------------------------------------------------------------------
10202, 0,"Oracle RAC Instance Management operation cannot be performed."
// *Cause: The RAC environment is not enabled on the system.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_RAC_ENVIRONMENT_ERR
/-------------------------------------------------------------------------------
10203, 0,"Oracle RAC Instance Management operation cannot be performed."
// *Cause: Oracle RAC Instance management operation can be performed only on Admin Managed Oracle RAC databases.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_ADMIN_DB_AVAILABLE_ERR
/-------------------------------------------------------------------------------
10301, 0,"The length of the PDB name must be between 1 and %s characters."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_NAME_LENGTH_ERR
/-------------------------------------------------------------------------------
10302, 0,"PDB name specified (%s) is invalid."
// *Cause: PDB name should start with an alphabetical character and may include alphanumeric characters, and the _ character.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_PDB_NAME_ERR
/-------------------------------------------------------------------------------
10303, 0,"PDB name cannot be the same as the Container database name."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_NAME_MATCH_GDB_NAME_ERR
/-------------------------------------------------------------------------------
10304, 0,"Oracle home user password is not correct."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ORACLE_HOME_USER_PASSWORD_INCORRECT_ERR
/-------------------------------------------------------------------------------
10305, 0,"The specified password is one of the keywords and is not allowed."
// *Cause: The password cannot be any of the following - CHANGE_ON_INSTALL,MANAGER, or DBSNMP.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_PASSWORD_NOT_ALLOWED_WARN
/-------------------------------------------------------------------------------
10306, 0,"PDB name cannot be same as the service name of Oracle RAC One Node database."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_NAME_MATCH_RACONE_SERVICE_NAME_ERR
/-------------------------------------------------------------------------------
10309, 0,"PDB name (%s) cannot be same as the RAC One Node database service name."
// *Cause: n/a
// *Action: Modify the PDB prefix name or the RAC One Node database service name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_NAME_MATCH_FROM_MULTIPLE_CREATION_RACONE_SERVICE_NAME_ERR
/-------------------------------------------------------------------------------
10310, 0,"PDB name (%s) cannot be same as the RAC One Node database service name."
// *Cause: n/a
// *Action: Modify the RAC One Node database service name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_NAME_CDB_TMPLT_MATCH_FROM_MULTIPLE_CREATION_RACONE_SERVICE_NAME_ERR
/-------------------------------------------------------------------------------
10311, 0,"Same PDB name (%s) is used for more than one PDB."
// *Cause: n/a
// *Action: Specify unique PDB names for each PDB.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DUPLICATE_PDB_NAME_FOUND_ERR
/-------------------------------------------------------------------------------
10312, 0,"Additional PDBs cannot be created when Container database template is specified to create a database."
// *Cause: n/a
// *Action: Do not specify PDB count if Container database template is specified to create a database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ADDITIONAL_PDB_CREATION_NOT_SUPPORTED_WARN
/-------------------------------------------------------------------------------
10313, 0,"A container database cannot be created from template %s."
// *Cause: A container database cannot be created from a database clone template that was created from a non-container database.
// *Action: Select a structural template, a Container database template or an Oracle shipped template.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NON_CDB_USER_PROVIDED_TEMPLATE_FOR_CDB_CREATION_ERR
/-------------------------------------------------------------------------------
10314, 0,"The %s cannot be empty."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.VALUE_NULL_OR_EMPTY_ERR
/-------------------------------------------------------------------------------
10315, 0,"Specified %s cannot exceed (%s) characters."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_NAME_LENGTH_ERR
/-------------------------------------------------------------------------------
10316, 0,"Specified %s (%s) contains characters that are not allowed."
// *Cause: n/a
// *Action: Specify a valid %s that starts with an alphabet and excludes characters (%s).
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_DB_NAME_ERR
/-------------------------------------------------------------------------------
10317, 0,"Specified %s (%s) already exists."
// *Cause: n/a
// *Action: Specify a different %s that does not already exist.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_ALREADY_EXISTS_ERR
/-------------------------------------------------------------------------------
10318, 0,"Specified RAC One database service name (%s) is invalid."
// *Cause: RAC One service name should start with an alphabet followed by letter, digits, or an underscore (_).
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_RAC_ONE_SERVICE_NAME_ERR
/-------------------------------------------------------------------------------
10319, 0,"RAC One service name (%s) cannot be the same as the global database name."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RAC_ONE_SERVICE_NAME_GDB_NAME_SAME_ERR
/-------------------------------------------------------------------------------
10320, 0,"RAC One service name has a domain part that cannot exceed %s characters."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RAC_ONE_SERVICE_DOMAIN_LENGTH_ERR
/-------------------------------------------------------------------------------
10321, 0,"The %s specified does not start with alphabetic character."
// *Cause: n/a
// *Action: Specify a (%s) that starts with an alphabet and contains only alphanumeric characters.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_NAME_SHOULD_START_WITH_ALPHA_ERR
/-------------------------------------------------------------------------------
10322, 0,"The %s specified contains non alphanumeric characters."
// *Cause: n/a
// *Action: Specify a %s that starts with an alphabet and contains only alphanumeric characters.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_NAME_CONTAINS_INVALID_CHARS_ERR
/-------------------------------------------------------------------------------
10323, 0,"The (%s) specified is a SQL reserved word."
// *Cause: n/a
// *Action: Specify a different value for (%s).
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PROVIDED_VALUE_IS_RESERVE_WORD_ERR
/-------------------------------------------------------------------------------
10324, 0,"The SID does not match with the first eight characters of the specified global database name."
// *Cause: n/a
// *Action: SID should match with the first eight characters of the specified global database name in Policy Managed database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SID_NOT_SAME_AS_GDB_IN_POLICY_MANAGED_ERR
/-------------------------------------------------------------------------------
10325, 0,"%s option is not specified."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OPTION_NOT_SELECTED_ERR
/-------------------------------------------------------------------------------
10326, 0,"Value of DB Name is not specified in the GDB Name."
// *Cause: n/a
// *Action: Specify a valid GDB Name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.EMPTY_DB_NAME_ERR
/-------------------------------------------------------------------------------
10327, 0,"Derived SID (%s) already exists."
// *Cause: SID is derived from the first 8 alphanumeric characters of the GDB name and this should be unique in Policy Managed database creation.
// *Action: Specify a different GDB name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DERIVED_SID_ALREADY_EXISTS
/-------------------------------------------------------------------------------
10328, 0,"Specified %s (%s) may have a potential conflict with an already existing database on the system."
// *Cause: n/a
// *Action: Specify a different %s that does not conflict with existing databases on the system.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_GDB_NAME_EXIST_WARN
/-------------------------------------------------------------------------------
10329, 0,"Specified %s (%s) contains NON-ASCII characters that are not allowed."
// *Cause: n/a
// *Action: Specify a valid %s that contains ASCII characters.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NON_ASCII_CHAR_ERR
/-------------------------------------------------------------------------------
10330, 0,"Container database (CDB) creation option is not selected."
// *Cause: You have specified the database template (%s) which represents container database (CDB) information. But, you have not selected to create container database (CDB). Only container database (CDB) can be created using this template.
// *Action: Select container database (CDB) creation option. Alternatively specify different database template
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NON_CDB_CREATION_USING_CDB_CLONE_TEMPLATE_ERR
/-------------------------------------------------------------------------------
10331, 0,"Specified %s (%s) may have a potential conflict with an already existing database on the system."
// *Cause: The specified %s without the trailing numeric characters (%s) may have a potential conflict with an already existing database on the system.
// *Action: Specify a different %s that does not conflict with existing databases on the system.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_PREFIX_EXISTING_DB_WARN
/-------------------------------------------------------------------------------
10332, 0,"SID (%s) already exists and is running on the machine."
// *Cause: Renaming database requires connecting to the sid (%s) to retrieve database information. If a database with same SID already exists, there could be loss of service.
// *Action: Make sure that database with SID (%s) does not exist on the box.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OLD_SID_SERVICE_EXISTS_ERR
/-------------------------------------------------------------------------------
10501, 0,"The specified template file (%s) cannot be read."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.TEMPLATE_FILE_CANNOT_BE_READ_ERR
/-------------------------------------------------------------------------------
10502, 0,"No database was selected to create the template."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_DATABASE_SELECTED_ERR
/-------------------------------------------------------------------------------
10503, 0,"Template file is not specified."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.TEMPLATE_FILE_NOT_SPECIFIED_ERR
/-------------------------------------------------------------------------------
10504, 0,"Unable to load the specified template (%s)."
// *Cause: The specified template data might not be in the expected format.
// *Action: Verify the format of the template.
// *FQN: oracle.assistants.dbca.util.resource.DBCAUtilErrorCode.UNABLE_TO_LOAD_TEMPLATE_ERR
/-------------------------------------------------------------------------------
10505, 0,"Unable to generate html document for the template."
// *Cause: Internal error occurred while creating html document.
// *Action: Refer to the logs or contact Oracle Support Services.
// *FQN: oracle.assistants.dbca.util.resource.DBCAUtilErrorCode.UNABLE_TO_CREATE_HTML_DOCUMENT_ERR
/-------------------------------------------------------------------------------
10506, 0,"Unable to generate html document for the template."
// *Cause: Internal error occurred while converting html document to string format.
// *Action: Refer to the logs or contact Oracle Support Services.
// *FQN: oracle.assistants.dbca.util.resource.DBCAUtilErrorCode.UNABLE_TO_CONVERT_HTML_DOC_TO_TEXT_FORMAT_ERR
/-------------------------------------------------------------------------------
10507, 0,"Invalid template file specified (%s)."
// *Cause: The given template is not compliant to the expected schema.
// *Action: Verify the correctness of the template syntactically and semantically. Alternatively contact Oracle Support Services.
// *FQN: oracle.assistants.dbca.util.resource.DBCAUtilErrorCode.INVALID_TEMPLATE_FORMAT_ERR
/-------------------------------------------------------------------------------
10508, 0,"Invalid template file specified (%s)."
// *Cause: Either the given template path is not valid file path or could not locate the given template in the local file system.
// *Action: Verify the existance of the template file.
// *FQN: oracle.assistants.dbca.util.resource.DBCAUtilErrorCode.INVALID_TEMPLATE_FILE_ERR
/-------------------------------------------------------------------------------
10601, 0,"(%s) cannot be created in the current Oracle home."
// *Cause: Oracle home is not RAC enabled.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RAC_SELECTED_BUT_HOME_IS_NOT_RAC_ENABLED_ERR
/-------------------------------------------------------------------------------
10602, 0,"(%s) database cannot be created in this system."
// *Cause: Oracle Grid Infrastructure is not configured on the system.
// *Action: Configure Oracle Grid Infrastructure prior to creation of (%s). Refer to Oracle Grid Infrastructure Installation Guide for installation and configuration steps.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RAC_SELECTED_BUT_CRS_NOT_CONFIGURED_ERR
/-------------------------------------------------------------------------------
10603, 0,"Oracle RAC software is not present on candidate nodes (%s) of the serverpool (%s)."
// *Cause: n/a
// *Action: Install Oracle RAC software on all the candidate nodes before doing database configuration.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RAC_SOFTWARE_NOT_PRESENT_ON_CANDIDATE_NODES_ERR
/-------------------------------------------------------------------------------
10800, 0,"Random password could not be generated for %s account."
// *Cause: n/a
// *Action: Refer log file for more information.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.COULD_NOT_GENERATE_RANDOM_PASSWORD_ERR
/-------------------------------------------------------------------------------
10900, 0,"Unable to get instance number for new instance addition."
// *Cause: Instance number may not have been generated for the new instance.
// *Action: Refer log file for more details.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INSTANCE_NUMBER_NOT_UPDATED_ERR
/-------------------------------------------------------------------------------
10901, 0,"Required undo tablespace is more than the number of instances."
// *Cause: n/a
// *Action: Refer log file for more details.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.REQUIRED_UNDO_TABLESPACE_MORE_THAN_INSTANCE_NAMES_ERR
/-------------------------------------------------------------------------------
10902, 0,"StorageSettings backup cloning failed."
// *Cause: n/a
// *Action: Refer log file for more details.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.STORAGE_SETTINGS_BACKUP_CLONE_FAILED_WARN
/-------------------------------------------------------------------------------
10951, 0,"Template file (%s) already exists and will be overwritten."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.TEMPLATE_FILE_ALREADY_EXISTS_WARN
/-------------------------------------------------------------------------------
10952, 0,"SYS user does not have DV_PATCH_ADMIN privileges."
// *Cause: n/a
// *Action: Grant DV_PATCH_ADMIN privileges to the SYS user to create a template from a database where Database Vault is configured.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_OWNER_PERM_REQUIRED_ERR
/-------------------------------------------------------------------------------
10953, 0,"One or more Pluggable database(s) (%s) in the Container database are not open."
// *Cause: All pluggable databases in the Container database should be open to perform a configuration.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_STATUS_NOT_OPEN_ERR
/-------------------------------------------------------------------------------
10954, 0,"The space in the template file name will be replaced with underscore(_)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.TEMPLATE_NAME_WITH_SPACE_WARN
/-------------------------------------------------------------------------------
10955, 0,"One or more Pluggable database(s) (%s) are in closed state. Selected configurations will not be performed on these PDBs"
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_STATUS_NOT_OPEN_WARN
/-------------------------------------------------------------------------------
11001, 0,"Oracle Managed Files (OMF) option is not selected for storage in Policy Managed database."
// *Cause: OMF option needs to be selected in order to enable Database to dynamically create required redolog groups and undo tablespaces when database server pool cardinality is increased.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.USE_OMF_FOR_POLICY_DB_ERR
/-------------------------------------------------------------------------------
11002, 0,"Use SPFile option is not selected in the DBCA template."
// *Cause: Oracle RAC database creation requires Use SPFile option to be selected in the DBCA template.
// *Action: Specify a DBCA template with Use SPFile option selected.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RAC_USE_SPFILE_SHOULD_BE_TRUE_ERR
/-------------------------------------------------------------------------------
11003, 0,"ASM storage option is selected for datafile location. However Oracle Managed Files (OMF) option is not selected."
// *Cause: OMF option is recommended when datafiles are placed in ASM storage.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.USE_OMF_FOR_ASM_WARN
/-------------------------------------------------------------------------------
11004, 0,"Unable to validate ASM. There is no disk group detected."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ASM_INSTANCE_NOT_VALIDATED_ERR
/-------------------------------------------------------------------------------
11101, 0,"The block size (%s) for the tablespace %s does not match the configured block size (%s)."
// *Cause: n/a
// *Action: To use block size of (%s), set initialization parameter %s.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INCORRECT_BLOCK_SIZE_ERR
/-------------------------------------------------------------------------------
11151, 0,"Character set specified (%s) is invalid."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_CHARACTER_SET_ERR
/-------------------------------------------------------------------------------
11152, 0,"National character set specified (%s) is invalid."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_NATIONAL_CHARACTER_SET_ERR
/-------------------------------------------------------------------------------
11153, 0,"Character set specified (%s) is different from that of the character set (%s) in the template. Character set mismatch may cause data truncation."
// *Cause: n/a
// *Action: Make sure the character sets uses the same encoding scheme.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DIFF_CHARSET_FROM_TEMPLATE_WARN
/-------------------------------------------------------------------------------
11201, 0,"PGA size specified is too small."
// *Cause: n/a
// *Action: PGA size of at least (%s%s) is recommended.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.MIN_PGA_NOT_PROVIDED_WARN
/-------------------------------------------------------------------------------
11202, 0,"Buffer cache size specified is too small."
// *Cause: n/a
// *Action: Buffer cache of at least (%s%s) is recommended.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.MIN_BUFFER_CACHE_NOT_PROVIDED_WARN
/-------------------------------------------------------------------------------
11203, 0,"Java pool size specified is too small."
// *Cause: n/a
// *Action: Java pool size of at least (%s%s) is recommended.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.MIN_JAVA_POOL_NOT_PROVIDED_WARN
/-------------------------------------------------------------------------------
11204, 0,"Memory target specified is too small."
// *Cause: n/a
// *Action: Memory target size of at least (%s%s) is recommended.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.MIN_MEMORY_REQUIRED_NOT_AVAILABLE_WARN
/-------------------------------------------------------------------------------
11205, 0,"Specified shared pool size does not meet the recommended minimum size requirement. This might cause database creation to fail."
// *Cause: n/a
// *Action: Specify at least (%s%s) for shared pool size.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_ENOUGH_SHARED_POOL_WARN
/-------------------------------------------------------------------------------
11206, 0,"Shared pool size specified is too small."
// *Cause: n/a
// *Action: Shared pool size of at least (%s%s) is recommended.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.MIN_SHARED_POOL_NOT_PROVIDED_WARN
/-------------------------------------------------------------------------------
11207, 0,"Specified SGA size is greater than the shmmax on the system. The database creation might fail with ORA-27125 - Unable to create shared memory segment error."
// *Cause: n/a
// *Action: Specify SGA size lesser than or equal to the shmmax on the system.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_ENOUGH_SGA_WARN
/-------------------------------------------------------------------------------
11208, 0,"SGA size specified is too small."
// *Cause: n/a
// *Action: SGA size of at least (%s%s) is recommended.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.MIN_SGA_REQUIRED_NOT_AVAILABLE_WARN
/-------------------------------------------------------------------------------
11209, 0,"Current available memory is less than the required available memory (%s%s) for creating the database."
// *Cause: Following nodes do not have required available memory :
//         %s
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_ENOUGH_MEMORY_AVAILABLE_WARN
/-------------------------------------------------------------------------------
11210, 0,"Automatic Memory Management is not supported on your current operating system."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.AMM_NOT_FEASIBLE_UNSUPPORTED_OS_ERR
/-------------------------------------------------------------------------------
11211, 0,"The Automatic Memory Management option is not allowed when the total physical memory is greater than %sGB."
// *Cause: The current total physical memory is %sGB.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.AMM_NOT_FEASIBLE_WITH_PHYSICAL_MEMORY_GREATER_THAN_LIMIT_ERR
/-------------------------------------------------------------------------------
11212, 0,"Automatic Memory Management is not a feasible option on the system."
// *Cause: There is no %s volume configured on the system.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.AMM_NOT_FEASIBLE_NO_DEV_SHM_VOLUME_ERR
/-------------------------------------------------------------------------------
11213, 0,"Automatic Memory Management is not a feasible option on the system."
// *Cause: There is not enough free space on volume %s to allocate %sMB on nodes %s.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.AMM_NOT_FEASIBLE_NOT_ENOUGH_VOLUME_SPACE_NODES_ERR
/-------------------------------------------------------------------------------
11214, 0,"Automatic Memory Management is not a feasible option on the system."
// *Cause: There is not enough free space on volume %s to allocate %sMB.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.AMM_NOT_FEASIBLE_NOT_ENOUGH_VOLUME_SPACE_ERR
/-------------------------------------------------------------------------------
11215, 0,"Shared pool size is not provided."
// *Cause: n/a
// *Action: Specify a value for shared pool size.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SHARED_POOL_NOT_PROVIDED_ERR
/-------------------------------------------------------------------------------
11216, 0,"You have specified Manual Shared Memory Management configuration option but the values for the corresponding initialization parameters are not provided. Database will be configured with default memory values."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.MANUAL_MEMORY_MANAGEMENT_NO_VALUE_SPECIFIED_WARN
/-------------------------------------------------------------------------------
11217, 0,"Unable to check available shared memory on specified node(s) (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.FAILED_CHECK_AVL_SHARED_MEMORY_WARN
/-------------------------------------------------------------------------------
11218, 0,"Some nodes do not have sufficient available shared memory."
// *Cause: Following node(s) do not have sufficient shared memory. 
//         
//          Node name, required value in %s, and actual value in %s for each node is displayed below. 
//         %s
// *Action: Increase available shared memory.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_ENOUGH_AVL_SHARED_MEMORY_WARN
/-------------------------------------------------------------------------------
11501, 0,"Oracle RAC database instance management operation is not feasible on the selected database %s."
// *Cause: Oracle RAC database instance management operation cannot be performed on single instance Oracle database, Oracle RAC One Node database, or Policy Managed Oracle RAC databases.
// *Action: Select Admin Managed RAC database for instance management.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SELECTED_DB_NOT_FEASIBLE_FOR_INSTANCE_MGMT_ERR
/-------------------------------------------------------------------------------
11502, 0,"The instance (%s) is not running on the local node."
// *Cause: A locally running instance is required to perform the selected operation.
// *Action: Specify a locally running database, or execute DBCA on a node where the database instance is running.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.LOCAL_INSTANCE_NOT_RUNNING_ERR
/-------------------------------------------------------------------------------
11503, 0,"The instance (%s) is not running on the local node. This may result in partial delete of Oracle database."
// *Cause: A locally running instance is required for complete deletion of Oracle database instance and database files.
// *Action: Specify a locally running database, or execute DBCA on a node where the database instance is running.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.LOCAL_INSTANCE_NOT_RUNNING_WARN
/-------------------------------------------------------------------------------
11504, 0,"The selected node is already part of an existing server pool (%s) that is hosting Policy Managed databases."
// *Cause: n/a
// *Action: Specify a different node for creating a database or adding instance.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NODE_PART_OF_SERVER_POOL_ERR
/-------------------------------------------------------------------------------
11505, 0,"Maximum PDBs limit reached for the selected Container database."
// *Cause: A Container database can only contain up to (%s) PDBs, including the seed.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.MAX_PDB_LIMIT_REACHED_ERR
/-------------------------------------------------------------------------------
11506, 0,"Creation of more than one PDB requires Enterprise Edition license."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.MAX_PDB_LIMIT_REACHED_SE_ERR
/-------------------------------------------------------------------------------
11507, 0,"No PDBs were found in the selected Container database."
// *Cause: n/a
// *Action: Select a Container database that has at least one PDB in it.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_PDBS_PRESENT_ERR
/-------------------------------------------------------------------------------
11508, 0,"The selected database is not a Container database."
// *Cause: PDB operations can be performed only on a Container database.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_A_CDB_ERR
/-------------------------------------------------------------------------------
11509, 0,"The selected database (%s) is not open."
// *Cause: Database should be in read/write mode to perform any configuration.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_NOT_OPEN_ERR
/-------------------------------------------------------------------------------
11510, 0,"Oracle Database Vault (DV) is enabled in the selected %s (%s)."
// *Cause: Database Vault should be disabled to perform any configuration update in the %s.
// *Action: Disable Database Vault in the selected %s (%s) and try again.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_ALREADY_ENFORCED_ERR
/-------------------------------------------------------------------------------
11511, 0,"No node is available for adding an instance because the database (%s) has instances on all nodes of the cluster."
// *Cause: n/a
// *Action: Extend the Oracle Grid Infrastructure Clusterware by adding more nodes before performing this operation. Refer to Oracle Grid Infrastructure Installation Guide on how to extend the Clusterware.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_NODE_AVAILABLE_FOR_ADD_INSTANCE_ERR
/-------------------------------------------------------------------------------
11512, 0,"No locally running instances found."
// *Cause: n/a
// *Action: Specify a locally running database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_LOCAL_INSTANCE_RUNNING_ERR
/-------------------------------------------------------------------------------
11513, 0,"The detected Oracle SID (%s) differs from the specified database (%s). This delete operation will delete the database associated with the Oracle SID."
// *Cause: n/a
// *Action: Verify if name mismatch is expected.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SOURCE_DB_MISMATCH_SID_WARN
/-------------------------------------------------------------------------------
11514, 0,"The detected Oracle SID (%s) for the specified database (%s) refers to an another existing database."
// *Cause:  The database deletion operation cannot be continued as the instance_name initialization parameter of the specified database refers to an another existing database.
// *Action: Verify the instance_name initialization parameter of both databases and resolve the conflicts.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SOURCE_DB_REFERS_TO_EXISTING_DATABASE_ERR
/-------------------------------------------------------------------------------
11515, 0,"SYSDBA user name is not specified."
// *Cause: SYSDBA user credential required to perform '%s' operation in the database (%s).
// *Action: Specify a valid sysdba user name
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SYS_DB_USER_NAME_EMPTY_ERR
/-------------------------------------------------------------------------------
11516, 0,"The password for SYSDBA user (%s) is not specified."
// *Cause: SYSDBA user password is required to perform '%s' operation in the database (%s).
// *Action: Specify a valid password for user '%s'.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SYS_DB_USER_PASSWORD_EMPTY_ERR
/-------------------------------------------------------------------------------
11517, 0,"Source database is not specified."
// *Cause: You have not specified a source database to perform '%s' operation.
// *Action: Specify a valid source database information.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SOURCE_DB_NOT_SPECIFIED_ERR
/-------------------------------------------------------------------------------
11518, 0,"Oracle Database Vault (DV) is not installed in the selected %s (%s)."
// *Cause: DV option should be installed in order to configure DV in the %s.
// *Action: Install DV option in the selected %s (%s) and try again.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_NOT_ENABLED_ERR
/-------------------------------------------------------------------------------
11519, 0,"Oracle Database Vault (DV) is already configured in the selected %s (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_ALREADY_CONFIGURED_ERR
/-------------------------------------------------------------------------------
12001, 0,"Specified user will be created as a common user in Container database. Common user name should start with C##."
// *Cause: n/a
// *Action: Specify a user name that starts with C##.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_CDB_DV_OWNER_AS_COMMON_USER_ERR
/-------------------------------------------------------------------------------
12002, 0,"%s specified is not valid."
// *Cause: n/a
// *Action: Specify a user name that does not start with C##.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_DV_OWNER_AS_COMMON_USER_ERR
/-------------------------------------------------------------------------------
12003, 0,"Specified user will be created as a local user in Pluggable database. Local user should not start with C##."
// *Cause: n/a
// *Action: Specify a user that does not start with C##.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_PDB_DV_OWNER_AS_LOCAL_USER_ERR
/-------------------------------------------------------------------------------
12004, 0,"The specified %s (%s) conflicts with Oracle reserved word."
// *Cause: n/a
// *Action: Specify a different %s.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_OWNER_NAME_IS_RESERVED_WORD_ERR
/-------------------------------------------------------------------------------
12005, 0,"The (%s) specified is either too short or too long."
// *Cause: The (%s) must be at least 2 characters and at most 30 characters long.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_OWNER_NAME_LENGTH_ERR
/-------------------------------------------------------------------------------
12006, 0,"%s contains characters that are not allowed."
// *Cause: n/a
// *Action: Specify %s without any of the below characters.
//         (%s)
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_OWNER_NAME_WITH_BAD_CHARS_ERR
/-------------------------------------------------------------------------------
12007, 0,"The Database Vault owner and Database Vault account manager cannot be same."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_MANAGER_SAME_AS_OWNER_ERR
/-------------------------------------------------------------------------------
12008, 0,"The %s password is same as either Database Vault owner or Database Vault account manager."
// *Cause: n/a
// *Action: Database Vault owner and Database Vault account manager should have different passwords.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_PASSWORD_SAME_AS_USER_NAME_ERR
/-------------------------------------------------------------------------------
12009, 0,"The specified password does not meet the Oracle recommended standards."
// *Cause: The %s password must be at least %s and at most %s characters long. Additionally, the password must contain at least one alphabet, one digit, and one non-alphanumeric character. The non-alphanumeric character must be one of the following: pound(#), percent(%), carat(^), dash(-), underscore(_), plus(+), tilde(~), open bracket([), close bracket(]), period(.), or comma(,).
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_PASSWORD_COMPLEXITY_WARN
/-------------------------------------------------------------------------------
12010, 0,"The %s password cannot contain any consecutive repeating characters."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_PASSWORD_WITH_REPEATED_CHARS_ERR
/-------------------------------------------------------------------------------
12011, 0,"Invalid LBACSYS password."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INCORRECT_LBACSYS_PASSWORD_ERR
/-------------------------------------------------------------------------------
12013, 0,"The LBACSYS account is locked.This account needs to be unlocked to configure Label Security on selected PDB."
// *Cause: n/a
// *Action: Unlock the LBACSYS account to proceed.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.LBACSYS_ACCOUNT_LOCKED_ERR
/-------------------------------------------------------------------------------
12101, 0,"A database with name (%s) is already registered with directory service. Proceeding with this name will overwrite the existing configuration details in the directory service."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_ALREADY_REGISTERED_WITH_DIR_SERVICE_WARN
/-------------------------------------------------------------------------------
12102, 0,"Oracle Label Security (OLS) cannot be configured with Oracle Internet Directory (OID) if database is not chosen to be registered with OID."
// *Cause: n/a
// *Action: Register database with OID in order to configure OLS with OID.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DIR_SERVICE_NOT_SELECTED_ERR
/-------------------------------------------------------------------------------
12103, 0,"Oracle Label Security (OLS) cannot be configured with Oracle Internet Directory (OID) if database (%s) is not registered with OID."
// *Cause: n/a
// *Action: Register database with OID in order to configure OLS with OID.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.CANNOT_SELECT_OID_WITH_UNREGISTERED_DB_ERR
/-------------------------------------------------------------------------------
12104, 0,"The specified database (%s) is not registered with directory service."
// *Cause: n/a
// *Action: Register the specified database or verify the directory service credentials.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_NOT_REGISTERED_WITH_DIR_SERVICE_ERR
/-------------------------------------------------------------------------------
12105, 0,"Database wallet already exists for the current database with a different wallet password. Proceeding with this password will overwrite the existing wallet file for this database."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NEED_TO_MODIFY_WALLET_FILE_UI_WARN
/-------------------------------------------------------------------------------
12106, 0,"There is no listener associated with the database,that is required for the correct configuration of Oracle Label Security (OLS) with Oracle Internet Directory (OID)."
// *Cause: n/a
// *Action: Register the database with a listener.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.CANNOT_SELECT_OID_WITHOUT_REGISTERED_LISTENERS_WARN
/-------------------------------------------------------------------------------
12107, 0,"There is no listener associated with the database,that is required for the correct configuration of directory service."
// *Cause: n/a
// *Action: Register the database with a listener.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.CANNOT_REGISTER_DS_WITHOUT_REGISTERED_LISTENERS_ERR
/-------------------------------------------------------------------------------
12108, 0,"Database wallet already exists for the current database with a different wallet password."
// *Cause: n/a
// *Action: Specify the correct wallet password or delete the existing wallet and try again.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NEED_TO_MODIFY_WALLET_FILE_SILENT_ERR
/-------------------------------------------------------------------------------
12109, 0,"Oracle Label Security (OLS) cannot be configured without Oracle Internet Directory (OID) on the PDB when CDB is configured for OLS with OID."
// *Cause: n/a
// *Action: Configure OLS with OID or deselect OLS configure option for PDB.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OLS_WITHOUT_OID_NOT_SUPPORTED_IN_PDB_ERR
/-------------------------------------------------------------------------------
12110, 0,"The PDBs configured in the selected Container Database (%s) will not be unregistered with the Directory Service."
// *Cause: Since each PDB inside the selected Container Database can have different Directory Service configurations, it is recommended to unregister the PDBs manually.
// *Action: Refer Oracle documentation on how to unregister PDB with the Directory Service.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.UNREGISTER_PDB_MANUALLY_WARN
/-------------------------------------------------------------------------------
12111, 0,"Oracle Label Security is already configured in the selected pluggable database (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OLS_ALREADY_CONFIGURED_IN_PDB_ERR
/-------------------------------------------------------------------------------
12112, 0,"Oracle Label Security (OLS) cannot be configured with Oracle Internet Directory (OID) on the PDB when CDB is configured for standalone OLS only."
// *Cause: n/a
// *Action: Configure standalone OLS or deselect OLS configure option for PDB.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OLS_WITH_OID_NOT_SUPPORTED_IN_PDB_ERR
/-------------------------------------------------------------------------------
12113, 0,"OLS can be configured in PDB only when it is configured on Container database."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.CDB_NOT_CONFIGURED_WITH_OLS_ERR
/-------------------------------------------------------------------------------
12114, 0,"Enable the OLS option in the PDB to do configuration or deselect the configure OLS option ."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OLS_DISABLED_IN_PDB_ERR
/-------------------------------------------------------------------------------
12115, 0,"Oracle Label Security (OLS) is configured with directory service in the selected database (%s). Unregistering the database with directory service might cause OLS to not function as expected."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OLS_WITH_OID_CONFIG_DISCOVERED_WARN
/-------------------------------------------------------------------------------
12116, 0,"Unable to create wallet to use for two-way authentication with the directory service: %s"
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.UNABLE_TO_CREATE_2WAY_SSL_WALLET_ERR
/-------------------------------------------------------------------------------
12117, 0,"The certificate file (%s) does not exist."
// *Cause: n/a
// *Action: Verify the correctness of the certificate path.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SSL_CERTIFICATE_NOT_FOUND_ERR
/-------------------------------------------------------------------------------
12501, 0,"SYSTEM password for sample schema cannot be null or empty."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SYSTEM_PASSWORD_FOR_SAMPLE_SCHEMA_NULL_ERR
/-------------------------------------------------------------------------------
12502, 0,"Unable to connect to database with the specified SYSTEM password."
// *Cause: n/a
// *Action: Specify a valid SYSTEM password.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_SYSTEM_PASSWORD_FOR_SAMPLE_SCHEMA_ERR
/-------------------------------------------------------------------------------
12503, 0,"Local node should be member of at least one of the specified serverpools (%s) for sample schema configuration."
// *Cause: n/a
// *Action: Configure local node to be a member of a server pool.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.UNABLE_TO_CONFIGURE_SAMPLE_SCHEMA_ERR
/-------------------------------------------------------------------------------
12504, 0,"For Policy Managed database, database instance may come up on local node depending on node availability. Sample schema on local node will be configured only when database instance comes up on local node."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SAMPLE_SCHEMA_DISALLOWED_ON_NEW_POOL_WARN
/-------------------------------------------------------------------------------
12506, 0,"The option %s is selected to be installed. But prerequisite options %s is not selected."
// *Cause: n/a
// *Action: Select all the prerequisite options for %s option.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DEPENDENTS_NOT_SELECTED_ERR
/-------------------------------------------------------------------------------
12507, 0,"DBCA does not allow sample schemas to be configured in container database with more than one PDBs."
// *Cause: n/a
// *Action: Choose only one PDB to be created in the container database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.UNABLE_TO_CREATE_SAMPLE_SCHEMA_FOR_MULTIPLE_PDB_ERR
/-------------------------------------------------------------------------------
12508, 0,"Option (%s) cannot be configured in this home."
// *Cause: n/a
// *Action: Deselect the option to continue. Proceeding without deselection will exclude the option from configuration.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OPTION_CANNOT_BE_CONFIGURED_WARN
/-------------------------------------------------------------------------------
12509, 0,"Option %s is enabled in the PDBs but not in the CDB."
// *Cause: This option must be enabled in the CDB in order to be included in the PDBs.
// *Action: Enable the option %s in the CDB.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OPTION_MUST_BE_ENABLED_IN_CDB_ERR
/-------------------------------------------------------------------------------
12510, 0,"The database option '%s' is not feasible to be installed in the current Oracle home."
// *Cause: The current Oracle home does not have required licensing to install the specified database option or does not have all required configuration files.
// *Action: Refer Oracle database edition licensing information and database option specific documentation to know the list of supported database options.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OPTION_NOT_FEASIBLE_ERR
/-------------------------------------------------------------------------------
12511, 0,"The specified tablespace '%s' cannot be used for the database component '%s' installation."
// *Cause: n/a
// *Action: Specify different tablespace name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OPTION_TABLESPACE_NOT_FEASIBLE_ERR
/-------------------------------------------------------------------------------
12512, 0,"The option %s is selected to be installed on PDBs. But prerequisite options %s is not selected."
// *Cause: n/a
// *Action: Select all the prerequisite options for %s option for PDB.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DEPENDENTS_NOT_SELECTED_FOR_PDB_ERR
/-------------------------------------------------------------------------------
13001, 0,"At least one create option should be selected."
// *Cause: n/a
// *Action: Select at least one of the create options - create db option, or create template option, or generate scripts option.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ATLEAST_ONE_CREATION_OPTION_TO_BE_SELECTED_ERR
/-------------------------------------------------------------------------------
13002, 0,"The specified custom script (%s) does not exist."
// *Cause: n/a
// *Action: Specify a valid custom script.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.CUSTOM_SCRIPT_FILE_NOT_EXISTS_ERR
/-------------------------------------------------------------------------------
13003, 0,"The custom script (%s) is specified multiple times in the list."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.REPEATED_SCRIPT_IN_THE_LIST_WARN
/-------------------------------------------------------------------------------
13051, 0,"The selected instance (%s) is the last instance of the database. This cannot be deleted."
// *Cause: n/a
// *Action: Use the Delete database feature to delete the instance and the database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.LAST_INSTANCE_CANNOT_BE_DELETED_ERR
/-------------------------------------------------------------------------------
13052, 0,"The instance (%s) is a local instance. This cannot be deleted."
// *Cause: n/a
// *Action: Try this operation from another node in the cluster.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.CANNOT_DELETE_LOCAL_INSTANCE_ERR
/-------------------------------------------------------------------------------
13053, 0,"Selected instance cannot be deleted as following services have this instance as their preferred instance.
//          (%s)"
// *Cause: n/a
// *Action: Update the service configuration to remove this as their preferred instance.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.CANNOT_DELETE_ONLY_PREFERRED_INSTANCE_ERR
/-------------------------------------------------------------------------------
13054, 0,"The instance (%s) is not running on the node (%s)."
// *Cause: n/a
// *Action: Specify the correct instance name and the corresponding node.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INSTANCE_DELETION_NODELIST_MISMATCH_ERR
/-------------------------------------------------------------------------------
13055, 0,"The local node instance (%s) is not running."
// *Cause: n/a
// *Action: Start the local instance and retry.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.LOCAL_INSTANCE_OF_DB_NOT_RUNNING_ERR
/-------------------------------------------------------------------------------
13056, 0,"The specified instance (%s) does not exist."
// *Cause: n/a
// *Action: Specify an existing database instance.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INSTANCE_NOT_EXIST_ERR
/-------------------------------------------------------------------------------
13057, 0,"Node name for add instance operation is not specified."
// *Cause: n/a
// *Action: Specify a node name for add instance operation.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NODE_FOR_INSTANCE_MGMT_IS_NULL_ERR
/-------------------------------------------------------------------------------
13058, 0,"Another instance with name (%s) already exists and is running for database (%s)."
// *Cause: n/a
// *Action: Specify a different instance name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INSTANCE_EXISTS_ALREADY_ERR
/-------------------------------------------------------------------------------
13059, 0,"Instance (%s) is disabled. To delete an instance, it should be enabled in the clusterware resource. DBCA will enable the instance first and then attempt to delete it."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INSTANCE_NOT_ENABLED_WARN
/-------------------------------------------------------------------------------
13101, 0,"Node specified for add instance operation (%s) is Leaf node."
// *Cause: n/a
// *Action: Specify only Hub nodes for add instance operation.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.LEAF_NODE_NOT_ALLOWED_FOR_ADD_INSTANCE_ERR
/-------------------------------------------------------------------------------
13102, 0,"The node specified for add instance (%s) is not part of cluster."
// *Cause: n/a
// *Action: Specify a node that is part of cluster to perform add instance operation.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NODE_NOT_PART_OF_CLUSTER_ERR
/-------------------------------------------------------------------------------
13103, 0,"Using Automatic Memory Management requires %sMB. The current available space is only %sMB on node %s."
// *Cause: n/a
// *Action: If you want to use Automatic Memory Management you should either free up some space in /dev/shm or reduce the memory allocated to Oracle database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_ENOUGH_SHM_MEMORY_WARN
/-------------------------------------------------------------------------------
13104, 0,"Existing datafile or SPFile is not in a shared location."
// *Cause: n/a
// *Action: Update %s location to shared location.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DATAFILES_SPFILE_NOT_SHARED_ERR
/-------------------------------------------------------------------------------
13901, 0,"Unable to create database from the selected template."
// *Cause: Selected template indicates that it was created from a database which had archive log mode enabled.
// *Action: Specify a template which was created from a database without archive log mode option to perform this operation.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ARCHIVE_LOG_NOT_SUPPORTED_FOR_RENAME_ERR
/-------------------------------------------------------------------------------
13902, 0,"Selected template cannot be used for this operation."
// *Cause: Specify a clone template to perform this operation.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_CLONE_TMPL_ERR
/-------------------------------------------------------------------------------
14001, 0,"No server pool is selected for database creation."
// *Cause: n/a
// *Action: Select at least one existing server pool for database creation.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_SERVERPOOL_SELECTED_ERR
/-------------------------------------------------------------------------------
14002, 0,"Validation of server pool (%s) failed."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.VALIDATION_OF_SERVERPOOL_FAILED_ERR
/-------------------------------------------------------------------------------
14003, 0,"Local node is not a member of server pool (%s)."
// *Cause: Local node should be member of server pool to create a Single Instance Policy Managed database.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.LOCAL_NODE_NOT_ASSIGNED_TO_SERVERPOOL_ERR
/-------------------------------------------------------------------------------
14004, 0,"The selected server pool (%s) does not exist."
// *Cause: n/a
// *Action: Select an existing server pool.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SERVER_POOL_DOES_NOT_EXIST_ERR
/-------------------------------------------------------------------------------
14005, 0,"A server pool by name (%s) already exists."
// *Cause: n/a
// *Action: Specify a new server pool name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SERVER_POOL_ALREADY_EXISTS_ERR
/-------------------------------------------------------------------------------
14006, 0,"No server is available to create a server pool."
// *Cause: n/a
// *Action: Select an existing server pool or create a new server pool.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_SERVER_AVAILABLE_FOR_SERVERPOOL_CREATION_ERR
/-------------------------------------------------------------------------------
14007, 0,"No server is available to create a Parallel Query server pool."
// *Cause: n/a
// *Action: Select an existing Parallel Query server pool or create a new server pool.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_SERVER_AVAILABLE_FOR_PQSERVERPOOL_CREATION_ERR
/-------------------------------------------------------------------------------
14008, 0,"The current user does not have CRS admin role."
// *Cause: CRS admin role is required to create a new server pool.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.CRSADMIN_ROLE_NOT_PRESENT_FOR_SERVERPOOL_CREATION_ERR
/-------------------------------------------------------------------------------
14009, 0,"Not enough servers are available to allocate to server pool."
// *Cause: n/a
// *Action: Modify the cardinality specified or allocate more servers to the free server pool.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_ENOUGH_SERVERS_AVAILABLE_FOR_ALLOCATION_WARN
/-------------------------------------------------------------------------------
14010, 0,"Server pool name cannot contain a space."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SERVER_POOL_SPACE_IN_NAME_ERR
/-------------------------------------------------------------------------------
14011, 0,"Server pool name specified is not valid."
// *Cause: The server pool name must include only alphabetical characters, numbers or the _, #, . or $ characters.
// *Action: Specify a valid server pool name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_CHARS_IN_SERVER_POOL_NAME_ERR
/-------------------------------------------------------------------------------
14012, 0,"Server pool name cannot start with a . or contain single quotes."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_START_CHARS_IN_SERVER_POOL_NAME_ERR
/-------------------------------------------------------------------------------
14013, 0,"Server pool name cannot be Free or Generic."
// *Cause: n/a
// *Action: Specify a different server pool name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_SERVER_POOL_NAME_ERR
/-------------------------------------------------------------------------------
14014, 0,"Server pool name cannot exceed %s characters."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SERVER_POOL_NAME_TOO_LONG_ERR
/-------------------------------------------------------------------------------
14015, 0,"Not enough servers are available to allocate to Parallel Query server pool."
// *Cause: n/a
// *Action: Modify the cardinality specified or allocate more servers to the free server pool.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_ENOUGH_SERVERS_AVAILABLE_FOR_PQSERVERPOOL_ALLOCATION_WARN
/-------------------------------------------------------------------------------
14016, 0,"Specified cardinality (%s) cannot be less than one."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.CARDINALITY_LESS_THAN_ONE_ERR
/-------------------------------------------------------------------------------
14017, 0,"No Hub category server pool selected."
// *Cause: n/a
// *Action: Select at least one Hub category server pool.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ATLEAST_ONE_HUB_CATEGORY_POOL_SHOULD_BE_SELECTED_ERR
/-------------------------------------------------------------------------------
14018, 0,"Server pool (%s) cannot be created on this Grid Infrastructure environment."
// *Cause: Parallel Query/Reader Farm server pool can be created only on Flex cluster environment.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PQSERVERPOOL_CREATION_NOT_SUPPORTED_ON_NON_FLEX_CLUSTER_ERR
/-------------------------------------------------------------------------------
14019, 0,"Same server pool names (%s) are specified to create different types of server pools."
// *Cause: Specify different server pool names for each type of server pool.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SAME_SERVERPOOL_NAMES_USED_FOR_PQPOOL_AND_NORMAL_SERVERPOOL_CREATION_ERR
/-------------------------------------------------------------------------------
14020, 0,"Parallel Query server pool (%s) is not supported on Oracle RAC One Node database."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PQSERVERPOOL_NOT_SUPPORTED_ON_RACONE_ERR
/-------------------------------------------------------------------------------
14021, 0,"New server pool creation cannot be done as a part of Single Instance Policy Managed database creation."
// *Cause: n/a
// *Action: Provide an existing server pool which has the local node member in order to create a Single Instance Policy Managed database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_NEW_SERVER_POOL_FOR_SI_POLICY_DB_ERR
/-------------------------------------------------------------------------------
14101, 0,"The local node (%s) should be a part of node list for database creation."
// *Cause: n/a
// *Action: Specify local node in the node list.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.LOCAL_NODE_NOT_IN_NODELIST_ERR
/-------------------------------------------------------------------------------
14102, 0,"Admin Managed database cannot be created on Leaf nodes."
// *Cause: The node(s) (%s) are Leaf nodes.
// *Action: Specify only Hub nodes to create Admin Managed database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ADMIN_MANAGED_DB_NODE_CANNOT_BE_LEAF_ERR
/-------------------------------------------------------------------------------
14103, 0,"Node list where database has to be created cannot be empty."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NODELIST_EMPTY_ERR
/-------------------------------------------------------------------------------
14104, 0,"Some of the nodes (%s) are not accessible."
// *Cause: n/a
// *Action: Ensure that all the nodes specified for database creation are accessible.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_ALL_NODES_ARE_ACCESSIBLE_ERR
/-------------------------------------------------------------------------------
14105, 0,"The specified node(s) (%s) is not configured with Oracle Grid Infrastructure."
// *Cause: RAC database creation can only be done on nodes that are configured with Oracle Grid Infrastructure.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SELECTED_NODE_NOT_CRS_CONFIGURED_ERR
/-------------------------------------------------------------------------------
14106, 0,"The local node is already part of an existing server pool (%s) that is hosting Policy Managed databases."
// *Cause: n/a
// *Action: Release the local node from the '%s' server pool.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.LOCAL_NODE_PART_OF_SERVER_POOL_ERR
/-------------------------------------------------------------------------------
14107, 0,"The configuration you selected cannot support failover of the Oracle RAC One Node instance."
// *Cause: Failover is not supported when less than two nodes are selected and grid is installed on more than one node.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RACONE_FAILOVER_WARN
/-------------------------------------------------------------------------------
14201, 0,"Archive log mode is not enabled in the source database."
// *Cause: Source database should be configured with archive log mode to perform the operation.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_SOURCE_DB_NOT_IN_ARCHIVELOG_MODE_ERR
/-------------------------------------------------------------------------------
14202, 0,"Specified source database is not a Single Instance (SI) database."
// *Cause: Snapshot database creation is supported only for SI databases.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_SOURCE_DB_RAC_ERR
/-------------------------------------------------------------------------------
14203, 0,"Specified source database is a container database (CDB)."
// *Cause: Snapshot database creation is supported only for non container databases.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_SOURCE_DB_CDB_ERR
/-------------------------------------------------------------------------------
14204, 0,"Unable to detect ACFS mount point path."
// *Cause: Failed to detect the ACFS mount point path from the datafile location.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_NOT_ACFS_MOUNTPOINT_ERR
/-------------------------------------------------------------------------------
14205, 0,"Source database is not using ASM Cluster File System (ACFS) location for database files."
// *Cause: Database files should be on ACFS location to perform this operation.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_SOURCEDB_DATAFILES_NOT_ACFS_MOUNTPOINT_ERR
/-------------------------------------------------------------------------------
14206, 0,"Specified template (%s) is not a snapshot template."
// *Cause: n/a
// *Action: Specify a valid snapshot template.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NOT_SNAPSHOT_TEMPLATE_ERR
/-------------------------------------------------------------------------------
14207, 0,"Source database recovery information is not available in the specified template (%s)."
// *Cause: Archive logs information is not available in the template (%s).
// *Action: Specify a valid snapshot template.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_SRCDB_RECOVERY_INFO_NOT_AVAILABLE_ERR
/-------------------------------------------------------------------------------
14208, 0,"Archive logs information is not available in the specified template (%s)."
// *Cause: At least one archive log is necessary to recover the database.
// *Action: Specify a valid snapshot template.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_SRCDB_ARCHIVE_LOGS_INFO_NOT_AVAILABLE_ERR
/-------------------------------------------------------------------------------
14209, 0,"Archive log (%s) is not available in the location."
// *Cause: Archive log (%s) might be deleted or moved from the specified location.
// *Action: Verify the archive log existence.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_SRCDB_ARCHIVE_LOGS_NOT_EXISTS_ERR
/-------------------------------------------------------------------------------
14210, 0,"Last SCN information of the source database is not available in the specified template (%s)."
// *Cause: SCN information is required to recover the database.
// *Action: Specify a valid snapshot template.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_RECOVERY_SCN_NOT_AVAILABLE_ERR
/-------------------------------------------------------------------------------
14211, 0,"Source database is not using ASM Cluster File System (ACFS) for Fast Recovery Area location."
// *Cause: Fast Recovery Area location should be on ASM Cluster File System (ACFS) to perform this operation.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_SOURCEDB_FRA_LOC_NOT_ACFS_MOUNTPOINT_ERR
/-------------------------------------------------------------------------------
14212, 0,"Oracle Database Vault (DV) is configured in the source database."
// *Cause: Source database configured with Oracle Database Vault (DV) option is not supported for creating Snapshot database/template.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_SOURCEDB_DVOPTION_CONFIGURED_ERR
/-------------------------------------------------------------------------------
14213, 0,"Source database datafile (%s) is not available in the location."
// *Cause: Source database datafile (%s) might have been deleted or moved from the specified location.
// *Action: Verify the database datafile existence.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SNAPSHOT_SRCDB_DATAFILES_NOT_EXISTS_ERR
/-------------------------------------------------------------------------------
14301, 0,"Specified Oracle R home location does not exist."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ORACLE_R_HOME_NOT_EXIST_ERR
/-------------------------------------------------------------------------------
14302, 0,"The specified Oracle R user name (%s) is invalid."
// *Cause: User name can contain only alphanumeric characters and underscore (_), dollar sign ($), or pound sign (#), and should not start with C##.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ORACLE_R_USER_INVALID_ERR
/-------------------------------------------------------------------------------
14303, 0,"Oracle R is already configured in the selected pluggable database (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ORACLE_R_ALREADY_CONFIGURED_IN_PDB_ERR
/-------------------------------------------------------------------------------
14304, 0,"Oracle R is already configured in the selected database (%s)."
// *Cause: n/a
// *Action: For Container databases, configure Oracle R in the individual pluggable databases of the selected database if required.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ORACLE_R_ALREADY_CONFIGURED_IN_DB_ERR
/-------------------------------------------------------------------------------
14305, 0,"The Oracle R user is one of (%s). Oracle R configuration cannot be performed with these users."
// *Cause: n/a
// *Action: Provide a valid Oracle R user.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_ORACLE_R_USER_ERR
/-------------------------------------------------------------------------------
14306, 0,"Unable to check if Oracle R is configured in the database (%s)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.UNABLE_TO_CHECK_ORACLE_R_CONFIG_ERR
/-------------------------------------------------------------------------------
14307, 0,"Oracle R is not supported on your current operating system."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ORACLE_R_FEATURE_NOT_SUPPORTED_ERR
/-------------------------------------------------------------------------------
14501, 0,"The version of the Oracle Grid Infrastructure for Standalone Server software is lower than database software version. Created database will not be registered with Oracle Grid Infrastructure."
// *Cause: n/a
// *Action: Upgrade the version of the Grid Infrastructure software to register the database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.HA_VERSION_INCOMPATIBLE_WARN
/-------------------------------------------------------------------------------
14502, 0,"Oracle Restart is not running in Grid Infrastructure home. Created database will not be registered with Oracle Grid Infrastructure."
// *Cause: n/a
// *Action: Startup the Oracle Restart in the Grid Infrastructure home.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.HA_NOT_RUNNING_WARN
/-------------------------------------------------------------------------------
14503, 0,"The version of Oracle Grid Infrastructure software (%s) is lower than the version of the RAC database software."
// *Cause: n/a
// *Action: Upgrade Oracle Grid Infrastructure to version (%s) or later before proceeding.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.CRS_VERSION_NOT_MATCH_ERR
/-------------------------------------------------------------------------------
14504, 0,"Oracle Grid Infrastructure is installed on nodes (%s) but Oracle RAC software is found only on nodes (%s)."
// *Cause: n/a
// *Action: It is recommended to have Oracle RAC software installed on all nodes where Oracle Grid Infrastructure is installed for policy managed database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RAC_SOFTWARE_NOT_ON_ALL_GI_NODES_ERR
/-------------------------------------------------------------------------------
14505, 0,"Oracle RAC software is not present on nodes (%s) selected for configuration."
// *Cause: n/a
// *Action: Install Oracle RAC software on all the selected nodes before doing database configuration.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RAC_SOFTWARE_NOT_ON_NODES_PROVIDED_ERR
/-------------------------------------------------------------------------------
14506, 0,"Unable to detect the version of Oracle Infrastructure software."
// *Cause: n/a
// *Action: Verify the status of Oracle Grid Infrastructure and make sure that its running on this system.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.UNABLE_TO_DETECT_CRS_VERSION_ERR
/-------------------------------------------------------------------------------
14507, 0,"SCAN listener does not exist."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SCAN_LSNR_NOT_EXIST_ERR
/-------------------------------------------------------------------------------
14508, 0,"SCAN listener is not running."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SCAN_LSNR_NOT_RUNNING_ERR
/-------------------------------------------------------------------------------
14509, 0,"The Oracle home users of the source home (%s) and target home (%s) do not match"
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OH_USERS_NOT_MATCH_ERR
/-------------------------------------------------------------------------------
14510, 0,"The Real Application Cluster (RAC) database creation is not supported  in the Standard Edition home."
// *Cause: RAC database creation is supported only in the enterprise edition home.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RAC_NOT_SUPPORTED_IN_SE_ERR
/-------------------------------------------------------------------------------
15001, 0,"The specified pdb archive file (%s) is not valid."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INCORRECT_PDB_ARCHIVE_FILE_ERR
/-------------------------------------------------------------------------------
15002, 0,"The specified metadata file (%s) is not valid."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INCORRECT_PDB_METADATA_ERR
/-------------------------------------------------------------------------------
15003, 0,"PDB with name (%s) already exists in the container database."
// *Cause: n/a
// *Action: Specify a different PDB name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_NAME_ALREADY_EXISTS_ERR
/-------------------------------------------------------------------------------
15004, 0,"The specified PDB Admin user name (%s) is invalid."
// *Cause: User name can contain only alphanumeric characters and underscore (_), dollar sign ($), or pound sign (#), and should not start with C##.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.INVALID_PDB_ADMIN_USER_ERR
/-------------------------------------------------------------------------------
15005, 0,"PDB requires (%s) datafiles to be created. Maximum number of data files specified in initialization parameter db_files (%s) exceeded for the Container database."
// *Cause: n/a
// *Action: Increase the value of initialization parameter db_files in the container database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_MAX_DATAFILES_COUNT_EXCEEDED_ERR
/-------------------------------------------------------------------------------
15006, 0,"PDB datafiles location (%s) is not empty. It is recommended to have an empty directory for PDB datafiles."
// *Cause: n/a
// *Action: Specify a different location for storing PDB datafiles.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_DATAFILE_LOC_NOT_EMPTY_WARN
/-------------------------------------------------------------------------------
15007, 0,"Work area location cannot be null or empty."
// *Cause: n/a
// *Action: Specify an existing work area location to unzip the pdb archive file.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.WORK_AREA_NOT_PROVIDED_ERR
/-------------------------------------------------------------------------------
15008, 0,"The specified work area location (%s) is on ASM."
// *Cause: n/a
// *Action: Specify an existing file system location for work area.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.WORK_AREA_ON_ASM_ERR
/-------------------------------------------------------------------------------
15009, 0,"The specified work area location (%s) does not exist."
// *Cause: n/a
// *Action: Specify an existing location for work area.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.WORK_AREA_NOT_EXISTING_ERR
/-------------------------------------------------------------------------------
15010, 0,"The selected PDB (%s) has tablespaces with different block sizes."
// *Cause: Unplugging PDB using file set option is not supported for tablespaces having different block sizes.
// *Action: Select a different PDB.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_WITH_DIFF_BLOCK_SIZE_ERR
/-------------------------------------------------------------------------------
15011, 0,"Selected PDB (%s) has one or more datafiles on ASM."
// *Cause: Unplugging PDB using PDB Archive option is not supported for PDB with datafiles on ASM.
// *Action: Select a different PDB.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_ON_ASM_ERR
/-------------------------------------------------------------------------------
15012, 0,"(%s) is not a valid file name."
// *Cause: n/a
// *Action: Specify a new file name under an existing directory location.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_FILE_SPECIFIED_IS_DIR_ERR
/-------------------------------------------------------------------------------
15013, 0,"The file (%s) already exists in the same location."
// *Cause: n/a
// *Action: Specify a non existing file for %s.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_FILE_EXISTS_ERR
/-------------------------------------------------------------------------------
15014, 0,"The parent directory specified for %s (%s) does not exist."
// *Cause: n/a
// *Action: Specify an existing directory location for %s.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_PARENT_FILE_NOT_EXISTS_ERR
/-------------------------------------------------------------------------------
15015, 0,"A user with name (%s) already exists in the database."
// *Cause: n/a
// *Action: Specify a non existing PDB admin user.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_ADMIN_USER_NOT_UNIQUE_ERR
/-------------------------------------------------------------------------------
15016, 0,"Specified PDB metadata file is not compatible to create a PDB in the selected CDB. This might impact the PDB creation process and PDB might be in mount mode at the end of this operation."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_INCOMPATIBLE_WARN
/-------------------------------------------------------------------------------
15017, 0,"PDB Source type is not specified."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_SOURCE_TYPE_NULL_ERR
/-------------------------------------------------------------------------------
15018, 0,"Specified PDB is of a higher version (%s) than the selected Container database (%s)."
// *Cause: PDB version should be lesser than or equal to the Container database version.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_XML_VERSION_INCOMPATIBLE_ERR
/-------------------------------------------------------------------------------
15019, 0,"Incompatible location type for PDB creation."
// *Cause: Selected container database is configured with OMF, hence PDB will be placed in the same OMF location.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_INCOMPATIBLE_LOCATION_TYPE_WARN
/-------------------------------------------------------------------------------
15020, 0,"Invalid PDB backup data file."
// *Cause: n/a
// *Action: Specify an existing PDB backup data file.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_BACKUP_FILE_NOT_EXIST_ERR
/-------------------------------------------------------------------------------
15021, 0,"Invalid PDB backup data file."
// *Cause: PDB backup data file %s cannot be read.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_BACKUP_FILE_CANNOT_BE_READ_ERR
/-------------------------------------------------------------------------------
15022, 0,"PDB datafiles destination locations are not specified for the copyPDBFiles option."
// *Cause: n/a
// *Action: Specify PDB datafiles destination location using fileNameConvert command line option.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.FILE_NAME_CONVERT_NOT_SPECIFIED_ERR
/-------------------------------------------------------------------------------
15023, 0,"Database files are found in PDB datafiles location (%s)."
// *Cause: The directory for PDB datafiles is not empty.
// *Action: Specify a different location for storing PDB datafiles.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_DATAFILE_LOC_IN_USE_ERR
/-------------------------------------------------------------------------------
15024, 0,"There is an already existing PDB (%s) with the same PDB identifier of the specified PDB backup."
// *Cause: You have selected to plug a PDB using PDB backup without clone option. But, there is an alredy existing PDB (%s) with the same PDB identifier as the specified PDB backup.
// *Action: Either select clone option to create new PDB or specify different PDB backup.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_WITH_SAME_DBID_EXISTS_ERR
/-------------------------------------------------------------------------------
15025, 0,"Oracle Database Vault (DV) is not configured and enabled in the container database (%s)."
// *Cause: DV should be configured and enabled in the container database (%s) to perform DV configuration in the pluggable database (%s).
// *Action: Configure and enable DV in container database and try again.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DV_NOT_CONFIGURED_AND_ENFORCED_IN_DB_ERR
/-------------------------------------------------------------------------------
15026, 0,"Specified PDB metadata file is not compatible to create a PDB in the selected CDB."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_INCOMPATIBLE_ERR
/-------------------------------------------------------------------------------
15027, 0,"Selected ASM PDB datafile location (%s) does not exist."
// *Cause: It has been detected that ASM instance is not running on local node. PDB directory has to be present in the selected diskgroup when local ASM instance is not present.
// *Action: Create the direcotry (%s) on ASM diskgroup and retry the operation.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ASM_DIR_EXISTENCE_ERR
/-------------------------------------------------------------------------------
15028, 0,"Source PDB is not specified."
// *Cause: You have selected to create a PDB from another PDB but source PDB name is not specified.
// *Action: Specify a valid source PDB name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.SOURCE_PDB_NOT_SPECIFIED_ERR
/-------------------------------------------------------------------------------
15029, 0,"Performing operations on PDB$SEED is not allowed."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_SEED_OPERATION_NOT_ALLOWED
/-------------------------------------------------------------------------------
15030, 0,"The Pluggable database (%s) will be closed and opened in read only mode to perform the clone operation."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_RESTART_REQUIRED_WARN
/-------------------------------------------------------------------------------
16001, 0,"Database configuration operation cannot be performed."
// *Cause: Either no configuration update is specified for the database or specified options are already configured on the given database.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_CONFIG_MODIFICATION_ERR
/-------------------------------------------------------------------------------
16002, 0,"The database will be restarted in order to configure the chosen options."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_RESTART_REQUIRED_WARN
/-------------------------------------------------------------------------------
16003, 0,"Pluggable database configuration operation cannot be performed."
// *Cause: Either no configuration update is specified for the pluggable database or specified options are already configured on the given pluggable database.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_CONFIG_MODIFICATION_IN_PDB_ERR
/-------------------------------------------------------------------------------
16004, 0,"The %s command line argument is not valid for configuring a Pluggable database."
// *Cause: n/a
// *Action: Remove %s from the list of command line arguments.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ARGUMENT_NOT_ALLOWED_IN_PDB_CONFIG_ERR
/-------------------------------------------------------------------------------
16051, 0,"Archive log mode is not enabled in the primary database."
// *Cause: n/a
// *Action: Primary database should be configured with archive log mode for creating a duplicate or standby database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PRIMARY_DB_NOT_IN_ARCHIVELOG_MODE_ERR
/-------------------------------------------------------------------------------
16052, 0,"The value (%s) specified for the initialization parameter db_name is not same as primary database name (%s)."
// *Cause: In order to create standby database, the database name should be same as primary database. However, either the specified db_name initialization parameter or the first 8 character of the specified gdb name is not matching the primary database name.
// *Action: Specify a same value for db_name initialization parameter or update the GDB name value in such a way that first 8 characters of host name part of it is matching the primary database name.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.STANDBY_DB_NAME_NOT_SAME_AS_PRIMARY_DB_NAME_ERR
/-------------------------------------------------------------------------------
16053, 0,"Duplicate database location contains ASM location paths."
// *Cause: ASM is not configured on this system.
// *Action: Specify appropriate database location for duplicate database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.ASM_NOT_CONFIGURED_ON_DUPLICATE_TARGET_ERR
/-------------------------------------------------------------------------------
16054, 0,"The datafile location (%s) used for duplicate database creation is not empty."
// *Cause: n/a
// *Action: Specify valid empty directory for datafile location.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DUPLICATE_DB_LOCATION_ALREADY_CONTAINS_DATAFILE_ERR
/-------------------------------------------------------------------------------
16055, 0,"The control file (%s) used for duplicate database already exists."
// *Cause: n/a
// *Action: Specify a valid control file location. Ensure that valid datafile location or Fast Recovery Area location is specified.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DUPLICATE_DB_LOCATION_ALREADY_CONTAINS_CONTROLFILE_ERR
/-------------------------------------------------------------------------------
16056, 0,"Specified primary database is not a Single Instance (SI) database."
// *Cause: Duplicate database operation is supported only for SI databases.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PRIMARY_DB_RAC_ERR
/-------------------------------------------------------------------------------
16057, 0,"Specified primary database is a container database (CDB)."
// *Cause: Duplicate database operation is supported only for non container databases.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PRIMARY_CDB_ERR
/-------------------------------------------------------------------------------
16058, 0,"Database configuration type is not specified."
// *Cause: One of the configuration types SI, RAC, or RAC One Node must be specified.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_CONFIG_TYPE_REQUIRED_ERR
/-------------------------------------------------------------------------------
16059, 0,"Database deployment type is not specified."
// *Cause: One of the deployment types Admin Managed or Policy Managed must be specified.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_DEPLOYMENT_TYPE_REQUIRED_ERR
/-------------------------------------------------------------------------------
17001, 0,"You have chosen to ignore some of the prerequisites for this DBCA operation. This may impact DBCA operation."
// *Cause: n/a
// *Action: Ensure that the failed prerequisites are fixed before proceeding.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.USER_IGNORED_PREREQ_WARNING
/-------------------------------------------------------------------------------
18001, 0,"Database requires %s datafiles to be created. However the value specified for initialization parameter db_files (%s) is lower than the required value."
// *Cause: The initialization parameter db_files represents the maximum number of datafiles that can be created on this database, but the specified value for this initialization parameter is lower than the number of datafiles to be created for this database.
// *Action: Increase the value of initialization parameter db_files in the database.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.EXCEEDED_MAX_NUMBER_OF_DATAFILES_ERR
/-------------------------------------------------------------------------------
18002, 0,"This database will result into approximately %s datafiles to be created, which exceeds the default value of initialization parameter db_files (%s). The value of db_files will be set to %s."
// *Cause: The initialization parameter db_files represents the maximum number of datafiles that can be created on this database. Based on the inputs provided, the expected number of datafiles that will get created will exceed the default value of db_files.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.EXCEEDED_DEFAULT_NUMBER_OF_DATAFILES_WARN
/-------------------------------------------------------------------------------
19001, 0,"Move database files configuration cannot be performed along with other configuration options."
// *Cause: n/a
// *Action: Specify move database files option without remaining configuration options
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OTHER_CONFIG_OPTIONS_SPECIFIED_ERR
/-------------------------------------------------------------------------------
19002, 0,"Move database files cannot do configuration of Fast Recovery Area."
// *Cause: Fast Recovery Area is not enabled in the source database. Move database files operation cannot do fresh configuration of recovery files.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.FRA_NOT_CONFIGURED_IN_SOURCE_DB_ERR
/-------------------------------------------------------------------------------
19003, 0,"Oracle Managed Files (OMF) option cannot be set to false."
// *Cause: OMF option is enabled in source databse. Move database files operation cannot disable the OMF option.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.OMF_CONFIGURED_IN_SOURCE_DB_ERR
/-------------------------------------------------------------------------------
19004, 0,"Oracle Database Vault (DV) is configured in the source database."
// *Cause: Source database configured with Oracle Database Vault (DV) option is not supported for moving database files.
// *Action: Disable Oracle Database Vault (DV) in the source database before moving database files.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.MOVEDB_DV_ENABLED_ERR
/-------------------------------------------------------------------------------
19101, 0,"The specified single instance database (%s) is a member of a Data Guard configuration that has fast-start failover enabled."
// *Cause: n/a
// *Action: Fast-start failover must be disabled in before converting database to RAC.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.FAILOVER_STATUS_ENABLED_ERR
/-------------------------------------------------------------------------------
19102, 0,"The specified single instance database (%s) is a member of a Data Guard configuration that has maximum protection mode enabled."
// *Cause: n/a
// *Action: Maximum protection mode must be disabled before converting database to RAC.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.MAX_PROTECTION_ENABLED_ERR
/-------------------------------------------------------------------------------
19103, 0,"Source Oracle home version %s and target Oracle home version %s are different."
// *Cause: RAC Conversion of single instance database is possible only when the versions are same.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.VERSION_MISMATCH_BETWEEN_SRC_AND_TARGET_HOME_ERR
/-------------------------------------------------------------------------------
19104, 0,"PDBSettings backup cloning failed."
// *Cause: n/a
// *Action: Refer log file for more details.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.PDB_SETTINGS_BACKUP_CLONE_FAILED_WARN
/-------------------------------------------------------------------------------
19201, 0,"This operation will delete template file %s along with database backup files associated with it."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DELETE_TEMPLATE_WARN
/-------------------------------------------------------------------------------
19202, 0,"The Database Configuration Assistant will delete the Oracle instances and datafiles for your database. All information in the database will be destroyed."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DELETE_DATABASE_WARN
/-------------------------------------------------------------------------------
19203, 0,"The Database Configuration Assistant will delete the Oracle instance and its associated OFA directory structure. All information about this instance will be deleted.
//         %s"
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DELETE_INSTANCE_WARN
/-------------------------------------------------------------------------------
19301, 0,"Update DB Files Locations with new database name has failed."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RENAME_DB_UPDATE_DATAFILE_STEP_FAILED
/-------------------------------------------------------------------------------
19302, 0,"Update DB entries for new database name has failed."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.RENAME_DB_UPDATE_DB_ENTRY_STEP_FAILED
/-------------------------------------------------------------------------------
19401, 0,"Archive log mode is not enabled in the (%s) database."
// *Cause: (%s) database should be configured with archive log mode to perform the operation.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_NOT_IN_ARCHIVELOG_MODE_ERR
/-------------------------------------------------------------------------------
19402, 0,"Local undo mode is not enabled in the (%s) container database."
// *Cause: Local undo mode should be enabled in the (%s) container database to perform the operation.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_LOCAL_UNDO_NOT_ENABLED_ERR
/-------------------------------------------------------------------------------
19403, 0,"(%s) user does not have (%s) privilege in the remote container database."
// *Cause: n/a
// *Action: Specify user with (%s) privilege in the remote container database to perform the operation.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.NO_PRIVILEGE_FOR_USER_ON_REMOTE_DB_ERR
/-------------------------------------------------------------------------------
19404, 0,"Specified database link user (%s) does not exist in the database(%s)."
// *Cause: n/a
// *Action: Specify an existing database link user.
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DBLINK_USER_NOT_EXIST_ERR
/-------------------------------------------------------------------------------
19405, 0,"Database link (%s) is already exists."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DBLINK_EXIST_ERR
/-------------------------------------------------------------------------------
19406, 0,"Local CDB(%s) and Remote CDB(%s) APEX option are different."
// *Cause: Local CDB(%s) has APEX option enabled (%s) and Remote CDB(%s) has APEX option enabled (%s).
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.APEX_OPTIONS_MISMATCH_ERR
/-------------------------------------------------------------------------------
19407, 0,"Database option (%s) is not installed in Local CDB (%s)."
// *Cause: The database options installed on the Remote CDB(%s) must be the same as the database options installed on the Local CDB(%s).
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_OPTIONS_MISMATCH_ERR
/-------------------------------------------------------------------------------
19408, 0,"Incompatible location type for PDB operation. Pluggable database operation cannot be performed."
// *Cause: Remote CDB(%s) is configured with Oracle Managed Files (OMF) option. Local CDB(%s) is not configured with OMF option.
// *Action: n/a
// *FQN: oracle.assistants.dbca.resource.DBCAErrorCode.DB_OMF_TO_NONOMF_NOTSUPPORTED_ERR
/-------------------------------------------------------------------------------
20001, 0,"Select a database to upgrade or move."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.DATABASE_NOT_SELECTED_ERR
/-------------------------------------------------------------------------------
20002, 0,"There are no databases detected on the system."
// *Cause: DBUA relies on oratab entries and Oracle Grid Infrastrcuture software as its source for for detecting Oracle Single Instance and RAC databases. It did not detect any Oracle database configured on the system from these sources.
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_EMPTY_CACHE_ERR
/-------------------------------------------------------------------------------
20003, 0,"Specified database %s is not detected on the system."
// *Cause: DBUA relies on oratab entries and Oracle Grid Infrastrcuture software as its source for for detecting Oracle Single Instance and RAC databases. It did not detect the specified database configured on the system from these sources.
// *Action: Verify that the dbname or SID of the selected database is correct.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_SID_NOT_FOUND_IN_CACHE_ERR
/-------------------------------------------------------------------------------
20004, 0,"OS authentication is disabled. Specify the corresponding SYSDBA credentials."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_SYSDBA_CREDENTIALS_REQD_ERR
/-------------------------------------------------------------------------------
20005, 0,"The SYSDBA username and password are not specified. Verify and try again."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_SYSDBA_INCOMPLETE_CREDENTIALS_REQD_ERR
/-------------------------------------------------------------------------------
20006, 0,"The specified user %s does not have SYSDBA privilegies to perform the selected operation."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_SYSDBA_PRIVILEGIES_REQD_ERR
/-------------------------------------------------------------------------------
20007, 0,"Specified SYSDBA credentials are not correct. Specify the correct SYSDBA credentials and try again."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_SYSDBA_CREDS_VALID_ERR
/-------------------------------------------------------------------------------
20008, 0,"There is no database instance running on the local node."
// *Cause: There was no local instance running for the selected database on the current system.
// *Action: Ensure that there is an instance configured on the local node or start DBUA on the node where local instance is running.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_LOCAL_INSTANCE_REQD_ERR
/-------------------------------------------------------------------------------
20009, 0,"Specified database %s is not running. DBUA started the database for information loading and to perform the required validations."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_NOT_RUNNING_WARN
/-------------------------------------------------------------------------------
20010, 0,"Specified database %s could not be started."
// *Cause: n/a
// *Action: Start the database manually and try again.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_NOT_STARTING_UP_ERR
/-------------------------------------------------------------------------------
20011, 0,"Oracle home %s is not enabled with RAC option."
// *Cause: n/a
// *Action: Launch DBUA from an Oracle home that has the RAC option enabled.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_RAC_NOT_ENABLED_ERR
/-------------------------------------------------------------------------------
20012, 0,"A RAC enabled database in Oracle home %s was selected. However, it was detected that the Oracle Grid Infrastructure is not currently running. Start the Oracle Grid Infrastructure and try again."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_CRS_NOT_RUNNING_ERR
/-------------------------------------------------------------------------------
20013, 0,"The selected database version %s is higher than the Oracle home version %s."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_HIGHER_VER_ERR
/-------------------------------------------------------------------------------
20014, 0,"A direct upgrade of %s database to Oracle Database release %s is not supported."
// *Cause: DBUA has detected that the version of the selected database is lower than the supported versions for upgrade. 
//         Following are the supported database versions for upgrade: %s.
// *Action: Upgrade the database to one of the supported versions for upgrade, and then upgrade to %s version.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_NOT_SUPPORTED_VER_ERR
/-------------------------------------------------------------------------------
20015, 0,"The version of the selected database could not be determined."
// *Cause: n/a
// *Action: Verify and/or start the database manually.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_UNKNOWN_VER_ERR
/-------------------------------------------------------------------------------
20016, 0,"The selected database cannot be upgraded as it is already running at %s version."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_NOT_SELECTABLE_ERR
/-------------------------------------------------------------------------------
20017, 0,"The database %s is not in a READ/WRITE open mode."
// *Cause: n/a
// *Action: Open the database in READ/WRITE mode and try again.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_NOT_OPENED_ERR
/-------------------------------------------------------------------------------
20018, 0,"The version of Oracle Grid Infrastructure software (%s) is lower than required (%s)."
// *Cause: DBUA has detected that the Oracle Grid Infrastructure version is lower than the selected database version.
// *Action: Upgrade the Grid Infrastructure and try again.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_CRS_VERSION_MISMATCH_ERR
/-------------------------------------------------------------------------------
20019, 0,"The version of Oracle Grid Infrastructure software (%s) is lower than required (%s). Oracle High Availability service registration will be skipped."
// *Cause: n/a
// *Action: Upgrade the Grid Infrastructure and try again if you need the selected database to be registered to the Oracle High Availability service.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_CRS_VERSION_MISMATCH_WARN
/-------------------------------------------------------------------------------
20020, 0,"The PDB seed of the database %s could not be opened in a valid mode."
// *Cause: DBUA was not able to open the PDB seed on the selected database.
// *Action: Verify and/or start the PDB seed manually.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_PDBSEED_NOT_OPENED_ERR
/-------------------------------------------------------------------------------
20021, 0,"The current Oracle home %s does not have the required %s licence to perform the %s operation."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_EDITIONS_NOT_COMPATIBLE_ERR
/-------------------------------------------------------------------------------
20022, 0,"The specified database uses disk group(s) %s that have access control enabled."
// *Cause: When the access control parameter is enabled, the database wont be able to access its files within the mentioned diskgroup(s) after the upgrade.
// *Action: Disable the access control parameter on the ASM instance as a privileged user and try again. Once the database upgrade finishes you can re-enable the access control parameter on the mentioned diskgroups.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.DISKGROUPS_ACL_ENABLED_ERR
/-------------------------------------------------------------------------------
20023, 0,"The software under Oracle home location %s is not configured on all the nodes of the selected database."
// *Cause: n/a
// *Action: Verify that the nodes configured for the Oracle home %s match the nodes configured for the selected database and try again.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_NODES_NOT_EQUIVALENT_WARN
/-------------------------------------------------------------------------------
20024, 0,"The local instance for the specified database %s could not be started."
// *Cause: n/a
// *Action: Start the local instance manually and try again.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_INSTANCE_NOT_STARTING_UP_ERR
/-------------------------------------------------------------------------------
20025, 0,"The version of one or more pluggable databases could not be detected to determine the upgrade status of the database."
// *Cause: DBUA was not able to open the detected pluggable databases to determine the version.
// *Action: Verify that there are no pluggable databases in MOUNT state and try again.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_UNKNOWN_PBD_VERSION_ERR
/-------------------------------------------------------------------------------
20026, 0,"This operation is not supported for Oracle Real Application Cluster databases on Standard Edition (SE)."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_DATABASE_SE2_RAC_NOT_SUPPORTED_ERR
/-------------------------------------------------------------------------------
20029, 0,"Partial selection of PDBs in a CDB for upgrade is not allowed. All PDBs in the CDB must be upgraded."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_PLUG_PDB_SELECTION_NOT_ALLOWED
/-------------------------------------------------------------------------------
20030, 0,"Selected PDB(s) %s are opened in restricted mode."
// *Cause: DBUA has detected PDB(s) that are open in RESTRICTED mode. This may cause issues during the upgrade.
// *Action: Open the PDB(s) %s in non RESTRICTED mode.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_PLUG_IN_RESTRICTED_MODE_WARN
/-------------------------------------------------------------------------------
20031, 0,"The selected PDB(s) %s are not part of the selected container database. Verify and try again."
// *Cause: DBUA was not able to detect the following PDB(s) %s in the selected container database.
// *Action: Verify the pluggable database selection and try again.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_PLUG_NOT_EXISTING_PDB_ERR
/-------------------------------------------------------------------------------
20032, 0,"The selected PDB(s) %s have already been upgraded or are in a newer version than the required one. Verify and try again."
// *Cause: DBUA has detected that the selected PDB(s) belong to a version equal or greater than the container database.
// *Action: Verify the pluggable database selection and try again.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_PLUG_UPGRADED_PDB_ERR
/-------------------------------------------------------------------------------
20033, 0,"There are no selected pluggable databases (PDB) for upgrade. Select at least one and try again."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_PLUG_NO_SELECTED_PDB_ERR
/-------------------------------------------------------------------------------
20034, 0,"The selected PDB(s) %s do not have a valid input as priority value."
// *Cause: The upgrade priority for pluggable databases must be in numeric format.
// *Action: Specify a valid numeric value as priority of the selected PDB(s).
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_PLUG_INVALID_PDB_PRIORITY_FORMAT_ERR
/-------------------------------------------------------------------------------
20035, 0,"The selected PDB(s) %s have an invalid upgrade priority value."
// *Cause: The upgrade priority value has to be within the allowed ranges[1-4096].
// *Action: Refer to Oracle documentation.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_PLUG_OUT_OF_RANGE_PDB_PRIORITY_ERR
/-------------------------------------------------------------------------------
20036, 0,"The selected PDB(s) %s are currently not plugged to the selected container. Verify and try again."
// *Cause: DBUA has detected that some PDB(s) are in UNPLUGGED state within the selected container database.
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_PLUG_PDBS_NOT_PLUGGED_ERR
/-------------------------------------------------------------------------------
20037, 0,"The selected PDB(s) %s are currently not opened. Verify and try again."
// *Cause: DBUA has detected that some PDB(s) are in MOUNTED state within the selected container database.
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_PLUG_PDBS_NOT_OPENED_ERR
/-------------------------------------------------------------------------------
20038, 0,"The selected PDB(s) %s are not in a required version for a Container Database (CDB) upgrade. Verify and try again."
// *Cause: DBUA has detected that some PDB(s) belong to a version that is not supported by the selected container database.
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_PLUG_PDBS_NOT_IN_SYNC_ERR
/-------------------------------------------------------------------------------
20039, 0,"The PDBs that are not selected will be in MIGRATE mode after the CDB gets upgraded, making them unavailable until they are upgraded."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_PLUG_PDBS_PENDING_WARN
/-------------------------------------------------------------------------------
20040, 0,"The password for Oracle home user cannot be empty."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.ORACLE_HOME_USER_PASSWORD_EMPTY_ERR
/-------------------------------------------------------------------------------
20041, 0,"Specified Oracle home user password is incorrect."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.ORACLE_HOME_USER_PASSWORD_INCORRECT_ERR
/-------------------------------------------------------------------------------
20050, 0,"Database upgrade is not supported from Oracle Home with Oracle Home User %s to an Oracle Home with Windows Built-In account."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.ORACLE_HOME_USER_TO_LOCAL_SYSTEM_ERR
/-------------------------------------------------------------------------------
20051, 0,"Database %s is not supported from Oracle Home with Oracle Home User %s to a Oracle Home with Oracle Home User %s."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.ORACLE_HOME_USERS_DIFFERENT_ERR
/-------------------------------------------------------------------------------
20052, 0,"Database %s is not supported from Oracle Home with Oracle Home User %s to an Oracle Home with Windows Virtual Account."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.ORACLE_HOME_USERS_TO_VIRTUAL_USER_ERR
/-------------------------------------------------------------------------------
20053, 0,"Database %s is not supported from Oracle Home with Windows Virtual Account to an Oracle Home with Oracle Home User %s."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.VIRTUAL_USER_TO_ORACLE_HOME_USER_ERR
/-------------------------------------------------------------------------------
20054, 0,"Database upgrade is not supported from Oracle Home with Windows Virtual Account to an Oracle Home with Windows Built-In account."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.VIRTUAL_USER_TO_LOCAL_SYSTEM_ERR
/-------------------------------------------------------------------------------
20055, 0,"Oracle Real Application Cluster Database upgrade is not supported from Oracle Home with non domain Oracle Home user %s."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.ORACLE_HOME_USER_IS_NOT_DOMAIN_USER_FOR_RAC
/-------------------------------------------------------------------------------
20060, 0,"One or more of the pre-upgrade checks on the database have resulted into warning conditions that require manual intervention. It is recommended that you address these warnings as suggested before proceeding."
// *Cause: n/a
// *Action: Refer to the pre-upgrade results location for details: %s
// *FQN: oracle.assistants.dbua.resource.ErrorCode.PREREQ_HAS_WARNINGS
/-------------------------------------------------------------------------------
20061, 0,"One or more of the pre-upgrade checks on the database have resulted into error conditions that must be addressed before proceeding."
// *Cause: n/a
// *Action: Refer to the pre-upgrade results location for details: %s
// *FQN: oracle.assistants.dbua.resource.ErrorCode.PREREQ_HAS_ERRORS
/-------------------------------------------------------------------------------
20062, 0,"One or more of the pre-upgrade checks on the database have resulted into error conditions that must be addressed before proceeding. It is not recommended to ignore them."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.PREREQ_IGNORED
/-------------------------------------------------------------------------------
20070, 0,"The specified custom script(s) do not exist: %s"
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.OPTIONS_CUSTOME_SCRIPT_ERR
/-------------------------------------------------------------------------------
20071, 0,"The Timezone upgrade will not be executed because the Timezone version of the %s Oracle Home could not be loaded."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.OPTIONS_TZ_UPGRADE_NOT_FEASIBLE_WARN
/-------------------------------------------------------------------------------
20072, 0,"In case that Timezone upgrade is desired, it is recommended to perform the recompilation of invalid objects as well."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.OPTIONS_TZ_UPGRADE_OBJ_RECOMPILE_DEPENDENCY_WARN
/-------------------------------------------------------------------------------
20080, 0,"There is no path specified for new RMAN backup."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_EMPTY_RMAN_PATH_ERR
/-------------------------------------------------------------------------------
20081, 0,"The specified RMAN backup path could not be created: %s"
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_NOT_ABLE_TO_CREATE_RMAN_PATH_ERR
/-------------------------------------------------------------------------------
20082, 0,"The specified RMAN backup path is not a valid directory: %s"
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_NOT_A_DIR_RMAN_PATH_ERR
/-------------------------------------------------------------------------------
20083, 0,"The specified RMAN backup path could not be set with the required permissions: %s"
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_NOT_WRITEABLE_RMAN_PATH_ERR
/-------------------------------------------------------------------------------
20084, 0,"The is no restore script specified for the existing RMAN backup."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_EMPTY_RMAN_SCRIPT_ERR
/-------------------------------------------------------------------------------
20085, 0,"Archive Log must be enabled in order to support GRP based backup."
// *Cause: DBUA has detected that the selected database is not in Archive Log mode which is required for a GRP-based backup.
// *Action: Enable the Archive Log mode on the selected database or select other recovery option available.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_NOT_GRP_CAPABLE_ERR
/-------------------------------------------------------------------------------
20086, 0,"The provided GRP for backup is invalid for the selected database."
// *Cause: DBUA has detected that the provided GRP is not available in the selected database.
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_INVALID_GRP_ERR
/-------------------------------------------------------------------------------
20087, 0,"The following warning was detected while checking the storage requirements for backup: %s"
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_STORAGE_WARN
/-------------------------------------------------------------------------------
20088, 0,"The following error was detected while checking the storage requirements for backup: %s"
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_STORAGE_ERR
/-------------------------------------------------------------------------------
20089, 0,"The following files from the latest RMAN backup are missing: %s"
// *Cause: DBUA has detected that there are some files corresponding to the selected RMAN backup that are not currently present on the system.
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_MISSING_RECOVERY_FILES_ERR
/-------------------------------------------------------------------------------
20090, 0,"There are no records for the files related to the latest RMAN backup."
// *Cause: DBUA has detected that there are no files currently associated to the selected RMAN backup.
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_NO_RECOVERY_FILES_ERR
/-------------------------------------------------------------------------------
20091, 0,"DBUA was not able to connect to the database to validate the files from the latest RMAN backup."
// *Cause: DBUA was not able to connect to the selected database to validate the files of the selected RMAN backup.
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_NO_DB_CONNECTION_FOR_RECOVERY_FILES_ERR
/-------------------------------------------------------------------------------
20092, 0,"The following error(s) were encountered during the validation of the backup set of the latest RMAN backup: %s."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_INVALID_RMAN_BACKUPSET_ERR
/-------------------------------------------------------------------------------
20093, 0,"There are no records of an existing backup set related to the latest RMAN backup."
// *Cause: DBUA has detected that there are no RMAN backup records corresponding to the latest timestamp.
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_NO_RMAN_BACKUPSET_ERR
/-------------------------------------------------------------------------------
20094, 0,"DBUA was not able to connect to the database to validate the latest RMAN backup set."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_NO_DB_CONNECTION_FOR_RMAN_BACKUPSET_ERR
/-------------------------------------------------------------------------------
20095, 0,"db_recovery_file_dest parameter needs to be set to a valid location. Current location is: %s"
// *Cause: DBUA has detected that the current value of the db_recovery_file_dest on the selected database points to an invalid location. This parameter is required for new GRP creation for backup.
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SELECT_RECOVERY_NO_RECOVERY_DEST_ERR
/-------------------------------------------------------------------------------
20100, 0,"Error while updating database parameters."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SETUP_DRIVER_DB_UPDATE_PARAMS_ERR
/-------------------------------------------------------------------------------
20101, 0,"Error while performing setup required for database upgrade."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.SETUP_DRIVER_DB_SETUP_ERR
/-------------------------------------------------------------------------------
20102, 0,"Flashback database feature is not enabled for the selected database."
// *Cause: DBUA has detected that the selected database does not have Flashback feature enabled which is required to take a GRP-based backup.
// *Action: Enable the Flashback feature on the selected database or select the other recovery option available.
// *FQN: oracle.assistants.dbua.resource.ErrorCode.FLASHBACK_FEATURE_NOT_AVAILABLE
/-------------------------------------------------------------------------------
20103, 0,"Database Upgrade operation in not supported from Grid Infrastructure Oracle home."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.dbua.resource.ErrorCode.DBUA_NOTSUPPORTED_IN_GRID_HOME_ERR
/-------------------------------------------------------------------------------
50000, 0,"Unable to check for available memory."
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.CVUErrorCode.UNABLE_TO_CHECK_AVL_MEMORY_ERR
/-------------------------------------------------------------------------------
50001, 0,"Unable to check the value of kernel parameter %s"
// *Cause: n/a
// *Action: n/a
// *FQN: oracle.assistants.common.resource.CVUErrorCode.UNABLE_TO_CHECK_KERNEL_PARAM_ERR
/-------------------------------------------------------------------------------
50002, 0,"Unable to check for available free shared memory"
// *Cause: Unable to check for available free shared memory on nodes %s.
// *Action: n/a
// *FQN: oracle.assistants.common.resource.CVUErrorCode.UNABLE_TO_CHECK_FREE_SHARED_MEMORY_WARN