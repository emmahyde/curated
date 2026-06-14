Methods

B

C

I

Q

U

## Instance Public methods

###  **build**(attributes = nil, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-build)
Builds an object (or multiple objects) and returns either the built object or a list of built objects.
The `attributes` parameter can be either a [`Hash`](https://api.rubyonrails.org/classes/Hash.html) or an [`Array`](https://api.rubyonrails.org/classes/Array.html) of Hashes. These Hashes describe the attributes on the objects that are to be built.

#### Examples

```

# Build a single new object
User.build(first_name: 'Jamie')

# Build an Array of new objects
User.build([{ first_name: 'Jamie' }, { first_name: 'Jeremy' }])

# Build a single object and pass it into a block to set other attributes.
User.build(first_name: 'Jamie')  ||
  .is_admin = false

# Building an Array of new objects using a block, where the block is executed for each object:
User.build([{ first_name: 'Jamie' }, { first_name: 'Jeremy' }])  ||
  .is_admin = false

Source: [show](javascript:toggleSource\('method-i-build_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L82)

# File activerecord/lib/active_record/persistence.rb, line 82
def build(attributes = nil, block)
  if attributes.is_a?(Array)
    attributes.collect { |attr| build(attr, block) }
  else
    new(attributes, block)
  end
end
```

###  **create**(attributes = nil, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-create)
Creates an object (or multiple objects) and saves it to the database, if validations pass. The resulting object is returned whether the object was saved successfully to the database or not.
The `attributes` parameter can be either a [`Hash`](https://api.rubyonrails.org/classes/Hash.html) or an [`Array`](https://api.rubyonrails.org/classes/Array.html) of Hashes. These Hashes describe the attributes on the objects that are to be created.

# Create a single new object
User.create(first_name: 'Jamie')

# Create an Array of new objects
User.create([{ first_name: 'Jamie' }, { first_name: 'Jeremy' }])

# Create a single object and pass it into a block to set other attributes.
User.create(first_name: 'Jamie')  ||
  .is_admin = false

# Creating an Array of new objects using a block, where the block is executed for each object:
User.create([{ first_name: 'Jamie' }, { first_name: 'Jeremy' }])  ||
  .is_admin = false

Source: [show](javascript:toggleSource\('method-i-create_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L33)

# File activerecord/lib/active_record/persistence.rb, line 33
def create(attributes = nil, block)
  if attributes.is_a?(Array)
    attributes.collect { |attr| create(attr, block) }
  else
    object = new(attributes, block)
    object.save
    object
  end
end
```

###  **create!**(attributes = nil, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-create-21)
Creates an object (or multiple objects) and saves it to the database, if validations pass. Raises a [`RecordInvalid`](https://api.rubyonrails.org/classes/ActiveRecord/RecordInvalid.html) error if validations fail, unlike Base#create.
The `attributes` parameter can be either a [`Hash`](https://api.rubyonrails.org/classes/Hash.html) or an [`Array`](https://api.rubyonrails.org/classes/Array.html) of Hashes. These describe which attributes to be created on the object, or multiple objects when given an [`Array`](https://api.rubyonrails.org/classes/Array.html) of Hashes.
Source: [show](javascript:toggleSource\('method-i-create-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L50)

# File activerecord/lib/active_record/persistence.rb, line 50
def create!(attributes = nil, block)
  if attributes.is_a?(Array)
    attributes.collect { |attr| create!(attr, block) }
  else
    object = new(attributes, block)
    object.save!
    object
  end
end
```

###  **instantiate**(attributes, column_types = {}, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-instantiate)
Given an attributes hash, `instantiate` returns a new instance of the appropriate class. Accepts only keys as strings.
For example, `Post.all` may return Comments, Messages, and Emails by storing the record’s subclass in a `type` attribute. By calling `instantiate` instead of `new`, finder methods ensure they get new instances of the appropriate class for each record.
See `ActiveRecord::Inheritance#discriminate_class_for_record` to see how this “single-table” inheritance mapping is implemented.
Source: [show](javascript:toggleSource\('method-i-instantiate_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L100)

# File activerecord/lib/active_record/persistence.rb, line 100
def instantiate(attributes, column_types = {}, block)
  klass = discriminate_class_for_record(attributes)
  instantiate_instance_of(klass, attributes, column_types, block)
end
```

###  **query_constraints**(*columns_list) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-query_constraints)
Accepts a list of attribute names to be used in the WHERE clause of SELECT / UPDATE / DELETE queries and in the ORDER BY clause for first and last finder methods.

```
class Developer  ActiveRecord::Base
  query_constraints :company_id,

developer = Developer.first

# SELECT "developers".* FROM "developers" ORDER BY "developers"."company_id" ASC, "developers"."id" ASC LIMIT 1
developer.inspect # => #<Developer id: 1, company_id: 1, ...>

developer.update!(name: "Nikita")

# UPDATE "developers" SET "name" = 'Nikita' WHERE "developers"."company_id" = 1 AND "developers"."id" = 1

# It is possible to update an attribute used in the query_constraints clause:
developer.update!(company_id: )

# UPDATE "developers" SET "company_id" = 2 WHERE "developers"."company_id" = 1 AND "developers"."id" = 1

developer. = "Bob"
developer.save!

# UPDATE "developers" SET "name" = 'Bob' WHERE "developers"."company_id" = 1 AND "developers"."id" = 1

developer.destroy!

# DELETE FROM "developers" WHERE "developers"."company_id" = 1 AND "developers"."id" = 1

developer.delete

developer.reload

# SELECT "developers".* FROM "developers" WHERE "developers"."company_id" = 1 AND "developers"."id" = 1 LIMIT 1

Source: [show](javascript:toggleSource\('method-i-query_constraints_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L212)

# File activerecord/lib/active_record/persistence.rb, line 212
def query_constraints(*columns_list)
  raise ArgumentError, "You must specify at least one column to be used in querying" if columns_list.empty?

@query_constraints_list = columns_list.map(:to_s)
  @has_query_constraints = @query_constraints_list
end
```

###  **update**(id = :all, attributes) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-update)
Updates an object (or multiple objects) and saves it to the database, if validations pass. The resulting object is returned whether the object was saved successfully to the database or not.

#### Parameters
  * `id` - This should be the id or an array of ids to be updated. Optional argument, defaults to all records in the relation.
  * `attributes` - This should be a hash of attributes or an array of hashes.

# Updates one record
Person.update(, user_name: "Samuel", group: "expert")

# Updates multiple records
people = {  => { "first_name" => "David" },  => { "first_name" => "Jeremy" } }
Person.update(people., people.values)

# Updates multiple records from the result of a relation
people = Person.where(group: "expert")
people.update(group: "masters")

Note: Updating a large number of records will run an UPDATE query for each record, which may cause a performance issue. When running callbacks is not needed for each record update, it is preferred to use [update_all](https://api.rubyonrails.org/classes/ActiveRecord/Relation.html#method-i-update_all) for updating all records in a single query.
Source: [show](javascript:toggleSource\('method-i-update_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L132)

# File activerecord/lib/active_record/persistence.rb, line 132
def update(id = :all, attributes)
  if id.is_a?(Array)
    if id.any?(ActiveRecord::Base)
      raise ArgumentError,
        "You are passing an array of ActiveRecord::Base instances to `update`. " \
        "Please pass the ids of the objects by calling `pluck(:id)` or `map(&:id)`."
    end
    id.map { |one_id| find(one_id) }.each_with_index { |object, idx|
      object.update(attributes[idx])
    }
  elsif id == :all
    all.each { |record| record.update(attributes) }
  else
    if ActiveRecord::Base === id
      raise ArgumentError,
        "You are passing an instance of ActiveRecord::Base to `update`. " \
        "Please pass the id of the object by calling `.id`."
    end
    object = find(id)
    object.update(attributes)
    object
  end
end
```

###  **update!**(id = :all, attributes) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-update-21)
Updates the object (or multiple objects) just like [`update`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-update) but calls [`update!`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-update-21) instead of `update`, so an exception is raised if the record is invalid and saving will fail.
Source: [show](javascript:toggleSource\('method-i-update-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L158)

# File activerecord/lib/active_record/persistence.rb, line 158
def update!(id = :all, attributes)
  if id.is_a?(Array)
    if id.any?(ActiveRecord::Base)
      raise ArgumentError,
        "You are passing an array of ActiveRecord::Base instances to `update!`. " \
        "Please pass the ids of the objects by calling `pluck(:id)` or `map(&:id)`."
    end
    id.map { |one_id| find(one_id) }.each_with_index { |object, idx|
      object.update!(attributes[idx])
    }
  elsif id == :all
    all.each { |record| record.update!(attributes) }
  else
    if ActiveRecord::Base === id
      raise ArgumentError,
        "You are passing an instance of ActiveRecord::Base to `update!`. " \
        "Please pass the id of the object by calling `.id`."
    end
    object = find(id)
    object.update!(attributes)
    object
  end
end
```