set define '^' verify off
prompt ...wwv_flow_string.sql
create or replace package wwv_flow_string authid definer as
--------------------------------------------------------------------------------
--
-- Copyright (c) Oracle Corporation 1999 - 2018. All Rights Reserved.
--
-- NAME
--   wwv_flow_string.sql - apex_string
--
-- DESCRIPTION
--   Utilities for varchar2, clob, apex_t_varchar2 and apex_t_number types. The
--   major features of this package are:
--
--   * push:         Append values to a table.
--   * split:        Split strings at separator patterns.
--   * next_chunk:   Read chunks of strings from a clob, with increasing offset.
--   * join:         Concatenate table values with separators in between.
--   * grep:         Return values of the input table or string that match a regular
--                   expression.
--   * shuffle:      Randomly re-order the values of the input table.
--   * plist_*:      Retrieve, set and delete values of a property list (plist),
--                   which is a key/value store based on apex_t_varchar2. Entries at
--                   odd table positions (1, 3, ...) are keys, while entries at even
--                   positions (2, 4, ...) are values. Native index by varchar2
--                   PL/SQL tables are more efficient, but this structure is
--                   sometimes more convenient to use, e.g. when passing multiple
--                   keys/values as parameters.
--   * format:       Return a formatted string, with substitutions applied.
--   * get_initials: Get N letter initials from the first N words.
--
-- RUNTIME DEPLOYMENT: YES
-- PUBLIC:             YES
--
-- MODIFIED   (MM/DD/YYYY)
--   cneumuel  08/09/2016 - Created
--   cbcho     08/29/2016 - Added get_initials (feature #2053)
--   cneumuel  09/22/2016 - Doc changes, p_limit for grep
--   cneumuel  07/13/2018 - Added next_chunk (bug #28341051)
--
--------------------------------------------------------------------------------

--==============================================================================
-- Append value to apex_t_varchar2 table.
--
-- PARAMETERS
-- * p_table:  The table.
-- * p_src:    The value to be added.
--
-- EXAMPLE
--   Append 2 values, then print the table.
--
--   declare
--       l_table apex_t_varchar2;
--   begin
--       apex_string.push(l_table, 'a');
--       apex_string.push(l_table, 'b');
--       sys.dbms_output.put_line(apex_string.join(l_table, ':'));
--   end;
--   -> a:b
--==============================================================================
procedure push (
    p_table in out nocopy wwv_flow_t_varchar2,
    p_value in            varchar2 );

--==============================================================================
-- Append value to apex_t_number table.
--
-- PARAMETERS
-- * p_table:  The table.
-- * p_src:    The value to be added.
--
-- EXAMPLE
--   Append 2 values, then print the table.
--
--   declare
--       l_table apex_t_number;
--   begin
--       apex_string.push(l_table, 1);
--       apex_string.push(l_table, 2);
--       sys.dbms_output.put_line(apex_string.join(l_table, ':'));
--   end;
--   -> 1:2
--==============================================================================
procedure push (
    p_table in out nocopy wwv_flow_t_number,
    p_value in number );

--==============================================================================
-- Append collection values to apex_t_varchar2 table.
--
-- PARAMETERS
-- * p_table:  The table.
-- * p_values: Values that should be added to p_table.
--
-- EXAMPLE
--   Append single value and multiple values, then print the table.
--
--   declare
--       l_table apex_t_varchar2;
--   begin
--       apex_string.push(l_table, 'a');
--       apex_string.push(l_table, apex_t_varchar2('1','2','3'));
--       sys.dbms_output.put_line(apex_string.join(l_table, ':'));
--   end;
--   -> a:1:2:3
--==============================================================================
procedure push (
    p_table  in out nocopy wwv_flow_t_varchar2,
    p_values in            wwv_flow_t_varchar2 );

--==============================================================================
-- Split input string at separator.
--
-- PARAMETERS
-- * p_str:    The input string.
-- * p_sep:    The separator. If null, split after each character. If a single
--             character, split at this character. If more than 1 character,
--             split at regular expression. The default is to split at line
--             feed.
-- * p_limit:  Maximum number of splits, ignored if null. If smaller than the
--             total possible number of splits, the last table element contains
--             the rest.
--
-- EXAMPLES
--   apex_string.split(1||chr(10)||2||chr(10)||3)
--   -> apex_t_varchar2('1','2','3')
--
--   apex_string.split('1:2:3',':')
--   -> apex_t_varchar2('1','2','3')
--
--   apex_string.split('123',null)
--   -> apex_t_varchar2('1','2','3')
--
--   apex_string.split('1:2:3:4',':',2)
--   -> apex_t_varchar2('1','2:3:4')
--
--   apex_string.split('key1=val1, key2=val2','\s*[=,]\s*')
--   -> apex_t_varchar2('key1','val1','key2','val2')
--==============================================================================
function split (
    p_str   in varchar2,
    p_sep   in varchar2    default wwv_flow.LF,
    p_limit in pls_integer default null )
    return wwv_flow_t_varchar2;

--==============================================================================
-- Split input clob at separator.
--
-- PARAMETERS
-- * p_str:    The input clob.
-- * p_sep:    The separator. If null, split after each character. If a single
--             character, split at this character. If more than 1 character,
--             split at regular expression. The default is to split at line
--             feed.
--
-- EXAMPLE
--   apex_string.split('1:2:3',':')
--   -> apex_t_varchar2('1','2','3')
--==============================================================================
function split (
    p_str   in clob,
    p_sep   in varchar2    default wwv_flow.LF )
    return wwv_flow_t_varchar2;

--==============================================================================
-- Split input at separator, values must all be numbers.
--
-- PARAMETERS
-- * p_str:    The input varchar2.
-- * p_sep:    The separator. If null, split after each character. If a single
--             character, split at this character. If more than 1 character,
--             split at regular expression. The default is to split at line
--             feed.
--
-- EXAMPLE
--   apex_string.split_numbers('1:2:3',':')
--   -> apex_t_number(1,2,3)
--==============================================================================
function split_numbers (
    p_str in varchar2,
    p_sep in varchar2 default wwv_flow.LF )
    return wwv_flow_t_number;

--==============================================================================
-- Read a fixed-length string from a clob. This is just a small wrapper around
-- DBMS_LOB.READ, but it prevents common errors when incrementing the offset and
-- picking the maximum chunk size.
--
-- PARAMETERS
--   * p_str:    The input clob.
--   * p_chunk:  The chunk value (in/out).
--   * p_offset: The position in p_str, where the next chunk should be read from
--               (in/out).
--   * p_amount: The amount of characters that should be read (default 8191).
--
-- RETURNS
--   True if another chunk could be read. False if reading past the end of
--   p_str.
--
-- EXAMPLE
--   Print chunks of 25 bytes of the input clob.
--
--     declare
--         l_input  clob := 'The quick brown fox jumps over the lazy dog';
--         l_offset pls_integer;
--         l_chunk  varchar2(20);
--     begin
--         while apex_string.next_chunk (
--                   p_str    => l_input,
--                   p_chunk  => l_chunk,
--                   p_offset => l_offset,
--                   p_amount => 20 )
--         loop
--             sys.dbms_output.put_line(l_chunk);
--         end loop;
--     end;
--
--   Output:
--     The quick brown fox
--     jumps over the lazy
--     dog
--
--==============================================================================
function next_chunk (
    p_str    in            clob,
    p_chunk  out           nocopy varchar2,
    p_offset in out nocopy pls_integer,
    p_amount in            pls_integer default 8191 )
    return boolean;

--==============================================================================
-- Return the values of the apex_t_varchar2 input table p_table as a
-- concatenated varchar2, separated by p_sep.
--
-- PARAMETERS
-- * p_table:  The input table.
-- * p_sep:    The separator, default is line feed.
--
-- EXAMPLE
--   Concatenate numbers, separated by ':'.
--
--   apex_string.join(apex_t_varchar2('a','b','c'),':')
--   -> a:b:c
--==============================================================================
function join (
    p_table in wwv_flow_t_varchar2,
    p_sep   in varchar2             default wwv_flow.LF)
    return varchar2;

--==============================================================================
-- Return the values of the apex_t_number input table p_table as a concatenated
-- varchar2, separated by p_sep.
--
-- PARAMETERS
-- * p_table:  The input table.
-- * p_sep:    The separator, default is line feed.
--
-- EXAMPLE
--   Concatenate numbers, separated by ':'.
--
--   apex_string.join(apex_t_number(1,2,3),':')
--   -> 1:2:3
--==============================================================================
function join (
    p_table in wwv_flow_t_number,
    p_sep   in varchar2 default wwv_flow.LF )
    return varchar2;

--==============================================================================
-- Return the values of the apex_t_varchar2 input table p_table as a
-- concatenated clob, separated by p_sep.
--
-- PARAMETERS
-- * p_table:  The input table.
-- * p_sep:    The separator, default is line feed.
-- * p_dur:    The duration of the clob, default sys.dbms_lob.call.
--
-- EXAMPLE
--   Concatenate numbers, separated by ':'
--
--   apex_string.join_clob(apex_t_varchar2(1,2,3),':')
--   -> 1:2:3
--==============================================================================
function join_clob (
    p_table in wwv_flow_t_varchar2,
    p_sep   in varchar2             default wwv_flow.LF,
    p_dur   in pls_integer          default sys.dbms_lob.call )
    return clob;

--==============================================================================
-- Return values of the input table that match a regular expression.
--
-- PARAMETERS
-- * p_table:         The input table.
-- * p_pattern:       The regular expression.
-- * p_modifier:      The regular expression modifier.
-- * p_subexpression: The subexpression which should be returned. If null,
--                    return the complete table value. If 0 (the default),
--                    return the matched expression. If > 0, return the
--                    subexpression value. You can also pass a comma separated
--                    list of numbers, to get multiple subexpressions in the
--                    result.
-- * p_limit:         Limitation for the number of elements in the return table.
--                    If null (the default), there is no limit.
--
-- EXAMPLE
--   Collect and print basenames of sql files in input collection
--
--   declare
--       l_sqlfiles apex_t_varchar2;
--   begin
--       l_sqlfiles := apex_string.grep (
--                         p_table         => apex_t_varchar2('a.html','b.sql', 'C.SQL'),
--                         p_pattern       => '(\w+)\.sql',
--                         p_modifier      => 'i',
--                         p_subexpression => '1' );
--       sys.dbms_output.put_line(apex_string.join(l_sqlfiles, ':'));
--   end;
--   -> b:C
--==============================================================================
function grep (
    p_table         in wwv_flow_t_varchar2,
    p_pattern       in varchar2,
    p_modifier      in varchar2             default null,
    p_subexpression in varchar2             default '0',
    p_limit         in pls_integer          default null )
    return wwv_flow_t_varchar2;

--==============================================================================
-- Return values of the input varchar2 that match a regular expression.
--
-- PARAMETERS
-- * p_str:           The input varchar2.
-- * p_pattern:       The regular expression.
-- * p_modifier:      The regular expression modifier.
-- * p_subexpression: The subexpression which should be returned. If null,
--                    return the line where a match is found. If 0 (the
--                    default), return the matched expression. If > 0, return
--                    subexpression value. You can also pass a comma separated
--                    list of numbers, to get multiple subexpressions in the
--                    result.
-- * p_limit:         Limitation for the number of elements in the return table.
--                    If null (the default), there is no limit.
--
-- EXAMPLE
--   Collect and print key=value definitions
--
--   declare
--       l_plist apex_t_varchar2;
--   begin
--       l_plist := apex_string.grep (
--                      p_str           => 'define k1=v1'||chr(10)||
--                                         'define k2 = v2',
--                      p_pattern       => 'define\s+(\w+)\s*=\s*([^'||chr(10)||']*)',
--                      p_modifier      => 'i',
--                      p_subexpression => '1,2' );
--       sys.dbms_output.put_line(apex_string.join(l_plist, ':'));
--   end;
--   -> k1:v1:k2:v2
--==============================================================================
function grep (
    p_str           in varchar2,
    p_pattern       in varchar2,
    p_modifier      in varchar2             default null,
    p_subexpression in varchar2             default '0',
    p_limit         in pls_integer          default null )
    return wwv_flow_t_varchar2;

--==============================================================================
-- Return values of the input clob that match a regular expression.
--
-- PARAMETERS
-- * p_str:           The input clob.
-- * p_pattern:       The regular expression.
-- * p_modifier:      The regular expression modifier.
-- * p_subexpression: The subexpression which should be returned. If null,
--                    return the line where a match is found. If 0 (the
--                    default), return the matched expression. If > 0, return
--                    subexpression value. You can also pass a comma separated
--                    list of numbers, to get multiple subexpressions in the
--                    result.
-- * p_limit:         Limitation for the number of elements in the return table.
--                    If null (the default), there is no limit.
--
-- EXAMPLE
--   Collect and print key=value definitions
--
--   declare
--       l_plist apex_t_varchar2;
--   begin
--       l_plist := apex_string.grep (
--                      p_str           => to_clob('define k1=v1'||chr(10)||
--                                                 'define k2 = v2'),
--                      p_pattern       => 'define\s+(\w+)\s*=\s*([^'||chr(10)||']*)',
--                      p_modifier      => 'i',
--                      p_subexpression => '1,2' );
--       sys.dbms_output.put_line(apex_string.join(l_plist, ':'));
--   end;
--   -> k1:v1:k2:v2
--==============================================================================
function grep (
    p_str           in clob,
    p_pattern       in varchar2,
    p_modifier      in varchar2             default null,
    p_subexpression in varchar2             default '0',
    p_limit         in pls_integer          default null )
    return wwv_flow_t_varchar2;

--==============================================================================
-- Randomly re-order the values of the input table.
--
-- PARAMETERS
-- * p_table:         The input table, which will be modified by the procedure.
--
-- EXAMPLE
--   Shuffle and print l_table.
--
--   declare
--       l_table apex_t_varchar2 := apex_string.split('1234567890',null);
--   begin
--       apex_string.shuffle(l_table);
--       sys.dbms_output.put_line(apex_string.join(l_table,':'));
--   end;
--   -> a permutation of 1:2:3:4:5:6:7:8:9:0
--==============================================================================
procedure shuffle (
    p_table         in out nocopy wwv_flow_t_varchar2 );

--==============================================================================
-- Return the input table values, re-ordered.
--
-- PARAMETERS
-- * p_table:         The input table.
--
-- EXAMPLE
--   Shuffle and print l_table.
--
--   declare
--       l_table apex_t_varchar2 := apex_string.split('1234567890',null);
--   begin
--       sys.dbms_output.put_line(apex_string.join(apex_string.shuffle(l_table),':'));
--   end;
--   -> a permutation of 1:2:3:4:5:6:7:8:9:0
--==============================================================================
function shuffle (
    p_table         in wwv_flow_t_varchar2 )
    return wwv_flow_t_varchar2;

--==============================================================================
-- Get property list value for key.
--
-- PARAMETERS
-- * p_table:         The input table.
-- * p_key:           The input key.
--
-- RAISES
-- * NO_DATA_FOUND:   Given key does not exist in table.
--
-- EXAMPLE
--   Get value of property "key2".
--
--   declare
--       l_plist apex_t_varchar2 := apex_t_varchar2('key1','foo','key2','bar');
--   begin
--       sys.dbms_output.put_line(apex_string.plist_get(l_plist,'key2'));
--   end;
--   -> bar
--==============================================================================
function plist_get (
    p_table in wwv_flow_t_varchar2,
    p_key   in varchar2 )
    return varchar2;

--==============================================================================
-- Insert or update property list value for key.
--
-- PARAMETERS
-- * p_table:         The input table.
-- * p_key:           The input key.
-- * p_value:         The input value.
--
-- EXAMPLE
--   Set value of property "key2".
--
--   declare
--       l_plist apex_t_varchar2 := apex_t_varchar2('key1','foo');
--   begin
--       apex_string.plist_put(l_plist,'key2','bar');
--       sys.dbms_output.put_line(apex_string.plist_get(l_plist,'key2'));
--   end;
--   -> bar
--==============================================================================
procedure plist_put (
    p_table in out nocopy wwv_flow_t_varchar2,
    p_key   in varchar2,
    p_value in varchar2 );

--==============================================================================
-- Remove the property list key from the table, by setting it to null.
--
-- PARAMETERS
-- * p_table:         The input table.
-- * p_key:           The input key.
--
-- RAISES
-- * NO_DATA_FOUND:   Given key does not exist in table.
--
-- EXAMPLE
--   Remove value of property "key2".
--
--   declare
--       l_plist apex_t_varchar2 := apex_t_varchar2('key1','foo','key2','bar');
--   begin
--       apex_string.plist_delete(l_plist,'key2');
--       sys.dbms_output.put_line(apex_string.join(l_plist,':'));
--   end;
--   -> key1:foo::
--==============================================================================
procedure plist_delete (
    p_table in out nocopy wwv_flow_t_varchar2,
    p_key   in varchar2 );

--==============================================================================
-- Return a formatted string, with substitutions applied.
--
-- Returns p_message after replacing each <n>th occurrence of %s with p<n> and
-- each occurrence of %<n> with p<n>. If p_max_length is not null,
-- substr(p<n>,1,p_arg_max_length) is used instead of p<n>.
--
-- PARAMETERS
-- * p_message:       Message string with substitution placeholders.
-- * p0-p19:          Substitution parameters.
-- * p_max_length:    If not null (default is 1000), cap each p<n> at
--                    p_max_length characters.
--
-- EXAMPLE
--   wwv_flow_utilities.format('%s+%s=%s', 1, 2, 'three')
--   -> 1+2=three
--
--   wwv_flow_utilities.format('%1+%2=%0', 'three', 1, 2)
--   -> 1+2=three
--==============================================================================
function format (
    p_message    in varchar2,
    p0           in varchar2    default null,
    p1           in varchar2    default null,
    p2           in varchar2    default null,
    p3           in varchar2    default null,
    p4           in varchar2    default null,
    p5           in varchar2    default null,
    p6           in varchar2    default null,
    p7           in varchar2    default null,
    p8           in varchar2    default null,
    p9           in varchar2    default null,
    p10          in varchar2    default null,
    p11          in varchar2    default null,
    p12          in varchar2    default null,
    p13          in varchar2    default null,
    p14          in varchar2    default null,
    p15          in varchar2    default null,
    p16          in varchar2    default null,
    p17          in varchar2    default null,
    p18          in varchar2    default null,
    p19          in varchar2    default null,
    p_max_length in pls_integer default 1000 )
    return varchar2;

--==============================================================================
-- Get N letter initials from the first N words.
--
-- PARAMETERS
-- * p_string:     The input string.
-- * p_cnt:        The N letter initials to get from the first N words. The default is 2.
--
-- EXAMPLE
--   Get initials from "John Doe".
--
--   begin
--     sys.dbms_output.put_line(get_initials('John Doe'));
--   end;
--   -> JD
--
--   begin
--     sys.dbms_output.put_line(get_initials(p_str => 'Andres Homero Lozano Garza', p_cnt => 3));
--   end;
--   -> AHL
--==============================================================================
function get_initials (
    p_str  in varchar2,
    p_cnt  in number default 2 )
    return varchar2;

end wwv_flow_string;
/
show err
