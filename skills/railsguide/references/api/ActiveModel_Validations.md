# Active Model Validations
Provides a full validation framework to your objects.
A minimal implementation could be:

```
class Person
  include ActiveModel::Validations

attr_accessor :first_name, :last_name

validates_each :first_name, :last_name  |record, attr, value|
    record.errors. attr, "starts with z."  value.start_with?()

```

Which provides you with the full standard validation stack that you know from Active Record:

```
person = Person.
person.valid?                   # => true
person.invalid?                 # => false

person.first_name = 'zoolander'
person.valid?                   # => false
person.invalid?                 # => true
person.errors.messages          # => {first_name:["starts with z."]}

Note that [`ActiveModel::Validations`](https://api.rubyonrails.org/classes/ActiveModel/Validations.html) automatically adds an `errors` method to your instances initialized with a new [`ActiveModel::Errors`](https://api.rubyonrails.org/classes/ActiveModel/Errors.html) object, so there is no need for you to do this manually.
Namespace
  * MODULE [ActiveModel::Validations::Callbacks](https://api.rubyonrails.org/classes/ActiveModel/Validations/Callbacks.html)
  * MODULE [ActiveModel::Validations::ClassMethods](https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html)
  * MODULE [ActiveModel::Validations::HelperMethods](https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html)

Methods

E

F

I

R

V

Included Modules
  * [ ActiveModel::Validations::HelperMethods ](https://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html)

## Instance Public methods

###  **errors**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-errors)
Returns the [`Errors`](https://api.rubyonrails.org/classes/ActiveModel/Errors.html) object that holds all information about attribute error messages.

attr_accessor :name
  validates_presence_of :name

person = Person.
person.valid? # => false
person.errors # => #<ActiveModel::Errors:0x007fe603816640 @messages={name:["can't be blank"]}>

Source: [show](javascript:toggleSource\('method-i-errors_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validations.rb#L330)

# File activemodel/lib/active_model/validations.rb, line 330
def errors
  @errors ||= Errors.new(self)
end
```

###  **freeze**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-freeze)
Source: [show](javascript:toggleSource\('method-i-freeze_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validations.rb#L374)

# File activemodel/lib/active_model/validations.rb, line 374
def freeze
  errors
  context_for_validation

super
end
```

###  **invalid?**(context = nil) [Link](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-invalid-3F)
Performs the opposite of `valid?`. Returns `true` if errors were added, `false` otherwise.

person = Person.
person. =
person.invalid? # => true
person. = 'david'
person.invalid? # => false

Context can optionally be supplied to define which callbacks to test against (the context is defined on the validations using `:on`).

attr_accessor :name
  validates_presence_of :name,

person = Person.
person.invalid?       # => false
person.invalid?() # => true

Source: [show](javascript:toggleSource\('method-i-invalid-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validations.rb#L410)

# File activemodel/lib/active_model/validations.rb, line 410
def invalid?(context = nil)
  !valid?(context)
end
```

###  **valid?**(context = nil) [Link](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-valid-3F)
Runs all the specified validations and returns `true` if no errors were added otherwise `false`.

person = Person.
person. =
person.valid? # => false
person. = 'david'
person.valid? # => true

person = Person.
person.valid?       # => true
person.valid?() # => false

Also aliased as: [validate](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validate)
Source: [show](javascript:toggleSource\('method-i-valid-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validations.rb#L363)

# File activemodel/lib/active_model/validations.rb, line 363
def valid?(context = nil)
  current_context = validation_context
  context_for_validation.context = context
  errors.clear
  run_validations!
ensure
  context_for_validation.context = current_context
end
```

###  **validate**(context = nil) [Link](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validate)
Alias for: [valid?](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-valid-3F)

###  **validate!**(context = nil) [Link](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validate-21)
Runs all the validations within the specified context. Returns `true` if no errors are found, raises [`ValidationError`](https://api.rubyonrails.org/classes/ActiveModel/ValidationError.html) otherwise.
[`Validations`](https://api.rubyonrails.org/classes/ActiveModel/Validations.html) with no `:on` option will run no matter the context. [`Validations`](https://api.rubyonrails.org/classes/ActiveModel/Validations.html) with some `:on` option will only run in the specified context.
Source: [show](javascript:toggleSource\('method-i-validate-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validations.rb#L419)

# File activemodel/lib/active_model/validations.rb, line 419
def validate!(context = nil)
  valid?(context) || raise_validation_error
end
```

###  **validates_with**(*args, &block) [Link](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validates_with)
Passes the record off to the class or classes specified and allows them to add errors based on more complex conditions.

validate :instance_validations

instance_validations
    validates_with MyValidator

Please consult the class method documentation for more information on creating your own validator.
You may also pass it multiple classes, like so:

validate :instance_validations,  :create

instance_validations
    validates_with MyValidator, MyOtherValidator

Standard configuration options (`:on`, `:if` and `:unless`), which are available on the class version of [`validates_with`](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validates_with), should instead be placed on the `validates` method as these are applied and tested in the callback.
If you pass any additional configuration options, they will be passed to the class and available as `options`, please refer to the class version of this method for more information.
Source: [show](javascript:toggleSource\('method-i-validates_with_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validations/with.rb#L144)

# File activemodel/lib/active_model/validations/with.rb, line 144
def validates_with(*args, block)
  options = args.extract_options!
  options[:class] = self.class

args.each do |klass|
    validator = klass.new(options.dup, block)
    validator.validate(self)
  end
end
```

###  **validation_context**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validation_context)
Returns the context when running validations.
Source: [show](javascript:toggleSource\('method-i-validation_context_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validations.rb#L442)

# File activemodel/lib/active_model/validations.rb, line 442
def validation_context
  context_for_validation.context
end
```

## Instance Private methods

###  **raise_validation_error**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-raise_validation_error)
Source: [show](javascript:toggleSource\('method-i-raise_validation_error_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/validations.rb#L466)

# File activemodel/lib/active_model/validations.rb, line 466
def raise_validation_error # :doc:
  raise(ValidationError.new(self))
end
```