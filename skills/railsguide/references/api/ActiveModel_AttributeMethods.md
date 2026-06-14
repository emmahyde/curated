# Active Model Attribute Methods
Provides a way to add prefixes and suffixes to your methods as well as handling the creation of [`ActiveRecord::Base`](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) - like class methods such as `table_name`.
The requirements to implement [`ActiveModel::AttributeMethods`](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html) are to:
  * `include ActiveModel::AttributeMethods` in your class.
  * Call each of its methods you want to add, such as `attribute_method_suffix` or `attribute_method_prefix`.
  * Call `define_attribute_methods` after the other methods are called.
  * Define the various generic `_attribute` methods that you have declared.
  * Define an `attributes` method which returns a hash with each attribute name in your model as hash key and the attribute value as hash value. [`Hash`](https://api.rubyonrails.org/classes/Hash.html) keys must be strings.

A minimal implementation could be:

```
class Person
  include ActiveModel::AttributeMethods

attribute_method_affix  prefix: 'reset_', suffix: '_to_default!'
  attribute_method_suffix '_contrived?'
  attribute_method_prefix 'clear_'
  define_attribute_methods :name

attr_accessor :name

attributes
    { 'name' => @name }

private
     attribute_contrived?(attr)

clear_attribute(attr)
      ("#{attr}=", )

reset_attribute_to_default!(attr)
      ("#{attr}=", 'Default Name')

```

Namespace
  * MODULE [ActiveModel::AttributeMethods::ClassMethods](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods/ClassMethods.html)

Methods

A

M

R

* respond_to_without_attributes?

## Constants
| CALL_COMPILABLE_REGEXP  | =  | /\A[a-zA-Z_]\w*[!?]?\z/  |
| --- | --- | --- |
| NAME_COMPILABLE_REGEXP  | =  | /\A[a-zA-Z_]\w*[!?=]?\z/  |

## Instance Public methods

###  **attribute_missing**(match, ...) [Link](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-attribute_missing)
[`attribute_missing`](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-attribute_missing) is like [`method_missing`](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-method_missing), but for attributes. When [`method_missing`](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-method_missing) is called we check to see if there is a matching attribute method. If so, we tell [`attribute_missing`](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-attribute_missing) to dispatch the attribute. This method can be overloaded to customize the behavior.
Source: [show](javascript:toggleSource\('method-i-attribute_missing_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/attribute_methods.rb#L520)

# File activemodel/lib/active_model/attribute_methods.rb, line 520
def attribute_missing(match, ...)
  __send__(match.proxy_target, match.attr_name, ...)
end
```

###  **method_missing**(method, ...) [Link](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-method_missing)
Allows access to the object attributes, which are held in the hash returned by `attributes`, as though they were first-class methods. So a `Person` class with a `name` attribute can for example use `Person#name` and `Person#name=` and never directly use the attributes hash – except for multiple assignments with `ActiveRecord::Base#attributes=`.
It’s also possible to instantiate related objects, so a `Client` class belonging to the `clients` table with a `master_id` foreign key can instantiate master through `Client#master`.
Source: [show](javascript:toggleSource\('method-i-method_missing_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/attribute_methods.rb#L507)

# File activemodel/lib/active_model/attribute_methods.rb, line 507
def method_missing(method, ...)
  if respond_to_without_attributes?(method, true)
    super
  else
    match = matched_attribute_method(method.name)
    match ? attribute_missing(match, ...) : super
  end
end
```

###  **respond_to?**(method, include_private_methods = false) [Link](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-respond_to-3F)
Also aliased as: [respond_to_without_attributes?](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-respond_to_without_attributes-3F)
Source: [show](javascript:toggleSource\('method-i-respond_to-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/attribute_methods.rb#L528)

# File activemodel/lib/active_model/attribute_methods.rb, line 528
def respond_to?(method, include_private_methods = false)
  if super
    true
  elsif !include_private_methods  super(method, true)
    # If we're here then we haven't found among non-private methods
    # but found among all methods. Which means that the given method is private.
    false
  else
    !matched_attribute_method(method.to_s).nil?
  end
end
```

###  **respond_to_without_attributes?**(method, include_private_methods = false) [Link](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-respond_to_without_attributes-3F)
A `Person` instance with a `name` attribute can ask `person.respond_to?(:name)`, `person.respond_to?(:name=)`, and `person.respond_to?(:name?)` which will all return `true`.
Alias for: [respond_to?](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html#method-i-respond_to-3F)