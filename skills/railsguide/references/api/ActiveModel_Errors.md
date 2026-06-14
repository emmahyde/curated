# Active Model Errors
Provides error related functionalities you can include in your object for handling error messages and interacting with Action View helpers.
A minimal implementation could be:

```
class Person

# Required dependency for ActiveModel::Errors
  extend ActiveModel::Naming

initialize
    @errors = ActiveModel::Errors.()

attr_accessor :name
  attr_reader   :errors

validate!
    errors.(:name, :blank, message: "cannot be nil")  .

# The following methods are needed to be minimally implemented

read_attribute_for_validation(attr)
    (attr)

.human_attribute_name(attr, options = {})
    attr

.lookup_ancestors
    []

```

The last three methods are required in your object for [`Errors`](https://api.rubyonrails.org/classes/ActiveModel/Errors.html) to be able to generate error messages correctly and also handle multiple languages. Of course, if you extend your object with [`ActiveModel::Translation`](https://api.rubyonrails.org/classes/ActiveModel/Translation.html) you will not need to implement the last two. Likewise, using [`ActiveModel::Validations`](https://api.rubyonrails.org/classes/ActiveModel/Validations.html) will handle the validation related methods for you.
The above allows you to do:

```
person = Person.
person.validate!            # => ["cannot be nil"]
person.errors.full_messages # => ["name cannot be nil"]

# etc..

Methods

#

A

C

D

E

F

G

H

I

K

M

N

O

S

T

W

Included Modules

## Attributes
|  [R]   | errors  | The actual array of [`Error`](https://api.rubyonrails.org/classes/ActiveModel/Error.html) objects This method is aliased to `objects`.  |
| --- | --- | --- |
|  [R]   | objects  | The actual array of [`Error`](https://api.rubyonrails.org/classes/ActiveModel/Error.html) objects This method is aliased to `objects`.  |

## Class Public methods

###  **new**(base) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-c-new)
Pass in the instance of the object that is using the errors object.

```
class Person
   initialize
    @errors = ActiveModel::Errors.()

Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L114)

# File activemodel/lib/active_model/errors.rb, line 114
def initialize(base)
  @base = base
  @errors = []
end
```

## Instance Public methods

###  **[]**(attribute) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-5B-5D)
When passed a symbol or a name of a method, returns an array of errors for the method.

```
person.errors[:name]  # => ["cannot be nil"]
person.errors['name'] # => ["cannot be nil"]

