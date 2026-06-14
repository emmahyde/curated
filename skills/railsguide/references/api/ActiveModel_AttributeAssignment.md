Methods

A

* attribute_writer_missing,

## Instance Public methods

###  **assign_attributes**(new_attributes) [Link](https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html#method-i-assign_attributes)
Allows you to set all the attributes by passing in a hash of attributes with keys matching the attribute names.
If the passed hash responds to `permitted?` method and the return value of this method is `false` an [`ActiveModel::ForbiddenAttributesError`](https://api.rubyonrails.org/classes/ActiveModel/ForbiddenAttributesError.html) exception is raised.

```
class
  include ActiveModel::AttributeAssignment
  attr_accessor :name, :status

= .
.assign_attributes(name: "Gorby", status: "yawning")
. # => 'Gorby'
.status # => 'yawning'
.assign_attributes(status: "sleeping")
. # => 'Gorby'
.status # => 'sleeping'

```

Also aliased as: [attributes=](https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html#method-i-attributes-3D)
Source: [show](javascript:toggleSource\('method-i-assign_attributes_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/attribute_assignment.rb#L28)

# File activemodel/lib/active_model/attribute_assignment.rb, line 28
def assign_attributes(new_attributes)
  unless new_attributes.respond_to?(:each_pair)
    raise ArgumentError, "When assigning attributes, you must pass a hash as an argument, #{new_attributes.class} passed."
  end
  return if new_attributes.empty?

_assign_attributes(sanitize_for_mass_assignment(new_attributes))
end
```

###  **attribute_writer_missing**(name, value) [Link](https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html#method-i-attribute_writer_missing)
Like ‘BasicObject#method_missing`, `#attribute_writer_missing` is invoked when `#assign_attributes` is passed an unknown attribute name.
By default, ‘#attribute_writer_missing` raises an [`UnknownAttributeError`](https://api.rubyonrails.org/classes/ActiveModel/UnknownAttributeError.html).

```
class Rectangle
  include ActiveModel::AttributeAssignment

attr_accessor :length, :width

attribute_writer_missing(, value)
    Rails.logger. "Tried to assign to unknown attribute #{name}"

rectangle = Rectangle.
rectangle.assign_attributes(height: ) # => Logs "Tried to assign to unknown attribute 'height'"

Source: [show](javascript:toggleSource\('method-i-attribute_writer_missing_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/attribute_assignment.rb#L56)

# File activemodel/lib/active_model/attribute_assignment.rb, line 56
def attribute_writer_missing(name, value)
  raise UnknownAttributeError.new(self, name)
end
```

###  **attributes=**(new_attributes) [Link](https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html#method-i-attributes-3D)
Alias for: [assign_attributes](https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html#method-i-assign_attributes)