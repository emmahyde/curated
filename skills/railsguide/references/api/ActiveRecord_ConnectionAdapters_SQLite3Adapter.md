# Active Record SQLite3 Adapter
The SQLite3 adapter works with the [sqlite3](https://sparklemotion.github.io/sqlite3-ruby/) driver.

#### Options
  * `:database` ([`String`](https://api.rubyonrails.org/classes/String.html)): Filesystem path to the database file.
  * `:statement_limit` ([`Integer`](https://api.rubyonrails.org/classes/Integer.html)): Maximum number of prepared statements to cache per database connection. (default: 1000)
  * `:timeout` ([`Integer`](https://api.rubyonrails.org/classes/Integer.html)): Timeout in milliseconds to use when waiting for a lock. (default: no wait)
  * `:strict` (Boolean): Enable or disable strict mode. When enabled, this will [disallow double-quoted string literals in SQL statements](https://www.sqlite.org/quirks.html#double_quoted_string_literals_are_accepted). (default: see [`strict_strings_by_default`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-c-strict_strings_by_default))
  * `:extensions` ([`Array`](https://api.rubyonrails.org/classes/Array.html)): (**requires sqlite3 v2.4.0**) Each entry specifies a sqlite extension to load for this database. The entry may be a filesystem path, or the name of a class that responds to `.to_path` to provide the filesystem path for the extension. See [sqlite3-ruby documentation](https://sparklemotion.github.io/sqlite3-ruby/SQLite3/Database.html#class-SQLite3::Database-label-SQLite+Extensions) for more information.

There may be other options available specific to the [`SQLite3`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3.html) driver. Please read the documentation for [SQLite3::Database.new](https://sparklemotion.github.io/sqlite3-ruby/SQLite3/Database.html#method-c-new)
Methods

A

C

D

E

F

N

R

S

* strict_strings_by_default,
  * supports_check_constraints?,
  * supports_common_table_expressions?,
  * supports_concurrent_connections?,
  * supports_datetime_with_precision?,
  * supports_ddl_transactions?,
  * supports_deferrable_constraints?,
  * supports_expression_index?,
  * supports_index_sort_order?,
  * supports_insert_conflict_target?,
  * supports_insert_on_conflict?,
  * supports_insert_on_duplicate_skip?,
  * supports_insert_on_duplicate_update?,
  * supports_insert_returning?,
  * supports_lazy_transactions?,
  * supports_transaction_isolation?,
  * supports_virtual_columns?

V

Included Modules
  * [ ActiveRecord::ConnectionAdapters::SQLite3::DatabaseStatements ](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3/DatabaseStatements.html)

## Constants
| ADAPTER_NAME  | =  | "SQLite"  |
| --- | --- | --- |
| COLLATE_REGEX  | =  | /.*"(\w+)".*collate\s+"(\w+)".*/i  |
| DEFAULT_PRAGMAS  | =  | { "foreign_keys" => true, "journal_mode" => :wal, "synchronous" => :normal, "mmap_size" => 134217728, # 128 megabytes "journal_size_limit" => 67108864, # 64 megabytes "cache_size" => 2000 }  |
| DEFERRABLE_REGEX  | =  | /DEFERRABLE INITIALLY (\w+)/  |
| EXTENDED_TYPE_MAPS  | =  | Concurrent::Map.new  |
| FINAL_CLOSE_PARENS_REGEX  | =  | /\\);*\z/  |
| FK_REGEX  | =  | /.*FOREIGN KEY\s+\\("([^"]+)"\\)\s+REFERENCES\s+"(\w+)"\s+\\("(\w+)"\\)/  |
| GENERATED_ALWAYS_AS_REGEX  | =  | /.*"(\w+)".+GENERATED ALWAYS AS \\((.+)\\) (?:STORED|VIRTUAL)/i  |
| NATIVE_DATABASE_TYPES  | =  | { primary_key: "integer PRIMARY KEY AUTOINCREMENT NOT NULL", string: { name: "varchar" }, text: { name: "text" }, integer: { name: "integer" }, float: { name: "float" }, decimal: { name: "decimal" }, datetime: { name: "datetime" }, time: { name: "time" }, date: { name: "date" }, binary: { name: "blob" }, boolean: { name: "boolean" }, json: { name: "json" }, }  |
| PRIMARY_KEY_AUTOINCREMENT_REGEX  | =  | /.*"(\w+)".+PRIMARY KEY AUTOINCREMENT/i  |
| TYPE_MAP  | =  | Type::TypeMap.new.tap { |m| initialize_type_map(m) }  |
| UNQUOTED_OPEN_PARENS_REGEX  | =  | /\\((?![^'"]*['"][^'"]*$)/  |
| VIRTUAL_TABLE_REGEX  | =  | /USING\s+(\w+)\s*\\((.*)\\)/i  |

## Class Public methods

###  **dbconsole**(config, options = {}) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-c-dbconsole)
Source: [show](javascript:toggleSource\('method-c-dbconsole_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L60)

```

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 60
def dbconsole(config, options = {})
  args = []

args << "-#{options[:mode]}" if options[:mode]
  args << "-header" if options[:header]
  args << File.expand_path(config.database, defined?(Rails.root) ? Rails.root : nil)

find_cmd_and_exec(ActiveRecord.database_cli[:sqlite], *args)
end
```

###  **new**(...) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-c-new)
Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L129)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 129
def initialize(...)
  super

@memory_database = false
  case @config[:database].to_s
  when ""
    raise ArgumentError, "No database file specified. Missing argument: database"
  when ":memory:"
    @memory_database = true
  when /\Afile:/
  else
    # Otherwise we have a path relative to Rails.root
    @config[:database] = File.expand_path(@config[:database], Rails.root) if defined?(Rails.root)
    dirname = File.dirname(@config[:database])
    unless File.directory?(dirname)
      begin
        FileUtils.mkdir_p(dirname)
      rescue SystemCallError
        raise ActiveRecord::NoDatabaseError.new(connection_pool: @pool)
      end
    end
  end

@previous_read_uncommitted = nil
  @config[:strict] = ConnectionAdapters::SQLite3Adapter.strict_strings_by_default unless @config.key?(:strict)

extensions = @config.fetch(:extensions, []).map do |extension|
    extension.safe_constantize || extension
  end

@connection_parameters = @config.merge(
    database: @config[:database].to_s,
    results_as_hash: true,
    default_transaction_mode: :immediate,
    extensions: extensions
  )
end
```

###  **new_client**(config) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-c-new_client)
Source: [show](javascript:toggleSource\('method-c-new_client_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L50)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 50
def new_client(config)
  ::SQLite3::Database.new(config[:database].to_s, config)
rescue Errno::ENOENT => error
  if error.message.include?("No such file or directory")
    raise ActiveRecord::NoDatabaseError
  else
    raise
  end
end
```

###  **strict_strings_by_default** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-c-strict_strings_by_default)
Configure the [`SQLite3Adapter`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html) to be used in a “strict strings” mode. When enabled, this will [disallow double-quoted string literals in SQL statements](https://www.sqlite.org/quirks.html#double_quoted_string_literals_are_accepted), which may prevent some typographical errors like creating an index for a non-existent column. The default is `false`.
If you wish to enable this mode you can add the following line to your [application.rb](https://api.rubyonrails.org/files/railties/lib/rails/application_rb.html) file:

```
config.active_record.sqlite3_adapter_strict_strings_by_default =

This can also be configured on individual databases by setting the `strict:` option.
Source: [show](javascript:toggleSource\('method-c-strict_strings_by_default_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L94)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 94
class_attribute :strict_strings_by_default, default: false

## Instance Public methods

###  **active?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-active-3F)
Source: [show](javascript:toggleSource\('method-i-active-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L242)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 242
def active?
  if connected?
    verified!
    true
  end
end
```

###  **add_timestamps**(table_name, **options) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-add_timestamps)
Source: [show](javascript:toggleSource\('method-i-add_timestamps_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L425)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 425
def add_timestamps(table_name, **options)
  options[:null] = false if options[:null].nil?

if !options.key?(:precision)
    options[:precision] = 6
  end

alter_table(table_name) do |definition|
    definition.column :created_at, :datetime, **options
    definition.column :updated_at, :datetime, **options
  end
end
```

###  **connected?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-connected-3F)
Source: [show](javascript:toggleSource\('method-i-connected-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L238)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 238
def connected?
  !(@raw_connection.nil? || @raw_connection.closed?)
end
```

###  **create_virtual_table**(table_name, module_name, values) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-create_virtual_table)
Creates a virtual table
Example:

```
create_virtual_table :emails, :fts5, ['sender', 'title', 'body']

Source: [show](javascript:toggleSource\('method-i-create_virtual_table_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L341)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 341
def create_virtual_table(table_name, module_name, values)
  exec_query "CREATE VIRTUAL TABLE IF NOT EXISTS #{table_name} USING #{module_name} (#{values.join(", ")})"
end
```

###  **database_exists?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-database_exists-3F)
Source: [show](javascript:toggleSource\('method-i-database_exists-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L167)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 167
def database_exists?
  @config[:database] == ":memory:" || File.exist?(@config[:database].to_s)
end
```

###  **disconnect!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-disconnect-21)
Disconnects from the database if already connected. Otherwise, this method does nothing.
Source: [show](javascript:toggleSource\('method-i-disconnect-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L253)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 253
def disconnect!
  super

@raw_connection&.close rescue nil
  @raw_connection = nil
end
```

###  **drop_virtual_table**(table_name, module_name, values, **options) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-drop_virtual_table)
Drops a virtual table
Although this command ignores `module_name` and `values`, it can be helpful to provide these in a migration’s `change` method so it can be reverted. In that case, `module_name`, `values` and `options` will be used by [`create_virtual_table`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-create_virtual_table).
Source: [show](javascript:toggleSource\('method-i-drop_virtual_table_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L350)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 350
def drop_virtual_table(table_name, module_name, values, **options)
  drop_table(table_name)
end
```

###  **encoding**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-encoding)
Returns the current database encoding format as a string, e.g. ‘UTF-8’
Source: [show](javascript:toggleSource\('method-i-encoding_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L265)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 265
def encoding
  any_raw_connection.encoding.to_s
end
```

###  **foreign_keys**(table_name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-foreign_keys)
Source: [show](javascript:toggleSource\('method-i-foreign_keys_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L445)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 445
def foreign_keys(table_name)

# SQLite returns 1 row for each column of composite foreign keys.
  fk_info = internal_exec_query("PRAGMA foreign_key_list(#{quote(table_name)})", "SCHEMA")

# Deferred or immediate foreign keys can only be seen in the CREATE TABLE sql
  fk_defs = table_structure_sql(table_name)
              .select do |column_string|
                column_string.start_with?("CONSTRAINT")
                column_string.include?("FOREIGN KEY")
              end
              .to_h do |fk_string|
                _, from, table, to = fk_string.match(FK_REGEX).to_a
                _, mode = fk_string.match(DEFERRABLE_REGEX).to_a
                deferred = mode&.downcase&.to_sym || false
                [[table, from, to], deferred]
              end

grouped_fk = fk_info.group_by { |row| row["id"] }.values.each { |group| group.sort_by! { |row| row["seq"] } }
  grouped_fk.map do |group|
    row = group.first
    options = {
      on_delete: extract_foreign_key_action(row["on_delete"]),
      on_update: extract_foreign_key_action(row["on_update"]),
      deferrable: fk_defs[[row["table"], row["from"], row["to"]]]
    }

if group.one?
      options[:column] = row["from"]
      options[:primary_key] = row["to"]
    else
      options[:column] = group.map { |row| row["from"] }
      options[:primary_key] = group.map { |row| row["to"] }
    end
    ForeignKeyDefinition.new(table_name, row["table"], options)
  end
end
```

###  **rename_table**(table_name, new_name, **options) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-rename_table)
Renames a table.
Example:

```
rename_table('octopuses', 'octopi')

Source: [show](javascript:toggleSource\('method-i-rename_table_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L358)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 358
def rename_table(table_name, new_name, **options)
  validate_table_length!(new_name) unless options[:_uses_legacy_table_name]
  schema_cache.clear_data_source_cache!(table_name.to_s)
  schema_cache.clear_data_source_cache!(new_name.to_s)
  exec_query "ALTER TABLE #{quote_table_name(table_name)} RENAME TO #{quote_table_name(new_name)}"
  rename_table_indexes(table_name, new_name, **options)
end
```

###  **requires_reloading?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-requires_reloading-3F)
Source: [show](javascript:toggleSource\('method-i-requires_reloading-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L191)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 191
def requires_reloading?
  true
end
```

###  **supports_check_constraints?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_check_constraints-3F)
Source: [show](javascript:toggleSource\('method-i-supports_check_constraints-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L199)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 199
def supports_check_constraints?
  true
end
```

###  **supports_common_table_expressions?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_common_table_expressions-3F)
Source: [show](javascript:toggleSource\('method-i-supports_common_table_expressions-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L215)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 215
def supports_common_table_expressions?
  true
end
```

###  **supports_concurrent_connections?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_concurrent_connections-3F)
Source: [show](javascript:toggleSource\('method-i-supports_concurrent_connections-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L230)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 230
def supports_concurrent_connections?
  !@memory_database
end
```

###  **supports_datetime_with_precision?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_datetime_with_precision-3F)
Source: [show](javascript:toggleSource\('method-i-supports_datetime_with_precision-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L207)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 207
def supports_datetime_with_precision?
  true
end
```

###  **supports_ddl_transactions?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_ddl_transactions-3F)
Source: [show](javascript:toggleSource\('method-i-supports_ddl_transactions-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L171)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 171
def supports_ddl_transactions?
  true
end
```

###  **supports_deferrable_constraints?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_deferrable_constraints-3F)
Source: [show](javascript:toggleSource\('method-i-supports_deferrable_constraints-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L277)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 277
def supports_deferrable_constraints?
  true
end
```

###  **supports_explain?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_explain-3F)
Source: [show](javascript:toggleSource\('method-i-supports_explain-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L269)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 269
def supports_explain?
  true
end
```

###  **supports_expression_index?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_expression_index-3F)
Source: [show](javascript:toggleSource\('method-i-supports_expression_index-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L187)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 187
def supports_expression_index?
  true
end
```

###  **supports_foreign_keys?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_foreign_keys-3F)
Source: [show](javascript:toggleSource\('method-i-supports_foreign_keys-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L195)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 195
def supports_foreign_keys?
  true
end
```

###  **supports_index_sort_order?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_index_sort_order-3F)
Source: [show](javascript:toggleSource\('method-i-supports_index_sort_order-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L260)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 260
def supports_index_sort_order?
  true
end
```

###  **supports_insert_conflict_target?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_insert_conflict_target-3F)
Alias for: [supports_insert_on_conflict?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_insert_on_conflict-3F)

###  **supports_insert_on_conflict?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_insert_on_conflict-3F)
Also aliased as: [supports_insert_on_duplicate_skip?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_insert_on_duplicate_skip-3F), [supports_insert_on_duplicate_update?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_insert_on_duplicate_update-3F), [supports_insert_conflict_target?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_insert_conflict_target-3F)
Source: [show](javascript:toggleSource\('method-i-supports_insert_on_conflict-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L223)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 223
def supports_insert_on_conflict?
  database_version >= "3.24.0"
end
```

###  **supports_insert_on_duplicate_skip?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_insert_on_duplicate_skip-3F)
Alias for: [supports_insert_on_conflict?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_insert_on_conflict-3F)

###  **supports_insert_on_duplicate_update?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_insert_on_duplicate_update-3F)
Alias for: [supports_insert_on_conflict?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_insert_on_conflict-3F)

###  **supports_insert_returning?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_insert_returning-3F)
Source: [show](javascript:toggleSource\('method-i-supports_insert_returning-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L219)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 219
def supports_insert_returning?
  database_version >= "3.35.0"
end
```

###  **supports_json?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_json-3F)
Source: [show](javascript:toggleSource\('method-i-supports_json-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L211)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 211
def supports_json?
  true
end
```

###  **supports_lazy_transactions?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_lazy_transactions-3F)
Source: [show](javascript:toggleSource\('method-i-supports_lazy_transactions-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L273)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 273
def supports_lazy_transactions?
  true
end
```

###  **supports_partial_index?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_partial_index-3F)
Source: [show](javascript:toggleSource\('method-i-supports_partial_index-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L183)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 183
def supports_partial_index?
  true
end
```

###  **supports_savepoints?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_savepoints-3F)
Source: [show](javascript:toggleSource\('method-i-supports_savepoints-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L175)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 175
def supports_savepoints?
  true
end
```

###  **supports_transaction_isolation?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_transaction_isolation-3F)
Source: [show](javascript:toggleSource\('method-i-supports_transaction_isolation-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L179)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 179
def supports_transaction_isolation?
  true
end
```

###  **supports_views?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_views-3F)
Source: [show](javascript:toggleSource\('method-i-supports_views-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L203)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 203
def supports_views?
  true
end
```

###  **supports_virtual_columns?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-supports_virtual_columns-3F)
Source: [show](javascript:toggleSource\('method-i-supports_virtual_columns-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L234)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 234
def supports_virtual_columns?
  database_version >= "3.31.0"
end
```

###  **virtual_tables**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html#method-i-virtual_tables)
Returns a list of defined virtual tables
Source: [show](javascript:toggleSource\('method-i-virtual_tables_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L325)

# File activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb, line 325
      def virtual_tables
        query = <<~SQL
          SELECT name, sql FROM sqlite_master WHERE sql LIKE 'CREATE VIRTUAL %';
        SQL

exec_query(query, "SCHEMA").cast_values.each_with_object({}) do |row, memo|
          table_name, sql = row[0], row[1]
          _, module_name, arguments = sql.match(VIRTUAL_TABLE_REGEX).to_a
          memo[table_name] = [module_name, arguments]
        end.to_a
      end
```