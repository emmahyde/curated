# Single table inheritance
Active Record allows inheritance by storing the name of the class in a column that by default is named “type” (can be changed by overwriting [`Base.inheritance_column`](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html#method-c-inheritance_column)). This means that an inheritance looking like this:

```
class Company  ActiveRecord::Base;
class Firm  Company;
class Client  Company;
class PriorityClient  Client;

```

When you do `Firm.create(name: "37signals")`, this record will be saved in the companies table with type = “Firm”. You can then fetch this row again using `Company.where(name: '37signals').first` and it will return a Firm object.
Be aware that because the type column is an attribute on the record every new subclass will instantly be marked as dirty and the type column will be included in the list of changed attributes on the record. This is different from non Single Table Inheritance(STI) classes:

```
Company..changed? # => false
Firm..changed?    # => true
Firm..changes     # => {"type"=>["","Firm"]}

If you don’t have a type column defined in your table, single-table inheritance won’t be triggered. In that case, it’ll work just like normal subclasses with no special magic for differentiating between them or reloading the right type with find.
Note, all the attributes for all the cases are kept in the same table. Read more:
  * [www.martinfowler.com/eaaCatalog/singleTableInheritance.html](https://www.martinfowler.com/eaaCatalog/singleTableInheritance.html)

Namespace
  * MODULE [ActiveRecord::Inheritance::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Inheritance/ClassMethods.html)

Methods

I

## Instance Public methods

###  **initialize_dup**(other) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Inheritance.html#method-i-initialize_dup)
Source: [show](javascript:toggleSource\('method-i-initialize_dup_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/inheritance.rb#L343)

# File activerecord/lib/active_record/inheritance.rb, line 343
def initialize_dup(other)
  super
  ensure_proper_type
end
```