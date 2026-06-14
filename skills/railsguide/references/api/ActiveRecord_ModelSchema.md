Namespace
  * MODULE [ActiveRecord::ModelSchema::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema/ClassMethods.html)

Methods

I

* immutable_strings_by_default=,
  * internal_metadata_table_name,
  * internal_metadata_table_name=

P

* primary_key_prefix_type=

S

* schema_migrations_table_name,
  * schema_migrations_table_name=

T

## Class Public methods

###  **immutable_strings_by_default=(bool)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-immutable_strings_by_default-3D)
Determines whether columns should infer their type as `:string` or `:immutable_string`. This setting does not affect the behavior of `attribute :foo, :string`. Defaults to false.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L131)

```

# File activerecord/lib/active_record/model_schema.rb, line 131

###  **implicit_order_column** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-implicit_order_column)
The name of the column(s) records are ordered by if no explicit order clause is used during an ordered finder call. If not set the primary key is used.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L113)

# File activerecord/lib/active_record/model_schema.rb, line 113

###  **implicit_order_column=(column_name)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-implicit_order_column-3D)
Sets the column(s) to sort records by when no explicit order clause is used during an ordered finder call. Useful for models where the primary key isn’t an auto-incrementing integer (such as UUID).
By default, records are subsorted by primary key to ensure deterministic results. To disable this subsort behavior, set ‘implicit_order_column` to `[“column_name”, nil]`.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L120)

# File activerecord/lib/active_record/model_schema.rb, line 120

###  **inheritance_column** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-inheritance_column)
The name of the table column which stores the class name on single-table inheritance situations.
The default inheritance column name is `type`, which means it’s a reserved word inside Active Record. To be able to use single-table inheritance with another column name, or to use the column `type` in your own model for something else, you can set [`inheritance_column`](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-inheritance_column):

```
.inheritance_column = 'zoink'

If you wish to disable single-table inheritance altogether you can set [`inheritance_column`](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-inheritance_column) to `nil`

```
.inheritance_column =

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L139)

# File activerecord/lib/active_record/model_schema.rb, line 139

###  **inheritance_column=(column)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-inheritance_column-3D)
Defines the name of the table column which will store the class name on single-table inheritance situations.
Source: [show](javascript:toggleSource\('method-c-inheritance_column-3D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L164)

# File activerecord/lib/active_record/model_schema.rb, line 164
included do
  class_attribute :primary_key_prefix_type, instance_writer: false
  class_attribute :table_name_prefix, instance_writer: false, default: ""
  class_attribute :table_name_suffix, instance_writer: false, default: ""
  class_attribute :schema_migrations_table_name, instance_accessor: false, default: "schema_migrations"
  class_attribute :internal_metadata_table_name, instance_accessor: false, default: "ar_internal_metadata"
  class_attribute :pluralize_table_names, instance_writer: false, default: true
  class_attribute :implicit_order_column, instance_accessor: false
  class_attribute :immutable_strings_by_default, instance_accessor: false

class_attribute :inheritance_column, instance_accessor: false, default: "type"
  singleton_class.class_eval do
    alias_method :_inheritance_column=, :inheritance_column=
    private :_inheritance_column=
    alias_method :inheritance_column=, :real_inheritance_column=
  end

self.protected_environments = ["production"]

self.ignored_columns = [].freeze
  self.only_columns = [].freeze

delegate :type_for_attribute, :column_for_attribute, to: :class

initialize_load_schema_monitor
end
```

###  **internal_metadata_table_name** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-internal_metadata_table_name)
The name of the internal metadata table. By default, the value is `"ar_internal_metadata"`.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L85)

# File activerecord/lib/active_record/model_schema.rb, line 85

###  **internal_metadata_table_name=(table_name)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-internal_metadata_table_name-3D)
Sets the name of the internal metadata table.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L91)

# File activerecord/lib/active_record/model_schema.rb, line 91

###  **pluralize_table_names** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-pluralize_table_names)
Indicates whether table names should be the pluralized versions of the corresponding class names. If true, the default table name for a Product class will be “products”. If false, it would just be “product”. See table_name for the full rules on table/class naming. This is true, by default.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L97)

# File activerecord/lib/active_record/model_schema.rb, line 97

###  **pluralize_table_names=(value)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-pluralize_table_names-3D)
Set whether table names should be the pluralized versions of the corresponding class names. If true, the default table name for a Product class will be “products”. If false, it would just be “product”. See table_name for the full rules on table/class naming. This is true, by default.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L105)

# File activerecord/lib/active_record/model_schema.rb, line 105

###  **primary_key_prefix_type** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-primary_key_prefix_type)
The prefix type that will be prepended to every primary key column name. The options are `:table_name` and `:table_name_with_underscore`. If the first is specified, the Product class will look for “productid” instead of “id” as the primary column. If the latter is specified, the Product class will look for “product_id” instead of “id”. Remember that this is a global setting for all Active Records.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L17)

# File activerecord/lib/active_record/model_schema.rb, line 17

###  **primary_key_prefix_type=(prefix_type)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-primary_key_prefix_type-3D)
Sets the prefix type that will be prepended to every primary key column name. The options are `:table_name` and `:table_name_with_underscore`. If the first is specified, the Product class will look for “productid” instead of “id” as the primary column. If the latter is specified, the Product class will look for “product_id” instead of “id”. Remember that this is a global setting for all Active Records.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L27)

# File activerecord/lib/active_record/model_schema.rb, line 27

###  **schema_migrations_table_name** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-schema_migrations_table_name)
The name of the schema migrations table. By default, the value is `"schema_migrations"`.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L73)

# File activerecord/lib/active_record/model_schema.rb, line 73

###  **schema_migrations_table_name=(table_name)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-schema_migrations_table_name-3D)
Sets the name of the schema migrations table.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L79)

# File activerecord/lib/active_record/model_schema.rb, line 79

###  **table_name_prefix** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-table_name_prefix)
The prefix string to prepend to every table name.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L37)

# File activerecord/lib/active_record/model_schema.rb, line 37

###  **table_name_prefix=(prefix)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-table_name_prefix-3D)
Sets the prefix string to prepend to every table name. So if set to “basecamp_”, all table names will be named like “basecamp_projects”, “basecamp_people”, etc. This is a convenient way of creating a namespace for tables in a shared database. By default, the prefix is the empty string.
If you are organizing your models within modules you can add a prefix to the models within a namespace by defining a singleton method in the parent module called [`table_name_prefix`](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-table_name_prefix) which returns your chosen prefix.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L43)

# File activerecord/lib/active_record/model_schema.rb, line 43

###  **table_name_suffix** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-table_name_suffix)
The suffix string to append to every table name.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L56)

# File activerecord/lib/active_record/model_schema.rb, line 56

###  **table_name_suffix=(suffix)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-table_name_suffix-3D)
Works like [`table_name_prefix=`](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-table_name_prefix-3D), but appends instead of prepends (set to “_basecamp” gives “projects_basecamp”, “people_basecamp”). By default, the suffix is the empty string.
If you are organizing your models within modules, you can add a suffix to the models within a namespace by defining a singleton method in the parent module called [`table_name_suffix`](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-table_name_suffix) which returns your chosen suffix.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L62)

# File activerecord/lib/active_record/model_schema.rb, line 62

## Instance Public methods

###  **id_value** [Link](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-i-id_value)
Returns the underlying column value for a column named “id”. Useful when defining a composite primary key including an “id” column so that the value is readable.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/model_schema.rb#L10)

# File activerecord/lib/active_record/model_schema.rb, line 10