## What is Optimistic Locking
[`Optimistic`](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html) locking allows multiple users to access the same record for edits, and assumes a minimum of conflicts with the data. It does this by checking whether another process has made changes to a record since it was opened, an [`ActiveRecord::StaleObjectError`](https://api.rubyonrails.org/classes/ActiveRecord/StaleObjectError.html) exception is thrown if that has occurred and the update is ignored.
Check out [`ActiveRecord::Locking::Pessimistic`](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html) for an alternative.

## Usage
Active Record supports optimistic locking if the `lock_version` field is present. Each update to the record increments the integer column `lock_version` and the locking facilities ensure that records instantiated twice will let the last one saved raise a [`StaleObjectError`](https://api.rubyonrails.org/classes/ActiveRecord/StaleObjectError.html) if the first was also updated. Example:

```
 = Person.()
 = Person.()

.first_name = "Michael"
.save

.first_name = "should fail"
.save # Raises an ActiveRecord::StaleObjectError

```

[`Optimistic`](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html) locking will also check for stale data when objects are destroyed. Example:

.destroy # Raises an ActiveRecord::StaleObjectError

You’re then responsible for dealing with the conflict by rescuing the exception and either rolling back, merging, or otherwise apply the business logic needed to resolve the conflict.
This locking mechanism will function inside a single Ruby process. To make it work across all web requests, the recommended approach is to add `lock_version` as a hidden field to your form.
This behavior can be turned off by setting `ActiveRecord::Base.lock_optimistically = false`. To override the name of the `lock_version` column, set the `locking_column` class attribute:

```
class Person  ActiveRecord::Base
  .locking_column = :lock_person

Namespace
  * MODULE [ActiveRecord::Locking::Optimistic::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic/ClassMethods.html)