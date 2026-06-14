# Active Model Serialization
Provides a basic serialization to a [`serializable_hash`](https://api.rubyonrails.org/classes/ActiveModel/Serialization.html#method-i-serializable_hash) for your objects.
A minimal implementation could be:

```
class Person
  include ActiveModel::Serialization

attr_accessor :name

attributes
    {'name' => }

```

Which would provide you with:

```
person = Person.
person.serializable_hash   # => {"name"=>nil}
person. = "Bob"
person.serializable_hash   # => {"name"=>"Bob"}

An `attributes` hash must be defined and should contain any attributes you need to be serialized. [`Attributes`](https://api.rubyonrails.org/classes/ActiveModel/Attributes.html) must be strings, not symbols. When called, serializable hash will use instance methods that match the name of the attributes hash’s keys. In order to override this behavior, override the `read_attribute_for_serialization` method.
[`ActiveModel::Serializers::JSON`](https://api.rubyonrails.org/classes/ActiveModel/Serializers/JSON.html) module automatically includes the [`ActiveModel::Serialization`](https://api.rubyonrails.org/classes/ActiveModel/Serialization.html) module, so there is no need to explicitly include [`ActiveModel::Serialization`](https://api.rubyonrails.org/classes/ActiveModel/Serialization.html).
A minimal implementation including JSON would be:

```
class Person
  include ActiveModel::Serializers::JSON

```
person = Person.
person.serializable_hash   # => {"name"=>nil}
person.as_json             # => {"name"=>nil}
person.to_json             # => "{\"name\":null}"

person. = "Bob"
person.serializable_hash   # => {"name"=>"Bob"}
person.as_json             # => {"name"=>"Bob"}
person.to_json             # => "{\"name\":\"Bob\"}"

Valid options are `:only`, `:except`, `:methods` and `:include`. The following are all valid examples:

```
person.serializable_hash(only: 'name')
person.serializable_hash(include: :address)
person.serializable_hash(include: { address: { only: 'city' }})

Methods

S

## Instance Public methods

###  **serializable_hash**(options = nil) [Link](https://api.rubyonrails.org/classes/ActiveModel/Serialization.html#method-i-serializable_hash)
Returns a serialized hash of your object.

attr_accessor :name,

attributes
    {'name' => , 'age' => }

capitalized_name
    .capitalize

person = Person.
person. = 'bob'
person.  =
person.serializable_hash                # => {"name"=>"bob", "age"=>22}
person.serializable_hash(only: :name)   # => {"name"=>"bob"}
person.serializable_hash(except: :name) # => {"age"=>22}
person.serializable_hash(methods: :capitalized_name)

# => {"name"=>"bob", "age"=>22, "capitalized_name"=>"Bob"}

Example with `:include` option

```
class
  include ActiveModel::Serializers::JSON
  attr_accessor :name, :notes # Emulate has_many :notes
   attributes
    {'name' => }

class
  include ActiveModel::Serializers::JSON
  attr_accessor :title, :text
   attributes
    {'title' => , 'text' => }

note = Note.
note.title = 'Battle of Austerlitz'
note.text = 'Some text here'

user = User.
user. = 'Napoleon'
user.notes = [note]

user.serializable_hash

# => {"name" => "Napoleon"}
user.serializable_hash(include: { notes: { only: 'title' }})

# => {"name" => "Napoleon", "notes" => [{"title"=>"Battle of Austerlitz"}]}

Source: [show](javascript:toggleSource\('method-i-serializable_hash_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/serialization.rb#L125)

# File activemodel/lib/active_model/serialization.rb, line 125
def serializable_hash(options = nil)
  attribute_names = attribute_names_for_serialization

return serializable_attributes(attribute_names) if options.blank?

if only = options[:only]
    attribute_names = Array(only).map(:to_s)  attribute_names
  elsif except = options[:except]
    attribute_names -= Array(except).map(:to_s)
  end

hash = serializable_attributes(attribute_names)

Array(options[:methods]).each { |m| hash[m.to_s] = send(m) }

serializable_add_includes(options) do |association, records, opts|
    hash[association.to_s] = if records.respond_to?(:to_ary)
      records.to_ary.map { |a| a.serializable_hash(opts) }
    else
      records.serializable_hash(opts)
    end
  end

hash
end
```