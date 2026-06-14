# Active Record Attribute Methods
Namespace
  * MODULE [ActiveRecord::AttributeMethods::BeforeTypeCast](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/BeforeTypeCast.html)
  * MODULE [ActiveRecord::AttributeMethods::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/ClassMethods.html)
  * MODULE [ActiveRecord::AttributeMethods::Dirty](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Dirty.html)
  * MODULE [ActiveRecord::AttributeMethods::PrimaryKey](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/PrimaryKey.html)
  * MODULE [ActiveRecord::AttributeMethods::Query](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Query.html)
  * MODULE [ActiveRecord::AttributeMethods::Read](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Read.html)
  * MODULE [ActiveRecord::AttributeMethods::Serialization](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Serialization.html)
  * MODULE [ActiveRecord::AttributeMethods::TimeZoneConversion](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/TimeZoneConversion.html)
  * MODULE [ActiveRecord::AttributeMethods::Write](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Write.html)

Methods

#

A

H

R

Included Modules
  * [ ActiveModel::AttributeMethods ](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html)
  * [ ActiveRecord::AttributeMethods::Read ](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Read.html)
  * [ ActiveRecord::AttributeMethods::Write ](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Write.html)
  * [ ActiveRecord::AttributeMethods::BeforeTypeCast ](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/BeforeTypeCast.html)
  * [ ActiveRecord::AttributeMethods::Query ](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Query.html)
  * [ ActiveRecord::AttributeMethods::PrimaryKey ](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/PrimaryKey.html)
  * [ ActiveRecord::AttributeMethods::TimeZoneConversion ](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/TimeZoneConversion.html)
  * [ ActiveRecord::AttributeMethods::Dirty ](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Dirty.html)
  * [ ActiveRecord::AttributeMethods::Serialization ](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Serialization.html)

## Constants
| RESTRICTED_CLASS_METHODS  | =  | %w(private public protected allocate new name superclass)  |
| --- | --- | --- |

## Instance Public methods

