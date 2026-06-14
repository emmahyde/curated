# Action Controller [`Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html)
Allows you to choose which attributes should be permitted for mass updating and thus prevent accidentally exposing that which shouldn’t be exposed.
Provides methods for filtering and requiring params:
  * `expect` to safely permit and require parameters in one step.
  * `permit` to filter params for mass assignment.
  * `require` to require a parameter or raise an error.

Examples:

```
params = ActionController::Parameters.({
  person: {
    name: "Francesco",
      ,
    role: "admin"
  }
})

permitted = params.expect(person: [:name, ])
permitted # => #<ActionController::Parameters {"name"=>"Francesco", "age"=>22} permitted: true>

Person.first.update!(permitted)

# => #<Person id: 1, name: "Francesco", age: 22, role: "user">

```

[`Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) provides two options that control the top-level behavior of new instances:
  * `permit_all_parameters` - If it’s `true`, all the parameters will be permitted by default. The default is `false`.
  * `action_on_unpermitted_parameters` - Controls behavior when parameters that are not explicitly permitted are found. The default value is `:log` in test and development environments, `false` otherwise. The values can be:
    * `false` to take no action.
    * `:log` to emit an [`ActiveSupport::Notifications.instrument`](https://api.rubyonrails.org/classes/ActiveSupport/Notifications.html#method-c-instrument) event on the `unpermitted_parameters.action_controller` topic and log at the DEBUG level.
    * `:raise` to raise an [`ActionController::UnpermittedParameters`](https://api.rubyonrails.org/classes/ActionController/UnpermittedParameters.html) exception.

```
params = ActionController::Parameters.
params.permitted? # => false

ActionController::Parameters.permit_all_parameters =

params = ActionController::Parameters.
params.permitted? # => true

params = ActionController::Parameters.( "123",  "456")
params.permit()

# => #<ActionController::Parameters {} permitted: true>

ActionController::Parameters.action_on_unpermitted_parameters = :raise

# => ActionController::UnpermittedParameters: found unpermitted keys: a, b

Please note that these options _are not thread-safe_. In a multi-threaded environment they should only be set once at boot-time and never mutated at runtime.
You can fetch values of [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) using either `:key` or `"key"`.

```
params = ActionController::Parameters.( "value")
params[]  # => "value"
params["key"] # => "value"

Methods

#

A

C

D

E

F

H

I

K

M

N

P

R

S

T

V

W

## Constants
| PERMITTED_SCALAR_TYPES  | =  | [ String, Symbol, NilClass, Numeric, TrueClass, FalseClass, Date, Time, # DateTimes are Dates, we document the type but avoid the redundant check. StringIO, IO, ActionDispatch::Http::UploadedFile, Rack::Test::UploadedFile, ]  |
| --- | --- | --- |
|  This is a list of permitted scalar types that includes the ones supported in XML and JSON requests. This list is in particular used to filter ordinary requests, [`String`](https://api.rubyonrails.org/classes/String.html) goes as first element to quickly short-circuit the common case. If you modify this collection please update the one in the [`permit`](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-permit) doc as well.  |

## Attributes
|  [R]   | parameters  |
| --- | --- |
|  [W]   | permitted  |

## Class Public methods

###  **new**(parameters = {}, logging_context = {}) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-c-new)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance. Also, sets the `permitted` attribute to the default value of `ActionController::Parameters.permit_all_parameters`.

```
class Person  ActiveRecord::Base

params = ActionController::Parameters.(name: "Francesco")
params.permitted?  # => false
Person.(params) # => ActiveModel::ForbiddenAttributesError

params = ActionController::Parameters.(name: "Francesco")
params.permitted?  # => true
Person.(params) # => #<Person id: nil, name: "Francesco">

Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L287)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 287
def initialize(parameters = {}, logging_context = {})
  parameters.each_key do |key|
    unless key.is_a?(String) || key.is_a?(Symbol)
      raise InvalidParameterKey, "all keys must be Strings or Symbols, got: #{key.class}"
    end
  end

@parameters = parameters.with_indifferent_access
  @logging_context = logging_context
  @permitted = self.class.permit_all_parameters
