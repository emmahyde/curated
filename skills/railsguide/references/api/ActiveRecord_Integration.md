Namespace
  * MODULE [ActiveRecord::Integration::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Integration/ClassMethods.html)

Methods

C

* collection_cache_versioning

T

## Class Public methods

###  **cache_timestamp_format** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-c-cache_timestamp_format)
Indicates the format used to generate the timestamp in the cache key, if versioning is off. Accepts any of the symbols in `Time::DATE_FORMATS`.
This is `:usec`, by default.
Source: [show](javascript:toggleSource\('method-c-cache_timestamp_format_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/integration.rb#L16)

```

# File activerecord/lib/active_record/integration.rb, line 16
class_attribute :cache_timestamp_format, instance_writer: false, default: :usec

###  **cache_versioning** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-c-cache_versioning)
Indicates whether to use a stable [`cache_key`](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-i-cache_key) method that is accompanied by a changing version in the [`cache_version`](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-i-cache_version) method.
This is `true`, by default on Rails 5.2 and above.
Source: [show](javascript:toggleSource\('method-c-cache_versioning_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/integration.rb#L24)

# File activerecord/lib/active_record/integration.rb, line 24
class_attribute :cache_versioning, instance_writer: false, default: false

###  **collection_cache_versioning** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-c-collection_cache_versioning)
Indicates whether to use a stable [`cache_key`](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-i-cache_key) method that is accompanied by a changing version in the [`cache_version`](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-i-cache_version) method on collections.
This is `false`, by default until Rails 6.1.
Source: [show](javascript:toggleSource\('method-c-collection_cache_versioning_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/integration.rb#L32)

# File activerecord/lib/active_record/integration.rb, line 32
class_attribute :collection_cache_versioning, instance_writer: false, default: false

## Instance Public methods

###  **cache_key**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-i-cache_key)
Returns a stable cache key that can be used to identify this record.

```
Product..cache_key     # => "products/new"
Product.().cache_key # => "products/5"

If [`ActiveRecord::Base.cache_versioning`](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-c-cache_versioning) is turned off, as it was in Rails 5.1 and earlier, the cache key will also include a version.

```
Product.cache_versioning = false
Product.().cache_key  # => "products/5-20071224150000" (updated_at available)

Source: [show](javascript:toggleSource\('method-i-cache_key_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/integration.rb#L72)

# File activerecord/lib/active_record/integration.rb, line 72
def cache_key
  if new_record?
    "#{model_name.cache_key}/new"
  else
    if cache_version
      "#{model_name.cache_key}/#{id}"
    else
      timestamp = max_updated_column_timestamp

if timestamp
        timestamp = timestamp.utc.to_fs(cache_timestamp_format)
        "#{model_name.cache_key}/#{id}-#{timestamp}"
      else
        "#{model_name.cache_key}/#{id}"
      end
    end
  end
end
```

###  **cache_key_with_version**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-i-cache_key_with_version)
Returns a cache key along with the version.
Source: [show](javascript:toggleSource\('method-i-cache_key_with_version_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/integration.rb#L114)

# File activerecord/lib/active_record/integration.rb, line 114
def cache_key_with_version
  if version = cache_version
    "#{cache_key}-#{version}"
  else
    cache_key
  end
end
```

###  **cache_version**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-i-cache_version)
Returns a cache version that can be used together with the cache key to form a recyclable caching scheme. By default, the updated_at column is used for the [`cache_version`](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-i-cache_version), but this method can be overwritten to return something else.
Note, this method will return nil if [`ActiveRecord::Base.cache_versioning`](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-c-cache_versioning) is set to `false`.
Source: [show](javascript:toggleSource\('method-i-cache_version_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/integration.rb#L97)

# File activerecord/lib/active_record/integration.rb, line 97
def cache_version
  return unless cache_versioning

if has_attribute?("updated_at")
    timestamp = updated_at_before_type_cast
    if can_use_fast_cache_version?(timestamp)
      raw_timestamp_to_cache_version(timestamp)

elsif timestamp = updated_at
      timestamp.utc.to_fs(cache_timestamp_format)
    end
  elsif self.class.has_attribute?("updated_at")
    raise ActiveModel::MissingAttributeError, "missing attribute 'updated_at' for #{self.class}"
  end
end
```

###  **to_param**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-i-to_param)
Returns a [`String`](https://api.rubyonrails.org/classes/String.html), which Action Pack uses for constructing a URL to this object. The default implementation returns this record’s id as a [`String`](https://api.rubyonrails.org/classes/String.html), or `nil` if this record’s unsaved.
For example, suppose that you have a User model, and that you have a `resources :users` route. Normally, `user_path` will construct a path with the user object’s ‘id’ in it:

```
user = User.find_by(name: 'Phusion')
user_path(user)  # => "/users/1"

You can override [`to_param`](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html#method-i-to_param) in your model to make `user_path` construct a path using the user’s name instead of the user’s id:

```
class User  ActiveRecord::Base
   to_param  # overridden

user = User.find_by(name: 'Phusion')
user_path(user)  # => "/users/Phusion"

Source: [show](javascript:toggleSource\('method-i-to_param_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/integration.rb#L57)

# File activerecord/lib/active_record/integration.rb, line 57
def to_param
  return unless id
  Array(id).join(self.class.param_delimiter)
end
```