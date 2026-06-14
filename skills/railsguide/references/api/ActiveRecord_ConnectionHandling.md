# Active Record Connection Handling
Methods

C

* clear_query_caches_for_current_thread,
  * connection_specification_name,

E

L

P

* prohibit_shard_swapping

R

S

* shard_swapping_prohibited?,

W

## Constants
| DEFAULT_ENV  | =  | -> { RAILS_ENV.call || "default_env" }  |
| --- | --- | --- |
| RAILS_ENV  | =  | -> { (Rails.env if defined?(Rails.env)) || ENV["RAILS_ENV"].presence || ENV["RACK_ENV"].presence }  |

## Attributes
|  [W]   | connection_specification_name  |
| --- | --- |

## Instance Public methods

###  **clear_query_caches_for_current_thread**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-clear_query_caches_for_current_thread)
Clears the query cache for all connections associated with the current thread.
Source: [show](javascript:toggleSource\('method-i-clear_query_caches_for_current_thread_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L261)

```

# File activerecord/lib/active_record/connection_handling.rb, line 261
def clear_query_caches_for_current_thread
  connection_handler.each_connection_pool do |pool|
    pool.clear_query_cache
  end
end
```

###  **connected?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected-3F)
Returns `true` if Active Record is connected.
Source: [show](javascript:toggleSource\('method-i-connected-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L354)

# File activerecord/lib/active_record/connection_handling.rb, line 354
def connected?
  connection_handler.connected?(connection_specification_name, role: current_role, shard: current_shard)
end
```

###  **connected_to**(role: nil, shard: nil, prevent_writes: false, &blk) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to)
Connects to a role (e.g. writing, reading, or a custom role) and/or shard for the duration of the block. At the end of the block the connection will be returned to the original role / shard.
If only a role is passed, Active Record will look up the connection based on the requested role. If a non-established role is requested an [`ActiveRecord::ConnectionNotEstablished`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionNotEstablished.html) error will be raised:

```
ActiveRecord::Base.connected_to(role: :writing)
  .create! # creates dog using dog writing connection

ActiveRecord::Base.connected_to(role: :reading)
  .create! # throws exception because we're on a replica

When swapping to a shard, the role must be passed as well. If a non-existent shard is passed, an [`ActiveRecord::ConnectionNotEstablished`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionNotEstablished.html) error will be raised.
When a shard and role is passed, Active Record will first lookup the role, and then look up the connection by shard key.

```
ActiveRecord::Base.connected_to(role: :reading, shard: :shard_one_replica)
  .first # finds first Dog record stored on the shard one replica

Source: [show](javascript:toggleSource\('method-i-connected_to_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L137)

# File activerecord/lib/active_record/connection_handling.rb, line 137
def connected_to(role: nil, shard: nil, prevent_writes: false, blk)
  if self != Base  !abstract_class
    raise NotImplementedError, "calling `connected_to` is only allowed on ActiveRecord::Base or abstract classes."
  end

if !connection_class?  !primary_class?
    raise NotImplementedError, "calling `connected_to` is only allowed on the abstract class that established the connection."
  end

unless role || shard
    raise ArgumentError, "must provide a `shard` and/or `role`."
  end

with_role_and_shard(role, shard, prevent_writes, blk)
end
```

###  **connected_to?**(role:, shard: ActiveRecord::Base.default_shard) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to-3F)
Returns true if role is the current connected role and/or current connected shard. If no shard is passed, the default will be used.

```
ActiveRecord::Base.connected_to(role: :writing)
  ActiveRecord::Base.connected_to?(role: :writing) #=> true
  ActiveRecord::Base.connected_to?(role: :reading) #=> false

ActiveRecord::Base.connected_to(role: :reading, shard: :shard_one)
  ActiveRecord::Base.connected_to?(role: :reading, shard: :shard_one) #=> true
  ActiveRecord::Base.connected_to?(role: :reading, shard: :default) #=> false
  ActiveRecord::Base.connected_to?(role: :writing, shard: :shard_one) #=> true

Source: [show](javascript:toggleSource\('method-i-connected_to-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L256)

# File activerecord/lib/active_record/connection_handling.rb, line 256
def connected_to?(role:, shard: ActiveRecord::Base.default_shard)
  current_role == role.to_sym  current_shard == shard.to_sym
end
```

###  **connected_to_all_shards**(role: nil, prevent_writes: false, &blk) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to_all_shards)
Passes the block to [`connected_to`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to) for every `shard` the model is configured to connect to (if any), and returns the results in an array.
Optionally, `role` and/or `prevent_writes` can be passed which will be forwarded to each [`connected_to`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to) call.
Source: [show](javascript:toggleSource\('method-i-connected_to_all_shards_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L189)

# File activerecord/lib/active_record/connection_handling.rb, line 189
def connected_to_all_shards(role: nil, prevent_writes: false, blk)
  shard_keys.map do |shard|
    connected_to(shard: shard, role: role, prevent_writes: prevent_writes, blk)
  end
end
```

###  **connected_to_many**(*classes, role:, shard: nil, prevent_writes: false) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to_many)
Connects a role and/or shard to the provided connection names. Optionally `prevent_writes` can be passed to block writes on a connection. `reading` will automatically set `prevent_writes` to true.
[`connected_to_many`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to_many) is an alternative to deeply nested [`connected_to`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to) blocks.
Usage:

```
ActiveRecord::Base.connected_to_many(AnimalsRecord, MealsRecord, role: :reading)
  .first # Read from animals replica
  Dinner.first # Read from meals replica
  Person.first # Read from primary writer

Source: [show](javascript:toggleSource\('method-i-connected_to_many_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L166)

# File activerecord/lib/active_record/connection_handling.rb, line 166
def connected_to_many(*classes, role:, shard: nil, prevent_writes: false)
  classes = classes.flatten

if self != Base || classes.include?(Base)
    raise NotImplementedError, "connected_to_many can only be called on ActiveRecord::Base."
  end

prevent_writes = true if role == ActiveRecord.reading_role

append_to_connected_to_stack(role: role, shard: shard, prevent_writes: prevent_writes, klasses: classes)
  begin
    yield
  ensure
    connected_to_stack.pop
  end
end
```

###  **connecting_to**(role: default_role, shard: default_shard, prevent_writes: false) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connecting_to)
Use a specified connection.
This method is useful for ensuring that a specific connection is being used. For example, when booting a console in readonly mode.
It is not recommended to use this method in a request since it does not yield to a block like [`connected_to`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to).
Source: [show](javascript:toggleSource\('method-i-connecting_to_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L202)

# File activerecord/lib/active_record/connection_handling.rb, line 202
def connecting_to(role: default_role, shard: default_shard, prevent_writes: false)
  prevent_writes = true if role == ActiveRecord.reading_role

append_to_connected_to_stack(role: role, shard: shard, prevent_writes: prevent_writes, klasses: [self])
end
```

###  **connection**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connection)
Soft deprecated. Use [`with_connection`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-with_connection) or [`lease_connection`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-lease_connection) instead.
Source: [show](javascript:toggleSource\('method-i-connection_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L277)

# File activerecord/lib/active_record/connection_handling.rb, line 277
    def connection
      pool = connection_pool
      if pool.permanent_lease?
        case ActiveRecord.permanent_connection_checkout
        when :deprecated
          ActiveRecord.deprecator.warn <<~MESSAGE
            Called deprecated `ActiveRecord::Base.connection` method.

Either use `with_connection` or `lease_connection`.
          MESSAGE
        when :disallowed
          raise ActiveRecordError, <<~MESSAGE
            Called deprecated `ActiveRecord::Base.connection` method.

Either use `with_connection` or `lease_connection`.
          MESSAGE
        end
        pool.lease_connection
      else
        pool.active_connection
      end
    end
```

###  **connection_db_config**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connection_db_config)
Returns the db_config object from the associated connection:

```
ActiveRecord::Base.connection_db_config
  #<ActiveRecord::DatabaseConfigurations::HashConfig:0x00007fd1acbded10 @env_name="development",
    @name="primary", @config={pool: 5, timeout: 5000, database: "storage/development.sqlite3", adapter: "sqlite3"}>
```

Use only for reading.
Source: [show](javascript:toggleSource\('method-i-connection_db_config_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L337)

# File activerecord/lib/active_record/connection_handling.rb, line 337
def connection_db_config
  connection_pool.db_config
end
```

###  **connection_pool**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connection_pool)
Source: [show](javascript:toggleSource\('method-i-connection_pool_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L345)

# File activerecord/lib/active_record/connection_handling.rb, line 345
def connection_pool
  connection_handler.retrieve_connection_pool(connection_specification_name, role: current_role, shard: current_shard, strict: true)
end
```

###  **connection_specification_name**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connection_specification_name)
Returns the connection specification name from the current class or its parent.
Source: [show](javascript:toggleSource\('method-i-connection_specification_name_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L319)

# File activerecord/lib/active_record/connection_handling.rb, line 319
def connection_specification_name
  if @connection_specification_name.nil?
    return self == Base ? Base.name : superclass.connection_specification_name
  end
  @connection_specification_name
end
```

###  **connects_to**(database: {}, shards: {}) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connects_to)
Connects a model to the databases specified. The `database` keyword takes a hash consisting of a `role` and a `database_key`.
This will look up the database config using the `database_key` and establish a connection to that config.

```
class AnimalsModel  ApplicationRecord
  .abstract_class =

connects_to database: { writing: :primary, reading: :primary_replica }

[`connects_to`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connects_to) also supports horizontal sharding. The horizontal sharding API supports read replicas as well. You can connect a model to a list of shards like this:

connects_to shards: {
    default: { writing: :primary, reading: :primary_replica },
    shard_two: { writing: :primary_shard_two, reading: :primary_shard_replica_two }
  }

Returns an array of database connections.
Source: [show](javascript:toggleSource\('method-i-connects_to_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L81)

# File activerecord/lib/active_record/connection_handling.rb, line 81
def connects_to(database: {}, shards: {})
  raise NotImplementedError, "`connects_to` can only be called on ActiveRecord::Base or abstract classes" unless self == Base || abstract_class?

if database.present?  shards.present?
    raise ArgumentError, "`connects_to` can only accept a `database` or `shards` argument, but not both arguments."
  end

connections = []

@shard_keys = shards.keys

if shards.empty?
    shards[:default] = database
  end

self.default_shard = shards.keys.first

shards.each do |shard, database_keys|
    database_keys.each do |role, database_key|
      db_config = resolve_config_for_connection(database_key)

self.connection_class = true
      shard = shard.to_sym unless shard.is_a? Integer
      connections << connection_handler.establish_connection(db_config, owner_name: self, role: role, shard: shard)
    end
  end

connections
end
```

###  **establish_connection**(config_or_env = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-establish_connection)
Establishes the connection to the database. Accepts a hash as input where the `:adapter` key must be specified with the name of a database adapter (in lower-case) example for regular databases (MySQL, PostgreSQL, etc):

```
ActiveRecord::Base.establish_connection(
  adapter:  "mysql2",
  host:     "localhost",
  username: "myuser",
  password: "mypass",
  database: "somedatabase"
)

Example for SQLite database:

```
ActiveRecord::Base.establish_connection(
  adapter:  "sqlite3",
  database: "path/to/dbfile"
)

Also accepts keys as strings (for parsing from YAML for example):

```
ActiveRecord::Base.establish_connection(
  "adapter"  => "sqlite3",
  "database" => "path/to/dbfile"
)

Or a URL:

```
ActiveRecord::Base.establish_connection(
  "postgres://myuser:mypass@localhost/somedatabase"
)

In case [ActiveRecord::Base.configurations](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-configurations) is set (Rails automatically loads the contents of config/database.yml into it), a symbol can also be given as argument, representing a key in the configuration hash:

```
ActiveRecord::Base.establish_connection(:production)

The exceptions [`AdapterNotSpecified`](https://api.rubyonrails.org/classes/ActiveRecord/AdapterNotSpecified.html), [`AdapterNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/AdapterNotFound.html), and `ArgumentError` may be returned on an error.
Source: [show](javascript:toggleSource\('method-i-establish_connection_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L50)

# File activerecord/lib/active_record/connection_handling.rb, line 50
def establish_connection(config_or_env = nil)
  config_or_env ||= DEFAULT_ENV.call.to_sym
  db_config = resolve_config_for_connection(config_or_env)
  connection_handler.establish_connection(db_config, owner_name: self, role: current_role, shard: current_shard)
end
```

###  **lease_connection**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-lease_connection)
Returns the connection currently associated with the class. This can also be used to “borrow” the connection to do database work unrelated to any of the specific Active Records. The connection will remain leased for the entire duration of the request or job, or until [`release_connection`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-release_connection) is called.
Source: [show](javascript:toggleSource\('method-i-lease_connection_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L272)

# File activerecord/lib/active_record/connection_handling.rb, line 272
def lease_connection
  connection_pool.lease_connection
end
```

###  **prohibit_shard_swapping**(enabled = true) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-prohibit_shard_swapping)
Prohibit swapping shards while inside of the passed block.
In some cases you may want to be able to swap shards but not allow a nested call to [`connected_to`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to) or [`connected_to_many`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connected_to_many) to swap again. This is useful in cases you’re using sharding to provide per-request database isolation.
Source: [show](javascript:toggleSource\('method-i-prohibit_shard_swapping_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L214)

# File activerecord/lib/active_record/connection_handling.rb, line 214
def prohibit_shard_swapping(enabled = true)
  prev_value = ActiveSupport::IsolatedExecutionState[:active_record_prohibit_shard_swapping]
  ActiveSupport::IsolatedExecutionState[:active_record_prohibit_shard_swapping] = enabled
  yield
ensure
  ActiveSupport::IsolatedExecutionState[:active_record_prohibit_shard_swapping] = prev_value
end
```

###  **release_connection**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-release_connection)
Return the currently leased connection into the pool
Source: [show](javascript:toggleSource\('method-i-release_connection_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L301)

# File activerecord/lib/active_record/connection_handling.rb, line 301
def release_connection
  connection_pool.release_connection
end
```

###  **remove_connection**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-remove_connection)
Source: [show](javascript:toggleSource\('method-i-remove_connection_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L358)

# File activerecord/lib/active_record/connection_handling.rb, line 358
def remove_connection
  name = @connection_specification_name if defined?(@connection_specification_name)

# if removing a connection that has a pool, we reset the

# connection_specification_name so it will use the parent

# pool.
  if connection_handler.retrieve_connection_pool(name, role: current_role, shard: current_shard)
    self.connection_specification_name = nil
  end

connection_handler.remove_connection_pool(name, role: current_role, shard: current_shard)
end
```

###  **retrieve_connection**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-retrieve_connection)
Source: [show](javascript:toggleSource\('method-i-retrieve_connection_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L349)

# File activerecord/lib/active_record/connection_handling.rb, line 349
def retrieve_connection
  connection_handler.retrieve_connection(connection_specification_name, role: current_role, shard: current_shard)
end
```

###  **shard_keys**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-shard_keys)
Source: [show](javascript:toggleSource\('method-i-shard_keys_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L379)

# File activerecord/lib/active_record/connection_handling.rb, line 379
def shard_keys
  connection_class_for_self.instance_variable_get(:@shard_keys) || []
end
```

###  **shard_swapping_prohibited?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-shard_swapping_prohibited-3F)
Determine whether or not shard swapping is currently prohibited
Source: [show](javascript:toggleSource\('method-i-shard_swapping_prohibited-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L223)

# File activerecord/lib/active_record/connection_handling.rb, line 223
def shard_swapping_prohibited?
  ActiveSupport::IsolatedExecutionState[:active_record_prohibit_shard_swapping]
end
```

###  **sharded?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-sharded-3F)
Source: [show](javascript:toggleSource\('method-i-sharded-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L383)

# File activerecord/lib/active_record/connection_handling.rb, line 383
def sharded?
  shard_keys.any?
end
```

###  **while_preventing_writes**(enabled = true, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-while_preventing_writes)
Prevent writing to the database regardless of role.
In some cases you may want to prevent writes to the database even if you are on a database that can write. [`while_preventing_writes`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-while_preventing_writes) will prevent writes to the database for the duration of the block.
This method does not provide the same protection as a readonly user and is meant to be a safeguard against accidental writes.
See `READ_QUERY` for the queries that are blocked by this method.
Source: [show](javascript:toggleSource\('method-i-while_preventing_writes_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L238)

# File activerecord/lib/active_record/connection_handling.rb, line 238
def while_preventing_writes(enabled = true, block)
  connected_to(role: current_role, prevent_writes: enabled, block)
end
```

###  **with_connection**(prevent_permanent_checkout: false, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-with_connection)
Checkouts a connection from the pool, yield it and then check it back in. If a connection was already leased via [`lease_connection`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-lease_connection) or a parent call to [`with_connection`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-with_connection), that same connection is yielded. If [`lease_connection`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-lease_connection) is called inside the block, the connection won’t be checked back in. If [`connection`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-connection) is called inside the block, the connection won’t be checked back in unless the `prevent_permanent_checkout` argument is set to `true`.
Source: [show](javascript:toggleSource\('method-i-with_connection_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_handling.rb#L312)

# File activerecord/lib/active_record/connection_handling.rb, line 312
def with_connection(prevent_permanent_checkout: false, block)
  connection_pool.with_connection(prevent_permanent_checkout: prevent_permanent_checkout, block)
end
```