end
```

## Instance Public methods

###  **==**(other) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-3D-3D)
Returns true if another [`Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) object contains the same content and permitted flag.
Source: [show](javascript:toggleSource\('method-i-3D-3D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L301)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 301
def ==(other)
  if other.respond_to?(:permitted?)
    permitted? == other.permitted?  parameters == other.parameters
  else
    super
  end
end
```

###  **[]**(key) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-5B-5D)
Returns a parameter for the given `key`. If not found, returns `nil`.

```
params = ActionController::Parameters.(person: { name: "Francesco" })
params[:person] # => #<ActionController::Parameters {"name"=>"Francesco"} permitted: false>
params[:none]   # => nil

Source: [show](javascript:toggleSource\('method-i-5B-5D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L797)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 797
def [](key)
  convert_hashes_to_parameters(key, @parameters[key])
end
```

###  **[]=**(key, value) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-5B-5D-3D)
Assigns a value to a given `key`. The given key may still get filtered out when [`permit`](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-permit) is called.
Source: [show](javascript:toggleSource\('method-i-5B-5D-3D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L803)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 803
def []=(key, value)
  @parameters[key] = value
end
```

###  **as_json(options=nil)** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-as_json)
Returns a hash that can be used as the JSON representation for the parameters.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L194)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 194

###  **compact**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-compact)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with `nil` values removed.
Source: [show](javascript:toggleSource\('method-i-compact_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L974)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 974
def compact
  new_instance_with_inherited_permitted_status(@parameters.compact)
end
```

###  **compact!**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-compact-21)
Removes all `nil` values in place and returns `self`, or `nil` if no changes were made.
Source: [show](javascript:toggleSource\('method-i-compact-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L980)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 980
def compact!
  self if @parameters.compact!
end
```

###  **compact_blank**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-compact_blank)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance without the blank values. Uses [`Object#blank?`](https://api.rubyonrails.org/classes/Object.html#method-i-blank-3F) for determining if a value is blank.
Source: [show](javascript:toggleSource\('method-i-compact_blank_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L986)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 986
def compact_blank
  reject { |_k, v| v.blank? }
end
```

###  **compact_blank!**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-compact_blank-21)
Removes all blank values in place and returns self. Uses [`Object#blank?`](https://api.rubyonrails.org/classes/Object.html#method-i-blank-3F) for determining if a value is blank.
Source: [show](javascript:toggleSource\('method-i-compact_blank-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L992)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 992
def compact_blank!
  reject! { |_k, v| v.blank? }
end
```

###  **converted_arrays**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-converted_arrays)
Attribute that keeps track of converted arrays, if any, to avoid double looping in the common use case permit + mass-assignment. Defined in a method to instantiate it only if needed.
[`Testing`](https://api.rubyonrails.org/classes/ActionController/Testing.html) membership still loops, but it’s going to be faster than our own loop that converts values. Also, we are not going to build a new array object per fetch.
Source: [show](javascript:toggleSource\('method-i-converted_arrays_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L435)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 435
def converted_arrays
  @converted_arrays ||= Set.new
end
```

###  **deep_dup**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-deep_dup)
Returns a duplicate [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with the same permitted parameters.
Source: [show](javascript:toggleSource\('method-i-deep_dup_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L1092)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 1092
def deep_dup
  self.class.new(@parameters.deep_dup, @logging_context).tap do |duplicate|
    duplicate.permitted = @permitted
  end
end
```

###  **deep_merge(other_hash, &block) ** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-deep_merge)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with `self` and `other_hash` merged recursively.
Like with `Hash#merge` in the standard library, a block can be provided to merge values.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L168)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 168

###  **deep_merge!(other_hash, &block) ** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-deep_merge-21)
Same as [`deep_merge`](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-deep_merge), but modifies `self`.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L183)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 183

###  **deep_transform_keys**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-deep_transform_keys)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with the results of running `block` once for every key. This includes the keys from the root hash and from all nested hashes and arrays. The values are unchanged.
Source: [show](javascript:toggleSource\('method-i-deep_transform_keys_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L924)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 924
def deep_transform_keys(block)
  new_instance_with_inherited_permitted_status(
    _deep_transform_keys_in_object(@parameters, block).to_unsafe_h
  )
end
```

###  **deep_transform_keys!**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-deep_transform_keys-21)
Returns the same [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with changed keys. This includes the keys from the root hash and from all nested hashes and arrays. The values are unchanged.
Source: [show](javascript:toggleSource\('method-i-deep_transform_keys-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L933)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 933
def deep_transform_keys!(block)
  @parameters = _deep_transform_keys_in_object(@parameters, block).to_unsafe_h
  self
end
```

###  **delete**(key, &block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-delete)
Deletes a key-value pair from [`Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) and returns the value. If `key` is not found, returns `nil` (or, with optional code block, yields `key` and returns the result). This method is similar to [`extract!`](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-extract-21), which returns the corresponding [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) object.
Source: [show](javascript:toggleSource\('method-i-delete_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L942)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 942
def delete(key, block)
  convert_value_to_parameters(@parameters.delete(key, block))
end
```

###  **delete_if**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-delete_if)
Alias for: [reject!](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-reject-21)

###  **dig**(*keys) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-dig)
Extracts the nested parameter from the given `keys` by calling `dig` at each step. Returns `nil` if any intermediate step is `nil`.

```
params = ActionController::Parameters.( {  {   } })
params.(, , ) # => 1
params.(, , ) # => nil

params2 = ActionController::Parameters.( [, , ])
params2.(, ) # => 11

Source: [show](javascript:toggleSource\('method-i-dig_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L841)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 841
def dig(*keys)
  convert_hashes_to_parameters(keys.first, @parameters[keys.first])
  @parameters.dig(*keys)
end
```

###  **each**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-each)
Alias for: [each_pair](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-each_pair)

###  **each_key( &block) ** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-each_key)
Calls block once for each key in the parameters, passing the key. If no block is given, an enumerator is returned instead.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L202)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 202

###  **each_pair**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-each_pair)
Convert all hashes in values into parameters, then yield each pair in the same way as `Hash#each_pair`.
Also aliased as: [each](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-each)
Source: [show](javascript:toggleSource\('method-i-each_pair_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L402)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 402
def each_pair(block)
  return to_enum(__callee__) unless block_given?
  @parameters.each_pair do |key, value|
    yield [key, convert_hashes_to_parameters(key, value)]
  end

self
end
```

###  **each_value**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-each_value)
Convert all hashes in values into parameters, then yield each value in the same way as `Hash#each_value`.
Source: [show](javascript:toggleSource\('method-i-each_value_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L414)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 414
def each_value(block)
  return to_enum(:each_value) unless block_given?
  @parameters.each_pair do |key, value|
    yield convert_hashes_to_parameters(key, value)
  end

###  **empty?()** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-empty-3F)
Returns true if the parameters have no key/value pairs.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L211)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 211

###  **eql?**(other) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-eql-3F)
Source: [show](javascript:toggleSource\('method-i-eql-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L309)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 309
def eql?(other)
  self.class == other.class
    permitted? == other.permitted?
    parameters.eql?(other.parameters)
end
```

###  **except**(*keys) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-except)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance that filters out the given `keys`.

```
params = ActionController::Parameters.( ,  ,  )
params.except(, ) # => #<ActionController::Parameters {"c"=>3} permitted: false>
params.except()     # => #<ActionController::Parameters {"a"=>1, "b"=>2, "c"=>3} permitted: false>

Also aliased as: [without](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-without)
Source: [show](javascript:toggleSource\('method-i-except_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L869)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 869
def except(*keys)
  new_instance_with_inherited_permitted_status(@parameters.except(*keys))
end
```

###  **exclude?(key)** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-exclude-3F)
Returns true if the given key is not present in the parameters.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L219)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 219

###  **expect**(*filters) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-expect)
`expect` is the preferred way to require and permit parameters. It is safer than the previous recommendation to call `permit` and `require` in sequence, which could allow user triggered 500 errors.
`expect` is more strict with types to avoid a number of potential pitfalls that may be encountered with the `.require.permit` pattern.
For example:

```
params = ActionController::Parameters.(comment: { text: "hello" })
params.expect(comment: [:text])

# => #<ActionController::Parameters { text: "hello" } permitted: true>

params = ActionController::Parameters.(comment: [{ text: "hello" }, { text: "world" }])
params.expect(comment: [:text])

# => ActionController::ParameterMissing: param is missing or the value is empty or invalid: comment

In order to permit an array of parameters, the array must be defined explicitly. Use double array brackets, an array inside an array, to declare that an array of parameters is expected.

```
params = ActionController::Parameters.(comments: [{ text: "hello" }, { text: "world" }])
params.expect(comments: [[:text]])

# => [#<ActionController::Parameters { "text" => "hello" } permitted: true>,

#     #<ActionController::Parameters { "text" => "world" } permitted: true>]

params = ActionController::Parameters.(comments: { text: "hello" })
params.expect(comments: [[:text]])

# => ActionController::ParameterMissing: param is missing or the value is empty or invalid: comments

`expect` is intended to protect against array tampering.

```
params = ActionController::Parameters.(user: "hack")

# The previous way of requiring and permitting parameters will error
params.require(:user).permit(:name, pets: [:name]) # wrong

# => NoMethodError: undefined method `permit' for an instance of String

# similarly with nested parameters
params = ActionController::Parameters.(user: { name: "Martin", pets: { name: "hack" } })
user_params = params.require(:user).permit(:name, pets: [:name]) # wrong

# user_params[:pets] is expected to be an array but is a hash

`expect` solves this by being more strict with types.

```
params = ActionController::Parameters.(user: "hack")
params.expect(user: [ :name, pets: [[:name]] ])

# => ActionController::ParameterMissing: param is missing or the value is empty or invalid: user

# with nested parameters
params = ActionController::Parameters.(user: { name: "Martin", pets: { name: "hack" } })
user_params = params.expect(user: [:name, pets: [[:name]] ])
user_params[:pets] # => nil

As the examples show, `expect` requires the `:user` key, and any root keys similar to the `.require.permit` pattern. If multiple root keys are expected, they will all be required.

```
params = ActionController::Parameters.(name: "Martin", pies: [{ type: "dessert", flavor: "pumpkin"}])
, pies = params.expect(:name, pies: [[:type, :flavor]])

# => "Martin"
pies # => [#<ActionController::Parameters {"type"=>"dessert", "flavor"=>"pumpkin"} permitted: true>]

When called with a hash with multiple keys, `expect` will permit the parameters and require the keys in the order they are given in the hash, returning an array of the permitted parameters.

```
params = ActionController::Parameters.(subject: { name: "Martin" }, object: {  "pumpkin" })
subject, object = params.expect(subject: [:name], object: [])
subject # => #<ActionController::Parameters {"name"=>"Martin"} permitted: true>
object  # => #<ActionController::Parameters {"pie"=>"pumpkin"} permitted: true>

Besides being more strict about array vs hash params, `expect` uses permit internally, so it will behave similarly.

```
params = ActionController::Parameters.({
  person: {
    name: "Francesco",
      ,
    pets: [{
      name: "Purplish",
      category: "dogs"
    }]
  }
})

permitted = params.expect(person: [ :name, { pets: [[:name]] } ])
permitted.permitted?           # => true
permitted[:name]               # => "Francesco"
permitted[]                # => nil
permitted[:pets][][:name]     # => "Purplish"
permitted[:pets][][:category] # => nil

An array of permitted scalars may be expected with the following:

```
params = ActionController::Parameters.(tags: ["rails", "parameters"])
permitted = params.expect(tags: [])
permitted                 # => ["rails", "parameters"]
permitted.is_a?(Array)    # => true
permitted.            # => 2

Source: [show](javascript:toggleSource\('method-i-expect_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L772)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 772
def expect(*filters)
  params = permit_filters(filters)
  keys = filters.flatten.flat_map { |f| f.is_a?(Hash) ? f.keys : f }
  values = params.require(keys)
  values.size == 1 ? values.first : values
end
```

###  **expect!**(*filters) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-expect-21)
Same as `expect`, but raises an [`ActionController::ExpectedParameterMissing`](https://api.rubyonrails.org/classes/ActionController/ExpectedParameterMissing.html) instead of [`ActionController::ParameterMissing`](https://api.rubyonrails.org/classes/ActionController/ParameterMissing.html). Unlike `expect` which will render a 400 response, `expect!` will raise an exception that is not handled. This is intended for debugging invalid params for an internal [`API`](https://api.rubyonrails.org/classes/ActionController/API.html) where incorrectly formatted params would indicate a bug in a client library that should be fixed.
Source: [show](javascript:toggleSource\('method-i-expect-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L786)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 786
def expect!(*filters)
  expect(*filters)
rescue ParameterMissing => e
  raise ExpectedParameterMissing.new(e.param, e.keys)
end
```

###  **extract!**(*keys) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-extract-21)
Removes and returns the key/value pairs matching the given keys.

```
params = ActionController::Parameters.( ,  ,  )
params.extract!(, ) # => #<ActionController::Parameters {"a"=>1, "b"=>2} permitted: false>
params                  # => #<ActionController::Parameters {"c"=>3} permitted: false>

Source: [show](javascript:toggleSource\('method-i-extract-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L879)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 879
def extract!(*keys)
  new_instance_with_inherited_permitted_status(@parameters.extract!(*keys))
end
```

###  **extract_value**(key, delimiter: "_") [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-extract_value)
Returns parameter value for the given `key` separated by `delimiter`.

```
params = ActionController::Parameters.( "1_123", tags: "ruby,rails")
params.extract_value() # => ["1", "123"]
params.extract_value(:tags, delimiter: ) # => ["ruby", "rails"]
params.extract_value(:non_existent_key) # => nil

Note that if the given `key`‘s value contains blank elements, then the returned array will include empty strings.

```
params = ActionController::Parameters.(tags: "ruby,rails,,web")
params.extract_value(:tags, delimiter: ) # => ["ruby", "rails", "", "web"]

Source: [show](javascript:toggleSource\('method-i-extract_value_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L1110)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 1110
def extract_value(key, delimiter: "_")
  @parameters[key]&.split(delimiter, -1)
end
```

###  **fetch**(key, *args) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-fetch)
Returns a parameter for the given `key`. If the `key` can’t be found, there are several options: With no other arguments, it will raise an [`ActionController::ParameterMissing`](https://api.rubyonrails.org/classes/ActionController/ParameterMissing.html) error; if a second argument is given, then that is returned (converted to an instance of [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) if possible); if a block is given, then that will be run and its result returned.

```
params = ActionController::Parameters.(person: { name: "Francesco" })
params.fetch(:person)               # => #<ActionController::Parameters {"name"=>"Francesco"} permitted: false>
params.fetch(:none)                 # => ActionController::ParameterMissing: param is missing or the value is empty or invalid: none
params.fetch(:none, {})             # => #<ActionController::Parameters {} permitted: false>
params.fetch(:none, "Francesco")    # => "Francesco"
params.fetch(:none) { "Francesco" } # => "Francesco"

Source: [show](javascript:toggleSource\('method-i-fetch_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L820)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 820
def fetch(key, *args)
  convert_value_to_parameters(
    @parameters.fetch(key) {
      if block_given?
        yield
      else
        args.fetch(0) { raise ActionController::ParameterMissing.new(key, @parameters.keys) }
      end
    }
  )
end
```

###  **has_key?** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-has_key-3F)
Alias for: [include?](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-include-3F)

###  **has_value?**(value) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-has_value-3F)
Returns true if the given value is present for some key in the parameters.
Also aliased as: [value?](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-value-3F)
Source: [show](javascript:toggleSource\('method-i-has_value-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L997)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 997
def has_value?(value)
  each_value.include?(convert_value_to_parameters(value))
end
```

###  **hash**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-hash)
Source: [show](javascript:toggleSource\('method-i-hash_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L315)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 315
def hash
  [self.class, @parameters, @permitted].hash
end
```

###  **include?(key)** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-include-3F)
Returns true if the given key is present in the parameters.
Also aliased as: [has_key?](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-has_key-3F), [key?](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-key-3F), [member?](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-member-3F)
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L227)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 227

###  **inspect**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-inspect)
Source: [show](javascript:toggleSource\('method-i-inspect_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L1055)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 1055
def inspect
  "#<#{self.class} #{@parameters} permitted: #{@permitted}>"
end
```

###  **keep_if**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-keep_if)
Alias for: [select!](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-select-21)

###  **key?** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-key-3F)
Alias for: [include?](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-include-3F)

###  **keys()** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-keys)
Returns a new array of the keys of the parameters.
Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L235)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 235

###  **member?** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-member-3F)
Alias for: [include?](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-include-3F)

###  **merge**(other_hash) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-merge)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with all keys from `other_hash` merged into current hash.
Source: [show](javascript:toggleSource\('method-i-merge_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L1011)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 1011
def merge(other_hash)
  new_instance_with_inherited_permitted_status(
    @parameters.merge(other_hash.to_h)
  )
end
```

###  **merge!(other_hash)** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-merge-21)
Returns the current [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with `other_hash` merged into current hash.
Source: [show](javascript:toggleSource\('method-i-merge-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L1022)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 1022
def merge!(other_hash, block)
  @parameters.merge!(other_hash.to_h, block)
  self
end
```

###  **permit**(*filters) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-permit)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance that includes only the given `filters` and sets the `permitted` attribute for the object to `true`. This is useful for limiting which attributes should be allowed for mass updating.

```
params = ActionController::Parameters.(name: "Francesco",  , role: "admin")
permitted = params.permit(:name, )
permitted.permitted?      # => true
permitted.has_key?(:name) # => true
permitted.has_key?()  # => true
permitted.has_key?(:role) # => false

Only permitted scalars pass the filter. For example, given

```
params.permit(:name)

`:name` passes if it is a key of `params` whose associated value is of type [`String`](https://api.rubyonrails.org/classes/String.html), [`Symbol`](https://api.rubyonrails.org/classes/Symbol.html), [`NilClass`](https://api.rubyonrails.org/classes/NilClass.html), [`Numeric`](https://api.rubyonrails.org/classes/Numeric.html), [`TrueClass`](https://api.rubyonrails.org/classes/TrueClass.html), [`FalseClass`](https://api.rubyonrails.org/classes/FalseClass.html), [`Date`](https://api.rubyonrails.org/classes/Date.html), [`Time`](https://api.rubyonrails.org/classes/Time.html), [`DateTime`](https://api.rubyonrails.org/classes/DateTime.html), `StringIO`, [`IO`](https://api.rubyonrails.org/classes/IO.html), [`ActionDispatch::Http::UploadedFile`](https://api.rubyonrails.org/classes/ActionDispatch/Http/UploadedFile.html) or `Rack::Test::UploadedFile`. Otherwise, the key `:name` is filtered out.
You may declare that the parameter should be an array of permitted scalars by mapping it to an empty array:

```
params = ActionController::Parameters.(tags: ["rails", "parameters"])
params.permit(tags: [])

Sometimes it is not possible or convenient to declare the valid keys of a hash parameter or its internal structure. Just map to an empty hash:

```
params.permit(preferences: {})

Be careful because this opens the door to arbitrary input. In this case, `permit` ensures values in the returned structure are permitted scalars and filters out anything else.
You can also use `permit` on nested parameters:

permitted = params.permit(person: [ :name, { pets: :name } ])
permitted.permitted?                    # => true
permitted[:person][:name]               # => "Francesco"
permitted[:person][]                # => nil
permitted[:person][:pets][][:name]     # => "Purplish"
permitted[:person][:pets][][:category] # => nil

This has the added benefit of rejecting user-modified inputs that send a string when a hash is expected.
When followed by `require`, you can both filter and require parameters following the typical pattern of a [`Rails`](https://api.rubyonrails.org/classes/Rails.html) form. The `expect` method was made specifically for this use case and is the recommended way to require and permit parameters.

```
 permitted = params.expect(person: [:name, ])

When using `permit` and `require` separately, pay careful attention to the order of the method calls.

```
 params = ActionController::Parameters.(person: { name: "Martin",  , role: "admin" })
 permitted = params.permit(person: [:name, ]).require(:person) # correct

When require is used first, it is possible for users of your application to trigger a NoMethodError when the user, for example, sends a string for :person.

```
 params = ActionController::Parameters.(person: "tampered")
 permitted = params.require(:person).permit(:name, ) # not recommended

Note that if you use `permit` in a key that points to a hash, it won’t allow all the hash. You also need to specify which attributes inside the hash should be permitted.

```
params = ActionController::Parameters.({
  person: {
    contact: {
      email: "none@test.com",
      phone: "555-1234"
    }
  }
})

params.permit(person: :contact).require(:person)

# => ActionController::ParameterMissing: param is missing or the value is empty or invalid: person

params.permit(person: { contact: :phone }).require(:person)

# => #<ActionController::Parameters {"contact"=>#<ActionController::Parameters {"phone"=>"555-1234"} permitted: true>} permitted: true>

params.permit(person: { contact: [ :email, :phone ] }).require(:person)

# => #<ActionController::Parameters {"contact"=>#<ActionController::Parameters {"email"=>"none@test.com", "phone"=>"555-1234"} permitted: true>} permitted: true>

If your parameters specify multiple parameters indexed by a number, you can permit each set of parameters under the numeric key to be the same using the same syntax as permitting a single item.

```
params = ActionController::Parameters.({
  person: {
     {
      email: "none@test.com",
      phone: "555-1234"
    },
     {
      email: "nothing@test.com",
      phone: "555-6789"
    },
  }
})
params.permit(person: [:email]).to_h

# => {"person"=>{"0"=>{"email"=>"none@test.com"}, "1"=>{"email"=>"nothing@test.com"}}}

If you want to specify what keys you want from each numeric key, you can instead specify each one individually

```
params = ActionController::Parameters.({
  person: {
     {
      email: "none@test.com",
      phone: "555-1234"
    },
     {
      email: "nothing@test.com",
      phone: "555-6789"
    },
  }
})
params.permit(person: {  [:email],  [:phone]}).to_h

# => {"person"=>{"0"=>{"email"=>"none@test.com"}, "1"=>{"phone"=>"555-6789"}}}

Source: [show](javascript:toggleSource\('method-i-permit_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L668)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 668
def permit(*filters)
  permit_filters(filters, on_unpermitted: self.class.action_on_unpermitted_parameters, explicit_arrays: false)
end
```

###  **permit!**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-permit-21)
Sets the `permitted` attribute to `true`. This can be used to pass mass assignment. Returns `self`.

params = ActionController::Parameters.(name: "Francesco")
params.permitted?  # => false
Person.(params) # => ActiveModel::ForbiddenAttributesError
params.permit!
params.permitted?  # => true
Person.(params) # => #<Person id: nil, name: "Francesco">

Source: [show](javascript:toggleSource\('method-i-permit-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L461)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 461
def permit!
  each_pair do |key, value|
    Array.wrap(value).flatten.each do |v|
      v.permit! if v.respond_to? :permit!
    end
  end

@permitted = true
  self
end
```

###  **permitted?**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-permitted-3F)
Returns `true` if the parameter is permitted, `false` otherwise.

```
params = ActionController::Parameters.
params.permitted? # => false
params.permit!
params.permitted? # => true

Source: [show](javascript:toggleSource\('method-i-permitted-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L445)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 445
def permitted?
  @permitted
end
```

###  **reject**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-reject)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with items that the block evaluates to true removed.
Source: [show](javascript:toggleSource\('method-i-reject_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L961)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 961
def reject(block)
  new_instance_with_inherited_permitted_status(@parameters.reject(block))
end
```

###  **reject!**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-reject-21)
Removes items that the block evaluates to true and returns self.
Also aliased as: [delete_if](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-delete_if)
Source: [show](javascript:toggleSource\('method-i-reject-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L966)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 966
def reject!(block)
  @parameters.reject!(block)
  self
end
```

###  **require**(key) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-require)
This method accepts both a single key and an array of keys.
When passed a single key, if it exists and its associated value is either present or the singleton `false`, returns said value:

```
ActionController::Parameters.(person: { name: "Francesco" }).require(:person)

# => #<ActionController::Parameters {"name"=>"Francesco"} permitted: false>

Otherwise raises [`ActionController::ParameterMissing`](https://api.rubyonrails.org/classes/ActionController/ParameterMissing.html):

```
ActionController::Parameters..require(:person)

# ActionController::ParameterMissing: param is missing or the value is empty or invalid: person

ActionController::Parameters.(person: ).require(:person)

ActionController::Parameters.(person: "\t").require(:person)

ActionController::Parameters.(person: {}).require(:person)

When given an array of keys, the method tries to require each one of them in order. If it succeeds, an array with the respective return values is returned:

```
params = ActionController::Parameters.(user: { ... }, profile: { ... })
user_params, profile_params = params.require([:user, :profile])
```

Otherwise, the method re-raises the first exception found:

```
params = ActionController::Parameters.(user: {}, profile: {})
user_params, profile_params = params.require([:user, :profile])

# ActionController::ParameterMissing: param is missing or the value is empty or invalid: user

This method is not recommended for fetching terminal values because it does not permit the values. For example, this can cause problems:

# CAREFUL
params = ActionController::Parameters.(person: { name: "Finn" })
 = params.require(:person).require(:name) # CAREFUL

It is recommended to use `expect` instead:

```
 person_params
  params.expect(person: :name).require(:name)

Also aliased as: [required](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-required)
Source: [show](javascript:toggleSource\('method-i-require_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L519)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 519
def require(key)
  return key.map { |k| require(k) } if key.is_a?(Array)
  value = self[key]
  if value.present? || value == false
    value
  else
    raise ParameterMissing.new(key, @parameters.keys)
  end
end
```

###  **required**(key) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-required)
Alias for: [require](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-require)

###  **reverse_merge**(other_hash) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-reverse_merge)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with all keys from current hash merged into `other_hash`.
Also aliased as: [with_defaults](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-with_defaults)
Source: [show](javascript:toggleSource\('method-i-reverse_merge_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L1033)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 1033
def reverse_merge(other_hash)
  new_instance_with_inherited_permitted_status(
    other_hash.to_h.merge(@parameters)
  )
end
```

###  **reverse_merge!**(other_hash) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-reverse_merge-21)
Returns the current [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with current hash merged into `other_hash`.
Also aliased as: [with_defaults!](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-with_defaults-21)
Source: [show](javascript:toggleSource\('method-i-reverse_merge-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L1042)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 1042
def reverse_merge!(other_hash)
  @parameters.merge!(other_hash.to_h) { |key, left, right| left }
  self
end
```

###  **select**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-select)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with only items that the block evaluates to true.
Source: [show](javascript:toggleSource\('method-i-select_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L948)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 948
def select(block)
  new_instance_with_inherited_permitted_status(@parameters.select(block))
end
```

###  **select!**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-select-21)
Equivalent to Hash#keep_if, but returns `nil` if no changes were made.
Also aliased as: [keep_if](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-keep_if)
Source: [show](javascript:toggleSource\('method-i-select-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L953)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 953
def select!(block)
  @parameters.select!(block)
  self
end
```

###  **slice**(*keys) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-slice)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance that includes only the given `keys`. If the given `keys` don’t exist, returns an empty hash.

```
params = ActionController::Parameters.( ,  ,  )
params.slice(, ) # => #<ActionController::Parameters {"a"=>1, "b"=>2} permitted: false>
params.slice()     # => #<ActionController::Parameters {} permitted: false>

Source: [show](javascript:toggleSource\('method-i-slice_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L852)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 852
def slice(*keys)
  new_instance_with_inherited_permitted_status(@parameters.slice(*keys))
end
```

###  **slice!**(*keys) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-slice-21)
Returns the current [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance which contains only the given `keys`.
Source: [show](javascript:toggleSource\('method-i-slice-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L858)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 858
def slice!(*keys)
  @parameters.slice!(*keys)
  self
end
```

###  **to_h**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-to_h)
Returns a safe [`ActiveSupport::HashWithIndifferentAccess`](https://api.rubyonrails.org/classes/ActiveSupport/HashWithIndifferentAccess.html) representation of the parameters with all unpermitted keys removed.

```
params = ActionController::Parameters.({
  name: "Senjougahara Hitagi",
  oddity: "Heavy stone crab"
})
params.to_h

# => ActionController::UnfilteredParameters: unable to convert unpermitted parameters to hash

safe_params = params.permit(:name)
safe_params.to_h # => {"name"=>"Senjougahara Hitagi"}

Source: [show](javascript:toggleSource\('method-i-to_h_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L331)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 331
def to_h(block)
  if permitted?
    convert_parameters_to_hashes(@parameters, :to_h, block)
  else
    raise UnfilteredParameters
  end
end
```

###  **to_hash**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-to_hash)
Returns a safe [`Hash`](https://api.rubyonrails.org/classes/Hash.html) representation of the parameters with all unpermitted keys removed.

```
params = ActionController::Parameters.({
  name: "Senjougahara Hitagi",
  oddity: "Heavy stone crab"
})
params.to_hash

safe_params = params.permit(:name)
safe_params.to_hash # => {"name"=>"Senjougahara Hitagi"}

Source: [show](javascript:toggleSource\('method-i-to_hash_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L351)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 351
def to_hash
  to_h.to_hash
end
```

###  **to_param**(*args) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-to_param)
Alias for: [to_query](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-to_query)

###  **to_query**(*args) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-to_query)
Returns a string representation of the receiver suitable for use as a URL query string:

```
params = ActionController::Parameters.({
  name: "David",
  nationality: "Danish"
})
params.to_query

safe_params = params.permit(:name, :nationality)
safe_params.to_query

# => "name=David&nationality=Danish"

An optional namespace can be passed to enclose key names:

```
params = ActionController::Parameters.({
  name: "David",
  nationality: "Danish"
})
safe_params = params.permit(:name, :nationality)
safe_params.to_query("user")

# => "user%5Bname%5D=David&user%5Bnationality%5D=Danish"

The string pairs `"key=value"` that conform the query string are sorted lexicographically in ascending order.
Also aliased as: [to_param](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-to_param)
Source: [show](javascript:toggleSource\('method-i-to_query_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L381)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 381
def to_query(*args)
  to_h.to_query(*args)
end
```

###  **to_s()** [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-to_s)
Returns the content of the parameters as a string.
Source: [show](javascript:toggleSource\('method-i-to_s_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L250)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 250
delegate :keys, :empty?, :exclude?, :include?,
  :as_json, :to_s, :each_key, to: :@parameters

###  **to_unsafe_h**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-to_unsafe_h)
Returns an unsafe, unfiltered [`ActiveSupport::HashWithIndifferentAccess`](https://api.rubyonrails.org/classes/ActiveSupport/HashWithIndifferentAccess.html) representation of the parameters.

```
params = ActionController::Parameters.({
  name: "Senjougahara Hitagi",
  oddity: "Heavy stone crab"
})
params.to_unsafe_h

# => {"name"=>"Senjougahara Hitagi", "oddity" => "Heavy stone crab"}

Also aliased as: [to_unsafe_hash](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-to_unsafe_hash)
Source: [show](javascript:toggleSource\('method-i-to_unsafe_h_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L395)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 395
def to_unsafe_h
  convert_parameters_to_hashes(@parameters, :to_unsafe_h)
end
```

###  **to_unsafe_hash**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-to_unsafe_hash)
Alias for: [to_unsafe_h](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-to_unsafe_h)

###  **transform_keys**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-transform_keys)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with the results of running `block` once for every key. The values are unchanged.
Source: [show](javascript:toggleSource\('method-i-transform_keys_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L906)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 906
def transform_keys(block)
  return to_enum(:transform_keys) unless block_given?
  new_instance_with_inherited_permitted_status(
    @parameters.transform_keys(block)
  )
end
```

###  **transform_keys!**(&block) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-transform_keys-21)
Performs keys transformation and returns the altered [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance.
Source: [show](javascript:toggleSource\('method-i-transform_keys-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L915)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 915
def transform_keys!(block)
  return to_enum(:transform_keys!) unless block_given?
  @parameters.transform_keys!(block)
  self
end
```

###  **transform_values**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-transform_values)
Returns a new [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance with the results of running `block` once for every value. The keys are unchanged.

```
params = ActionController::Parameters.( ,  ,  )
params.transform_values { ||  *  }

# => #<ActionController::Parameters {"a"=>2, "b"=>4, "c"=>6} permitted: false>

Source: [show](javascript:toggleSource\('method-i-transform_values_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L889)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 889
def transform_values
  return to_enum(:transform_values) unless block_given?
  new_instance_with_inherited_permitted_status(
    @parameters.transform_values { |v| yield convert_value_to_parameters(v) }
  )
end
```

###  **transform_values!**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-transform_values-21)
Performs values transformation and returns the altered [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html) instance.
Source: [show](javascript:toggleSource\('method-i-transform_values-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L898)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 898
def transform_values!
  return to_enum(:transform_values!) unless block_given?
  @parameters.transform_values! { |v| yield convert_value_to_parameters(v) }
  self
end
```

###  **value?**(value) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-value-3F)
Alias for: [has_value?](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-has_value-3F)

###  **values**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-values)
Returns a new array of the values of the parameters.
Source: [show](javascript:toggleSource\('method-i-values_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L424)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 424
def values
  to_enum(:each_value).to_a
end
```

###  **values_at**(*keys) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-values_at)
Returns values that were assigned to the given `keys`. Note that all the [`Hash`](https://api.rubyonrails.org/classes/Hash.html) objects will be converted to [`ActionController::Parameters`](https://api.rubyonrails.org/classes/ActionController/Parameters.html).
Source: [show](javascript:toggleSource\('method-i-values_at_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L1005)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 1005
def values_at(*keys)
  convert_value_to_parameters(@parameters.values_at(*keys))
end
```

###  **with_defaults**(other_hash) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-with_defaults)
Alias for: [reverse_merge](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-reverse_merge)

###  **with_defaults!**(other_hash) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-with_defaults-21)
Alias for: [reverse_merge!](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-reverse_merge-21)

###  **without**(*keys) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-without)
Alias for: [except](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-except)

## Instance Protected methods

###  **each_nested_attribute**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-each_nested_attribute)
Source: [show](javascript:toggleSource\('method-i-each_nested_attribute_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L1123)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 1123
def each_nested_attribute
  hash = self.class.new
  self.each { |k, v| hash[k] = yield v if Parameters.nested_attribute?(k, v) }
  hash
end
```

###  **nested_attributes?**() [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-nested_attributes-3F)
Source: [show](javascript:toggleSource\('method-i-nested_attributes-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L1119)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 1119
def nested_attributes?
  @parameters.any? { |k, v| Parameters.nested_attribute?(k, v) }
end
```

###  **permit_filters**(filters, on_unpermitted: nil, explicit_arrays: true) [Link](https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-permit_filters)
Filters self and optionally checks for unpermitted keys
Source: [show](javascript:toggleSource\('method-i-permit_filters_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/actionpack/lib/action_controller/metal/strong_parameters.rb#L1130)

# File actionpack/lib/action_controller/metal/strong_parameters.rb, line 1130
def permit_filters(filters, on_unpermitted: nil, explicit_arrays: true)
  params = self.class.new

filters.flatten.each do |filter|
    case filter
    when Symbol, String
      # Declaration [:name, "age"]
      permitted_scalar_filter(params, filter)
    when Hash
      # Declaration [{ person: ... }]
      hash_filter(params, filter, on_unpermitted:, explicit_arrays:)
    end
  end

unpermitted_parameters!(params, on_unpermitted:)

params.permit!
end
```