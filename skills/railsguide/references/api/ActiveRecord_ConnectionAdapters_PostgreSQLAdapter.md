# Active Record PostgreSQL Adapter
The PostgreSQL adapter works with the native C ([github.com/ged/ruby-pg](https://github.com/ged/ruby-pg)) driver.

#### Options
  * `:host` - Defaults to a Unix-domain socket in /tmp. On machines without Unix-domain sockets, the default is to connect to localhost.
  * `:port` - Defaults to 5432.
  * `:username` - Defaults to be the same as the operating system name of the user running the application.
  * `:password` - Password to be used if the server demands password authentication.
  * `:database` - Defaults to be the same as the username.
  * `:schema_search_path` - An optional schema search path for the connection given as a string of comma-separated schema names. This is backward-compatible with the `:schema_order` option.
  * `:encoding` - An optional client encoding that is used in a `SET client_encoding TO <encoding>` call on the connection.
  * `:min_messages` - An optional client min messages that is used in a `SET client_min_messages TO <min_messages>` call on the connection.
  * `:variables` - An optional hash of additional parameters that will be used in `SET SESSION key = val` calls on the connection.
  * `:insert_returning` - An optional boolean to control the use of `RETURNING` for `INSERT` statements defaults to true.

Any further options are used as connection parameters to libpq. See [www.postgresql.org/docs/current/static/libpq-connect.html](https://www.postgresql.org/docs/current/static/libpq-connect.html) for the list of parameters.
In addition, default connection parameters of libpq can be set per environment variables. See [www.postgresql.org/docs/current/static/libpq-envars.html](https://www.postgresql.org/docs/current/static/libpq-envars.html) .
Methods

A

C

D

E

I

M

N

R

S

* set_standard_conforming_strings,
  * supports_advisory_locks?,
  * supports_check_constraints?,
  * supports_common_table_expressions?,
  * supports_datetime_with_precision?,
  * supports_ddl_transactions?,
  * supports_deferrable_constraints?,
  * supports_exclusion_constraints?,
  * supports_expression_index?,
  * supports_foreign_tables?,
  * supports_index_sort_order?,
  * supports_insert_conflict_target?,
  * supports_insert_on_conflict?,
  * supports_insert_on_duplicate_skip?,
  * supports_insert_on_duplicate_update?,
  * supports_insert_returning?,
  * supports_lazy_transactions?,
  * supports_materialized_views?,
  * supports_nulls_not_distinct?,
  * supports_optimizer_hints?,
  * supports_partitioned_indexes?,
  * supports_restart_db_transaction?,
  * supports_transaction_isolation?,
  * supports_unique_constraints?,
  * supports_validate_constraints?,
  * supports_virtual_columns?

U

Included Modules
  * [ ActiveRecord::ConnectionAdapters::PostgreSQL::Quoting ](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQL/Quoting.html)
  * [ ActiveRecord::ConnectionAdapters::PostgreSQL::SchemaStatements ](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQL/SchemaStatements.html)
  * [ ActiveRecord::ConnectionAdapters::PostgreSQL::DatabaseStatements ](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQL/DatabaseStatements.html)

## Constants
| ADAPTER_NAME  | =  | "PostgreSQL"  |
| --- | --- | --- |
| CHECK_VIOLATION  | =  | "23514"  |
| DEADLOCK_DETECTED  | =  | "40P01"  |
| DUPLICATE_DATABASE  | =  | "42P04"  |
| EXCLUSION_VIOLATION  | =  | "23P01"  |
| FOREIGN_KEY_VIOLATION  | =  | "23503"  |
| LOCK_NOT_AVAILABLE  | =  | "55P03"  |
| NATIVE_DATABASE_TYPES  | =  | { primary_key: "bigserial primary key", string: { name: "character varying" }, text: { name: "text" }, integer: { name: "integer", limit: 4 }, bigint: { name: "bigint" }, float: { name: "float" }, decimal: { name: "decimal" }, datetime: {}, # set dynamically based on datetime_type timestamp: { name: "timestamp" }, timestamptz: { name: "timestamptz" }, time: { name: "time" }, date: { name: "date" }, daterange: { name: "daterange" }, numrange: { name: "numrange" }, tsrange: { name: "tsrange" }, tstzrange: { name: "tstzrange" }, int4range: { name: "int4range" }, int8range: { name: "int8range" }, binary: { name: "bytea" }, boolean: { name: "boolean" }, xml: { name: "xml" }, tsvector: { name: "tsvector" }, hstore: { name: "hstore" }, inet: { name: "inet" }, cidr: { name: "cidr" }, macaddr: { name: "macaddr" }, uuid: { name: "uuid" }, json: { name: "json" }, jsonb: { name: "jsonb" }, ltree: { name: "ltree" }, citext: { name: "citext" }, point: { name: "point" }, line: { name: "line" }, lseg: { name: "lseg" }, box: { name: "box" }, path: { name: "path" }, polygon: { name: "polygon" }, circle: { name: "circle" }, bit: { name: "bit" }, bit_varying: { name: "bit varying" }, money: { name: "money" }, interval: { name: "interval" }, oid: { name: "oid" }, enum: {} # special type https://www.postgresql.org/docs/current/datatype-enum.html }  |
| NOT_NULL_VIOLATION  | =  | "23502"  |
| NUMERIC_VALUE_OUT_OF_RANGE  | =  | "22003"  |
| QUERY_CANCELED  | =  | "57014"  |
| SERIALIZATION_FAILURE  | =  | "40001"  |
| UNIQUE_VIOLATION  | =  | "23505"  |
| VALUE_LIMIT_VIOLATION  | =  | "22001"  |
| See [www.postgresql.org/docs/current/static/errcodes-appendix.html](https://www.postgresql.org/docs/current/static/errcodes-appendix.html)  |

## Class Public methods

###  **create_unlogged_tables** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-c-create_unlogged_tables)
PostgreSQL allows the creation of “unlogged” tables, which do not record data in the PostgreSQL Write-Ahead Log. This can make the tables faster, but significantly increases the risk of data loss if the database crashes. As a result, this should not be used in production environments. If you would like all created tables to be unlogged in the test environment you can add the following to your [test.rb](https://api.rubyonrails.org/files/actioncable/lib/action_cable/subscription_adapter/test_rb.html) file:

```
ActiveSupport.on_load(:active_record_postgresqladapter)
  .create_unlogged_tables =

```

Source: [show](javascript:toggleSource\('method-c-create_unlogged_tables_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L105)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 105
class_attribute :create_unlogged_tables, default: false

###  **datetime_type** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-c-datetime_type)
PostgreSQL supports multiple types for DateTimes. By default, if you use `datetime` in migrations, Rails will translate this to a PostgreSQL “timestamp without time zone”. Change this in an initializer to use another [`NATIVE_DATABASE_TYPES`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#NATIVE_DATABASE_TYPES). For example, to store DateTimes as “timestamp with time zone”:

```
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.datetime_type = :timestamptz

Or if you are adding a custom type:

```
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:my_custom_type] = { name: "my_custom_type_name" }
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.datetime_type = :my_custom_type

If you’re using `:ruby` as your `config.active_record.schema_format` and you change this setting, you should immediately run `bin/rails db:migrate` to update the types in your schema.rb.
Source: [show](javascript:toggleSource\('method-c-datetime_type_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L123)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 123
class_attribute :datetime_type, default: :timestamp

###  **dbconsole**(config, options = {}) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-c-dbconsole)
Source: [show](javascript:toggleSource\('method-c-dbconsole_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L73)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 73
def dbconsole(config, options = {})
  pg_config = config.configuration_hash

ENV["PGUSER"]         = pg_config[:username] if pg_config[:username]
  ENV["PGHOST"]         = pg_config[:host] if pg_config[:host]
  ENV["PGPORT"]         = pg_config[:port].to_s if pg_config[:port]
  ENV["PGPASSWORD"]     = pg_config[:password].to_s if pg_config[:password]  options[:include_password]
  ENV["PGSSLMODE"]      = pg_config[:sslmode].to_s if pg_config[:sslmode]
  ENV["PGSSLCERT"]      = pg_config[:sslcert].to_s if pg_config[:sslcert]
  ENV["PGSSLKEY"]       = pg_config[:sslkey].to_s if pg_config[:sslkey]
  ENV["PGSSLROOTCERT"]  = pg_config[:sslrootcert].to_s if pg_config[:sslrootcert]
  if pg_config[:variables]
    ENV["PGOPTIONS"] = pg_config[:variables].filter_map do |name, value|
      "-c #{name}=#{value.to_s.gsub(/[ \\]/, '\\\\\0')}" unless value == ":default" || value == :default
    end.join(" ")
  end
  find_cmd_and_exec(ActiveRecord.database_cli[:postgresql], config.database)
end
```

###  **decode_dates** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-c-decode_dates)
Toggles automatic decoding of date columns.

```
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.select_value("select '2024-01-01'::date").class #=> String
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.decode_dates =
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.select_value("select '2024-01-01'::date").class #=> Date

Source: [show](javascript:toggleSource\('method-c-decode_dates_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L132)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 132
class_attribute :decode_dates, default: false

###  **new**(...) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-c-new)
Initializes and connects a PostgreSQL adapter.
Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L334)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 334
def initialize(...)
  super

conn_params = @config.compact

# Map ActiveRecords param names to PGs.
  conn_params[:user] = conn_params.delete(:username) if conn_params[:username]
  conn_params[:dbname] = conn_params.delete(:database) if conn_params[:database]

# Forward only valid config params to PG::Connection.connect.
  valid_conn_param_keys = PG::Connection.conndefaults_hash.keys + [:requiressl]
  conn_params.slice!(*valid_conn_param_keys)

@connection_parameters = conn_params

@max_identifier_length = nil
  @type_map = nil
  @raw_connection = nil
  @notice_receiver_sql_warnings = []

@use_insert_returning = @config.key?(:insert_returning) ? self.class.type_cast_config_to_boolean(@config[:insert_returning]) : true
end
```

###  **new_client**(conn_params) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-c-new_client)
Source: [show](javascript:toggleSource\('method-c-new_client_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L57)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 57
def new_client(conn_params)
  PG.connect(**conn_params)
rescue ::PG::Error => error
  if conn_params  conn_params[:dbname] == "postgres"
    raise ActiveRecord::ConnectionNotEstablished, error.message
  elsif conn_params  conn_params[:dbname]  error.message.include?(conn_params[:dbname])
    raise ActiveRecord::NoDatabaseError.db_error(conn_params[:dbname])
  elsif conn_params  conn_params[:user]  error.message.include?(conn_params[:user])
    raise ActiveRecord::DatabaseConnectionError.username_error(conn_params[:user])
  elsif conn_params  conn_params[:host]  error.message.include?(conn_params[:host])
    raise ActiveRecord::DatabaseConnectionError.hostname_error(conn_params[:host])
  else
    raise ActiveRecord::ConnectionNotEstablished, error.message
  end
end
```

## Instance Public methods

###  **active?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-active-3F)
Is this connection alive and ready for queries?
Source: [show](javascript:toggleSource\('method-i-active-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L362)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 362
def active?
  @lock.synchronize do
    return false unless @raw_connection
    @raw_connection.query ";"
    verified!
  end
  true
rescue PG::Error
  false
end
```

###  **add_enum_value**(type_name, value, **options) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-add_enum_value)
Add enum value to an existing enum type.
Source: [show](javascript:toggleSource\('method-i-add_enum_value_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L603)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 603
def add_enum_value(type_name, value, **options)
  before, after = options.values_at(:before, :after)
  sql = +"ALTER TYPE #{quote_table_name(type_name)} ADD VALUE"
  sql << " IF NOT EXISTS" if options[:if_not_exists]
  sql << " #{quote(value)}"

if before  after
    raise ArgumentError, "Cannot have both :before and :after at the same time"
  elsif before
    sql << " BEFORE #{quote(before)}"
  elsif after
    sql << " AFTER #{quote(after)}"
  end

execute(sql).tap { reload_type_map }
end
```

###  **clear_cache!**(new_connection: false) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-clear_cache-21)
Source: [show](javascript:toggleSource\('method-i-clear_cache-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L398)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 398
def clear_cache!(new_connection: false)
  super
  @schema_search_path = nil if new_connection
end
```

###  **connected?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-connected-3F)
Source: [show](javascript:toggleSource\('method-i-connected-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L357)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 357
def connected?
  !(@raw_connection.nil? || @raw_connection.finished?)
end
```

###  **create_enum**(name, values, **options) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-create_enum)
Given a name and an array of values, creates an enum type.
Source: [show](javascript:toggleSource\('method-i-create_enum_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L556)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 556
      def create_enum(name, values, **options)
        sql_values = values.map { |s| quote(s) }.join(", ")
        scope = quoted_scope(name)
        query = <<~SQL
          DO $$
          BEGIN
              IF NOT EXISTS (
                SELECT 1
                FROM pg_type t
                JOIN pg_namespace n ON t.typnamespace = n.oid
                WHERE t.typname = #{scope[:name]}
                  AND n.nspname = #{scope[:schema]}
              ) THEN
                  CREATE TYPE #{quote_table_name(name)} AS ENUM (#{sql_values});
              END IF;
          END
          $$;
        SQL
        internal_exec_query(query).tap { reload_type_map }
      end
```

###  **disable_extension**(name, force: false) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-disable_extension)
Removes an extension from the database.

`:force`

Set to `:cascade` to drop dependent objects as well. Defaults to false.
Source: [show](javascript:toggleSource\('method-i-disable_extension_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L501)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 501
def disable_extension(name, force: false)
  _schema, name = name.to_s.split(".").values_at(-2, -1)
  internal_exec_query("DROP EXTENSION IF EXISTS \"#{name}\"#{' CASCADE' if force == :cascade}").tap {
    reload_type_map
  }
end
```

###  **disconnect!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-disconnect-21)
Disconnects from the database if already connected. Otherwise, this method does nothing.
Source: [show](javascript:toggleSource\('method-i-disconnect-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L405)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 405
def disconnect!
  @lock.synchronize do
    super
    @raw_connection&.close rescue nil
    @raw_connection = nil
  end
end
```

###  **drop_enum**(name, values = nil, **options) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-drop_enum)
Drops an enum type.
If the `if_exists: true` option is provided, the enum is dropped only if it exists. Otherwise, if the enum doesn’t exist, an error is raised.
The `values` parameter will be ignored if present. It can be helpful to provide this in a migration’s `change` method so it can be reverted. In that case, `values` will be used by [`create_enum`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-create_enum).
Source: [show](javascript:toggleSource\('method-i-drop_enum_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L586)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 586
      def drop_enum(name, values = nil, **options)
        query = <<~SQL
          DROP TYPE#{' IF EXISTS' if options[:if_exists]} #{quote_table_name(name)};
        SQL
        internal_exec_query(query).tap { reload_type_map }
      end
```

###  **enable_extension**(name, **) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-enable_extension)
Source: [show](javascript:toggleSource\('method-i-enable_extension_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L488)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 488
def enable_extension(name, **)
  schema, name = name.to_s.split(".").values_at(-2, -1)
  sql = +"CREATE EXTENSION IF NOT EXISTS \"#{name}\""
  sql << " SCHEMA #{schema}" if schema

internal_exec_query(sql).tap { reload_type_map }
end
```

###  **enum_types**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-enum_types)
Returns a list of defined enum types, and their values.
Source: [show](javascript:toggleSource\('method-i-enum_types_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L533)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 533
      def enum_types
        query = <<~SQL
          SELECT
            type.typname AS name,
            type.OID AS oid,
            n.nspname AS schema,
            array_agg(enum.enumlabel ORDER BY enum.enumsortorder) AS value
          FROM pg_enum AS enum
          JOIN pg_type AS type ON (type.oid = enum.enumtypid)
          JOIN pg_namespace n ON type.typnamespace = n.oid
          WHERE n.nspname = ANY (current_schemas(false))
          GROUP BY type.OID, n.nspname, type.typname;
        SQL

internal_exec_query(query, "SCHEMA", allow_retry: true, materialize_transactions: false).cast_values.each_with_object({}) do |row, memo|
          name, schema = row[0], row[2]
          schema = nil if schema == current_schema
          full_name = [schema, name].compact.join(".")
          memo[full_name] = row.last
        end.to_a
      end
```

###  **extension_available?**(name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-extension_available-3F)
Source: [show](javascript:toggleSource\('method-i-extension_available-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L508)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 508
def extension_available?(name)
  query_value("SELECT true FROM pg_available_extensions WHERE name = #{quote(name)}", "SCHEMA")
end
```

###  **extension_enabled?**(name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-extension_enabled-3F)
Source: [show](javascript:toggleSource\('method-i-extension_enabled-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L512)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 512
def extension_enabled?(name)
  query_value("SELECT installed_version IS NOT NULL FROM pg_available_extensions WHERE name = #{quote(name)}", "SCHEMA")
end
```

###  **extensions**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-extensions)
Source: [show](javascript:toggleSource\('method-i-extensions_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L516)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 516
      def extensions
        query = <<~SQL
          SELECT
            pg_extension.extname,
            n.nspname AS schema
          FROM pg_extension
          JOIN pg_namespace n ON pg_extension.extnamespace = n.oid
        SQL

internal_exec_query(query, "SCHEMA", allow_retry: true, materialize_transactions: false).cast_values.map do |row|
          name, schema = row[0], row[1]
          schema = nil if schema == current_schema
          [schema, name].compact.join(".")
        end
      end
```

###  **index_algorithms**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-index_algorithms)
Source: [show](javascript:toggleSource\('method-i-index_algorithms_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L301)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 301
def index_algorithms
  { concurrently: "CONCURRENTLY" }
end
```

###  **max_identifier_length**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-max_identifier_length)
Returns the configured maximum supported identifier length supported by PostgreSQL
Source: [show](javascript:toggleSource\('method-i-max_identifier_length_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L635)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 635
def max_identifier_length
  @max_identifier_length ||= query_value("SHOW max_identifier_length", "SCHEMA").to_i
end
```

###  **rename_enum**(name, new_name = nil, **options) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-rename_enum)
Rename an existing enum type to something else.
Source: [show](javascript:toggleSource\('method-i-rename_enum_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L594)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 594
def rename_enum(name, new_name = nil, **options)
  new_name ||= options.fetch(:to) do
    raise ArgumentError, "rename_enum requires two from/to name positional arguments."
  end

exec_query("ALTER TYPE #{quote_table_name(name)} RENAME TO #{quote_table_name(new_name)}").tap { reload_type_map }
end
```

###  **rename_enum_value**(type_name, **options) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-rename_enum_value)
Rename enum value on an existing enum type.
Source: [show](javascript:toggleSource\('method-i-rename_enum_value_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L621)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 621
def rename_enum_value(type_name, **options)
  unless database_version >= 10_00_00 # >= 10.0
    raise ArgumentError, "Renaming enum values is only supported in PostgreSQL 10 or later"
  end

from = options.fetch(:from) { raise ArgumentError, ":from is required" }
  to = options.fetch(:to) { raise ArgumentError, ":to is required" }

execute("ALTER TYPE #{quote_table_name(type_name)} RENAME VALUE #{quote(from)} TO #{quote(to)}").tap {
    reload_type_map
  }
end
```

###  **reset!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-reset-21)
Source: [show](javascript:toggleSource\('method-i-reset-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L385)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 385
def reset!
  @lock.synchronize do
    return connect! unless @raw_connection

unless @raw_connection.transaction_status == ::PG::PQTRANS_IDLE
      @raw_connection.query "ROLLBACK"
    end
    @raw_connection.query "DISCARD ALL"

super
  end
end
```

###  **session_auth=**(user) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-session_auth-3D)
Set the authorized user for this session
Source: [show](javascript:toggleSource\('method-i-session_auth-3D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L640)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 640
def session_auth=(user)
  clear_cache!
  internal_execute("SET SESSION AUTHORIZATION #{user}", nil, materialize_transactions: true)
end
```

###  **set_standard_conforming_strings**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-set_standard_conforming_strings)
Source: [show](javascript:toggleSource\('method-i-set_standard_conforming_strings_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L427)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 427
def set_standard_conforming_strings
  internal_execute("SET standard_conforming_strings = on", "SCHEMA")
end
```

###  **supports_advisory_locks?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_advisory_locks-3F)
Source: [show](javascript:toggleSource\('method-i-supports_advisory_locks-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L435)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 435
def supports_advisory_locks?
  true
end
```

###  **supports_bulk_alter?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_bulk_alter-3F)
Source: [show](javascript:toggleSource\('method-i-supports_bulk_alter-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L188)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 188
def supports_bulk_alter?
  true
end
```

###  **supports_check_constraints?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_check_constraints-3F)
Source: [show](javascript:toggleSource\('method-i-supports_check_constraints-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L220)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 220
def supports_check_constraints?
  true
end
```

###  **supports_comments?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_comments-3F)
Source: [show](javascript:toggleSource\('method-i-supports_comments-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L252)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 252
def supports_comments?
  true
end
```

###  **supports_common_table_expressions?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_common_table_expressions-3F)
Source: [show](javascript:toggleSource\('method-i-supports_common_table_expressions-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L466)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 466
def supports_common_table_expressions?
  true
end
```

###  **supports_datetime_with_precision?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_datetime_with_precision-3F)
Source: [show](javascript:toggleSource\('method-i-supports_datetime_with_precision-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L244)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 244
def supports_datetime_with_precision?
  true
end
```

###  **supports_ddl_transactions?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_ddl_transactions-3F)
Source: [show](javascript:toggleSource\('method-i-supports_ddl_transactions-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L431)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 431
def supports_ddl_transactions?
  true
end
```

###  **supports_deferrable_constraints?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_deferrable_constraints-3F)
Source: [show](javascript:toggleSource\('method-i-supports_deferrable_constraints-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L236)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 236
def supports_deferrable_constraints?
  true
end
```

###  **supports_exclusion_constraints?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_exclusion_constraints-3F)
Source: [show](javascript:toggleSource\('method-i-supports_exclusion_constraints-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L224)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 224
def supports_exclusion_constraints?
  true
end
```

###  **supports_explain?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_explain-3F)
Source: [show](javascript:toggleSource\('method-i-supports_explain-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L439)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 439
def supports_explain?
  true
end
```

###  **supports_expression_index?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_expression_index-3F)
Source: [show](javascript:toggleSource\('method-i-supports_expression_index-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L208)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 208
def supports_expression_index?
  true
end
```

###  **supports_extensions?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_extensions-3F)
Source: [show](javascript:toggleSource\('method-i-supports_extensions-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L443)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 443
def supports_extensions?
  true
end
```

###  **supports_foreign_keys?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_foreign_keys-3F)
Source: [show](javascript:toggleSource\('method-i-supports_foreign_keys-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L216)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 216
def supports_foreign_keys?
  true
end
```

###  **supports_foreign_tables?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_foreign_tables-3F)
Source: [show](javascript:toggleSource\('method-i-supports_foreign_tables-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L451)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 451
def supports_foreign_tables?
  true
end
```

###  **supports_index_include?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_index_include-3F)
Source: [show](javascript:toggleSource\('method-i-supports_index_include-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L204)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 204
def supports_index_include?
  database_version >= 11_00_00 # >= 11.0
end
```

###  **supports_index_sort_order?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_index_sort_order-3F)
Source: [show](javascript:toggleSource\('method-i-supports_index_sort_order-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L192)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 192
def supports_index_sort_order?
  true
end
```

###  **supports_insert_conflict_target?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_insert_conflict_target-3F)
Alias for: [supports_insert_on_conflict?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_insert_on_conflict-3F)

###  **supports_insert_on_conflict?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_insert_on_conflict-3F)
Also aliased as: [supports_insert_on_duplicate_skip?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_insert_on_duplicate_skip-3F), [supports_insert_on_duplicate_update?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_insert_on_duplicate_update-3F), [supports_insert_conflict_target?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_insert_conflict_target-3F)
Source: [show](javascript:toggleSource\('method-i-supports_insert_on_conflict-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L268)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 268
def supports_insert_on_conflict?
  database_version >= 9_05_00 # >= 9.5
end
```

###  **supports_insert_on_duplicate_skip?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_insert_on_duplicate_skip-3F)
Alias for: [supports_insert_on_conflict?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_insert_on_conflict-3F)

###  **supports_insert_on_duplicate_update?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_insert_on_duplicate_update-3F)
Alias for: [supports_insert_on_conflict?](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_insert_on_conflict-3F)

###  **supports_insert_returning?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_insert_returning-3F)
Source: [show](javascript:toggleSource\('method-i-supports_insert_returning-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L264)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 264
def supports_insert_returning?
  true
end
```

###  **supports_json?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_json-3F)
Source: [show](javascript:toggleSource\('method-i-supports_json-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L248)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 248
def supports_json?
  true
end
```

###  **supports_lazy_transactions?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_lazy_transactions-3F)
Source: [show](javascript:toggleSource\('method-i-supports_lazy_transactions-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L470)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 470
def supports_lazy_transactions?
  true
end
```

###  **supports_materialized_views?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_materialized_views-3F)
Source: [show](javascript:toggleSource\('method-i-supports_materialized_views-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L447)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 447
def supports_materialized_views?
  true
end
```

###  **supports_nulls_not_distinct?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_nulls_not_distinct-3F)
Source: [show](javascript:toggleSource\('method-i-supports_nulls_not_distinct-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L283)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 283
def supports_nulls_not_distinct?
  database_version >= 15_00_00 # >= 15.0
end
```

###  **supports_optimizer_hints?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_optimizer_hints-3F)
Source: [show](javascript:toggleSource\('method-i-supports_optimizer_hints-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L459)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 459
def supports_optimizer_hints?
  unless defined?(@has_pg_hint_plan)
    @has_pg_hint_plan = extension_available?("pg_hint_plan")
  end
  @has_pg_hint_plan
end
```

###  **supports_partial_index?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_partial_index-3F)
Source: [show](javascript:toggleSource\('method-i-supports_partial_index-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L200)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 200
def supports_partial_index?
  true
end
```

###  **supports_partitioned_indexes?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_partitioned_indexes-3F)
Source: [show](javascript:toggleSource\('method-i-supports_partitioned_indexes-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L196)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 196
def supports_partitioned_indexes?
  database_version >= 11_00_00 # >= 11.0
end
```

###  **supports_pgcrypto_uuid?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_pgcrypto_uuid-3F)
Source: [show](javascript:toggleSource\('method-i-supports_pgcrypto_uuid-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L455)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 455
def supports_pgcrypto_uuid?
  database_version >= 9_04_00 # >= 9.4
end
```

###  **supports_restart_db_transaction?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_restart_db_transaction-3F)
Source: [show](javascript:toggleSource\('method-i-supports_restart_db_transaction-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L260)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 260
def supports_restart_db_transaction?
  database_version >= 12_00_00 # >= 12.0
end
```

###  **supports_savepoints?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_savepoints-3F)
Source: [show](javascript:toggleSource\('method-i-supports_savepoints-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L256)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 256
def supports_savepoints?
  true
end
```

###  **supports_transaction_isolation?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_transaction_isolation-3F)
Source: [show](javascript:toggleSource\('method-i-supports_transaction_isolation-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L212)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 212
def supports_transaction_isolation?
  true
end
```

###  **supports_unique_constraints?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_unique_constraints-3F)
Source: [show](javascript:toggleSource\('method-i-supports_unique_constraints-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L228)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 228
def supports_unique_constraints?
  true
end
```

###  **supports_validate_constraints?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_validate_constraints-3F)
Source: [show](javascript:toggleSource\('method-i-supports_validate_constraints-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L232)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 232
def supports_validate_constraints?
  true
end
```

###  **supports_views?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_views-3F)
Source: [show](javascript:toggleSource\('method-i-supports_views-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L240)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 240
def supports_views?
  true
end
```

###  **supports_virtual_columns?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-supports_virtual_columns-3F)
Source: [show](javascript:toggleSource\('method-i-supports_virtual_columns-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L275)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 275
def supports_virtual_columns?
  database_version >= 12_00_00 # >= 12.0
end
```

###  **use_insert_returning?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-use_insert_returning-3F)
Source: [show](javascript:toggleSource\('method-i-use_insert_returning-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L645)

# File activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb, line 645
def use_insert_returning?
  @use_insert_returning
end
```