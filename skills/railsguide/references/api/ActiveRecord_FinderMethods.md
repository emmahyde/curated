Methods

E

F

I

L

M

S

T

## Constants
| ONE_AS_ONE  | =  | "1 AS one"  |
| --- | --- | --- |

## Instance Public methods

###  **exists?**(conditions = :none) [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-exists-3F)
Returns true if a record exists in the table that matches the `id` or conditions given, or false otherwise. The argument can take six forms:
  * [`Integer`](https://api.rubyonrails.org/classes/Integer.html) - Finds the record with this primary key.
  * [`String`](https://api.rubyonrails.org/classes/String.html) - Finds the record with a primary key corresponding to this string (such as `'5'`).
  * [`Array`](https://api.rubyonrails.org/classes/Array.html) - Finds the record that matches these `where`-style conditions (such as `['name LIKE ?', "%#{query}%"]`).
  * [`Hash`](https://api.rubyonrails.org/classes/Hash.html) - Finds the record that matches these `where`-style conditions (such as `{name: 'David'}`).
  * `false` - Returns always `false`.
  * No args - Returns `false` if the relation is empty, `true` otherwise.

For more information about specifying conditions as a hash or array, see the Conditions section in the introduction to [`ActiveRecord::Base`](https://api.rubyonrails.org/classes/ActiveRecord/Base.html).
Note: You can’t pass in a condition as a string (like `name = 'Jamie'`), since it would be sanitized and then queried against the primary key column, like `id = 'name = \'Jamie\''`.

```
Person.exists?()
Person.exists?()
Person.exists?(['name LIKE ?', "%#{query}%"])
Person.exists?( [, , ])
Person.exists?(name: 'David')
Person.exists?(false)
Person.exists?
Person.where(name: 'Spartacus', rating: ).exists?

```

Source: [show](javascript:toggleSource\('method-i-exists-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L357)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 357
    def exists?(conditions = :none)
      return false if @none

if Base === conditions
        raise ArgumentError, <<-MSG.squish
          You are passing an instance of ActiveRecord::Base to `exists?`.
          Please pass the id of the object by calling `.id`.
        MSG
      end

return false if !conditions || limit_value == 0

if eager_loading?
        relation = apply_join_dependency(eager_loading: false)
        return relation.exists?(conditions)
      end

relation = construct_relation_for_exists(conditions)
      return false if relation.where_clause.contradiction?

skip_query_cache_if_necessary do
        with_connection do |c|
          c.select_rows(relation.arel, "#{model.name} Exists?").size == 1
        end
      end
    end
```

###  **fifth**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-fifth)
Find the fifth record. If no order is defined it will order by primary key.

```
Person.fifth # returns the fifth object fetched by SELECT * FROM people
Person.offset().fifth # returns the fifth object from OFFSET 3 (which is OFFSET 7)
Person.where(["user_name = :u", {  user_name }]).fifth

Source: [show](javascript:toggleSource\('method-i-fifth_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L271)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 271
def fifth
  find_nth 4
end
```

###  **fifth!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-fifth-21)
Same as [`fifth`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-fifth) but raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found.
Source: [show](javascript:toggleSource\('method-i-fifth-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L277)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 277
def fifth!
  fifth || raise_record_not_found_exception!
end
```

###  **find**(*args) [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-find)
Find by id - This can either be a specific id (ID), a list of ids (ID, ID, ID), or an array of ids ([ID, ID, ID]). ‘ID` refers to an “identifier”. For models with a single-column primary key, `ID` will be a single value, and for models with a composite primary key, it will be an array of values. If one or more records cannot be found for the requested ids, then [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) will be raised. If the primary key is an integer, find by id coerces its arguments by using `to_i`.

```
Person.()          # returns the object for ID = 1
Person.()        # returns the object for ID = 1
Person.("31-sarah") # returns the object for ID = 31
Person.(, , )    # returns an array for objects with IDs in (1, 2, 6)
Person.([, ])    # returns an array for objects with IDs in (7, 17), or with composite primary key [7, 17]
Person.([])        # returns an array for the object with ID = 1
Person.where("administrator = 1").order("created_on DESC").()

#### Find a record for a composite primary key model

```
TravelRoute.primary_key = [:origin, :destination]

TravelRoute.(["Ottawa", "London"])

# => #<TravelRoute origin: "Ottawa", destination: "London">

TravelRoute.([["Paris", "Montreal"]])

# => [#<TravelRoute origin: "Paris", destination: "Montreal">]

TravelRoute.(["New York", "Las Vegas"], ["New York", "Portland"])

# => [

#      #<TravelRoute origin: "New York", destination: "Las Vegas">,

#      #<TravelRoute origin: "New York", destination: "Portland">

#    ]

TravelRoute.([["Berlin", "London"], ["Barcelona", "Lisbon"]])

#      #<TravelRoute origin: "Berlin", destination: "London">,

#      #<TravelRoute origin: "Barcelona", destination: "Lisbon">

NOTE: The returned records are in the same order as the ids you provide. If you want the results to be sorted by database, you can use [`ActiveRecord::QueryMethods#where`](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-where) method and provide an explicit [`ActiveRecord::QueryMethods#order`](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-order) option. But [`ActiveRecord::QueryMethods#where`](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-where) method doesn’t raise [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html).

#### Find with lock
Example for find with a lock: Imagine two concurrent transactions: each will read `person.visits == 2`, add 1 to it, and save, resulting in two saves of `person.visits = 3`. By locking the row, the second transaction has to wait until the first is finished; we get the expected `person.visits == 4`.

```
Person.transaction
  person = Person.lock().()
  person.visits +=
  person.save!

#### Variations of [`find`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-find)

```
Person.where(name: 'Spartacus', rating: )

# returns a chainable list (which can be empty).

Person.find_by(name: 'Spartacus', rating: )

# returns the first item or nil.

Person.find_or_initialize_by(name: 'Spartacus', rating: )

# returns the first item or returns a new instance (requires you call .save to persist against the database).

Person.find_or_create_by(name: 'Spartacus', rating: )

# returns the first item or creates it and returns it.

#### Alternatives for [`find`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-find)

```
Person.where(name: 'Spartacus', rating: ).exists?(conditions = :none)

# returns a boolean indicating if any record with the given conditions exist.

Person.where(name: 'Spartacus', rating: ).select("field1, field2, field3")

# returns a chainable list of instances with only the mentioned fields.

Person.where(name: 'Spartacus', rating: ).

# returns an Array of ids.

Person.where(name: 'Spartacus', rating: ).pluck(:field1, :field2)

# returns an Array of the required fields.

#### Edge Cases

```
Person.()          # raises ActiveRecord::RecordNotFound exception if the record with the given ID does not exist.
Person.([])        # raises ActiveRecord::RecordNotFound exception if the record with the given ID in the input array does not exist.
Person.()         # raises ActiveRecord::RecordNotFound exception if the argument is nil.
Person.([])          # returns an empty array if the argument is an empty array.
Person.              # raises ActiveRecord::RecordNotFound exception if the argument is not provided.

Source: [show](javascript:toggleSource\('method-i-find_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L98)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 98
def find(*args)
  return super if block_given?
  find_with_ids(*args)
end
```

###  **find_by**(arg, *args) [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-find_by)
Finds the first record matching the specified conditions. There is no implied ordering so if order matters, you should specify it yourself.
If no record is found, returns `nil`.

```
Post.find_by name: 'Spartacus', rating:
Post.find_by "published_at < ?", .weeks.

Source: [show](javascript:toggleSource\('method-i-find_by_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L111)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 111
def find_by(arg, *args)
  where(arg, *args).take
end
```

###  **find_by!**(arg, *args) [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-find_by-21)
Like [`find_by`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-find_by), except that if no record is found, raises an [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) error.
Source: [show](javascript:toggleSource\('method-i-find_by-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L117)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 117
def find_by!(arg, *args)
  where(arg, *args).take!
end
```

###  **find_sole_by**(arg, *args) [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-find_sole_by)
Finds the sole matching record. Raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found. Raises [`ActiveRecord::SoleRecordExceeded`](https://api.rubyonrails.org/classes/ActiveRecord/SoleRecordExceeded.html) if more than one record is found.

```
Product.find_sole_by(["price = %?", price])

Source: [show](javascript:toggleSource\('method-i-find_sole_by_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L160)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 160
def find_sole_by(arg, *args)
  where(arg, *args).sole
end
```

###  **first**(limit = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-first)
Find the first record (or first N records if a parameter is supplied). If no order is defined it will order by primary key.

```
Person.first # returns the first object fetched by SELECT * FROM people ORDER BY people.id LIMIT 1
Person.where(["user_name = ?", user_name]).first
Person.where(["user_name = :u", {  user_name }]).first
Person.order("created_on DESC").offset().first
Person.first() # returns the first three objects fetched by SELECT * FROM people ORDER BY people.id LIMIT 3

Source: [show](javascript:toggleSource\('method-i-first_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L173)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 173
def first(limit = nil)
  if limit
    find_nth_with_limit(0, limit)
  else
    find_nth 0
  end
end
```

###  **first!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-first-21)
Same as [`first`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-first) but raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found. Note that [`first!`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-first-21) accepts no arguments.
Source: [show](javascript:toggleSource\('method-i-first-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L183)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 183
def first!
  first || raise_record_not_found_exception!
end
```

###  **forty_two**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-forty_two)
Find the forty-second record. Also known as accessing “the reddit”. If no order is defined it will order by primary key.

```
Person.forty_two # returns the forty-second object fetched by SELECT * FROM people
Person.offset().forty_two # returns the forty-second object from OFFSET 3 (which is OFFSET 44)
Person.where(["user_name = :u", {  user_name }]).forty_two

Source: [show](javascript:toggleSource\('method-i-forty_two_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L287)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 287
def forty_two
  find_nth 41
end
```

###  **forty_two!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-forty_two-21)
Same as [`forty_two`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-forty_two) but raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found.
Source: [show](javascript:toggleSource\('method-i-forty_two-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L293)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 293
def forty_two!
  forty_two || raise_record_not_found_exception!
end
```

###  **fourth**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-fourth)
Find the fourth record. If no order is defined it will order by primary key.

```
Person.fourth # returns the fourth object fetched by SELECT * FROM people
Person.offset().fourth # returns the fourth object from OFFSET 3 (which is OFFSET 6)
Person.where(["user_name = :u", {  user_name }]).fourth

Source: [show](javascript:toggleSource\('method-i-fourth_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L255)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 255
def fourth
  find_nth 3
end
```

###  **fourth!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-fourth-21)
Same as [`fourth`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-fourth) but raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found.
Source: [show](javascript:toggleSource\('method-i-fourth-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L261)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 261
def fourth!
  fourth || raise_record_not_found_exception!
end
```

###  **include?**(record) [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-include-3F)
Returns true if the relation contains the given record or false otherwise.
No query is performed if the relation is loaded; the given record is compared to the records in memory. If the relation is unloaded, an efficient existence query is performed, as in [`exists?`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-exists-3F).
Also aliased as: [member?](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-member-3F)
Source: [show](javascript:toggleSource\('method-i-include-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L389)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 389
def include?(record)

# The existing implementation relies on receiving an Active Record instance as the input parameter named record.

# Any non-Active Record object passed to this implementation is guaranteed to return `false`.
  return false unless record.is_a?(model)

if loaded? || offset_value || limit_value || having_clause.any?
    records.include?(record)
  else
    id = if record.class.composite_primary_key?
      record.class.primary_key.zip(record.id).to_h
    else
      record.id
    end

exists?(id)
  end
end
```

###  **last**(limit = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-last)
Find the last record (or last N records if a parameter is supplied). If no order is defined it will order by primary key.

```
Person. # returns the last object fetched by SELECT * FROM people
Person.where(["user_name = ?", user_name]).
Person.order("created_on DESC").offset().
Person.() # returns the last three objects fetched by SELECT * FROM people.

Take note that in that last case, the results are sorted in ascending order:

```
[#<Person id:2>, #<Person id:3>, #<Person id:4>]
```

and not:

```
[#<Person id:4>, #<Person id:3>, #<Person id:2>]
```

Source: [show](javascript:toggleSource\('method-i-last_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L202)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 202
def last(limit = nil)
  return find_last(limit) if loaded? || has_limit_or_offset?

result = ordered_relation.limit(limit)
  result = result.reverse_order!

limit ? result.reverse : result.first
end
```

###  **last!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-last-21)
Same as [`last`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-last) but raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found. Note that [`last!`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-last-21) accepts no arguments.
Source: [show](javascript:toggleSource\('method-i-last-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L213)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 213
def last!
  last || raise_record_not_found_exception!
end
```

###  **member?**(record) [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-member-3F)
Alias for: [include?](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-include-3F)

###  **second**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-second)
Find the second record. If no order is defined it will order by primary key.

```
Person.second # returns the second object fetched by SELECT * FROM people
Person.offset().second # returns the second object from OFFSET 3 (which is OFFSET 4)
Person.where(["user_name = :u", {  user_name }]).second

Source: [show](javascript:toggleSource\('method-i-second_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L223)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 223
def second
  find_nth 1
end
```

###  **second!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-second-21)
Same as [`second`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-second) but raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found.
Source: [show](javascript:toggleSource\('method-i-second-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L229)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 229
def second!
  second || raise_record_not_found_exception!
end
```

###  **second_to_last**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-second_to_last)
Find the second-to-last record. If no order is defined it will order by primary key.

```
Person.second_to_last # returns the second-to-last object fetched by SELECT * FROM people
Person.offset().second_to_last # returns the second-to-last object from OFFSET 3
Person.where(["user_name = :u", {  user_name }]).second_to_last

Source: [show](javascript:toggleSource\('method-i-second_to_last_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L319)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 319
def second_to_last
  find_nth_from_last 2
end
```

###  **second_to_last!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-second_to_last-21)
Same as [`second_to_last`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-second_to_last) but raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found.
Source: [show](javascript:toggleSource\('method-i-second_to_last-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L325)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 325
def second_to_last!
  second_to_last || raise_record_not_found_exception!
end
```

###  **sole**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-sole)
Finds the sole matching record. Raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found. Raises [`ActiveRecord::SoleRecordExceeded`](https://api.rubyonrails.org/classes/ActiveRecord/SoleRecordExceeded.html) if more than one record is found.

```
Product.where(["price = %?", price]).sole

Source: [show](javascript:toggleSource\('method-i-sole_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L143)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 143
def sole
  found, undesired = take(2)

if found.nil?
    raise_record_not_found_exception!
  elsif undesired.nil?
    found
  else
    raise ActiveRecord::SoleRecordExceeded.new(self)
  end
end
```

###  **take**(limit = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-take)
Gives a record (or N records if a parameter is supplied) without any implied order. The order will depend on the database implementation. If an order is supplied it will be respected.

```
Person.take # returns an object fetched by SELECT * FROM people LIMIT 1
Person.take() # returns 5 objects fetched by SELECT * FROM people LIMIT 5
Person.where(["name LIKE '%?'", ]).take

Source: [show](javascript:toggleSource\('method-i-take_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L128)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 128
def take(limit = nil)
  limit ? find_take_with_limit(limit) : find_take
end
```

###  **take!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-take-21)
Same as [`take`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-take) but raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found. Note that [`take!`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-take-21) accepts no arguments.
Source: [show](javascript:toggleSource\('method-i-take-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L134)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 134
def take!
  take || raise_record_not_found_exception!
end
```

###  **third**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-third)
Find the third record. If no order is defined it will order by primary key.

```
Person.third # returns the third object fetched by SELECT * FROM people
Person.offset().third # returns the third object from OFFSET 3 (which is OFFSET 5)
Person.where(["user_name = :u", {  user_name }]).third

Source: [show](javascript:toggleSource\('method-i-third_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L239)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 239
def third
  find_nth 2
end
```

###  **third!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-third-21)
Same as [`third`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-third) but raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found.
Source: [show](javascript:toggleSource\('method-i-third-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L245)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 245
def third!
  third || raise_record_not_found_exception!
end
```

###  **third_to_last**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-third_to_last)
Find the third-to-last record. If no order is defined it will order by primary key.

```
Person.third_to_last # returns the third-to-last object fetched by SELECT * FROM people
Person.offset().third_to_last # returns the third-to-last object from OFFSET 3
Person.where(["user_name = :u", {  user_name }]).third_to_last

Source: [show](javascript:toggleSource\('method-i-third_to_last_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L303)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 303
def third_to_last
  find_nth_from_last 3
end
```

###  **third_to_last!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-third_to_last-21)
Same as [`third_to_last`](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-third_to_last) but raises [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) if no record is found.
Source: [show](javascript:toggleSource\('method-i-third_to_last-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/relation/finder_methods.rb#L309)

# File activerecord/lib/active_record/relation/finder_methods.rb, line 309
def third_to_last!
  third_to_last || raise_record_not_found_exception!
end
```