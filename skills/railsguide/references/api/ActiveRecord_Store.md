# Active Record Store
[`Store`](https://api.rubyonrails.org/classes/ActiveRecord/Store.html) gives you a thin wrapper around serialize for the purpose of storing hashes in a single column. It’s like a simple key/value store baked into your record when you don’t care about being able to query that store outside the context of a single record.
You can then declare accessors to this store that are then accessible just like any other attribute of the model. This is very helpful for easily exposing store keys to a form or elsewhere that’s already built around just accessing attributes on the model.
Every accessor comes with dirty tracking methods (`key_changed?`, `key_was` and `key_change`) and methods to access the changes made during the last save (`saved_change_to_key?`, `saved_change_to_key` and `key_before_last_save`).
NOTE: There is no `key_will_change!` method for accessors, use `store_will_change!` instead.
Make sure that you declare the database column used for the serialized store as a text, so there’s plenty of room.
You can set custom coder to encode/decode your serialized attributes to/from different formats. JSON, YAML, Marshal are supported out of the box. Generally it can be any wrapper that provides `load` and `dump`.
NOTE: If you are using structured database data types (e.g. PostgreSQL `hstore`/`json`, MySQL 5.7+ `json`, or SQLite 3.38+ `json`) there is no need for the serialization provided by [.store](https://api.rubyonrails.org/classes/ActiveRecord/Store/ClassMethods.html#method-i-store). Simply use [.store_accessor](https://api.rubyonrails.org/classes/ActiveRecord/Store/ClassMethods.html#method-i-store_accessor) instead to generate the accessor methods. Be aware that these columns use a string keyed hash and do not allow access using a symbol.
NOTE: The default validations with the exception of `uniqueness` will work. For example, if you want to check for `uniqueness` with `hstore` you will need to use a custom validation to handle it.
Examples:

```
class User  ActiveRecord::Base
  store :settings, accessors: [ :color, :homepage ], coder: JSON
  store :parent, accessors: [ :name ], coder: JSON, prefix:
  store :spouse, accessors: [ :name ], coder: JSON, prefix: :partner
  store :settings, accessors: [ :two_factor_auth ], suffix:
  store :settings, accessors: [ :login_retry ], suffix: :config

= User.(color: 'black', homepage: '37signals.com', parent_name: 'Mary', partner_name: 'Lily')
.color                          # Accessor stored attribute
.parent_name                    # Accessor stored attribute with prefix
.partner_name                   # Accessor stored attribute with custom prefix
.two_factor_auth_settings       # Accessor stored attribute with suffix
.login_retry_config             # Accessor stored attribute with custom suffix
.settings[:country] = 'Denmark' # Any attribute, even if not specified with an accessor

# There is no difference between strings and symbols for accessing custom attributes
.settings[:country]  # => 'Denmark'
.settings['country'] # => 'Denmark'

# Dirty tracking
.color = 'green'
.color_changed? # => true
.color_was # => 'black'
.color_change # => ['black', 'green']

# Add additional accessors to an existing store through store_accessor
class SuperUser
  store_accessor :settings, :privileges, :servants
  store_accessor :parent, :birthday, prefix:
  store_accessor :settings, :secret_question, suffix: :config

```

The stored attribute names can be retrieved using [.stored_attributes](https://api.rubyonrails.org/classes/ActiveRecord/Store/ClassMethods.html#method-i-stored_attributes).

```
User.stored_attributes[:settings] # => [:color, :homepage, :two_factor_auth, :login_retry]

## Overwriting default accessors
All stored values are automatically available through accessors on the Active Record object, but sometimes you want to specialize this behavior. This can be done by overwriting the default accessors (using the same name as the attribute) and calling `super` to actually change things.

```
class Song  ActiveRecord::Base

# Uses a stored integer to hold the volume adjustment of the song
  store :settings, accessors: [:volume_adjustment]

volume_adjustment=(decibels)
    super(decibels.)

volume_adjustment
    super.

Namespace
  * MODULE [ActiveRecord::Store::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Store/ClassMethods.html)

Methods

R

W

## Attributes
|  [RW]   | local_stored_attributes  |
| --- | --- |

## Instance Private methods

###  **read_store_attribute**(store_attribute, key) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Store.html#method-i-read_store_attribute)
Source: [show](javascript:toggleSource\('method-i-read_store_attribute_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/store.rb#L215)

# File activerecord/lib/active_record/store.rb, line 215
def read_store_attribute(store_attribute, key) # :doc:
  accessor = store_accessor_for(store_attribute)
  accessor.read(self, store_attribute, key)
end
```

###  **write_store_attribute**(store_attribute, key, value) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Store.html#method-i-write_store_attribute)
Source: [show](javascript:toggleSource\('method-i-write_store_attribute_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/store.rb#L220)

# File activerecord/lib/active_record/store.rb, line 220
def write_store_attribute(store_attribute, key, value) # :doc:
  accessor = store_accessor_for(store_attribute)
  accessor.write(self, store_attribute, key, value)
end
```