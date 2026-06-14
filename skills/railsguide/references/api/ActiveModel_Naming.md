# Active Model Naming
Creates a [`model_name`](https://api.rubyonrails.org/classes/ActiveModel/Naming.html#method-i-model_name) method on your object.
To implement, just extend [`ActiveModel::Naming`](https://api.rubyonrails.org/classes/ActiveModel/Naming.html) in your object:

```
class BookCover
  extend ActiveModel::Naming

BookCover.model_name.   # => "BookCover"
BookCover.model_name.human  # => "Book cover"

BookCover.model_name.i18n_key              # => :book_cover
BookModule::BookCover.model_name.i18n_key  # => :"book_module/book_cover"

```

Providing the functionality that [`ActiveModel::Naming`](https://api.rubyonrails.org/classes/ActiveModel/Naming.html) provides in your object is required to pass the Active Model [`Lint`](https://api.rubyonrails.org/classes/ActiveModel/Lint.html) test. So either extending the provided method below, or rolling your own is required.
Methods

M

P

R

S

U

## Class Public methods

###  **param_key**(record_or_class) [Link](https://api.rubyonrails.org/classes/ActiveModel/Naming.html#method-c-param_key)
Returns string to use for params names. It differs for namespaced models regarding whether it’s inside isolated engine.

# For isolated engine:
ActiveModel::Naming.param_key(Blog::Post) # => "post"

# For shared engine:
ActiveModel::Naming.param_key(Blog::Post) # => "blog_post"

Source: [show](javascript:toggleSource\('method-c-param_key_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/naming.rb#L337)

# File activemodel/lib/active_model/naming.rb, line 337
def self.param_key(record_or_class)
  model_name_from_record_or_class(record_or_class).param_key
end
```

###  **plural**(record_or_class) [Link](https://api.rubyonrails.org/classes/ActiveModel/Naming.html#method-c-plural)
Returns the plural class name of a record or class.

```
ActiveModel::Naming.plural(post)             # => "posts"
ActiveModel::Naming.plural(Highrise::Person) # => "highrise_people"

Source: [show](javascript:toggleSource\('method-c-plural_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/naming.rb#L282)

# File activemodel/lib/active_model/naming.rb, line 282
def self.plural(record_or_class)
  model_name_from_record_or_class(record_or_class).plural
end
```

###  **route_key**(record_or_class) [Link](https://api.rubyonrails.org/classes/ActiveModel/Naming.html#method-c-route_key)
Returns string to use while generating route names. It differs for namespaced models regarding whether it’s inside isolated engine.

# For isolated engine:
ActiveModel::Naming.route_key(Blog::Post) # => "posts"

# For shared engine:
ActiveModel::Naming.route_key(Blog::Post) # => "blog_posts"

The route key also considers if the noun is uncountable and, in such cases, automatically appends _index.
Source: [show](javascript:toggleSource\('method-c-route_key_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/naming.rb#L325)

# File activemodel/lib/active_model/naming.rb, line 325
def self.route_key(record_or_class)
  model_name_from_record_or_class(record_or_class).route_key
end
```

###  **singular**(record_or_class) [Link](https://api.rubyonrails.org/classes/ActiveModel/Naming.html#method-c-singular)
Returns the singular class name of a record or class.

```
ActiveModel::Naming.singular(post)             # => "post"
ActiveModel::Naming.singular(Highrise::Person) # => "highrise_person"

Source: [show](javascript:toggleSource\('method-c-singular_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/naming.rb#L290)

# File activemodel/lib/active_model/naming.rb, line 290
def self.singular(record_or_class)
  model_name_from_record_or_class(record_or_class).singular
end
```

###  **singular_route_key**(record_or_class) [Link](https://api.rubyonrails.org/classes/ActiveModel/Naming.html#method-c-singular_route_key)
Returns string to use while generating route names. It differs for namespaced models regarding whether it’s inside isolated engine.

# For isolated engine:
ActiveModel::Naming.singular_route_key(Blog::Post) # => "post"

# For shared engine:
ActiveModel::Naming.singular_route_key(Blog::Post) # => "blog_post"

Source: [show](javascript:toggleSource\('method-c-singular_route_key_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/naming.rb#L310)

# File activemodel/lib/active_model/naming.rb, line 310
def self.singular_route_key(record_or_class)
  model_name_from_record_or_class(record_or_class).singular_route_key
end
```

###  **uncountable?**(record_or_class) [Link](https://api.rubyonrails.org/classes/ActiveModel/Naming.html#method-c-uncountable-3F)
Identifies whether the class name of a record or class is uncountable.

```
ActiveModel::Naming.uncountable?(Sheep) # => true
ActiveModel::Naming.uncountable?(Post)  # => false

Source: [show](javascript:toggleSource\('method-c-uncountable-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/naming.rb#L298)

# File activemodel/lib/active_model/naming.rb, line 298
def self.uncountable?(record_or_class)
  model_name_from_record_or_class(record_or_class).uncountable?
end
```

## Instance Public methods

###  **model_name**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Naming.html#method-i-model_name)
Returns an [`ActiveModel::Name`](https://api.rubyonrails.org/classes/ActiveModel/Name.html) object for module. It can be used to retrieve all kinds of naming-related information (See [`ActiveModel::Name`](https://api.rubyonrails.org/classes/ActiveModel/Name.html) for more information).

```
class Person
  extend ActiveModel::Naming

Person.model_name.     # => "Person"
Person.model_name.class    # => ActiveModel::Name
Person.model_name.singular # => "person"
Person.model_name.plural   # => "people"

Source: [show](javascript:toggleSource\('method-i-model_name_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/naming.rb#L269)

# File activemodel/lib/active_model/naming.rb, line 269
def model_name
  @_model_name ||= begin
    namespace = module_parents.detect do |n|
      n.respond_to?(:use_relative_model_naming?)  n.use_relative_model_naming?
    end
    ActiveModel::Name.new(self, namespace)
  end
end
```