###  **[]**(attr_name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods.html#method-i-5B-5D)
Returns the value of the attribute identified by `attr_name` after it has been type cast. (For information about specific type casting behavior, see the types under [`ActiveModel::Type`](https://api.rubyonrails.org/classes/ActiveModel/Type.html).)

```
class Person  ActiveRecord::Base
  belongs_to :organization

person = Person.(name: "Francesco", date_of_birth: "2004-12-12")
person[:name]            # => "Francesco"
person[:date_of_birth]   # => Date.new(2004, 12, 12)
person[:organization_id] # => nil

```

Raises [`ActiveModel::MissingAttributeError`](https://api.rubyonrails.org/classes/ActiveModel/MissingAttributeError.html) if the attribute is missing. Note, however, that the `id` attribute will never be considered missing.

```
person = Person.select(:name).first
person[:name]            # => "Francesco"
person[:date_of_birth]   # => ActiveModel::MissingAttributeError: missing attribute 'date_of_birth' for Person
person[:organization_id] # => ActiveModel::MissingAttributeError: missing attribute 'organization_id' for Person
person[]              # => nil

Source: [show](javascript:toggleSource\('method-i-5B-5D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/attribute_methods.rb#L415)

# File activerecord/lib/active_record/attribute_methods.rb, line 415
def [](attr_name)
  read_attribute(attr_name) { |n| missing_attribute(n, caller) }
end
```

###  **[]=**(attr_name, value) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods.html#method-i-5B-5D-3D)
Updates the attribute identified by `attr_name` using the specified `value`. The attribute value will be type cast upon being read.

```
class Person  ActiveRecord::Base

person = Person.
person[:date_of_birth] = "2004-12-12"
person[:date_of_birth] # => Date.new(2004, 12, 12)

Source: [show](javascript:toggleSource\('method-i-5B-5D-3D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/attribute_methods.rb#L428)

# File activerecord/lib/active_record/attribute_methods.rb, line 428
def []=(attr_name, value)
  write_attribute(attr_name, value)
end
```

###  **accessed_fields**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods.html#method-i-accessed_fields)
Returns the name of all database fields which have been read from this model. This can be useful in development mode to determine which fields need to be selected. For performance critical pages, selecting only the required fields can be an easy performance win (assuming you aren’t using all of the fields on the model).
For example:

```
class PostsController  ActionController::Base
  after_action :print_accessed_fields, only: :index

index
    @posts = Post.

private
     print_accessed_fields
       @posts.first.accessed_fields

Which allows you to quickly change your code to:

```
class PostsController  ActionController::Base
   index
    @posts = Post.select(, :title, :author_id, :updated_at)

Source: [show](javascript:toggleSource\('method-i-accessed_fields_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/attribute_methods.rb#L460)

# File activerecord/lib/active_record/attribute_methods.rb, line 460
def accessed_fields
  @attributes.accessed
end
```

###  **attribute_for_inspect**(attr_name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods.html#method-i-attribute_for_inspect)
Returns an inspect-like string for the value of the attribute `attr_name`. [`String`](https://api.rubyonrails.org/classes/String.html) attributes are truncated up to 50 characters. Other attributes return the value of inspect without modification.

```
person = Person.create!(name: 'David Heinemeier Hansson ' * )

person.attribute_for_inspect(:name)

# => "\"David Heinemeier Hansson David Heinemeier Hansson ...\""

person.attribute_for_inspect(:created_at)

# => "\"2012-10-22 00:15:07.000000000 +0000\""

person.attribute_for_inspect(:tag_ids)

# => "[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]"

Source: [show](javascript:toggleSource\('method-i-attribute_for_inspect_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/attribute_methods.rb#L365)

# File activerecord/lib/active_record/attribute_methods.rb, line 365
def attribute_for_inspect(attr_name)
  attr_name = attr_name.to_s
  attr_name = self.class.attribute_aliases[attr_name] || attr_name
  value = _read_attribute(attr_name)
  format_for_inspect(attr_name, value)
end
```

###  **attribute_names**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods.html#method-i-attribute_names)
Returns an array of names for the attributes available on this object.

person = Person.
person.attribute_names

# => ["id", "created_at", "updated_at", "name", "age"]

Source: [show](javascript:toggleSource\('method-i-attribute_names_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/attribute_methods.rb#L334)

# File activerecord/lib/active_record/attribute_methods.rb, line 334
def attribute_names
  @attributes.keys
end
```

###  **attribute_present?**(attr_name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods.html#method-i-attribute_present-3F)
Returns `true` if the specified `attribute` has been set by the user or by a database load and is neither `nil` nor `empty?` (the latter only applies to objects that respond to `empty?`, most notably Strings). Otherwise, `false`. Note that it always returns `true` with boolean attributes.

```
class Task  ActiveRecord::Base

task = Task.(title: , is_done: false)
task.attribute_present?(:title)   # => false
task.attribute_present?(:is_done) # => true
task.title = 'Buy milk'
task.is_done =
task.attribute_present?(:title)   # => true
task.attribute_present?(:is_done) # => true

Source: [show](javascript:toggleSource\('method-i-attribute_present-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/attribute_methods.rb#L387)

# File activerecord/lib/active_record/attribute_methods.rb, line 387
def attribute_present?(attr_name)
  attr_name = attr_name.to_s
  attr_name = self.class.attribute_aliases[attr_name] || attr_name
  value = _read_attribute(attr_name)
  !value.nil?  !(value.respond_to?(:empty?)  value.empty?)
end
```

###  **attributes**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods.html#method-i-attributes)
Returns a hash of all the attributes with their names as keys and the values of the attributes as values.

person = Person.create(name: 'Francesco',  )
person.attributes

# => {"id"=>3, "created_at"=>Sun, 21 Oct 2012 04:53:04, "updated_at"=>Sun, 21 Oct 2012 04:53:04, "name"=>"Francesco", "age"=>22}

Source: [show](javascript:toggleSource\('method-i-attributes_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/attribute_methods.rb#L346)

# File activerecord/lib/active_record/attribute_methods.rb, line 346
def attributes
  @attributes.to_hash
end
```

###  **has_attribute?**(attr_name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods.html#method-i-has_attribute-3F)
Returns `true` if the given attribute is in the attributes hash, otherwise `false`.

```
class Person  ActiveRecord::Base
  alias_attribute :new_name, :name

person = Person.
person.has_attribute?(:name)     # => true
person.has_attribute?(:new_name) # => true
person.has_attribute?('age')     # => true
person.has_attribute?(:nothing)  # => false

Source: [show](javascript:toggleSource\('method-i-has_attribute-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/attribute_methods.rb#L316)

# File activerecord/lib/active_record/attribute_methods.rb, line 316
def has_attribute?(attr_name)
  attr_name = attr_name.to_s
  attr_name = self.class.attribute_aliases[attr_name] || attr_name
  @attributes.key?(attr_name)
end
```

###  **respond_to?**(name, include_private = false) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods.html#method-i-respond_to-3F)
A Person object with a name attribute can ask `person.respond_to?(:name)`, `person.respond_to?(:name=)`, and `person.respond_to?(:name?)` which will all return `true`. It also defines the attribute methods if they have not been generated.

person = Person.
person.respond_to?(:name)    # => true
person.respond_to?(:name=)   # => true
person.respond_to?(:name?)   # => true
person.respond_to?('age')    # => true
person.respond_to?('age=')   # => true
person.respond_to?('age?')   # => true
person.respond_to?(:nothing) # => false

Source: [show](javascript:toggleSource\('method-i-respond_to-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/attribute_methods.rb#L291)

# File activerecord/lib/active_record/attribute_methods.rb, line 291
def respond_to?(name, include_private = false)
  return false unless super

# If the result is true then check for the select case.

# For queries selecting a subset of columns, return false for unselected columns.
  if @attributes
    if name = self.class.symbol_column_to_string(name.to_sym)
      return _has_attribute?(name)
    end
  end

true
end
```