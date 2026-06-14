# Active Model Dirty
Provides a way to track changes in your object in the same way as Active Record does.
The requirements for implementing [`ActiveModel::Dirty`](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html) are:
  * `include ActiveModel::Dirty` in your object.
  * Call `define_attribute_methods` passing each method you want to track.
  * Call `*_will_change!` before each change to the tracked attribute.
  * Call [`changes_applied`](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-changes_applied) after the changes are persisted.
  * Call [`clear_changes_information`](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-clear_changes_information) when you want to reset the changes information.
  * Call [`restore_attributes`](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-restore_attributes) when you want to restore previous data.

A minimal implementation could be:

```
class Person
  include ActiveModel::Dirty

define_attribute_methods :name

initialize
    @name =

@name

name=()
    name_will_change! unless  == @name
    @name =

# do persistence work

changes_applied

reload!
    # get the values from the persistence layer

clear_changes_information

rollback!
    restore_attributes

```

A newly instantiated `Person` object is unchanged:

```
person = Person.
person.changed? # => false

Change the name:

```
person. = 'Bob'
person.changed?       # => true
person.name_changed?  # => true
person.name_changed?(from: ,  "Bob") # => true
person.name_was       # => nil
person.name_change    # => [nil, "Bob"]
person. = 'Bill'
person.name_change    # => [nil, "Bill"]

Save the changes:

```
person.save
person.changed?      # => false
person.name_changed? # => false

Reset the changes:

```
person.previous_changes         # => {"name" => [nil, "Bill"]}
person.name_previously_changed? # => true
person.name_previously_changed?(from: ,  "Bill") # => true
person.name_previous_change     # => [nil, "Bill"]
person.name_previously_was      # => nil
person.reload!
person.previous_changes         # => {}

Rollback the changes:

```
person. = "Uncle Bob"
person.rollback!
person.          # => "Bill"
person.name_changed? # => false

Assigning the same value leaves the attribute unchanged:

```
person. = 'Bill'
person.name_changed? # => false
person.name_change   # => nil

Which attributes have changed?

```
person. = 'Bob'
person.changed # => ["name"]
person.changes # => {"name" => ["Bill", "Bob"]}

If an attribute is modified in-place then make use of [*_will_change!](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_will_change-21) to mark that the attribute is changing. Otherwise Active Model can’t track changes to in-place attributes. Note that Active Record can detect in-place modifications automatically. You do not need to call `*_will_change!` on Active Record models.

```
person.name_will_change!
person.name_change # => ["Bill", "Bill"]
person. <<
person.name_change # => ["Bill", "Billy"]

Methods can be invoked as `name_changed?` or by passing an argument to the generic method `attribute_changed?("name")`.
Methods

#

A

* attribute_previously_changed?,
  * attribute_previously_was,

C

* clear_changes_information

P

R

Included Modules
  * [ ActiveModel::AttributeMethods ](https://api.rubyonrails.org/classes/ActiveModel/AttributeMethods.html)

## Instance Public methods

###  ***_change** [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_change)
This method is generated for each attribute.
Returns the old and the new value of the attribute.

```
person = Person.
person. = 'Nick'
person.name_change # => [nil, 'Nick']

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L155)

# File activemodel/lib/active_model/dirty.rb, line 155

###  ***_changed?** [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_changed-3F)
This method is generated for each attribute.
Returns true if the attribute has unsaved changes.

```
person = Person.
person. = 'Andrew'
person.name_changed? # => true

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L144)

# File activemodel/lib/active_model/dirty.rb, line 144

###  ***_previous_change** [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_previous_change)
This method is generated for each attribute.
Returns the old and the new value of the attribute before the last save.

