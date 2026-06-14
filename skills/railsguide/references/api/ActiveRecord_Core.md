# Active Record Core
Namespace
  * MODULE [ActiveRecord::Core::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Core/ClassMethods.html)
  * CLASS [ActiveRecord::Core::InspectionMask](https://api.rubyonrails.org/classes/ActiveRecord/Core/InspectionMask.html)

Methods

#

A

C

* current_preventing_writes,

D

* destroy_association_async_batch_size,
  * destroy_association_async_job,

E

* enumerate_columns_in_select_statements,

F

H

I

L

N

P

R

S

* strict_loading_n_plus_one_only?

V

## Attributes
|  [R]   | strict_loading_mode  |
| --- | --- |

## Class Public methods

###  **attributes_for_inspect** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-attributes_for_inspect)
Specifies the attributes that will be included in the output of the [`inspect`](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-inspect) method:

```
Post.attributes_for_inspect = [, :title]
Post.first.inspect #=> "#<Post id: 1, title: "Hello, World!">"

```

When set to `:all` inspect will list all the record’s attributes:

```
Post.attributes_for_inspect =
Post.first.inspect #=> "#<Post id: 1, title: "Hello, World!", published_at: "2023-10-23 14:28:11 +0000">"

Source: [show](javascript:toggleSource\('method-c-attributes_for_inspect_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L118)

# File activerecord/lib/active_record/core.rb, line 118
class_attribute :attributes_for_inspect, instance_accessor: false, default: :all

###  **configurations**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-configurations)
Returns a fully resolved [`ActiveRecord::DatabaseConfigurations`](https://api.rubyonrails.org/classes/ActiveRecord/DatabaseConfigurations.html) object.
Source: [show](javascript:toggleSource\('method-c-configurations_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L76)

# File activerecord/lib/active_record/core.rb, line 76
def self.configurations
  @@configurations
end
```

###  **configurations=**(config) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-configurations-3D)
Contains the database configuration - as is typically stored in config/database.yml - as an [`ActiveRecord::DatabaseConfigurations`](https://api.rubyonrails.org/classes/ActiveRecord/DatabaseConfigurations.html) object.
For example, the following database.yml…

```
development:
  adapter: sqlite3
  database: storage/development.sqlite3

production:
  adapter: sqlite3
  database: storage/production.sqlite3
```

…would result in [`ActiveRecord::Base.configurations`](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-configurations) to look like this:

```
#<ActiveRecord::DatabaseConfigurations:0x00007fd1acbdf800 @configurations=[
  #<ActiveRecord::DatabaseConfigurations::HashConfig:0x00007fd1acbded10 @env_name="development",
    @name="primary", @config={adapter: "sqlite3", database: "storage/development.sqlite3"}>,
  #<ActiveRecord::DatabaseConfigurations::HashConfig:0x00007fd1acbdea90 @env_name="production",
    @name="primary", @config={adapter: "sqlite3", database: "storage/production.sqlite3"}>
]>
```

Source: [show](javascript:toggleSource\('method-c-configurations-3D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L70)

# File activerecord/lib/active_record/core.rb, line 70
def self.configurations=(config)
  @@configurations = ActiveRecord::DatabaseConfigurations.new(config)
end
```

###  **connection_handler**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-connection_handler)
Source: [show](javascript:toggleSource\('method-c-connection_handler_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L132)

# File activerecord/lib/active_record/core.rb, line 132
def self.connection_handler
  ActiveSupport::IsolatedExecutionState[:active_record_connection_handler] || default_connection_handler
end
```

###  **connection_handler=**(handler) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-connection_handler-3D)
Source: [show](javascript:toggleSource\('method-c-connection_handler-3D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L136)

# File activerecord/lib/active_record/core.rb, line 136
def self.connection_handler=(handler)
  ActiveSupport::IsolatedExecutionState[:active_record_connection_handler] = handler
end
```

###  **current_preventing_writes**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-current_preventing_writes)
Returns the symbol representing the current setting for preventing writes.

```
ActiveRecord::Base.connected_to(role: :reading)
  ActiveRecord::Base.current_preventing_writes #=> true

ActiveRecord::Base.connected_to(role: :writing)
  ActiveRecord::Base.current_preventing_writes #=> false

Source: [show](javascript:toggleSource\('method-c-current_preventing_writes_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L195)

# File activerecord/lib/active_record/core.rb, line 195
def self.current_preventing_writes
  connected_to_stack.reverse_each do |hash|
    return hash[:prevent_writes] if !hash[:prevent_writes].nil?  hash[:klasses].include?(Base)
    return hash[:prevent_writes] if !hash[:prevent_writes].nil?  hash[:klasses].include?(connection_class_for_self)
  end

false
end
```

###  **current_role**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-current_role)
Returns the symbol representing the current connected role.

```
ActiveRecord::Base.connected_to(role: :writing)
  ActiveRecord::Base.current_role #=> :writing

ActiveRecord::Base.connected_to(role: :reading)
  ActiveRecord::Base.current_role #=> :reading

Source: [show](javascript:toggleSource\('method-c-current_role_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L158)

# File activerecord/lib/active_record/core.rb, line 158
def self.current_role
  connected_to_stack.reverse_each do |hash|
    return hash[:role] if hash[:role]  hash[:klasses].include?(Base)
    return hash[:role] if hash[:role]  hash[:klasses].include?(connection_class_for_self)
  end

default_role
end
```

###  **current_shard**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-current_shard)
Returns the symbol representing the current connected shard.

```
ActiveRecord::Base.connected_to(role: :reading)
  ActiveRecord::Base.current_shard #=> :default

ActiveRecord::Base.connected_to(role: :writing, shard: )
  ActiveRecord::Base.current_shard #=> :one

Source: [show](javascript:toggleSource\('method-c-current_shard_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L176)

# File activerecord/lib/active_record/core.rb, line 176
def self.current_shard
  connected_to_stack.reverse_each do |hash|
    return hash[:shard] if hash[:shard]  hash[:klasses].include?(Base)
    return hash[:shard] if hash[:shard]  hash[:klasses].include?(connection_class_for_self)
  end

default_shard
end
```

###  **destroy_association_async_batch_size** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-destroy_association_async_batch_size)
Specifies the maximum number of records that will be destroyed in a single background job by the `dependent: :destroy_async` association option. When `nil` (default), all dependent records will be destroyed in a single background job. If specified, the records to be destroyed will be split into multiple background jobs.
Source: [show](javascript:toggleSource\('method-c-destroy_association_async_batch_size_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L46)

# File activerecord/lib/active_record/core.rb, line 46
class_attribute :destroy_association_async_batch_size, instance_writer: false, instance_predicate: false, default: nil

###  **destroy_association_async_job**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-destroy_association_async_job)
The job class used to destroy associations in the background.
Source: [show](javascript:toggleSource\('method-c-destroy_association_async_job_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L26)

# File activerecord/lib/active_record/core.rb, line 26
def self.destroy_association_async_job
  if _destroy_association_async_job.is_a?(String)
    self._destroy_association_async_job = _destroy_association_async_job.constantize
  end
  _destroy_association_async_job
rescue NameError => error
  raise NameError, "Unable to load destroy_association_async_job: #{error.message}"
end
```

###  **enumerate_columns_in_select_statements** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-enumerate_columns_in_select_statements)
Force enumeration of all columns in SELECT statements. e.g. `SELECT first_name, last_name FROM ...` instead of `SELECT * FROM ...` This avoids [`PreparedStatementCacheExpired`](https://api.rubyonrails.org/classes/ActiveRecord/PreparedStatementCacheExpired.html) errors when a column is added to the database while the app is running.
Source: [show](javascript:toggleSource\('method-c-enumerate_columns_in_select_statements_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L86)

# File activerecord/lib/active_record/core.rb, line 86
class_attribute :enumerate_columns_in_select_statements, instance_accessor: false, default: false

###  **logger** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-logger)
Accepts a logger conforming to the interface of Log4r or the default Ruby `Logger` class, which is then passed on to any new database connections made. You can retrieve this logger by calling `logger` on either an Active Record model class or an Active Record model instance.
Source: [show](javascript:toggleSource\('method-c-logger_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L21)

# File activerecord/lib/active_record/core.rb, line 21
class_attribute :logger, instance_writer: false

###  **new**(attributes = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-c-new)
New objects can be instantiated as either empty (pass no construction parameter) or pre-set with attributes but not yet saved (pass a hash with key names matching the associated table column names). In both instances, valid attribute keys are determined by the column names of the associated table – hence you can’t have attributes that aren’t part of the table columns.

#### Example

# Instantiates a single new object
User.(first_name: 'Jamie')

Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L472)

# File activerecord/lib/active_record/core.rb, line 472
def initialize(attributes = nil)
  @new_record = true
  @attributes = self.class._default_attributes.deep_dup

init_internals
  initialize_internals_callback

super

yield self if block_given?
  _run_initialize_callbacks
end
```

## Instance Public methods

###  **< =>**(other_object) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-3C-3D-3E)
Allows sort on objects
Source: [show](javascript:toggleSource\('method-i-3C-3D-3E_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L666)

# File activerecord/lib/active_record/core.rb, line 666
def <=>(other_object)
  if other_object.is_a?(self.class)
    to_key <=> other_object.to_key
  else
    super
  end
end
```

###  **==**(comparison_object) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-3D-3D)
Returns true if `comparison_object` is the same exact object, or `comparison_object` is of the same type and `self` has an ID and it is equal to `comparison_object.id`.
Note that new records are different from any other record by definition, unless the other record is the receiver itself. Besides, if you fetch existing records with `select` and leave the ID out, you’re on your own, this predicate will return false.
Note also that destroying a record preserves its ID in the model instance, so deleted models are still comparable.
Also aliased as: [eql?](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-eql-3F)
Source: [show](javascript:toggleSource\('method-i-3D-3D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L632)

# File activerecord/lib/active_record/core.rb, line 632
def ==(comparison_object)
  super ||
    comparison_object.instance_of?(self.class)
    primary_key_values_present?
    comparison_object.id == id
end
```

###  **clone** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-clone)
Identical to Ruby’s clone method. This is a “shallow” copy. Be warned that your attributes are not copied. That means that modifying attributes of the clone will modify the original, since they will both point to the same attributes hash. If you need a copy of your attributes hash, please use the [`dup`](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-dup) method.

```
user = User.first
new_user = user.clone
user.               # => "Bob"
new_user. = "Joe"
user.               # => "Joe"

user.object_id == new_user.object_id            # => false
user..object_id == new_user..object_id  # => true

user..object_id == user...object_id  # => false

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L524)

# File activerecord/lib/active_record/core.rb, line 524

###  **connection_handler**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-connection_handler)
Source: [show](javascript:toggleSource\('method-i-connection_handler_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L771)

# File activerecord/lib/active_record/core.rb, line 771
def connection_handler
  self.class.connection_handler
end
```

###  **dup** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-dup)
Duped objects have no id assigned and are treated as new records. Note that this is a “shallow” copy as it copies the object’s attributes only, not its associations. The extent of a “deep” copy is application specific and is therefore left to the application to implement according to its need. The dup method does not preserve the timestamps (created|updated)_(at|on) and locking column.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L541)

# File activerecord/lib/active_record/core.rb, line 541

###  **encode_with**(coder) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-encode_with)
Populate `coder` with attributes about this record that should be serialized. The structure of `coder` defined in this method is guaranteed to match the structure of `coder` passed to the [`init_with`](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-init_with) method.
Example:

```
class Post  ActiveRecord::Base

coder = {}
Post..encode_with(coder)
coder # => {"attributes" => {"id" => nil, ... }}

Source: [show](javascript:toggleSource\('method-i-encode_with_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L588)

# File activerecord/lib/active_record/core.rb, line 588
def encode_with(coder)
  self.class.yaml_encoder.encode(@attributes, coder)
  coder["new_record"] = new_record?
  coder["active_record_yaml_version"] = 2
end
```

###  **eql?**(comparison_object) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-eql-3F)
Alias for: [==](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-3D-3D)

###  **freeze**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-freeze)
Clone and freeze the attributes hash such that associations are still accessible, even on destroyed records, but cloned models will not be frozen.
Source: [show](javascript:toggleSource\('method-i-freeze_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L655)

# File activerecord/lib/active_record/core.rb, line 655
def freeze
  @attributes = @attributes.clone.freeze
  self
end
```

###  **frozen?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-frozen-3F)
Returns `true` if the attributes hash has been frozen.
Source: [show](javascript:toggleSource\('method-i-frozen-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L661)

# File activerecord/lib/active_record/core.rb, line 661
def frozen?
  @attributes.frozen?
end
```

###  **full_inspect**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-full_inspect)
Returns all attributes of the record as a nicely formatted string, ignoring `.attributes_for_inspect`.

```
Post.first.full_inspect
#=> "#<Post id: 1, title: "Hello, World!", published_at: "2023-10-23 14:28:11 +0000">"

Source: [show](javascript:toggleSource\('method-i-full_inspect_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L795)

# File activerecord/lib/active_record/core.rb, line 795
def full_inspect
  inspect_with_attributes(all_attributes_for_inspect)
end
```

###  **hash**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-hash)
Delegates to id in order to allow two records of the same type and id to work with something like:

```
[ Person.(), Person.(), Person.() ]  [ Person.(), Person.() ] # => [ Person.find(1) ]

Source: [show](javascript:toggleSource\('method-i-hash_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L642)

# File activerecord/lib/active_record/core.rb, line 642
def hash
  id = self.id

if self.class.composite_primary_key? ? primary_key_values_present? : id
    self.class.hash ^ id.hash
  else
    super
  end
end
```

###  **init_with**(coder, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-init_with)
Initialize an empty model object from `coder`. `coder` should be the result of previously encoding an Active Record model, using [`encode_with`](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-encode_with).

old_post = Post.(title: "hello world")
coder = {}
old_post.encode_with(coder)

post = Post.allocate
post.init_with(coder)
post.title # => 'hello world'

Source: [show](javascript:toggleSource\('method-i-init_with_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L499)

# File activerecord/lib/active_record/core.rb, line 499
def init_with(coder, block)
  coder = LegacyYamlAdapter.convert(coder)
  attributes = self.class.yaml_encoder.decode(coder)
  init_with_attributes(attributes, coder["new_record"], block)
end
```

###  **inspect**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-inspect)
Returns the attributes of the record as a nicely formatted string.

```
Post.first.inspect
#=> "#<Post id: 1, title: "Hello, World!", published_at: "2023-10-23 14:28:11 +0000">"

The attributes can be limited by setting `.attributes_for_inspect`.

```
Post.attributes_for_inspect = [, :title]
Post.first.inspect
#=> "#<Post id: 1, title: "Hello, World!">"

Source: [show](javascript:toggleSource\('method-i-inspect_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L785)

# File activerecord/lib/active_record/core.rb, line 785
def inspect
  inspect_with_attributes(attributes_for_inspect)
end
```

###  **pretty_print**(pp) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-pretty_print)
Takes a PP and prettily prints this record to it, allowing you to get a nice result from `pp record` when pp is required.
Source: [show](javascript:toggleSource\('method-i-pretty_print_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L801)

# File activerecord/lib/active_record/core.rb, line 801
def pretty_print(pp)
  return super if custom_inspect_method_defined?
  pp.object_address_group(self) do
    if @attributes
      attr_names = attributes_for_inspect.select { |name| _has_attribute?(name.to_s) }
      pp.seplist(attr_names, proc { pp.text "," }) do |attr_name|
        attr_name = attr_name.to_s
        pp.breakable " "
        pp.group(1) do
          pp.text attr_name
          pp.text ":"
          pp.breakable
          value = attribute_for_inspect(attr_name)
          pp.text value
        end
      end
    else
      pp.breakable " "
      pp.text "not initialized"
    end
  end
end
```

###  **readonly!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-readonly-21)
Prevents records from being written to the database:

```
customer = Customer.
customer.readonly!
customer.save # raises ActiveRecord::ReadOnlyRecord

customer = Customer.first
customer.readonly!
customer.update(name: 'New Name') # raises ActiveRecord::ReadOnlyRecord

Read-only records cannot be deleted from the database either:

```
customer = Customer.first
customer.readonly!
customer.destroy # raises ActiveRecord::ReadOnlyRecord

Please, note that the objects themselves are still mutable in memory:

```
customer = Customer.
customer.readonly!
customer. = 'New Name' # OK

but you won’t be able to persist the changes.
Source: [show](javascript:toggleSource\('method-i-readonly-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L767)

# File activerecord/lib/active_record/core.rb, line 767
def readonly!
  @readonly = true
end
```

###  **readonly?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-readonly-3F)
Returns `true` if the record is read only.
Source: [show](javascript:toggleSource\('method-i-readonly-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L683)

# File activerecord/lib/active_record/core.rb, line 683
def readonly?
  @readonly
end
```

###  **slice(*methods)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-slice)
Returns a hash of the given methods with their names as keys and returned values as values.

```
topic = Topic.(title: "Budget", author_name: "Jason")
topic.slice(:title, :author_name)

# => { "title" => "Budget", "author_name" => "Jason" }

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L595)

# File activerecord/lib/active_record/core.rb, line 595

###  **strict_loading!**(value = true, mode: :all) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-strict_loading-21)
Sets the record to strict_loading mode. This will raise an error if the record tries to lazily load an association.
NOTE: Strict loading is disabled during validation in order to let the record validate its association.

```
user = User.first
user.strict_loading! # => true
user.address.city

# => ActiveRecord::StrictLoadingViolationError
user.comments.

# => ActiveRecord::StrictLoadingViolationError

#### Parameters
  * `value` - Boolean specifying whether to enable or disable strict loading.
  * `:mode` - [`Symbol`](https://api.rubyonrails.org/classes/Symbol.html) specifying strict loading mode. Defaults to :all. Using :n_plus_one_only mode will only raise an error if an association that will lead to an n plus one query is lazily loaded.

#### Examples

```
user = User.first
user.strict_loading!(false) # => false
user.address.city # => "Tatooine"
user.comments. # => [#<Comment:0x00...]

user.strict_loading!(mode: :n_plus_one_only)
user.address.city # => "Tatooine"
user.comments. # => [#<Comment:0x00...]
user.comments.first.ratings.

Source: [show](javascript:toggleSource\('method-i-strict_loading-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L723)

# File activerecord/lib/active_record/core.rb, line 723
def strict_loading!(value = true, mode: :all)
  unless [:all, :n_plus_one_only].include?(mode)
    raise ArgumentError, "The :mode option must be one of [:all, :n_plus_one_only] but #{mode.inspect} was provided."
  end

@strict_loading_mode = mode
  @strict_loading = value
end
```

###  **strict_loading?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-strict_loading-3F)
Returns `true` if the record is in strict_loading mode.
Source: [show](javascript:toggleSource\('method-i-strict_loading-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L688)

# File activerecord/lib/active_record/core.rb, line 688
def strict_loading?
  @strict_loading
end
```

###  **strict_loading_all?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-strict_loading_all-3F)
Returns `true` if the record uses strict_loading with `:all` mode enabled.
Source: [show](javascript:toggleSource\('method-i-strict_loading_all-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L740)

# File activerecord/lib/active_record/core.rb, line 740
def strict_loading_all?
  @strict_loading_mode == :all
end
```

###  **strict_loading_n_plus_one_only?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-strict_loading_n_plus_one_only-3F)
Returns `true` if the record uses strict_loading with `:n_plus_one_only` mode enabled.
Source: [show](javascript:toggleSource\('method-i-strict_loading_n_plus_one_only-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L735)

# File activerecord/lib/active_record/core.rb, line 735
def strict_loading_n_plus_one_only?
  @strict_loading_mode == :n_plus_one_only
end
```

###  **values_at(*methods)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-values_at)
Returns an array of the values returned by the given methods.

```
topic = Topic.(title: "Budget", author_name: "Jason")
topic.values_at(:title, :author_name)

# => ["Budget", "Jason"]

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/core.rb#L610)

# File activerecord/lib/active_record/core.rb, line 610