Methods

A

B

D

H

I

* instance_variable_names

P

T

W

Included Modules
  * [ ActiveSupport::NumericWithFormat ](https://api.rubyonrails.org/classes/ActiveSupport/NumericWithFormat.html)
  * Java

## Constants
| APP_PATH  | =  | File.expand_path("test/dummy/config/application", ENGINE_ROOT)  |
| --- | --- | --- |

## Instance Public methods

###  **acts_like?**(duck) [Link](https://api.rubyonrails.org/classes/Object.html#method-i-acts_like-3F)
Provides a way to check whether some class acts like some other class based on the existence of an appropriately-named marker method.
A class that provides the same interface as `SomeClass` may define a marker method named `acts_like_some_class?` to signal its compatibility to callers of `acts_like?(:some_class)`.
For example, Active Support extends [`Date`](https://api.rubyonrails.org/classes/Date.html) to define an `acts_like_date?` method, and extends [`Time`](https://api.rubyonrails.org/classes/Time.html) to define `acts_like_time?`. As a result, developers can call `x.acts_like?(:time)` and `x.acts_like?(:date)` to test duck-type compatibility, and classes that are able to act like [`Time`](https://api.rubyonrails.org/classes/Time.html) can also define an `acts_like_time?` method to interoperate.
Note that the marker method is only expected to exist. It isn’t called, so its body or return value are irrelevant.

#### Example: A class that provides the same interface as [`String`](https://api.rubyonrails.org/classes/String.html)
This class may define:

```
class Stringish
   acts_like_string?

```

Then client code can query for duck-type-safeness this way:

```
Stringish..acts_like?(:string) # => true

Source: [show](javascript:toggleSource\('method-i-acts_like-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/acts_like.rb#L33)

# File activesupport/lib/active_support/core_ext/object/acts_like.rb, line 33
def acts_like?(duck)
  case duck
  when :time
    respond_to? :acts_like_time?
  when :date
    respond_to? :acts_like_date?
  when :string
    respond_to? :acts_like_string?
  else
    respond_to? :"acts_like_#{duck}?"
  end
end
```

###  **blank?**() [Link](https://api.rubyonrails.org/classes/Object.html#method-i-blank-3F)
An object is blank if it’s false, empty, or a whitespace string. For example, `nil`, ”, ‘ ’, [], {}, and `false` are all blank.
This simplifies

```
!address || address.empty?

to

```
address.blank?

@return [true, false]
Source: [show](javascript:toggleSource\('method-i-blank-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/blank.rb#L18)

# File activesupport/lib/active_support/core_ext/object/blank.rb, line 18
def blank?
  respond_to?(:empty?) ? !!empty? : false
end
```

###  **deep_dup**() [Link](https://api.rubyonrails.org/classes/Object.html#method-i-deep_dup)
Returns a deep copy of object if it’s duplicable. If it’s not duplicable, returns `self`.

```
object = Object.
    = object.deep_dup
.instance_variable_set(, )

object.instance_variable_defined?() # => false
.instance_variable_defined?()    # => true

Source: [show](javascript:toggleSource\('method-i-deep_dup_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/deep_dup.rb#L15)

# File activesupport/lib/active_support/core_ext/object/deep_dup.rb, line 15
def deep_dup
  duplicable? ? dup : self
end
```

###  **duplicable?**() [Link](https://api.rubyonrails.org/classes/Object.html#method-i-duplicable-3F)
Can you safely dup this object?
False for method objects; true otherwise.
Source: [show](javascript:toggleSource\('method-i-duplicable-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/duplicable.rb#L26)

# File activesupport/lib/active_support/core_ext/object/duplicable.rb, line 26
def duplicable?
  true
end
```

###  **html_safe?**() [Link](https://api.rubyonrails.org/classes/Object.html#method-i-html_safe-3F)
Source: [show](javascript:toggleSource\('method-i-html_safe-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/string/output_safety.rb#L7)

# File activesupport/lib/active_support/core_ext/string/output_safety.rb, line 7
def html_safe?
  false
end
```

###  **in?**(another_object) [Link](https://api.rubyonrails.org/classes/Object.html#method-i-in-3F)
Returns true if this object is included in the argument.
When argument is a [`Range`](https://api.rubyonrails.org/classes/Range.html), cover? is used to properly handle inclusion check within open ranges. Otherwise, argument must be any object which responds to include?. Usage:

```
characters = ["Konata", "Kagami", "Tsukasa"]
"Konata".(characters) # => true

For non [`Range`](https://api.rubyonrails.org/classes/Range.html) arguments, this will throw an `ArgumentError` if the argument doesn’t respond to include?.
Source: [show](javascript:toggleSource\('method-i-in-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/inclusion.rb#L15)

# File activesupport/lib/active_support/core_ext/object/inclusion.rb, line 15
def in?(another_object)
  case another_object
  when Range
    another_object.cover?(self)
  else
    another_object.include?(self)
  end
rescue NoMethodError
  raise ArgumentError.new("The parameter passed to #in? must respond to #include?")
end
```

###  **instance_values**() [Link](https://api.rubyonrails.org/classes/Object.html#method-i-instance_values)
Returns a hash with string keys that maps instance variable names without “@” to their corresponding values.

```
class
   initialize(, )
    ,  = ,

.(, ).instance_values # => {"x" => 0, "y" => 1}

Source: [show](javascript:toggleSource\('method-i-instance_values_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/instance_variables.rb#L14)

# File activesupport/lib/active_support/core_ext/object/instance_variables.rb, line 14
def instance_values
  instance_variables.to_h do |ivar|
    [ivar[1..-1].freeze, instance_variable_get(ivar)]
  end
end
```

###  **instance_variable_names**() [Link](https://api.rubyonrails.org/classes/Object.html#method-i-instance_variable_names)
Returns an array of instance variable names as strings including “@”.

.(, ).instance_variable_names # => ["@y", "@x"]

Source: [show](javascript:toggleSource\('method-i-instance_variable_names_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/instance_variables.rb#L29)

# File activesupport/lib/active_support/core_ext/object/instance_variables.rb, line 29
def instance_variable_names
  instance_variables.map(:name)
end
```

###  **presence**() [Link](https://api.rubyonrails.org/classes/Object.html#method-i-presence)
Returns the receiver if it’s present otherwise returns `nil`. `object.presence` is equivalent to

```
object.present? ? object

For example, something like

```
state   = params[:state]    params[:state].present?
country = params[:country]  params[:country].present?
region  = state || country || 'US'

becomes

```
region = params[:state].presence || params[:country].presence || 'US'

@return [Object]
Source: [show](javascript:toggleSource\('method-i-presence_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/blank.rb#L45)

# File activesupport/lib/active_support/core_ext/object/blank.rb, line 45
def presence
  self if present?
end
```

###  **presence_in**(another_object) [Link](https://api.rubyonrails.org/classes/Object.html#method-i-presence_in)
Returns the receiver if it’s included in the argument otherwise returns `nil`. Argument must be any object which responds to include?. Usage:

```
params[:bucket_type].presence_in %w( project calendar )

This will throw an `ArgumentError` if the argument doesn’t respond to include?.
@return [Object]
Source: [show](javascript:toggleSource\('method-i-presence_in_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/inclusion.rb#L34)

# File activesupport/lib/active_support/core_ext/object/inclusion.rb, line 34
def presence_in(another_object)
  in?(another_object) ? self : nil
end
```

###  **present?**() [Link](https://api.rubyonrails.org/classes/Object.html#method-i-present-3F)
An object is present if it’s not blank.
@return [true, false]
Source: [show](javascript:toggleSource\('method-i-present-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/blank.rb#L25)

# File activesupport/lib/active_support/core_ext/object/blank.rb, line 25
def present?
  !blank?
end
```

###  **to_param**() [Link](https://api.rubyonrails.org/classes/Object.html#method-i-to_param)
Alias of `to_s`.
Source: [show](javascript:toggleSource\('method-i-to_param_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/to_query.rb#L8)

# File activesupport/lib/active_support/core_ext/object/to_query.rb, line 8
def to_param
  to_s
end
```

###  **to_query**(key) [Link](https://api.rubyonrails.org/classes/Object.html#method-i-to_query)
Converts an object into a string suitable for use as a URL query string, using the given `key` as the param name.
Source: [show](javascript:toggleSource\('method-i-to_query_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/to_query.rb#L14)

# File activesupport/lib/active_support/core_ext/object/to_query.rb, line 14
def to_query(key)
  "#{CGI.escape(key.to_param)}=#{CGI.escape(to_param.to_s)}"
end
```

###  **try(*args, &block) ** [Link](https://api.rubyonrails.org/classes/Object.html#method-i-try)
Invokes the public method whose name goes as first argument just like `public_send` does, except that if the receiver does not respond to it the call returns `nil` rather than raising an exception.
This method is defined to be able to write

```
@person.(:name)

instead of

```
@person.  @person

`try` calls can be chained:

```
@person.(:spouse).(:name)

```
@person.spouse.  @person  @person.spouse

`try` will also return `nil` if the receiver does not respond to the method:

```
@person.(:non_existing_method) # => nil

```
@person.non_existing_method  @person.respond_to?(:non_existing_method) # => nil

`try` returns `nil` when called on `nil` regardless of whether it responds to the method:

```
.(:to_i) # => nil, rather than 0

Arguments and blocks are forwarded to the method if invoked:

```
@posts.try(:each_slice, 2)  |a, b|
  ...

The number of arguments in the signature must match. If the object responds to the method the call is attempted and `ArgumentError` is still raised in case of argument mismatch.
If `try` is called without arguments it yields the receiver to a given block unless it is `nil`:

```
@person.try  |p|
  ...

You can also call try with a block without accepting an argument, and the block will be instance_eval’ed instead:

```
@person. { upcase.truncate() }

Please also note that `try` is defined on [`Object`](https://api.rubyonrails.org/classes/Object.html). Therefore, it won’t work with instances of classes that do not have [`Object`](https://api.rubyonrails.org/classes/Object.html) among their ancestors, like direct subclasses of `BasicObject`.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/try.rb#L39)

# File activesupport/lib/active_support/core_ext/object/try.rb, line 39

###  **try!(*args, &block) ** [Link](https://api.rubyonrails.org/classes/Object.html#method-i-try-21)
Same as [`try`](https://api.rubyonrails.org/classes/Object.html#method-i-try), but raises a `NoMethodError` exception if the receiver is not `nil` and does not implement the tried method.

```
.try!(:upcase) # => "A"
.try!(:upcase) # => nil
.try!(:upcase) # => NoMethodError: undefined method `upcase' for 123:Integer

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/try.rb#L104)

# File activesupport/lib/active_support/core_ext/object/try.rb, line 104

###  **with**(**attributes) [Link](https://api.rubyonrails.org/classes/Object.html#method-i-with)
Set and restore public attributes around a block.

```
client.timeout # => 5
client.with(timeout: )  ||
  .timeout # => 1

client.timeout # => 5

The receiver is yielded to the provided block.
This method is a shorthand for the common begin/ensure pattern:

```
old_value = object.attribute
begin
  object.attribute = new_value

# do things
ensure
  object.attribute = old_value

It can be used on any object as long as both the reader and writer methods are public.
Source: [show](javascript:toggleSource\('method-i-with_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/with.rb#L26)

# File activesupport/lib/active_support/core_ext/object/with.rb, line 26
def with(**attributes)
  old_values = {}
  begin
    attributes.each do |key, value|
      old_values[key] = public_send(key)
      public_send("#{key}=", value)
    end
    yield self
  ensure
    old_values.each do |key, old_value|
      public_send("#{key}=", old_value)
    end
  end
end
```

###  **with_options**(options, &block) [Link](https://api.rubyonrails.org/classes/Object.html#method-i-with_options)
An elegant way to factor duplication out of options passed to a series of method calls. Each method called in the block, with the block variable as the receiver, will have its options merged with the default `options` [`Hash`](https://api.rubyonrails.org/classes/Hash.html) or [`Hash`](https://api.rubyonrails.org/classes/Hash.html)-like object provided. Each method called on the block variable must take an options hash as its final argument.
Without [`with_options`](https://api.rubyonrails.org/classes/Object.html#method-i-with_options), this code contains duplication:

```
class Account  ActiveRecord::Base
  has_many :customers, dependent: :destroy
  has_many :products,  dependent: :destroy
  has_many :invoices,  dependent: :destroy
  has_many :expenses,  dependent: :destroy

Using [`with_options`](https://api.rubyonrails.org/classes/Object.html#method-i-with_options), we can remove the duplication:

```
class Account  ActiveRecord::Base
  with_options dependent: :destroy  |assoc|
    assoc.has_many :customers
    assoc.has_many :products
    assoc.has_many :invoices
    assoc.has_many :expenses

It can also be used with an explicit receiver:

```
I18n.with_options locale: user.locale, scope: 'newsletter'  |i18n|
  subject i18n. :subject
  body    i18n. :body, user_name: user.

When you don’t pass an explicit receiver, it executes the whole block in merging options context:

```
class Account  ActiveRecord::Base
  with_options dependent: :destroy
    has_many :customers
    has_many :products
    has_many :invoices
    has_many :expenses

[`with_options`](https://api.rubyonrails.org/classes/Object.html#method-i-with_options) can also be nested since the call is forwarded to its receiver.
NOTE: Each nesting level will merge inherited defaults in addition to their own.

```
class Post  ActiveRecord::Base
  with_options  :persisted?, length: { minimum:  }
    validates :content,  -> { content.present? }

The code is equivalent to:

```
validates :content, length: { minimum:  },  -> { content.present? }

Hence the inherited default for `if` key is ignored.
NOTE: You cannot call class methods implicitly inside of [`with_options`](https://api.rubyonrails.org/classes/Object.html#method-i-with_options). You can access these methods using the class name instead:

```
class Phone  ActiveRecord::Base
  enum :phone_number_type, { home: , office: , mobile:  }

with_options presence:
    validates :phone_number_type, inclusion: {  Phone.phone_number_types. }

When the block argument is omitted, the decorated [`Object`](https://api.rubyonrails.org/classes/Object.html) instance is returned:

```
module MyStyledHelpers
   styled
    with_options style: "color: red;"

styled.link_to "I'm red",

# => <a href="/" style="color: red;">I'm red</a>

styled.button_tag "I'm red too!"

# => <button style="color: red;">I'm red too!</button>

Source: [show](javascript:toggleSource\('method-i-with_options_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activesupport/lib/active_support/core_ext/object/with_options.rb#L92)

# File activesupport/lib/active_support/core_ext/object/with_options.rb, line 92
def with_options(options, block)
  option_merger = ActiveSupport::OptionMerger.new(self, options)

if block
    block.arity.zero? ? option_merger.instance_eval(block) : block.call(option_merger)
  else
    option_merger
  end
end
```