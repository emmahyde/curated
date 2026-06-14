# Active Model Validator
A simple base class that can be used along with [`ActiveModel::Validations::ClassMethods.validates_with`](https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates_with)

```
class Person
  include ActiveModel::Validations
  validates_with MyValidator

class MyValidator  ActiveModel::Validator
   validate(record)
     some_complex_logic
      record.errors.(:base, "This record is invalid")

private
     some_complex_logic
      # ...

```

Any class that inherits from ActiveModel::Validator must implement a method called `validate` which accepts a `record`.

class MyValidator  ActiveModel::Validator
   validate(record)
    record # => The person instance being validated
    options # => Any non-standard options passed to validates_with

To cause a validation error, you must add to the `record`‘s errors directly from within the validators message.

```
class MyValidator  ActiveModel::Validator
   validate(record)
    record.errors. :base, "This is some custom error message"
    record.errors. :first_name, "This is some complex validation"
    # etc...

To add behavior to the initialize method, use the following signature:

```
class MyValidator  ActiveModel::Validator
   initialize(options)
    super
    @my_custom_field = options[:field_name] || :first_name

Note that the validator is initialized only once for the whole application life cycle, and not on each validation run.
The easiest way to add custom validators for validating individual attributes is with the convenient [`ActiveModel::EachValidator`](https://api.rubyonrails.org/classes/ActiveModel/EachValidator.html) class.

```
class TitleValidator  ActiveModel::EachValidator
   validate_each(record, attribute, value)
    record.errors. attribute, 'must be Mr., Mrs., or Dr.' unless %w(Mr. Mrs. Dr.).include?(value)

This can now be used in combination with the `validates` method. See [`ActiveModel::Validations::ClassMethods#validates`](https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates) for more on this.

```
class Person
  include ActiveModel::Validations
  attr_accessor :title

validates :title, presence: , title:

It can be useful to access the class that is using that validator when there are prerequisites such as an `attr_accessor` being present. This class is accessible via `options[:class]` in the constructor. To set up your validator override the constructor.

```
class MyValidator  ActiveModel::Validator
   initialize(options={})
    super
    options[:class].attr_accessor :custom_attribute

Methods

K

N

V

## Attributes
|  [R]   | options  |
| --- | --- |

## Class Public methods

###  **kind**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Validator.html#method-c-kind)
Returns the kind of the validator.

```
PresenceValidator.kind   # => :presence
AcceptanceValidator.kind # => :acceptance

Source: [show](javascript:toggleSource\('method-c-kind_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validator.rb#L103)

# File activemodel/lib/active_model/validator.rb, line 103
def self.kind
  @kind ||= name.split("::").last.underscore.chomp("_validator").to_sym unless anonymous?
end
```

###  **new**(options = {}) [Link](https://api.rubyonrails.org/classes/ActiveModel/Validator.html#method-c-new)
Accepts options that will be made available through the `options` reader.
Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validator.rb#L108)

# File activemodel/lib/active_model/validator.rb, line 108
def initialize(options = {})
  @options = options.except(:class).freeze
end
```

## Instance Public methods

###  **kind**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Validator.html#method-i-kind)
Returns the kind for this validator.

```
PresenceValidator.(attributes: [:username]).kind # => :presence
AcceptanceValidator.(attributes: [:terms]).kind  # => :acceptance

Source: [show](javascript:toggleSource\('method-i-kind_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validator.rb#L116)

# File activemodel/lib/active_model/validator.rb, line 116
def kind
  self.class.kind
end
```

###  **validate**(record) [Link](https://api.rubyonrails.org/classes/ActiveModel/Validator.html#method-i-validate)
Override this method in subclasses with validation logic, adding errors to the records `errors` array where necessary.
Source: [show](javascript:toggleSource\('method-i-validate_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validator.rb#L122)

# File activemodel/lib/active_model/validator.rb, line 122
def validate(record)
  raise NotImplementedError, "Subclasses must implement a validate(record) method."
end
```