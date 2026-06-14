# Active Record [`Reflection`](https://api.rubyonrails.org/classes/ActiveRecord/Reflection.html)
Reflection enables the ability to examine the associations and aggregations of Active Record classes and objects. This information, for example, can be used in a form builder that takes an Active Record object and creates input fields for all of the attributes depending on their type and displays the associations to other objects.
[`MacroReflection`](https://api.rubyonrails.org/classes/ActiveRecord/Reflection/MacroReflection.html) class has info for AggregateReflection and AssociationReflection classes.
Methods

R

* reflect_on_all_aggregations,
  * reflect_on_all_associations,
  * reflect_on_all_autosave_associations,

## Instance Public methods

###  **reflect_on_aggregation**(aggregation) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Reflection/ClassMethods.html#method-i-reflect_on_aggregation)
Returns the AggregateReflection object for the named `aggregation` (use the symbol).

```
Account.reflect_on_aggregation(:balance) # => the balance AggregateReflection

```

Source: [show](javascript:toggleSource\('method-i-reflect_on_aggregation_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/reflection.rb#L70)

# File activerecord/lib/active_record/reflection.rb, line 70
def reflect_on_aggregation(aggregation)
  aggregate_reflections[aggregation.to_sym]
end
```

###  **reflect_on_all_aggregations**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Reflection/ClassMethods.html#method-i-reflect_on_all_aggregations)
Returns an array of AggregateReflection objects for all the aggregations in the class.
Source: [show](javascript:toggleSource\('method-i-reflect_on_all_aggregations_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/reflection.rb#L62)

# File activerecord/lib/active_record/reflection.rb, line 62
def reflect_on_all_aggregations
  aggregate_reflections.values
end
```

###  **reflect_on_all_associations**(macro = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Reflection/ClassMethods.html#method-i-reflect_on_all_associations)
Returns an array of AssociationReflection objects for all the associations in the class. If you only want to reflect on a certain association type, pass in the symbol (`:has_many`, `:has_one`, `:belongs_to`) as the first parameter.
Example:

```
Account.reflect_on_all_associations             # returns an array of all associations
Account.reflect_on_all_associations(:has_many)  # returns an array of all has_many associations

Source: [show](javascript:toggleSource\('method-i-reflect_on_all_associations_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/reflection.rb#L111)

# File activerecord/lib/active_record/reflection.rb, line 111
def reflect_on_all_associations(macro = nil)
  association_reflections = normalized_reflections.values
  association_reflections.select! { |reflection| reflection.macro == macro } if macro
  association_reflections
end
```

###  **reflect_on_all_autosave_associations**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Reflection/ClassMethods.html#method-i-reflect_on_all_autosave_associations)
Returns an array of AssociationReflection objects for all associations which have `:autosave` enabled.
Source: [show](javascript:toggleSource\('method-i-reflect_on_all_autosave_associations_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/reflection.rb#L131)

# File activerecord/lib/active_record/reflection.rb, line 131
def reflect_on_all_autosave_associations
  reflections = normalized_reflections.values
  reflections.select! { |reflection| reflection.options[:autosave] }
  reflections
end
```

###  **reflect_on_association**(association) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Reflection/ClassMethods.html#method-i-reflect_on_association)
Returns the AssociationReflection object for the `association` (use the symbol).

```
Account.reflect_on_association(:owner)             # returns the owner AssociationReflection
Invoice.reflect_on_association(:line_items).macro  # returns :has_many

Source: [show](javascript:toggleSource\('method-i-reflect_on_association_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/reflection.rb#L122)

# File activerecord/lib/active_record/reflection.rb, line 122
def reflect_on_association(association)
  normalized_reflections[association.to_sym]
end
```

###  **reflections**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Reflection/ClassMethods.html#method-i-reflections)
Returns a [`Hash`](https://api.rubyonrails.org/classes/Hash.html) of name of the reflection as the key and an AssociationReflection as the value.

```
Account.reflections # => {"balance" => AggregateReflection}

Source: [show](javascript:toggleSource\('method-i-reflections_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/reflection.rb#L78)

# File activerecord/lib/active_record/reflection.rb, line 78
def reflections
  normalized_reflections.stringify_keys
end
```