Source: [show](javascript:toggleSource\('method-i-5B-5D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L226)

# File activemodel/lib/active_model/errors.rb, line 226
def [](attribute)
  messages_for(attribute)
end
```

###  **add**(attribute, type = :invalid, **options) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-add)
Adds a new error of `type` on `attribute`. More than one error can be added to the same `attribute`. If no `type` is supplied, `:invalid` is assumed.

```
person.errors.(:name)

# Adds <#ActiveModel::Error attribute=name, type=invalid>
person.errors.(:name, :not_implemented, message: "must be implemented")

# Adds <#ActiveModel::Error attribute=name, type=not_implemented,
                            options={:message=>"must be implemented"}

person.errors.messages

# => {:name=>["is invalid", "must be implemented"]}

If `type` is a string, it will be used as error message.
If `type` is a symbol, it will be translated using the appropriate scope (see [`generate_message`](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-generate_message)).

```
person.errors.(:name, :blank)
person.errors.messages

# => {:name=>["can't be blank"]}

person.errors.(:name, :too_long, count: )
person.errors.messages

# => ["is too long (maximum is 25 characters)"]

If `type` is a proc, it will be called, allowing for things like `Time.now` to be used within an error.
If the `:strict` option is set to `true`, it will raise [`ActiveModel::StrictValidationFailed`](https://api.rubyonrails.org/classes/ActiveModel/StrictValidationFailed.html) instead of adding the error. `:strict` option can also be set to any other exception.

```
person.errors.(:name, :invalid, strict: )

# => ActiveModel::StrictValidationFailed: Name is invalid
person.errors.(:name, :invalid, strict: NameIsInvalid)

# => NameIsInvalid: Name is invalid

person.errors.messages # => {}

`attribute` should be set to `:base` if the error is not directly associated with a single attribute.

```
person.errors.(:base, :name_or_email_blank,
  message: "either name or email must be present")
person.errors.messages

# => {:base=>["either name or email must be present"]}
person.errors.details

# => {:base=>[{error: :name_or_email_blank}]}

Source: [show](javascript:toggleSource\('method-i-add_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L339)

# File activemodel/lib/active_model/errors.rb, line 339
def add(attribute, type = :invalid, **options)
  attribute, type, options = normalize_arguments(attribute, type, **options)
  error = Error.new(@base, attribute, type, **options)

if exception = options[:strict]
    exception = ActiveModel::StrictValidationFailed if exception == true
    raise exception, error.full_message
  end

@errors.append(error)

error
end
```

###  **added?**(attribute, type = :invalid, options = {}) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-added-3F)
Returns `true` if an error matches provided `attribute` and `type`, or `false` otherwise. `type` is treated the same as for `add`.

```
person.errors. :name, :blank
person.errors.added? :name, :blank           # => true
person.errors.added? :name, "can't be blank" # => true

If the error requires options, then it returns `true` with the correct options, or `false` with incorrect or missing options.

```
person.errors. :name, :too_long, count:
person.errors.added? :name, :too_long, count:                      # => true
person.errors.added? :name, "is too long (maximum is 25 characters)" # => true
person.errors.added? :name, :too_long, count:                      # => false
person.errors.added? :name, :too_long                                # => false
person.errors.added? :name, "is too long"                            # => false

Source: [show](javascript:toggleSource\('method-i-added-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L369)

# File activemodel/lib/active_model/errors.rb, line 369
def added?(attribute, type = :invalid, options = {})
  attribute, type, options = normalize_arguments(attribute, type, **options)

if type.is_a? Symbol
    @errors.any? { |error|
      error.strict_match?(attribute, type, **options)
    }
  else
    messages_for(attribute).include?(type)
  end
end
```

###  **as_json**(options = nil) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-as_json)
Returns a [`Hash`](https://api.rubyonrails.org/classes/Hash.html) that can be used as the JSON representation for this object. You can pass the `:full_messages` option. This determines if the JSON object should contain full messages or not (false by default).

```
person.errors.as_json                      # => {:name=>["cannot be nil"]}
person.errors.as_json(full_messages: ) # => {:name=>["name cannot be nil"]}

Source: [show](javascript:toggleSource\('method-i-as_json_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L244)

# File activemodel/lib/active_model/errors.rb, line 244
def as_json(options = nil)
  to_hash(options  options[:full_messages])
end
```

###  **attribute_names**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-attribute_names)
Returns all error attribute names

```
person.errors.messages        # => {:name=>["cannot be nil", "must be specified"]}
person.errors.attribute_names # => [:name]

Source: [show](javascript:toggleSource\('method-i-attribute_names_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L234)

# File activemodel/lib/active_model/errors.rb, line 234
def attribute_names
  @errors.map(:attribute).uniq.freeze
end
```

###  **clear** [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-clear)
Clears all errors. Clearing the errors does not, however, make the model valid. The next time the validations are run (for example, via [`ActiveRecord::Validations#valid?`](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html#method-i-valid-3F)), the errors collection will be filled again if any validations fail.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L77)

# File activemodel/lib/active_model/errors.rb, line 77

###  **delete**(attribute, type = nil, **options) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-delete)
Delete messages for `key`. Returns the deleted messages.

```
person.errors[:name]        # => ["cannot be nil"]
person.errors.delete(:name) # => ["cannot be nil"]
person.errors[:name]        # => []

Source: [show](javascript:toggleSource\('method-i-delete_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L212)

# File activemodel/lib/active_model/errors.rb, line 212
def delete(attribute, type = nil, **options)
  attribute, type, options = normalize_arguments(attribute, type, **options)
  matches = where(attribute, type, **options)
  matches.each do |error|
    @errors.delete(error)
  end
  matches.map(:message).presence
end
```

###  **details**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-details)
Returns a [`Hash`](https://api.rubyonrails.org/classes/Hash.html) of attributes with an array of their error details.
Source: [show](javascript:toggleSource\('method-i-details_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L273)

# File activemodel/lib/active_model/errors.rb, line 273
def details
  hash = group_by_attribute.transform_values do |errors|
    errors.map(:details)
  end
  hash.default = EMPTY_ARRAY
  hash.freeze
  hash
end
```

###  **each( &block) ** [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-each)
Iterates through each error object.

```
person.errors.add(:name, :too_short, count: 2)
person.errors.each do |error|

# Will yield <#ActiveModel::Error attribute=name, type=too_short,
                                    options={:count=>3}>
end
```

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L64)

# File activemodel/lib/active_model/errors.rb, line 64

###  **empty?** [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-empty-3F)
Returns true if there are no errors.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L87)

# File activemodel/lib/active_model/errors.rb, line 87

###  **full_message**(attribute, message) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-full_message)
Returns a full message for a given attribute.

```
person.errors.full_message(:name, 'is invalid') # => "Name is invalid"

Source: [show](javascript:toggleSource\('method-i-full_message_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L448)

# File activemodel/lib/active_model/errors.rb, line 448
def full_message(attribute, message)
  Error.full_message(attribute, message, @base)
end
```

###  **full_messages**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-full_messages)
Returns all the full error messages in an array.

```
class Person
  validates_presence_of :name, :address, :email
  validates_length_of :name,  ..

person = Person.create(address: '123 First St.')
person.errors.full_messages

# => ["Name is too short (minimum is 5 characters)", "Name can't be blank", "Email can't be blank"]

Also aliased as: [to_a](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-to_a)
Source: [show](javascript:toggleSource\('method-i-full_messages_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L412)

# File activemodel/lib/active_model/errors.rb, line 412
def full_messages
  @errors.map(:full_message)
end
```

###  **full_messages_for**(attribute) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-full_messages_for)
Returns all the full error messages for a given attribute in an array.

```
class Person
  validates_presence_of :name, :email
  validates_length_of :name,  ..

person = Person.create()
person.errors.full_messages_for(:name)

# => ["Name is too short (minimum is 5 characters)", "Name can't be blank"]

Source: [show](javascript:toggleSource\('method-i-full_messages_for_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L427)

# File activemodel/lib/active_model/errors.rb, line 427
def full_messages_for(attribute)
  where(attribute).map(:full_message).freeze
end
```

###  **generate_message**(attribute, type = :invalid, options = {}) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-generate_message)
Translates an error message in its default scope (`activemodel.errors.messages`).
[`Error`](https://api.rubyonrails.org/classes/ActiveModel/Error.html) messages are first looked up in `activemodel.errors.models.MODEL.attributes.ATTRIBUTE.MESSAGE`, if it’s not there, it’s looked up in `activemodel.errors.models.MODEL.MESSAGE` and if that is not there also, it returns the translation of the default message (e.g. `activemodel.errors.messages.MESSAGE`). The translated model name, translated attribute name, and the value are available for interpolation.
When using inheritance in your models, it will check all the inherited models too, but only if the model itself hasn’t been found. Say you have `class Admin < User; end` and you wanted the translation for the `:blank` error message for the `title` attribute, it looks for these translations:
  * `activemodel.errors.models.admin.attributes.title.blank`
  * `activemodel.errors.models.admin.blank`
  * `activemodel.errors.models.user.attributes.title.blank`
  * `activemodel.errors.models.user.blank`
  * any default you provided through the `options` hash (in the `activemodel.errors` scope)
  * `activemodel.errors.messages.blank`
  * `errors.attributes.title.blank`
  * `errors.messages.blank`

Source: [show](javascript:toggleSource\('method-i-generate_message_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L476)

# File activemodel/lib/active_model/errors.rb, line 476
def generate_message(attribute, type = :invalid, options = {})
  Error.generate_message(attribute, type, @base, options)
end
```

###  **group_by_attribute**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-group_by_attribute)
Returns a [`Hash`](https://api.rubyonrails.org/classes/Hash.html) of attributes with an array of their [`Error`](https://api.rubyonrails.org/classes/ActiveModel/Error.html) objects.

```
person.errors.group_by_attribute

# => {:name=>[<#ActiveModel::Error>, <#ActiveModel::Error>]}

Source: [show](javascript:toggleSource\('method-i-group_by_attribute_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L286)

# File activemodel/lib/active_model/errors.rb, line 286
def group_by_attribute
  @errors.group_by(:attribute)
end
```

###  **has_key?**(attribute) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-has_key-3F)
Alias for: [include?](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-include-3F)

###  **import**(error, override_options = {}) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-import)
Imports one error. Imported errors are wrapped as a [`NestedError`](https://api.rubyonrails.org/classes/ActiveModel/NestedError.html), providing access to original error object. If attribute or type needs to be overridden, use `override_options`.

#### Options
  * `:attribute` - Override the attribute the error belongs to.
  * `:type` - Override type of the error.

Source: [show](javascript:toggleSource\('method-i-import_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L151)

# File activemodel/lib/active_model/errors.rb, line 151
def import(error, override_options = {})
  [:attribute, :type].each do |key|
    if override_options.key?(key)
      override_options[key] = override_options[key].to_sym
    end
  end
  @errors.append(NestedError.new(@base, error, override_options))
end
```

###  **include?**(attribute) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-include-3F)
Returns `true` if the error messages include an error for the given key `attribute`, `false` otherwise.

```
person.errors.messages        # => {:name=>["cannot be nil"]}
person.errors.include?(:name) # => true
person.errors.include?()  # => false

Also aliased as: [has_key?](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-has_key-3F), [key?](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-key-3F)
Source: [show](javascript:toggleSource\('method-i-include-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L199)

# File activemodel/lib/active_model/errors.rb, line 199
def include?(attribute)
  @errors.any? { |error|
    error.match?(attribute.to_sym)
  }
end
```

###  **key?**(attribute) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-key-3F)
Alias for: [include?](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-include-3F)

###  **merge!**(other) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-merge-21)
Merges the errors from `other`, each [`Error`](https://api.rubyonrails.org/classes/ActiveModel/Error.html) wrapped as [`NestedError`](https://api.rubyonrails.org/classes/ActiveModel/NestedError.html).

#### Parameters
  * `other` - The [`ActiveModel::Errors`](https://api.rubyonrails.org/classes/ActiveModel/Errors.html) instance.

#### Examples

```
person.errors.merge!(other)

Source: [show](javascript:toggleSource\('method-i-merge-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L171)

# File activemodel/lib/active_model/errors.rb, line 171
def merge!(other)
  return errors if equal?(other)

other.errors.each { |error|
    import(error)
  }
end
```

###  **messages**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-messages)
Returns a [`Hash`](https://api.rubyonrails.org/classes/Hash.html) of attributes with an array of their error messages.
Source: [show](javascript:toggleSource\('method-i-messages_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L265)

# File activemodel/lib/active_model/errors.rb, line 265
def messages
  hash = to_hash
  hash.default = EMPTY_ARRAY
  hash.freeze
  hash
end
```

###  **messages_for**(attribute) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-messages_for)
Returns all the error messages for a given attribute in an array.

person = Person.create()
person.errors.messages_for(:name)

# => ["is too short (minimum is 5 characters)", "can't be blank"]

Source: [show](javascript:toggleSource\('method-i-messages_for_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L441)

# File activemodel/lib/active_model/errors.rb, line 441
def messages_for(attribute)
  where(attribute).map(:message)
end
```

###  **of_kind?**(attribute, type = :invalid) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-of_kind-3F)
Returns `true` if an error on the attribute with the given type is present, or `false` otherwise. `type` is treated the same as for `add`.

```
person.errors.
person.errors. :name, :too_long, count:
person.errors.of_kind?                                             # => true
person.errors.of_kind? :name                                           # => false
person.errors.of_kind? :name, :too_long                                # => true
person.errors.of_kind? :name, "is too long (maximum is 25 characters)" # => true
person.errors.of_kind? :name, :not_too_long                            # => false
person.errors.of_kind? :name, "is too long"                            # => false

Source: [show](javascript:toggleSource\('method-i-of_kind-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L392)

# File activemodel/lib/active_model/errors.rb, line 392
def of_kind?(attribute, type = :invalid)
  attribute, type = normalize_arguments(attribute, type)

if type.is_a? Symbol
    !where(attribute, type).empty?
  else
    messages_for(attribute).include?(type)
  end
end
```

###  **size** [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-size)
Returns number of errors.
Source: [show](javascript:toggleSource\('method-i-size_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L100)

# File activemodel/lib/active_model/errors.rb, line 100
delegate :each, :clear, :empty?, :size, :uniq!, to: :@errors

###  **to_a**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-to_a)
Alias for: [full_messages](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-full_messages)

###  **to_hash**(full_messages = false) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-to_hash)
Returns a [`Hash`](https://api.rubyonrails.org/classes/Hash.html) of attributes with their error messages. If [`full_messages`](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-full_messages) is `true`, it will contain full messages (see [`full_message`](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-full_message)).

```
person.errors.to_hash       # => {:name=>["cannot be nil"]}
person.errors.to_hash() # => {:name=>["name cannot be nil"]}

Source: [show](javascript:toggleSource\('method-i-to_hash_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L253)

# File activemodel/lib/active_model/errors.rb, line 253
def to_hash(full_messages = false)
  message_method = full_messages ? :full_message : :message
  group_by_attribute.transform_values do |errors|
    errors.map(message_method)
  end
end
```

###  **where**(attribute, type = nil, **options) [Link](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-where)
Search for errors matching `attribute`, `type`, or `options`.
Only supplied params will be matched.

```
person.errors.where(:name) # => all name errors.
person.errors.where(:name, :too_short) # => all name errors being too short
person.errors.where(:name, :too_short, minimum: ) # => all name errors being too short and minimum is 2

Source: [show](javascript:toggleSource\('method-i-where_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/errors.rb#L186)

# File activemodel/lib/active_model/errors.rb, line 186
def where(attribute, type = nil, **options)
  attribute, type, options = normalize_arguments(attribute, type, **options)
  @errors.select { |error|
    error.match?(attribute, type, **options)
  }
end
```