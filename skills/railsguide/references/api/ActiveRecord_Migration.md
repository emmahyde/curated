# Active Record Migrations
Migrations can manage the evolution of a schema used by several physical databases. It’s a solution to the common problem of adding a field to make a new feature work in your local database, but being unsure of how to push that change to other developers and to the production server. With migrations, you can describe the transformations in self-contained classes that can be checked into version control systems and executed against another database that might be one, two, or five versions behind.
Example of a simple migration:

```
class AddSsl  ActiveRecord::Migration[8.1]

add_column :accounts, :ssl_enabled, :boolean, default:

remove_column :accounts, :ssl_enabled

```

This migration will add a boolean flag to the accounts table and remove it if you’re backing out of the migration. It shows how all migrations have two methods `up` and `down` that describes the transformations required to implement or remove the migration. These methods can consist of both the migration specific methods like `add_column` and `remove_column`, but may also contain regular Ruby code for generating data needed for the transformations.
Example of a more complex migration that also needs to initialize data:

```
class AddSystemSettings  ActiveRecord::Migration[8.1]

create_table :system_settings  ||
      .string  :name
      .string  :label
      .text    :value
      .string  :type
      .integer :position

SystemSetting.create  name:  'notice',
                          label: 'Use notice?',
                          value:

drop_table :system_settings

This migration first adds the `system_settings` table, then creates the very first row in it using the Active Record model that relies on the table. It also uses the more advanced `create_table` syntax where you can specify a complete table schema in one block call.

## Available transformations

### Creation
  * `create_join_table(table_1, table_2, options)`: Creates a join table having its name as the lexical order of the first two arguments. See [`ActiveRecord::ConnectionAdapters::SchemaStatements#create_join_table`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-create_join_table) for details.
  * `create_table(name, options)`: Creates a table called `name` and makes the table object available to a block that can then add columns to it, following the same format as `add_column`. See example above. The options hash is for fragments like “DEFAULT CHARSET=UTF-8” that are appended to the create table definition.
  * `add_column(table_name, column_name, type, options)`: Adds a new column to the table called `table_name` named `column_name` specified to be one of the following types: `:string`, `:text`, `:integer`, `:float`, `:decimal`, `:datetime`, `:timestamp`, `:time`, `:date`, `:binary`, `:boolean`. A default value can be specified by passing an `options` hash like `{ default: 11 }`. Other options include `:limit` and `:null` (e.g. `{ limit: 50, null: false }`) – see [`ActiveRecord::ConnectionAdapters::TableDefinition#column`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html#method-i-column) for details.
  * `add_foreign_key(from_table, to_table, options)`: Adds a new foreign key. `from_table` is the table with the key column, `to_table` contains the referenced primary key.
  * `add_index(table_name, column_names, options)`: Adds a new index with the name of the column. Other options include `:name`, `:unique` (e.g. `{ name: 'users_name_index', unique: true }`) and `:order` (e.g. `{ order: { name: :desc } }`).
  * `add_reference(:table_name, :reference_name)`: Adds a new column `reference_name_id` by default an integer. See [`ActiveRecord::ConnectionAdapters::SchemaStatements#add_reference`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-add_reference) for details.
  * `add_timestamps(table_name, options)`: Adds timestamps (`created_at` and `updated_at`) columns to `table_name`.

### Modification
  * `change_column(table_name, column_name, type, options)`: Changes the column to a different type using the same parameters as add_column.
  * `change_column_default(table_name, column_name, default_or_changes)`: Sets a default value for `column_name` defined by `default_or_changes` on `table_name`. Passing a hash containing `:from` and `:to` as `default_or_changes` will make this change reversible in the migration.
  * `change_column_null(table_name, column_name, null, default = nil)`: Sets or removes a `NOT NULL` constraint on `column_name`. The `null` flag indicates whether the value can be `NULL`. See [`ActiveRecord::ConnectionAdapters::SchemaStatements#change_column_null`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-change_column_null) for details.
  * `change_table(name, options)`: Allows to make column alterations to the table called `name`. It makes the table object available to a block that can then add/remove columns, indexes, or foreign keys to it.
  * `rename_column(table_name, column_name, new_column_name)`: Renames a column but keeps the type and content.
  * `rename_index(table_name, old_name, new_name)`: Renames an index.
  * `rename_table(old_name, new_name)`: Renames the table called `old_name` to `new_name`.

### Deletion
  * `drop_table(*names)`: Drops the given tables.
  * `drop_join_table(table_1, table_2, options)`: Drops the join table specified by the given arguments.
  * `remove_column(table_name, column_name, type, options)`: Removes the column named `column_name` from the table called `table_name`.
  * `remove_columns(table_name, *column_names)`: Removes the given columns from the table definition.
  * `remove_foreign_key(from_table, to_table = nil, **options)`: Removes the given foreign key from the table called `table_name`.
  * `remove_index(table_name, column: column_names)`: Removes the index specified by `column_names`.
  * `remove_index(table_name, name: index_name)`: Removes the index specified by `index_name`.
  * `remove_reference(table_name, ref_name, options)`: Removes the reference(s) on `table_name` specified by `ref_name`.
  * `remove_timestamps(table_name, options)`: Removes the timestamp columns (`created_at` and `updated_at`) from the table definition.

## Irreversible transformations
Some transformations are destructive in a manner that cannot be reversed. Migrations of that kind should raise an [`ActiveRecord::IrreversibleMigration`](https://api.rubyonrails.org/classes/ActiveRecord/IrreversibleMigration.html) exception in their `down` method.

## Running migrations from within Rails
The Rails package has several tools to help create and apply migrations.
To generate a new migration, you can use

```
$ bin/rails generate migration MyNewMigration
```

where MyNewMigration is the name of your migration. The generator will create an empty migration file `timestamp_my_new_migration.rb` in the `db/migrate/` directory where `timestamp` is the UTC formatted date and time that the migration was generated.
There is a special syntactic shortcut to generate migrations that add fields to a table.

```
$ bin/rails generate migration add_fieldname_to_tablename fieldname:string
```

This will generate the file `timestamp_add_fieldname_to_tablename.rb`, which will look like this:

```
class AddFieldnameToTablename  ActiveRecord::Migration[8.1]
   change
    add_column :tablenames, :fieldname, :string

To run migrations against the currently configured database, use `bin/rails db:migrate`. This will update the database by running all of the pending migrations, creating the `schema_migrations` table (see “About the schema_migrations table” section below) if missing. It will also invoke the db:schema:dump command, which will update your db/schema.rb file to match the structure of your database.
To roll the database back to a previous migration version, use `bin/rails db:rollback VERSION=X` where `X` is the version to which you wish to downgrade. Alternatively, you can also use the STEP option if you wish to rollback last few migrations. `bin/rails db:rollback STEP=2` will rollback the latest two migrations.
If any of the migrations throw an [`ActiveRecord::IrreversibleMigration`](https://api.rubyonrails.org/classes/ActiveRecord/IrreversibleMigration.html) exception, that step will fail and you’ll have some manual work to do.

## More examples
Not all migrations change the schema. Some just fix the data:

```
class RemoveEmptyTags  ActiveRecord::Migration[8.1]

.. { || .destroy  .pages.empty? }

# not much we can do to restore deleted data
    raise ActiveRecord::IrreversibleMigration, "Can't recover the deleted tags"

Others remove columns when they migrate up instead of down:

```
class RemoveUnnecessaryItemAttributes  ActiveRecord::Migration[8.1]

remove_column :items, :incomplete_items_count
    remove_column :items, :completed_items_count

add_column :items, :incomplete_items_count
    add_column :items, :completed_items_count

And sometimes you need to do something in SQL not abstracted directly by migrations:

```
class MakeJoinUnique  ActiveRecord::Migration[8.1]

execute "ALTER TABLE `pages_linked_pages` ADD UNIQUE `page_id_linked_page_id` (`page_id`,`linked_page_id`)"

execute "ALTER TABLE `pages_linked_pages` DROP INDEX `page_id_linked_page_id`"

## Using a model after changing its table
Sometimes you’ll want to add a column in a migration and populate it immediately after. In that case, you’ll need to make a call to `Base#reset_column_information` in order to ensure that the model has the latest column data from after the new column was added. Example:

```
class AddPeopleSalary  ActiveRecord::Migration[8.1]

add_column :people, :salary, :integer
    Person.reset_column_information
    Person..  ||
      .update_attribute :salary, SalaryCalculator.compute()

## Controlling verbosity
By default, migrations will describe the actions they are taking, writing them to the console as they happen, along with benchmarks describing how long each step took.
You can quiet them down by setting `ActiveRecord::Migration.verbose = false`.
You can also insert your own messages and benchmarks by using the [`say_with_time`](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-say_with_time) method:

```
def up
  ...
  say_with_time "Updating salaries..."
    Person.all.each  |p|
      p.update_attribute :salary, SalaryCalculator.compute(p)

...

The phrase “Updating salaries…” would then be printed, along with the benchmark for the block when the block completes.

## Timestamped Migrations
By default, Rails generates migrations that look like:

```
20080717013526_your_migration_name.rb
```

The prefix is a generation timestamp (in UTC). Timestamps should not be modified manually. To validate that migration timestamps adhere to the format Active Record expects, you can use the following configuration option:

```
config.active_record.validate_migration_timestamps =

If you’d prefer to use numeric prefixes, you can turn timestamped migrations off by setting:

```
config.active_record.timestamped_migrations = false

In application.rb.

## Reversible Migrations
Reversible migrations are migrations that know how to go `down` for you. You simply supply the `up` logic, and the [`Migration`](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html) system figures out how to execute the down commands for you.
To define a reversible migration, define the `change` method in your migration like this:

```
class TenderloveMigration  ActiveRecord::Migration[8.1]
   change
    create_table(:horses)  ||
      .column :content, :text
      .column :remind_at, :datetime

This migration will create the horses table for you on the way up, and automatically figure out how to drop the table on the way down.
Some commands cannot be reversed. If you care to define how to move up and down in these cases, you should define the `up` and `down` methods as before.
If a command cannot be reversed, an [`ActiveRecord::IrreversibleMigration`](https://api.rubyonrails.org/classes/ActiveRecord/IrreversibleMigration.html) exception will be raised when the migration is moving down.
For a list of commands that are reversible, please see [`ActiveRecord::Migration::CommandRecorder`](https://api.rubyonrails.org/classes/ActiveRecord/Migration/CommandRecorder.html).

## Transactional Migrations
If the database adapter supports DDL transactions, all migrations will automatically be wrapped in a transaction. There are queries that you can’t execute inside a transaction though, and for these situations you can turn the automatic transactions off.

```
class ChangeEnum  ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

execute "ALTER TYPE model_size ADD VALUE 'new_value'"

Remember that you can still open your own transactions, even if you are in a [`Migration`](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html) with `self.disable_ddl_transaction!`.
Namespace
  * MODULE [ActiveRecord::Migration::Compatibility](https://api.rubyonrails.org/classes/ActiveRecord/Migration/Compatibility.html)
  * CLASS [ActiveRecord::Migration::CheckPending](https://api.rubyonrails.org/classes/ActiveRecord/Migration/CheckPending.html)
  * CLASS [ActiveRecord::Migration::CommandRecorder](https://api.rubyonrails.org/classes/ActiveRecord/Migration/CommandRecorder.html)

Methods

#

A

C

D

* disable_ddl_transaction!,

E

L

* load_schema_if_pending!

M

N

P

R

S

U

V

W

## Attributes
|  [RW]   | name  |
| --- | --- |
|  [RW]   | version  |

## Class Public methods

###  **[]**(version) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-c-5B-5D)
Source: [show](javascript:toggleSource\('method-c-5B-5D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L629)

# File activerecord/lib/active_record/migration.rb, line 629
def self.[](version)
  Compatibility.find(version)
end
```

###  **check_all_pending!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-c-check_all_pending-21)
Raises ActiveRecord::PendingMigrationError error if any migrations are pending for all database configurations in an environment.
Source: [show](javascript:toggleSource\('method-c-check_all_pending-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L693)

# File activerecord/lib/active_record/migration.rb, line 693
def check_all_pending!
  pending_migrations = []

ActiveRecord::Tasks::DatabaseTasks.with_temporary_pool_for_each(env: env) do |pool|
    if pending = pool.migration_context.open.pending_migrations
      pending_migrations << pending
    end
  end

migrations = pending_migrations.flatten

if migrations.any?
    raise ActiveRecord::PendingMigrationError.new(pending_migrations: migrations)
  end
end
```

###  **current_version**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-c-current_version)
Source: [show](javascript:toggleSource\('method-c-current_version_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L633)

# File activerecord/lib/active_record/migration.rb, line 633
def self.current_version
  ActiveRecord::VERSION::STRING.to_f
end
```

###  **disable_ddl_transaction!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-c-disable_ddl_transaction-21)
Disable the transaction wrapping this migration. You can still create your own transactions even after calling disable_ddl_transaction!
For more details read the [“Transactional Migrations” section above](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html).
Source: [show](javascript:toggleSource\('method-c-disable_ddl_transaction-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L735)

# File activerecord/lib/active_record/migration.rb, line 735
def disable_ddl_transaction!
  @disable_ddl_transaction = true
end
```

###  **load_schema_if_pending!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-c-load_schema_if_pending-21)
Source: [show](javascript:toggleSource\('method-c-load_schema_if_pending-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L709)

# File activerecord/lib/active_record/migration.rb, line 709
def load_schema_if_pending!
  if any_schema_needs_update?
    load_schema!
  end

check_pending_migrations
end
```

###  **migrate**(direction) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-c-migrate)
Source: [show](javascript:toggleSource\('method-c-migrate_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L727)

# File activerecord/lib/active_record/migration.rb, line 727
def migrate(direction)
  new.migrate direction
end
```

###  **new**(name = self.class.name, version = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-c-new)
Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L805)

# File activerecord/lib/active_record/migration.rb, line 805
def initialize(name = self.class.name, version = nil)
  @name       = name
  @version    = version
  @connection = nil
  @pool       = nil
end
```

###  **verbose** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-c-verbose)
Specifies if migrations will write the actions they are taking to the console as they happen, along with benchmarks describing how long each step took. Defaults to true.
Source: [show](javascript:toggleSource\('method-c-verbose_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L802)

# File activerecord/lib/active_record/migration.rb, line 802
cattr_accessor :verbose

## Instance Public methods

###  **announce**(message) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-announce)
Source: [show](javascript:toggleSource\('method-i-announce_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L1010)

# File activerecord/lib/active_record/migration.rb, line 1010
def announce(message)
  text = "#{version} #{name}: #{message}"
  length = [0, 75 - text.length].max
  write "== %s %s" % [text, "=" * length]
end
```

###  **connection**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-connection)
Source: [show](javascript:toggleSource\('method-i-connection_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L1041)

# File activerecord/lib/active_record/migration.rb, line 1041
def connection
  @connection || ActiveRecord::Tasks::DatabaseTasks.migration_connection
end
```

###  **connection_pool**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-connection_pool)
Source: [show](javascript:toggleSource\('method-i-connection_pool_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L1045)

# File activerecord/lib/active_record/migration.rb, line 1045
def connection_pool
  @pool || ActiveRecord::Tasks::DatabaseTasks.migration_connection_pool
end
```

###  **copy**(destination, sources, options = {}) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-copy)
Source: [show](javascript:toggleSource\('method-i-copy_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L1066)

# File activerecord/lib/active_record/migration.rb, line 1066
def copy(destination, sources, options = {})
  copied = []

FileUtils.mkdir_p(destination) unless File.exist?(destination)
  schema_migration = SchemaMigration::NullSchemaMigration.new
  internal_metadata = InternalMetadata::NullInternalMetadata.new

destination_migrations = ActiveRecord::MigrationContext.new(destination, schema_migration, internal_metadata).migrations
  last = destination_migrations.last
  sources.each do |scope, path|
    source_migrations = ActiveRecord::MigrationContext.new(path, schema_migration, internal_metadata).migrations

source_migrations.each do |migration|
      source = File.binread(migration.filename)
      inserted_comment = "# This migration comes from #{scope} (originally #{migration.version})\n"
      magic_comments = +""
      loop do
        # If we have a magic comment in the original migration,
        # insert our comment after the first newline(end of the magic comment line)
        # so the magic keep working.
        # Note that magic comments must be at the first line(except sh-bang).
        source.sub!(/\A(?:#.*\b(?:en)?coding:\s*\S+|#\s*frozen_string_literal:\s*(?:true|false)).*\n/) do |magic_comment|
          magic_comments << magic_comment; ""
        end || break
      end

if !magic_comments.empty?  source.start_with?("\n")
        magic_comments << "\n"
        source = source[1..-1]
      end

source = "#{magic_comments}#{inserted_comment}#{source}"

if duplicate = destination_migrations.detect { |m| m.name == migration.name }
        if options[:on_skip]  duplicate.scope != scope.to_s
          options[:on_skip].call(scope, migration)
        end
        next
      end

migration.version = next_migration_number(last ? last.version + 1 : 0).to_i
      new_path = File.join(destination, "#{migration.version}_#{migration.name.underscore}.#{scope}.rb")
      old_path, migration.filename = migration.filename, new_path
      last = migration

File.binwrite(migration.filename, source)
      copied << migration
      options[:on_copy].call(scope, migration, old_path) if options[:on_copy]
      destination_migrations << migration
    end
  end

copied
end
```

###  **down**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-down)
Source: [show](javascript:toggleSource\('method-i-down_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L962)

# File activerecord/lib/active_record/migration.rb, line 962
def down
  self.class.delegate = self
  return unless self.class.respond_to?(:down)
  self.class.down
end
```

###  **exec_migration**(conn, direction) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-exec_migration)
Source: [show](javascript:toggleSource\('method-i-exec_migration_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L990)

# File activerecord/lib/active_record/migration.rb, line 990
def exec_migration(conn, direction)
  @connection = conn
  if respond_to?(:change)
    if direction == :down
      revert { change }
    else
      change
    end
  else
    public_send(direction)
  end
ensure
  @connection = nil
  @execution_strategy = nil
end
```

###  **execution_strategy**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-execution_strategy)
Source: [show](javascript:toggleSource\('method-i-execution_strategy_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L812)

# File activerecord/lib/active_record/migration.rb, line 812
def execution_strategy
  @execution_strategy ||= ActiveRecord.migration_strategy.new(self)
end
```

###  **method_missing**(method, *arguments, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-method_missing)
Source: [show](javascript:toggleSource\('method-i-method_missing_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L1049)

# File activerecord/lib/active_record/migration.rb, line 1049
def method_missing(method, *arguments, block)
  say_with_time "#{method}(#{format_arguments(arguments)})" do
    unless connection.respond_to? :revert
      unless arguments.empty? || [:execute, :enable_extension, :disable_extension].include?(method)
        arguments[0] = proper_table_name(arguments.first, table_name_options)
        if method == :rename_table ||
          (method == :remove_foreign_key  !arguments.second.is_a?(Hash))
          arguments[1] = proper_table_name(arguments.second, table_name_options)
        end
      end
    end
    return super unless execution_strategy.respond_to?(method)
    execution_strategy.send(method, *arguments, block)
  end
end
```

###  **migrate**(direction) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-migrate)
Execute this migration in the named direction
Source: [show](javascript:toggleSource\('method-i-migrate_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L969)

# File activerecord/lib/active_record/migration.rb, line 969
def migrate(direction)
  return unless respond_to?(direction)

case direction
  when :up   then announce "migrating"
  when :down then announce "reverting"
  end

time_elapsed = nil
  ActiveRecord::Tasks::DatabaseTasks.migration_connection.pool.with_connection do |conn|
    time_elapsed = ActiveSupport::Benchmark.realtime do
      exec_migration(conn, direction)
    end
  end

case direction
  when :up   then announce "migrated (%.4fs)" % time_elapsed; write
  when :down then announce "reverted (%.4fs)" % time_elapsed; write
  end
end
```

###  **next_migration_number**(number) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-next_migration_number)
Determines the version number of the next migration.
Source: [show](javascript:toggleSource\('method-i-next_migration_number_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L1133)

# File activerecord/lib/active_record/migration.rb, line 1133
def next_migration_number(number)
  if ActiveRecord.timestamped_migrations
    [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % number].max
  else
    "%.3d" % number.to_i
  end
end
```

###  **proper_table_name**(name, options = {}) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-proper_table_name)
Finds the correct table name given an Active Record object. Uses the Active Record object’s own table_name, or pre/suffix from the options passed in.
Source: [show](javascript:toggleSource\('method-i-proper_table_name_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L1124)

# File activerecord/lib/active_record/migration.rb, line 1124
def proper_table_name(name, options = {})
  if name.respond_to? :table_name
    name.table_name
  else
    "#{options[:table_name_prefix]}#{name}#{options[:table_name_suffix]}"
  end
end
```

###  **reversible**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-reversible)
Used to specify an operation that can be run in one direction or another. Call the methods `up` and `down` of the yielded object to run a block only in one given direction. The whole block will be called in the right order within the migration.
In the following example, the looping on users will always be done when the three columns ‘first_name’, ‘last_name’ and ‘full_name’ exist, even when migrating down:

```
class SplitNameMigration  ActiveRecord::Migration[8.1]
   change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

reversible  ||
      User.reset_column_information
      User..  ||
        .   { .first_name, .last_name = .full_name.split() }
        .down { .full_name = "#{u.first_name} #{u.last_name}" }
        .save

revert { add_column :users, :full_name, :string }

Source: [show](javascript:toggleSource\('method-i-reversible_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L914)

# File activerecord/lib/active_record/migration.rb, line 914
def reversible
  helper = ReversibleBlockHelper.new(reverting?)
  execute_block { yield helper }
end
```

###  **revert**(*migration_classes, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-revert)
Reverses the migration commands for the given block and the given migrations.
The following migration will remove the table ‘horses’ and create the table ‘apples’ on the way up, and the reverse on the way down.

```
class FixTLMigration  ActiveRecord::Migration[8.1]
   change
    revert
      create_table(:horses)  ||
        .text :content
        .datetime :remind_at

create_table(:apples)  ||
      .string :variety

Or equivalently, if `TenderloveMigration` is defined as in the documentation for Migration:

```
require_relative "20121212123456_tenderlove_migration"

class FixupTLMigration  ActiveRecord::Migration[8.1]
   change
    revert TenderloveMigration

This command can be nested.
Source: [show](javascript:toggleSource\('method-i-revert_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L857)

# File activerecord/lib/active_record/migration.rb, line 857
def revert(*migration_classes, block)
  run(*migration_classes.reverse, revert: true) unless migration_classes.empty?
  if block_given?
    if connection.respond_to? :revert
      connection.revert(block)
    else
      recorder = command_recorder
      @connection = recorder
      suppress_messages do
        connection.revert(block)
      end
      @connection = recorder.delegate
      recorder.replay(self)
    end
  end
end
```

###  **reverting?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-reverting-3F)
Source: [show](javascript:toggleSource\('method-i-reverting-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L874)

# File activerecord/lib/active_record/migration.rb, line 874
def reverting?
  connection.respond_to?(:reverting)  connection.reverting
end
```

###  **run**(*migration_classes) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-run)
Runs the given migration classes. Last argument can specify options:
  * `:direction` - Default is `:up`.
  * `:revert` - Default is `false`.

Source: [show](javascript:toggleSource\('method-i-run_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L942)

# File activerecord/lib/active_record/migration.rb, line 942
def run(*migration_classes)
  opts = migration_classes.extract_options!
  dir = opts[:direction] || :up
  dir = (dir == :down ? :up : :down) if opts[:revert]
  if reverting?
    # If in revert and going :up, say, we want to execute :down without reverting, so
    revert { run(*migration_classes, direction: dir, revert: true) }
  else
    migration_classes.each do |migration_class|
      migration_class.new.exec_migration(connection, dir)
    end
  end
end
```

###  **say**(message, subitem = false) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-say)
Takes a message argument and outputs it as is. A second boolean argument can be passed to specify whether to indent or not.
Source: [show](javascript:toggleSource\('method-i-say_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L1018)

# File activerecord/lib/active_record/migration.rb, line 1018
def say(message, subitem = false)
  write "#{subitem ? "   ->" : "--"} #{message}"
end
```

###  **say_with_time**(message) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-say_with_time)
Outputs text along with how long it took to run its block. If the block returns an integer it assumes it is the number of rows affected.
Source: [show](javascript:toggleSource\('method-i-say_with_time_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L1024)

# File activerecord/lib/active_record/migration.rb, line 1024
def say_with_time(message)
  say(message)
  result = nil
  time_elapsed = ActiveSupport::Benchmark.realtime { result = yield }
  say "%.4fs" % time_elapsed, :subitem
  say("#{result} rows", :subitem) if result.is_a?(Integer)
  result
end
```

###  **suppress_messages**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-suppress_messages)
Takes a block as an argument and suppresses any output generated by the block.
Source: [show](javascript:toggleSource\('method-i-suppress_messages_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L1034)

# File activerecord/lib/active_record/migration.rb, line 1034
def suppress_messages
  save, self.verbose = verbose, false
  yield
ensure
  self.verbose = save
end
```

###  **up**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-up)
Source: [show](javascript:toggleSource\('method-i-up_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L956)

# File activerecord/lib/active_record/migration.rb, line 956
def up
  self.class.delegate = self
  return unless self.class.respond_to?(:up)
  self.class.up
end
```

###  **up_only**(&block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-up_only)
Used to specify an operation that is only run when migrating up (for example, populating a new column with its initial values).
In the following example, the new column `published` will be given the value `true` for all existing records.

```
class AddPublishedToPosts  ActiveRecord::Migration[8.1]
   change
    add_column :posts, :published, :boolean, default: false
    up_only
      execute "update posts set published = 'true'"

Source: [show](javascript:toggleSource\('method-i-up_only_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L933)

# File activerecord/lib/active_record/migration.rb, line 933
def up_only(block)
  execute_block(block) unless reverting?
end
```

###  **write**(text = "") [Link](https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#method-i-write)
Source: [show](javascript:toggleSource\('method-i-write_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/migration.rb#L1006)

# File activerecord/lib/active_record/migration.rb, line 1006
def write(text = "")
  puts(text) if verbose
end
```