```
person = Person.
person. = 'Emmanuel'
person.save
person.name_previous_change # => [nil, 'Emmanuel']

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L193)

# File activemodel/lib/active_model/dirty.rb, line 193

###  ***_previously_changed?(**options)** [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_previously_changed-3F)
This method is generated for each attribute.
Returns true if the attribute previously had unsaved changes.

```
person = Person.
person. = 'Britanny'
person.save
person.name_previously_changed? # => true
person.name_previously_changed?(from: ,  'Britanny') # => true

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L129)

# File activemodel/lib/active_model/dirty.rb, line 129

###  ***_previously_was** [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_previously_was)
This method is generated for each attribute.
Returns the old value of the attribute before the last save.

```
person = Person.
person. = 'Sage'
person.save
person.name_previously_was  # => nil

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L205)

# File activemodel/lib/active_model/dirty.rb, line 205

###  ***_was** [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_was)
This method is generated for each attribute.
Returns the old value of the attribute.

```
person = Person.(name: 'Steph')
person. = 'Stephanie'
person.name_was # => 'Steph'

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L182)

# File activemodel/lib/active_model/dirty.rb, line 182

###  ***_will_change!** [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_will_change-21)
This method is generated for each attribute.
If an attribute is modified in-place then make use of `*_will_change!` to mark that the attribute is changing. Otherwise Active [`Model`](https://api.rubyonrails.org/classes/ActiveModel/Model.html) can’t track changes to in-place attributes. Note that Active Record can detect in-place modifications automatically. You do not need to call `*_will_change!` on Active Record models.

```
person = Person.('Sandy')
person.name_will_change!
person.name_change # => ['Sandy', 'Sandy']

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L166)

# File activemodel/lib/active_model/dirty.rb, line 166

###  **attribute_changed?**(attr_name, **options) [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-attribute_changed-3F)
Dispatch target for [*_changed?](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_changed-3F) attribute methods.
Source: [show](javascript:toggleSource\('method-i-attribute_changed-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L300)

# File activemodel/lib/active_model/dirty.rb, line 300
def attribute_changed?(attr_name, **options)
  mutations_from_database.changed?(attr_name.to_s, **options)
end
```

###  **attribute_previously_changed?**(attr_name, **options) [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-attribute_previously_changed-3F)
Dispatch target for [*_previously_changed?](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_previously_changed-3F) attribute methods.
Source: [show](javascript:toggleSource\('method-i-attribute_previously_changed-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L310)

# File activemodel/lib/active_model/dirty.rb, line 310
def attribute_previously_changed?(attr_name, **options)
  mutations_before_last_save.changed?(attr_name.to_s, **options)
end
```

###  **attribute_previously_was**(attr_name) [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-attribute_previously_was)
Dispatch target for [*_previously_was](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_previously_was) attribute methods.
Source: [show](javascript:toggleSource\('method-i-attribute_previously_was_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L315)

# File activemodel/lib/active_model/dirty.rb, line 315
def attribute_previously_was(attr_name)
  mutations_before_last_save.original_value(attr_name.to_s)
end
```

###  **attribute_was**(attr_name) [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-attribute_was)
Dispatch target for [*_was](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-2A_was) attribute methods.
Source: [show](javascript:toggleSource\('method-i-attribute_was_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L305)

# File activemodel/lib/active_model/dirty.rb, line 305
def attribute_was(attr_name)
  mutations_from_database.original_value(attr_name.to_s)
end
```

###  **changed**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-changed)
Returns an array with the name of the attributes with unsaved changes.

```
person.changed # => []
person. = 'bob'
person.changed # => ["name"]

Source: [show](javascript:toggleSource\('method-i-changed_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L295)

# File activemodel/lib/active_model/dirty.rb, line 295
def changed
  mutations_from_database.changed_attribute_names
end
```

###  **changed?**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-changed-3F)
Returns `true` if any of the attributes has unsaved changes, `false` otherwise.

```
person.changed? # => false
person. = 'bob'
person.changed? # => true

Source: [show](javascript:toggleSource\('method-i-changed-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L286)

# File activemodel/lib/active_model/dirty.rb, line 286
def changed?
  mutations_from_database.any_changes?
end
```

###  **changed_attributes**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-changed_attributes)
Returns a hash of the attributes with unsaved changes indicating their original values like `attr => original value`.

```
person. # => "bob"
person. = 'robert'
person.changed_attributes # => {"name" => "bob"}

Source: [show](javascript:toggleSource\('method-i-changed_attributes_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L343)

# File activemodel/lib/active_model/dirty.rb, line 343
def changed_attributes
  mutations_from_database.changed_values
end
```

###  **changes**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-changes)
Returns a hash of changed attributes indicating their original and new values like `attr => [original value, new value]`.

```
person.changes # => {}
person. = 'bob'
person.changes # => { "name" => ["bill", "bob"] }

Source: [show](javascript:toggleSource\('method-i-changes_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L353)

# File activemodel/lib/active_model/dirty.rb, line 353
def changes
  mutations_from_database.changes
end
```

###  **changes_applied**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-changes_applied)
Clears dirty data and moves `changes` to [`previous_changes`](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-previous_changes) and `mutations_from_database` to `mutations_before_last_save` respectively.
Source: [show](javascript:toggleSource\('method-i-changes_applied_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L272)

# File activemodel/lib/active_model/dirty.rb, line 272
def changes_applied
  unless defined?(@attributes)
    mutations_from_database.finalize_changes
  end
  @mutations_before_last_save = mutations_from_database
  forget_attribute_assignments
  @mutations_from_database = nil
end
```

###  **clear_*_change** [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-clear_-2A_change)
This method is generated for each attribute.
Clears all dirty data of the attribute: current changes and previous changes.

```
person = Person.(name: 'Chris')
person. = 'Jason'
person.name_change # => ['Chris', 'Jason']
person.clear_name_change
person.name_change # => nil

Source: [show](javascript:toggleSource\('method-i-clear_-2A_change_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L241)

# File activemodel/lib/active_model/dirty.rb, line 241
attribute_method_suffix "_previously_changed?", "_changed?", parameters: "**options"

###  **clear_attribute_changes**(attr_names) [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-clear_attribute_changes)
Source: [show](javascript:toggleSource\('method-i-clear_attribute_changes_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L331)

# File activemodel/lib/active_model/dirty.rb, line 331
def clear_attribute_changes(attr_names)
  attr_names.each do |attr_name|
    clear_attribute_change(attr_name)
  end
end
```

###  **clear_changes_information**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-clear_changes_information)
Clears all dirty data: current changes and previous changes.
Source: [show](javascript:toggleSource\('method-i-clear_changes_information_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L325)

# File activemodel/lib/active_model/dirty.rb, line 325
def clear_changes_information
  @mutations_before_last_save = nil
  forget_attribute_assignments
  @mutations_from_database = nil
end
```

###  **previous_changes**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-previous_changes)
Returns a hash of attributes that were changed before the model was saved.

```
person. # => "bob"
person. = 'robert'
person.save
person.previous_changes # => {"name" => ["bob", "robert"]}

Source: [show](javascript:toggleSource\('method-i-previous_changes_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L363)

# File activemodel/lib/active_model/dirty.rb, line 363
def previous_changes
  mutations_before_last_save.changes
end
```

###  **restore_*!** [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-restore_-2A-21)
This method is generated for each attribute.
Restores the attribute to the old value.

```
person = Person.
person. = 'Amanda'
person.restore_name!
person. # => nil

Source: [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L217)

# File activemodel/lib/active_model/dirty.rb, line 217

###  **restore_attributes**(attr_names = changed) [Link](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-restore_attributes)
Restore all previous data of the provided attributes.
Source: [show](javascript:toggleSource\('method-i-restore_attributes_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/dirty.rb#L320)

# File activemodel/lib/active_model/dirty.rb, line 320
def restore_attributes(attr_names = changed)
  attr_names.each { |attr_name| restore_attribute!(attr_name) }
end
```