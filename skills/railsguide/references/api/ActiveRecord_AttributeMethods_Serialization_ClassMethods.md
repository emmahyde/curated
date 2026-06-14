Methods

S

## Instance Public methods

###  **serialize**(attr_name, coder: nil, type: Object, comparable: false, yaml: {}, **options) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Serialization/ClassMethods.html#method-i-serialize)
If you have an attribute that needs to be saved to the database as a serialized object, and retrieved by deserializing into the same object, then specify the name of that attribute using this method and serialization will be handled automatically.
The serialization format may be YAML, JSON, or any custom format using a custom coder class.
Keep in mind that database adapters handle certain serialization tasks for you. For instance: `json` and `jsonb` types in PostgreSQL will be converted between JSON object/array syntax and Ruby [`Hash`](https://api.rubyonrails.org/classes/Hash.html) or [`Array`](https://api.rubyonrails.org/classes/Array.html) objects transparently. There is no need to use [`serialize`](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Serialization/ClassMethods.html#method-i-serialize) in this case.
For more complex cases, such as conversion to or from your application domain objects, consider using the [`ActiveRecord::Attributes`](https://api.rubyonrails.org/classes/ActiveRecord/Attributes.html) API.

#### Parameters
  * `attr_name` - The name of the attribute to serialize.
  * `coder` The serializer implementation to use, e.g. `JSON`.
    * The attribute value will be serialized using the coder’s `dump(value)` method, and will be deserialized using the coder’s `load(string)` method. The `dump` method may return `nil` to serialize the value as `NULL`.
  * `type` - Optional. What the type of the serialized object should be.
    * Attempting to serialize another type will raise an [`ActiveRecord::SerializationTypeMismatch`](https://api.rubyonrails.org/classes/ActiveRecord/SerializationTypeMismatch.html) error.
    * If the column is `NULL` or starting from a new record, the default value will set to `type.new`
  * `comparable` - Specify whether the deserialized object is safely comparable for the purpose of detecting changes. Defaults to `false` When set to `false` the old and new values will be compared by their serialized representation (e.g. JSON or YAML), which can sometimes cause two objects that are semantically equal to be considered different. For instance two hashes with the same keys and values but a different order have a different serialized representation, but are semantically equal once deserialized. If set to `true` the comparison will be done on the deserialized object. This options should only be enabled if the `type` is known to have a proper `==` method that deeply compare the objects.
  * `yaml` - Optional. Yaml specific options. The allowed config is:
    * `:permitted_classes` - [`Array`](https://api.rubyonrails.org/classes/Array.html) with the permitted classes.
    * `:unsafe_load` - Unsafely load YAML blobs, allow YAML to load any class.

#### Options
  * `:default` - The default value to use when no value is provided. If this option is not passed, the previous default value (if any) will be used. Otherwise, the default will be `nil`.

#### Choosing a serializer
While any serialization format can be used, it is recommended to carefully evaluate the properties of a serializer before using it, as migrating to another format later on can be difficult.

##### Avoid accepting arbitrary types
When serializing data in a column, it is heavily recommended to make sure only expected types will be serialized. For instance some serializer like `Marshal` or `YAML` are capable of serializing almost any Ruby object.
This can lead to unexpected types being serialized, and it is important that type serialization remains backward and forward compatible as long as some database records still contain these serialized types.

```
class Address
   initialize(line, city, country)
    @line, @city, @country = line, city, country

```

In the above example, if any of the `Address` attributes is renamed, instances that were persisted before the change will be loaded with the old attributes. This problem is even worse when the serialized type comes from a dependency which doesn’t expect to be serialized this way and may change its internal representation without notice.
As such, it is heavily recommended to instead convert these objects into primitives of the serialization format, for example:

```
class Address
  attr_reader :line, :city, :country

.(payload)
    data = YAML.safe_load(payload)
    (data["line"], data["city"], data["country"])

.(address)
    YAML.safe_dump(
      "line" => address.line,
      "city" => address.city,
      "country" => address.country,
    )

initialize(line, city, country)
    @line, @city, @country = line, city, country

class User  ActiveRecord::Base
  serialize :address, coder: Address

This pattern allows to be more deliberate about what is serialized, and to evolve the format in a backward compatible way.

##### Ensure serialization stability
Some serialization methods may accept some types they don’t support by silently casting them to other types. This can cause bugs when the data is deserialized.
For instance the `JSON` serializer provided in the standard library will silently cast unsupported types to [`String`](https://api.rubyonrails.org/classes/String.html):

```
>> JSON.parse(JSON.dump(Struct.(:foo)))

# => "#<Class:0x000000013090b4c0>"
```

#### Examples

##### Serialize the `preferences` attribute using YAML

```
class User  ActiveRecord::Base
  serialize :preferences, coder: YAML

##### Serialize the `preferences` attribute using JSON

```
class User  ActiveRecord::Base
  serialize :preferences, coder: JSON

##### Serialize the `preferences` [`Hash`](https://api.rubyonrails.org/classes/Hash.html) using YAML

```
class User  ActiveRecord::Base
  serialize :preferences, type: Hash, coder: YAML

##### Serializes `preferences` to YAML, permitting select classes

```
class User  ActiveRecord::Base
  serialize :preferences, coder: YAML, yaml: { permitted_classes: [Symbol, Time] }

##### Serialize the `preferences` attribute using a custom coder

```
class Rot13JSON
   .rot13(string)
    string.("a-zA-Z", "n-za-mN-ZA-M")

# Serializes an attribute value to a string that will be stored in the database.
   .(value)
    rot13(ActiveSupport::JSON.(value))

# Deserializes a string from the database to an attribute value.
   .(string)
    ActiveSupport::JSON.(rot13(string))

class User  ActiveRecord::Base
  serialize :preferences, coder: Rot13JSON

Source: [show](javascript:toggleSource\('method-i-serialize_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/attribute_methods/serialization.rb#L193)

# File activerecord/lib/active_record/attribute_methods/serialization.rb, line 193
        def serialize(attr_name, coder: nil, type: Object, comparable: false, yaml: {}, **options)
          coder ||= default_column_serializer
          unless coder
            raise ArgumentError, <<~MSG.squish
              missing keyword: :coder

If no default coder is configured, a coder must be provided to `serialize`.
            MSG
          end

column_serializer = build_column_serializer(attr_name, coder, type, yaml)

attribute(attr_name, **options)

decorate_attributes([attr_name]) do |attr_name, cast_type|
            if type_incompatible_with_serialize?(cast_type, coder, type)
              raise ColumnNotSerializableError.new(attr_name, cast_type)
            end

cast_type = cast_type.subtype if Type::Serialized === cast_type
            Type::Serialized.new(cast_type, column_serializer, comparable: comparable)
          end
        end
```