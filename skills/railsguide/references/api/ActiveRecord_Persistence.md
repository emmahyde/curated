# Active Record Persistence
Namespace
  * MODULE [ActiveRecord::Persistence::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html)

Methods

B

D

I

N

P

R

S

T

U

## Instance Public methods

###  **becomes**(klass) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-becomes)
Returns an instance of the specified `klass` with the attributes of the current record. This is mostly useful in relation to single table inheritance (STI) structures where you want a subclass to appear as the superclass. This can be used along with record identification in Action Pack to allow, say, `Client < Company` to do something like render `partial: @client.becomes(Company)` to render that instance using the companies/company partial instead of clients/client.
Note: The new instance will share a link to the same attributes as the original class. Therefore the STI column value will still be the same. Any change to the attributes on either instance will affect both instances. This includes any attribute initialization done by the new instance.
If you want to change the STI column as well, use [`becomes!`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-becomes-21) instead.
Source: [show](javascript:toggleSource\('method-i-becomes_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L487)

```

# File activerecord/lib/active_record/persistence.rb, line 487
def becomes(klass)
  became = klass.allocate

became.send(:initialize) do |becoming|
    @attributes.reverse_merge!(becoming.instance_variable_get(:@attributes))
    becoming.instance_variable_set(:@attributes, @attributes)
    becoming.instance_variable_set(:@mutations_from_database, @mutations_from_database ||= nil)
    becoming.instance_variable_set(:@new_record, new_record?)
    becoming.instance_variable_set(:@previously_new_record, previously_new_record?)
    becoming.instance_variable_set(:@destroyed, destroyed?)
    becoming.errors.copy!(errors)
  end

became
end
```

###  **becomes!**(klass) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-becomes-21)
Wrapper around [`becomes`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-becomes) that also changes the instance’s STI column value. This is especially useful if you want to persist the changed class in your database.
Note: The old instance’s STI column value will be changed too, as both objects share the same set of attributes.
Source: [show](javascript:toggleSource\('method-i-becomes-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L509)

# File activerecord/lib/active_record/persistence.rb, line 509
def becomes!(klass)
  became = becomes(klass)
  sti_type = nil
  if !klass.descends_from_active_record?
    sti_type = klass.sti_name
  end
  became.public_send("#{klass.inheritance_column}=", sti_type)
  became
end
```

###  **decrement**(attribute, by = 1) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-decrement)
Initializes `attribute` to zero if `nil` and subtracts the value passed as `by` (default is 1). The decrement is performed directly on the underlying attribute, no setter is invoked. Only makes sense for number-based attributes. Returns `self`.
Source: [show](javascript:toggleSource\('method-i-decrement_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L686)

# File activerecord/lib/active_record/persistence.rb, line 686
def decrement(attribute, by = 1)
  increment(attribute, -by)
end
```

###  **decrement!**(attribute, by = 1, touch: nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-decrement-21)
Wrapper around [`decrement`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-decrement) that writes the update to the database. Only `attribute` is updated; the record itself is not saved. This means that any other modified attributes will still be dirty. [`Validations`](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) and callbacks are skipped. Supports the `touch` option from `update_counters`, see that for more. Returns `self`.
Source: [show](javascript:toggleSource\('method-i-decrement-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L696)

# File activerecord/lib/active_record/persistence.rb, line 696
def decrement!(attribute, by = 1, touch: nil)
  increment!(attribute, -by, touch: touch)
end
```

###  **delete**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-delete)
Deletes the record in the database and freezes this instance to reflect that no changes should be made (since they can’t be persisted). Returns the frozen instance.
The row is simply removed with an SQL `DELETE` statement on the record’s primary key, and no callbacks are executed.
Note that this will also delete records marked as [#readonly?](https://api.rubyonrails.org/classes/ActiveRecord/Core.html#method-i-readonly-3F).
To enforce the object’s `before_destroy` and `after_destroy` callbacks or any `:dependent` association options, use [`destroy`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroy).
Source: [show](javascript:toggleSource\('method-i-delete_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L439)

# File activerecord/lib/active_record/persistence.rb, line 439
def delete
  _delete_row if persisted?
  @destroyed = true
  @previously_new_record = false
  freeze
end
```

###  **destroy**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroy)
Deletes the record in the database and freezes this instance to reflect that no changes should be made (since they can’t be persisted).
There’s a series of callbacks associated with [`destroy`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroy). If the `before_destroy` callback throws `:abort` the action is cancelled and [`destroy`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroy) returns `false`. See [`ActiveRecord::Callbacks`](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) for further details.
Source: [show](javascript:toggleSource\('method-i-destroy_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L453)

# File activerecord/lib/active_record/persistence.rb, line 453
def destroy
  _raise_readonly_record_error if readonly?
  destroy_associations
  @_trigger_destroy_callback ||= persisted?  destroy_row  0
  @destroyed = true
  @previously_new_record = false
  freeze
end
```

###  **destroy!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroy-21)
Deletes the record in the database and freezes this instance to reflect that no changes should be made (since they can’t be persisted).
There’s a series of callbacks associated with [`destroy!`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroy-21). If the `before_destroy` callback throws `:abort` the action is cancelled and [`destroy!`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroy-21) raises [`ActiveRecord::RecordNotDestroyed`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotDestroyed.html). See [`ActiveRecord::Callbacks`](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) for further details.
Source: [show](javascript:toggleSource\('method-i-destroy-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L469)

# File activerecord/lib/active_record/persistence.rb, line 469
def destroy!
  destroy || _raise_record_not_destroyed
end
```

###  **destroyed?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroyed-3F)
Returns true if this object has been destroyed, otherwise returns false.
Source: [show](javascript:toggleSource\('method-i-destroyed-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L355)

# File activerecord/lib/active_record/persistence.rb, line 355
def destroyed?
  @destroyed
end
```

###  **increment**(attribute, by = 1) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-increment)
Initializes `attribute` to zero if `nil` and adds the value passed as `by` (default is 1). The increment is performed directly on the underlying attribute, no setter is invoked. Only makes sense for number-based attributes. Returns `self`.
Source: [show](javascript:toggleSource\('method-i-increment_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L656)

# File activerecord/lib/active_record/persistence.rb, line 656
def increment(attribute, by = 1)
  self[attribute] ||= 0
  self[attribute] += by
  self
end
```

###  **increment!**(attribute, by = 1, touch: nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-increment-21)
Wrapper around [`increment`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-increment) that writes the update to the database. Only `attribute` is updated; the record itself is not saved. This means that any other modified attributes will still be dirty. [`Validations`](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) and callbacks are skipped. Supports the `touch` option from `update_counters`, see that for more.
This method raises an [`ActiveRecord::ActiveRecordError`](https://api.rubyonrails.org/classes/ActiveRecord/ActiveRecordError.html) when called on new objects, or when at least one of the attributes is marked as readonly.
Returns `self`.
Source: [show](javascript:toggleSource\('method-i-increment-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L672)

# File activerecord/lib/active_record/persistence.rb, line 672
def increment!(attribute, by = 1, touch: nil)
  raise ActiveRecordError, "cannot update a new record" if new_record?
  raise ActiveRecordError, "cannot update a destroyed record" if destroyed?

increment(attribute, by)
  change = public_send(attribute) - (public_send(:"#{attribute}_in_database") || 0)
  self.class.update_counters(id, attribute => change, touch: touch)
  public_send(:"clear_#{attribute}_change")
  self
end
```

###  **new_record?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-new_record-3F)
Returns true if this object hasn’t been saved yet – that is, a record for the object doesn’t exist in the database yet; otherwise, returns false.
Source: [show](javascript:toggleSource\('method-i-new_record-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L338)

# File activerecord/lib/active_record/persistence.rb, line 338
def new_record?
  @new_record
end
```

###  **persisted?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-persisted-3F)
Returns true if the record is persisted, i.e. it’s not a new record and it was not destroyed, otherwise returns false.
Source: [show](javascript:toggleSource\('method-i-persisted-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L361)

# File activerecord/lib/active_record/persistence.rb, line 361
def persisted?
  !(@new_record || @destroyed)
end
```

###  **previously_new_record?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-previously_new_record-3F)
Returns true if this object was just created – that is, prior to the last update or delete, the object didn’t exist in the database and new_record? would have returned true.
Source: [show](javascript:toggleSource\('method-i-previously_new_record-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L345)

# File activerecord/lib/active_record/persistence.rb, line 345
def previously_new_record?
  @previously_new_record
end
```

###  **previously_persisted?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-previously_persisted-3F)
Returns true if this object was previously persisted but now it has been deleted.
Source: [show](javascript:toggleSource\('method-i-previously_persisted-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L350)

# File activerecord/lib/active_record/persistence.rb, line 350
def previously_persisted?
  !new_record?  destroyed?
end
```

###  **reload**(options = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-reload)
Reloads the record from the database.
This method finds the record by its primary key (which could be assigned manually) and modifies the receiver in-place:

```
account = Account.

# => #<Account id: nil, email: nil>
account. =
account.reload

# Account Load (1.2ms)  SELECT "accounts".* FROM "accounts" WHERE "accounts"."id" = $1 LIMIT 1  [["id", 1]]

# => #<Account id: 1, email: 'account@example.com'>

[`Attributes`](https://api.rubyonrails.org/classes/ActiveRecord/Attributes.html) are reloaded from the database, and caches busted, in particular the associations cache and the [`QueryCache`](https://api.rubyonrails.org/classes/ActiveRecord/QueryCache.html).
If the record no longer exists in the database [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) is raised. Otherwise, in addition to the in-place modification the method returns `self` for convenience.
The optional `:lock` flag option allows you to lock the reloaded record:

```
reload(lock: ) # reload with pessimistic locking

Reloading is commonly used in test suites to test something is actually written to the database, or when some action modifies the corresponding row in the database but not the object in memory:

```
assert account.deposit!()
assert_equal , account.credit        # check it is updated in memory
assert_equal , account.reload.credit # check it is also persisted

Another common use case is optimistic locking handling:

```
 with_optimistic_retry
  begin
    yield
  rescue ActiveRecord::StaleObjectError
    begin
      # Reload lock_version in particular.
      reload
    rescue ActiveRecord::RecordNotFound
      # If the record is gone there is nothing to do.

retry

Source: [show](javascript:toggleSource\('method-i-reload_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L773)

# File activerecord/lib/active_record/persistence.rb, line 773
def reload(options = nil)
  self.class.connection_pool.clear_query_cache

fresh_object = if apply_scoping?(options)
    _find_record((options || {}).merge(all_queries: true))
  else
    self.class.unscoped { _find_record(options) }
  end

@association_cache = fresh_object.instance_variable_get(:@association_cache)
  @association_cache.each_value { |association| association.owner = self }
  @attributes = fresh_object.instance_variable_get(:@attributes)
  @new_record = false
  @previously_new_record = false
  self
end
```

###  **save(**options)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save)
Saves the model.
If the model is new, a record gets created in the database, otherwise the existing record gets updated.
By default, save always runs validations. If any of them fail the action is cancelled and [`save`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save) returns `false`, and the record won’t be saved. However, if you supply `validate: false`, validations are bypassed altogether. See [`ActiveRecord::Validations`](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) for more information.
By default, [`save`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save) also sets the `updated_at`/`updated_on` attributes to the current time. However, if you supply `touch: false`, these timestamps will not be updated.
There’s a series of callbacks associated with [`save`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save). If any of the `before_*` callbacks throws `:abort` the action is cancelled and [`save`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save) returns `false`. See [`ActiveRecord::Callbacks`](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) for further details.
[`Attributes`](https://api.rubyonrails.org/classes/ActiveRecord/Attributes.html) marked as readonly are silently ignored if the record is being updated.
Source: [show](javascript:toggleSource\('method-i-save_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L390)

# File activerecord/lib/active_record/persistence.rb, line 390
def save(**options, block)
  create_or_update(**options, block)
rescue ActiveRecord::RecordInvalid
  false
end
```

###  **save!(**options)** [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21)
Saves the model.
If the model is new, a record gets created in the database, otherwise the existing record gets updated.
By default, [`save!`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21) always runs validations. If any of them fail [`ActiveRecord::RecordInvalid`](https://api.rubyonrails.org/classes/ActiveRecord/RecordInvalid.html) gets raised, and the record won’t be saved. However, if you supply `validate: false`, validations are bypassed altogether. See [`ActiveRecord::Validations`](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) for more information.
By default, [`save!`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21) also sets the `updated_at`/`updated_on` attributes to the current time. However, if you supply `touch: false`, these timestamps will not be updated.
There’s a series of callbacks associated with [`save!`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21). If any of the `before_*` callbacks throws `:abort` the action is cancelled and [`save!`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21) raises [`ActiveRecord::RecordNotSaved`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotSaved.html). See [`ActiveRecord::Callbacks`](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) for further details.
[`Attributes`](https://api.rubyonrails.org/classes/ActiveRecord/Attributes.html) marked as readonly are silently ignored if the record is being updated.
Unless an error is raised, returns true.
Source: [show](javascript:toggleSource\('method-i-save-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L423)

# File activerecord/lib/active_record/persistence.rb, line 423
def save!(**options, block)
  create_or_update(**options, block) || raise(RecordNotSaved.new("Failed to save the record", self))
end
```

###  **toggle**(attribute) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-toggle)
Assigns to `attribute` the boolean opposite of `attribute?`. So if the predicate returns `true` the attribute will become `false`. This method toggles directly the underlying value without calling any setter. Returns `self`.
Example:

```
user = User.first
user.banned? # => false
user.toggle(:banned)
user.banned? # => true

Source: [show](javascript:toggleSource\('method-i-toggle_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L712)

# File activerecord/lib/active_record/persistence.rb, line 712
def toggle(attribute)
  self[attribute] = !public_send("#{attribute}?")
  self
end
```

###  **toggle!**(attribute) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-toggle-21)
Wrapper around [`toggle`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-toggle) that saves the record. This method differs from its non-bang version in the sense that it passes through the attribute setter. Saving is not subjected to validation checks. Returns `true` if the record could be saved.
Source: [show](javascript:toggleSource\('method-i-toggle-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L721)

# File activerecord/lib/active_record/persistence.rb, line 721
def toggle!(attribute)
  toggle(attribute).update_attribute(attribute, self[attribute])
end
```

###  **touch**(*names, time: nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-touch)
Saves the record with the updated_at/on attributes set to the current time or the time specified. Please note that no validation is performed and only the `after_touch`, `after_commit` and `after_rollback` callbacks are executed.
This method can be passed attribute names and an optional time argument. If attribute names are passed, they are updated along with updated_at/on attributes. If no time argument is passed, the current time is used as default.

```
product.touch                         # updates updated_at/on with current time
product.touch(time: Time.(2015, , , , , )) # updates updated_at/on with specified time
product.touch(:designed_at)           # updates the designed_at attribute and updated_at/on
product.touch(:started_at, :ended_at) # updates started_at, ended_at and updated_at/on attributes

If used along with [belongs_to](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#method-i-belongs_to) then `touch` will invoke `touch` method on associated object.

```
class Brake  ActiveRecord::Base
  belongs_to , touch:

class   ActiveRecord::Base
  belongs_to :corporation, touch:

# triggers @brake.car.touch and @brake.car.corporation.touch
@brake.touch

Note that `touch` must be used on a persisted object, or else an [`ActiveRecordError`](https://api.rubyonrails.org/classes/ActiveRecord/ActiveRecordError.html) will be thrown. For example:

```
ball = Ball.
ball.touch(:updated_at)   # => raises ActiveRecordError

Source: [show](javascript:toggleSource\('method-i-touch_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L824)

# File activerecord/lib/active_record/persistence.rb, line 824
def touch(*names, time: nil)
  _raise_record_not_touched_error unless persisted?
  _raise_readonly_record_error if readonly?

attribute_names = timestamp_attributes_for_update_in_model
  attribute_names = (attribute_names | names).map! do |name|
    name = name.to_s
    name = self.class.attribute_aliases[name] || name
    verify_readonly_attribute(name)
    name
  end

unless attribute_names.empty?
    affected_rows = _touch_row(attribute_names, time)
    @_trigger_update_callback = affected_rows == 1
  else
    true
  end
end
```

###  **update**(attributes) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update)
Updates the attributes of the model from the passed-in hash and saves the record, all wrapped in a transaction. If the object is invalid, the saving will fail and false will be returned.
Source: [show](javascript:toggleSource\('method-i-update_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L564)

# File activerecord/lib/active_record/persistence.rb, line 564
def update(attributes)

# The following transaction covers any possible database side-effects of the

# attributes assignment. For example, setting the IDs of a child collection.
  with_transaction_returning_status do
    assign_attributes(attributes)
    save
  end
end
```

###  **update!**(attributes) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update-21)
Updates its receiver just like [`update`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update) but calls [`save!`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21) instead of `save`, so an exception is raised if the record is invalid and saving will fail.
Source: [show](javascript:toggleSource\('method-i-update-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L575)

# File activerecord/lib/active_record/persistence.rb, line 575
def update!(attributes)

# attributes assignment. For example, setting the IDs of a child collection.
  with_transaction_returning_status do
    assign_attributes(attributes)
    save!
  end
end
```

###  **update_attribute**(name, value) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update_attribute)
Updates a single attribute and saves the record. This is especially useful for boolean flags on existing records. Also note that
  * Validation is skipped.
  * Callbacks are invoked.
  * updated_at/updated_on column is updated if that column is available.
  * Updates all the attributes that are dirty in this object.

This method raises an [`ActiveRecord::ActiveRecordError`](https://api.rubyonrails.org/classes/ActiveRecord/ActiveRecordError.html) if the attribute is marked as readonly.
Also see [`update_column`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update_column).
Source: [show](javascript:toggleSource\('method-i-update_attribute_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L531)

# File activerecord/lib/active_record/persistence.rb, line 531
def update_attribute(name, value)
  name = name.to_s
  verify_readonly_attribute(name)
  public_send("#{name}=", value)

save(validate: false)
end
```

###  **update_attribute!**(name, value) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update_attribute-21)
Updates a single attribute and saves the record. This is especially useful for boolean flags on existing records. Also note that
  * Validation is skipped.
  * Callbacks are invoked.
  * updated_at/updated_on column is updated if that column is available.
  * Updates all the attributes that are dirty in this object.

This method raises an [`ActiveRecord::ActiveRecordError`](https://api.rubyonrails.org/classes/ActiveRecord/ActiveRecordError.html) if the attribute is marked as readonly.
If any of the `before_*` callbacks throws `:abort` the action is cancelled and [`update_attribute!`](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update_attribute-21) raises [`ActiveRecord::RecordNotSaved`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotSaved.html). See [`ActiveRecord::Callbacks`](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) for further details.
Source: [show](javascript:toggleSource\('method-i-update_attribute-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L553)

# File activerecord/lib/active_record/persistence.rb, line 553
def update_attribute!(name, value)
  name = name.to_s
  verify_readonly_attribute(name)
  public_send("#{name}=", value)

save!(validate: false)
end
```

###  **update_column**(name, value, touch: nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update_column)
Equivalent to `update_columns(name => value)`.
Source: [show](javascript:toggleSource\('method-i-update_column_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L585)

# File activerecord/lib/active_record/persistence.rb, line 585
def update_column(name, value, touch: nil)
  update_columns(name => value, touch: touch)
end
```

###  **update_columns**(attributes) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-update_columns)
Updates the attributes directly in the database issuing an UPDATE SQL statement and sets them in the receiver:

```
user.update_columns(last_request_at: Time.current)

This is the fastest way to update attributes because it goes straight to the database, but take into account that in consequence the regular update procedures are totally bypassed. In particular:
  * Validations are skipped.
  * Callbacks are skipped.
  * `updated_at`/`updated_on` are updated if the `touch` option is set to `true`.
  * However, attributes are serialized with the same rules as [`ActiveRecord::Relation#update_all`](https://api.rubyonrails.org/classes/ActiveRecord/Relation.html#method-i-update_all)

This method raises an [`ActiveRecord::ActiveRecordError`](https://api.rubyonrails.org/classes/ActiveRecord/ActiveRecordError.html) when called on new objects, or when at least one of the attributes is marked as readonly.

#### Parameters
  * `:touch` option - Touch the timestamp columns when updating.
  * If attribute names are passed, they are updated along with `updated_at`/`updated_on` attributes.

#### Examples

# Update a single attribute.
user.update_columns(last_request_at: Time.current)

# Update with touch option.
user.update_columns(last_request_at: Time.current, touch: )

Source: [show](javascript:toggleSource\('method-i-update_columns_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/persistence.rb#L619)

# File activerecord/lib/active_record/persistence.rb, line 619
def update_columns(attributes)
  raise ActiveRecordError, "cannot update a new record" if new_record?
  raise ActiveRecordError, "cannot update a destroyed record" if destroyed?
  _raise_readonly_record_error if readonly?

attributes = attributes.transform_keys do |key|
    name = key.to_s
    name = self.class.attribute_aliases[name] || name
    verify_readonly_attribute(name) || name
  end

touch = attributes.delete("touch")
  if touch
    names = touch if touch != true
    names = Array.wrap(names)
    options = names.extract_options!
    touch_updates = self.class.touch_attributes_with_time(*names, **options)
    attributes.with_defaults!(touch_updates) unless touch_updates.empty?
  end

update_constraints = _query_constraints_hash
  attributes = attributes.each_with_object({}) do |(k, v), h|
    h[k] = @attributes.write_cast_value(k, v)
    clear_attribute_change(k)
  end

affected_rows = self.class._update_record(
    attributes,
    update_constraints
  )

affected_rows == 1
end
```