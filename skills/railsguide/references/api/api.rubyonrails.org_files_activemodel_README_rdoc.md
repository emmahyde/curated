# Active Model – model interfaces for Rails
Active Model provides a known set of interfaces for usage in model classes. They allow for Action Pack helpers to interact with non-Active Record models, for example. Active Model also helps with building custom ORMs for use outside of the Rails framework.
You can read more about Active Model in the [Active Model Basics](https://guides.rubyonrails.org/active_model_basics.html) guide.
Prior to Rails 3.0, if a plugin or gem developer wanted to have an object interact with Action Pack helpers, it was required to either copy chunks of code from Rails, or monkey patch entire helpers to make them handle objects that did not exactly conform to the Active Record interface. This would result in code duplication and fragile applications that broke on upgrades. Active Model solves this by defining an explicit API. You can read more about the API in [`ActiveModel::Lint::Tests`](https://api.rubyonrails.org/classes/ActiveModel/Lint/Tests.html).
Active Model provides a default module that implements the basic API required to integrate with Action Pack out of the box: [`ActiveModel::API`](https://api.rubyonrails.org/classes/ActiveModel/API.html).

```
class Person
  include ActiveModel::API

attr_accessor :name,
  validates_presence_of :name

person = Person.(name: 'bob',  '18')
person.   # => 'bob'
person.    # => '18'
person.valid? # => true

```

It includes model name introspections, conversions, translations and validations, resulting in a class suitable to be used with Action Pack. See [`ActiveModel::API`](https://api.rubyonrails.org/classes/ActiveModel/API.html) for more examples.
Active Model also provides the following functionality to have ORM-like behavior out of the box:
  * Add attribute magic to objects

```
class Person
  include ActiveModel::AttributeMethods

attribute_method_prefix 'clear_'
  define_attribute_methods :name,

attr_accessor :name,

clear_attribute(attr)
    ("#{attr}=", )

person = Person.
person.clear_name
person.clear_age

[Learn more](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html)
  * Callbacks for certain operations

```
class Person
  extend ActiveModel::Callbacks
  define_model_callbacks :create

create
    run_callbacks :create
      # Your create action methods here

This generates `before_create`, `around_create` and `after_create` class methods that wrap your create method.
[Learn more](https://api.rubyonrails.org/classes/ActiveModel/Callbacks.html)
  * Tracking value changes

```
class Person
  include ActiveModel::Dirty

define_attribute_methods :name

@name

name=()
    name_will_change! unless  == @name
    @name =

# do persistence work
    changes_applied

person = Person.
person.             # => nil
person.changed?         # => false
person. = 'bob'
person.changed?         # => true
person.changed          # => ['name']
person.changes          # => { 'name' => [nil, 'bob'] }
person.save
person. = 'robert'
person.save
person.previous_changes # => {'name' => ['bob, 'robert']}

[Learn more](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html)
  * Adding `errors` interface to objects
Exposing error messages allows objects to interact with Action Pack helpers seamlessly.

```
class Person

initialize
    @errors = ActiveModel::Errors.()

attr_accessor :name
  attr_reader   :errors

validate!
    errors.(:name, "cannot be nil")  .

.human_attribute_name(attr, options = {})
    "Name"

person = Person.
person. =
person.validate!
person.errors.full_messages

# => ["Name cannot be nil"]

[Learn more](https://api.rubyonrails.org/classes/ActiveModel/Errors.html)
  * Model name introspection

```
class NamedPerson
  extend ActiveModel::Naming

NamedPerson.model_name.   # => "NamedPerson"
NamedPerson.model_name.human  # => "Named person"

[Learn more](https://api.rubyonrails.org/classes/ActiveModel/Naming.html)
  * Making objects serializable
[`ActiveModel::Serialization`](https://api.rubyonrails.org/classes/ActiveModel/Serialization.html) provides a standard interface for your object to provide `to_json` serialization.

```
class SerialPerson
  include ActiveModel::Serialization

attr_accessor :name

attributes
    {'name' => }

= SerialPerson.
.serializable_hash   # => {"name"=>nil}

class SerialPerson
  include ActiveModel::Serializers::JSON

= SerialPerson.
.to_json             # => "{\"name\":null}"

[Learn more](https://api.rubyonrails.org/classes/ActiveModel/Serialization.html)
  * Internationalization (i18n) support

```
class Person
  extend ActiveModel::Translation

Person.human_attribute_name('my_attribute')

# => "My attribute"

[Learn more](https://api.rubyonrails.org/classes/ActiveModel/Translation.html)
  * Validation support

```
class Person
  include ActiveModel::Validations

attr_accessor :first_name, :last_name

validates_each :first_name, :last_name  |record, attr, value|
    record.errors. attr, "starts with z."  value.start_with?()

person = Person.
person.first_name = 'zoolander'
person.valid?  # => false

[Learn more](https://api.rubyonrails.org/classes/ActiveModel/Validations.html)
  * Custom validators

```
class HasNameValidator  ActiveModel::Validator
   validate(record)
    record.errors.(:name, "must exist")  record..blank?

class ValidatorPerson
  include ActiveModel::Validations
  validates_with HasNameValidator
  attr_accessor :name

= ValidatorPerson.
.valid?                  # =>  false
.errors.full_messages    # => ["Name must exist"]
. = "Bob"
.valid?                  # =>  true

[Learn more](https://api.rubyonrails.org/classes/ActiveModel/Validator.html)

## Download and installation
The latest version of Active Model can be installed with RubyGems:

```
$ gem install activemodel
```

Source code can be downloaded as part of the Rails project on GitHub
  * [github.com/rails/rails/tree/main/activemodel](https://github.com/rails/rails/tree/main/activemodel)

## License
Active Model is released under the MIT license:
  * [opensource.org/licenses/MIT](https://opensource.org/licenses/MIT)

## Support
API documentation is at:
  * [api.rubyonrails.org](https://api.rubyonrails.org)

Bug reports for the Ruby on Rails project can be filed here:
  * [github.com/rails/rails/issues](https://github.com/rails/rails/issues)

Feature requests should be discussed on the rubyonrails-core forum here:
  * [discuss.rubyonrails.org/c/rubyonrails-core](https://discuss.rubyonrails.org/c/rubyonrails-core)