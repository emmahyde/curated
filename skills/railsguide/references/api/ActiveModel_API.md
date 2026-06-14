# Active Model API
Includes the required interface for an object to interact with Action Pack and Action View, using different Active Model modules. It includes model name introspections, conversions, translations, and validations. Besides that, it allows you to initialize the object with a hash of attributes, pretty much like Active Record does.
A minimal implementation could be:

```
class Person
  include ActiveModel::API
  attr_accessor :name,

person = Person.(name: 'bob',  '18')
person. # => "bob"
person.  # => "18"

```

Note that, by default, [`ActiveModel::API`](https://api.rubyonrails.org/classes/ActiveModel/API.html) implements [`persisted?`](https://api.rubyonrails.org/classes/ActiveModel/API.html#method-i-persisted-3F) to return `false`, which is the most common case. You may want to override it in your class to simulate a different scenario:

```
class Person
  include ActiveModel::API
  attr_accessor , :name

persisted?
    ..present?

person = Person.( , name: 'bob')
person.persisted? # => true

Also, if for some reason you need to run code on initialize ( [`::new`](https://api.rubyonrails.org/classes/ActiveModel/API.html#method-c-new) ), make sure you call `super` if you want the attributes hash initialization to happen.

```
class Person
  include ActiveModel::API
  attr_accessor , :name,

initialize(attributes={})
    super
    @omg ||=

person = Person.( , name: 'bob')
person. # => true

For more detailed information on other functionalities available, please refer to the specific modules included in [`ActiveModel::API`](https://api.rubyonrails.org/classes/ActiveModel/API.html) (see below).
Methods

N

P

Included Modules
  * [ ActiveModel::AttributeAssignment ](https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html)

## Class Public methods

###  **new**(attributes = {}) [Link](https://api.rubyonrails.org/classes/ActiveModel/API.html#method-c-new)
Initializes a new model with the given `params`.

Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/api.rb#L80)

# File activemodel/lib/active_model/api.rb, line 80
def initialize(attributes = {})
  assign_attributes(attributes) if attributes

super()
end
```

## Instance Public methods

###  **persisted?**() [Link](https://api.rubyonrails.org/classes/ActiveModel/API.html#method-i-persisted-3F)
Indicates if the model is persisted. Default is `false`.

person = Person.( , name: 'bob')
person.persisted? # => false

Source: [show](javascript:toggleSource\('method-i-persisted-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/api.rb#L95)

# File activemodel/lib/active_model/api.rb, line 95
def persisted?
  false
end
```