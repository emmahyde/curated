# Active Record Callbacks
Callbacks are hooks into the life cycle of an Active Record object that allow you to trigger logic before or after a change in the object state. This can be used to make sure that associated and dependent objects are deleted when [ActiveRecord::Base#destroy](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroy) is called (by overwriting `before_destroy`) or to massage attributes before they’re validated (by overwriting `before_validation`). As an example of the callbacks initiated, consider the [ActiveRecord::Base#save](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save) call for a new record:
  * (-) `save`
  * (-) `valid`
  * (1) `before_validation`
  * (-) `validate`
  * (2) `after_validation`
  * (3) `before_save`
  * (4) `before_create`
  * (-) `create`
  * (5) `after_create`
  * (6) `after_save`
  * (7) `after_commit`

Also, an `after_rollback` callback can be configured to be triggered whenever a rollback is issued. Check out [`ActiveRecord::Transactions`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions.html) for more details about `after_commit` and `after_rollback`.
Additionally, an `after_touch` callback is triggered whenever an object is touched.
Lastly an `after_find` and `after_initialize` callback is triggered for each object that is found and instantiated by a finder, with `after_initialize` being triggered after new objects are instantiated as well.
There are nineteen callbacks in total, which give a lot of control over how to react and prepare for each state in the Active Record life cycle. The sequence for calling [ActiveRecord::Base#save](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save) for an existing record is similar, except that each `_create` callback is replaced by the corresponding `_update` callback.
Examples:

```
class CreditCard  ActiveRecord::Base

# Strip everything but digits, so the user can specify "555 234 34" or

# "5552-3434" and both will mean "55523434"
  before_validation( :create)
    .number = number.(/[^0-9]/, )  attribute_present?("number")

class Subscription  ActiveRecord::Base
  before_create :record_signup

private
     record_signup
      .signed_up_on = Date.today

class Firm  ActiveRecord::Base

# Disables access to the system, for associated clients and people when the firm is destroyed
  before_destroy { |record| Person.where(firm_id: record.).update_all(access: 'disabled')   }
  before_destroy { |record| Client.where(client_of: record.).update_all(access: 'disabled') }

```

## Inheritable callback queues
Besides the overwritable callback methods, it’s also possible to register callbacks through the use of the callback macros. Their main advantage is that the macros add behavior into a callback queue that is kept intact through an inheritance hierarchy.

```
class Topic  ActiveRecord::Base
  before_destroy :destroy_author

class Reply  Topic
  before_destroy :destroy_readers

When `Topic#destroy` is run only `destroy_author` is called. When `Reply#destroy` is run, both `destroy_author` and `destroy_readers` are called.
**IMPORTANT:** In order for inheritance to work for the callback queues, you must specify the callbacks before specifying the associations. Otherwise, you might trigger the loading of a child before the parent has registered the callbacks and they won’t be inherited.

## Types of callbacks
There are three types of callbacks accepted by the callback macros: method references (symbol), callback objects, inline methods (using a proc). Method references and callback objects are the recommended approaches, inline methods using a proc are sometimes appropriate (such as for creating mix-ins).
The method reference callbacks work by specifying a protected or private method available in the object, like this:

```
class Topic  ActiveRecord::Base
  before_destroy :delete_parents

private
     delete_parents
      .class.delete_by(parent_id: )

The callback objects have methods named after the callback called with the record as the only parameter, such as:

```
class BankAccount  ActiveRecord::Base
  before_save      EncryptionWrapper.
  after_save       EncryptionWrapper.
  after_initialize EncryptionWrapper.

class EncryptionWrapper
   before_save(record)
    record.credit_card_number = encrypt(record.credit_card_number)

after_save(record)
    record.credit_card_number = decrypt(record.credit_card_number)

alias_method :after_initialize, :after_save

private
     encrypt(value)
      # Secrecy is committed

decrypt(value)
      # Secrecy is unveiled

So you specify the object you want to be messaged on a given callback. When that callback is triggered, the object has a method by the name of the callback messaged. You can make these callbacks more flexible by passing in other initialization data such as the name of the attribute to work with:

```
class BankAccount  ActiveRecord::Base
  before_save      EncryptionWrapper.("credit_card_number")
  after_save       EncryptionWrapper.("credit_card_number")
  after_initialize EncryptionWrapper.("credit_card_number")

class EncryptionWrapper
   initialize(attribute)
    @attribute = attribute

before_save(record)
    record.("#{@attribute}=", encrypt(record.("#{@attribute}")))

after_save(record)
    record.("#{@attribute}=", decrypt(record.("#{@attribute}")))

##  `before_validation*` returning statements
If the `before_validation` callback throws `:abort`, the process will be aborted and [ActiveRecord::Base#save](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save) will return `false`. If [ActiveRecord::Base#save!](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21) is called it will raise an [`ActiveRecord::RecordInvalid`](https://api.rubyonrails.org/classes/ActiveRecord/RecordInvalid.html) exception. Nothing will be appended to the errors object.

## Canceling callbacks
If a `before_*` callback throws `:abort`, all the later callbacks and the associated action are cancelled. Callbacks are generally run in the order they are defined, with the exception of callbacks defined as methods on the model, which are called last.

## Ordering callbacks
Sometimes application code requires that callbacks execute in a specific order. For example, a `before_destroy` callback (`log_children` in this case) should be executed before records in the `children` association are destroyed by the `dependent: :destroy` option.
Let’s look at the code below:

```
class Topic  ActiveRecord::Base
  has_many :children, dependent: :destroy

before_destroy :log_children

private
     log_children
      # Child processing

In this case, the problem is that when the `before_destroy` callback is executed, records in the `children` association no longer exist because the [ActiveRecord::Base#destroy](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroy) callback was executed first. You can use the `prepend` option on the `before_destroy` callback to avoid this.

before_destroy :log_children, prepend:

This way, the `before_destroy` is executed before the `dependent: :destroy` is called, and the data is still available.
Also, there are cases when you want several callbacks of the same type to be executed in order.
For example:

```
class Topic  ActiveRecord::Base
  has_many :children

after_save :log_children
  after_save :do_something_else

do_something_else
      # Something else

In this case the `log_children` is executed before `do_something_else`. This applies to all non-transactional callbacks, and to `before_commit`.
For transactional `after_` callbacks (`after_commit`, `after_rollback`, etc), the order can be set via configuration.

```
config.active_record.run_after_transaction_callbacks_in_order_defined = false

When set to `true` (the default from Rails 7.1), callbacks are executed in the order they are defined, just like the example above. When set to `false`, the order is reversed, so `do_something_else` is executed before `log_children`.

## Transactions
The entire callback chain of a [#save](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save), [#save!](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21), or [#destroy](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroy) call runs within a transaction. That includes `after_*` hooks. If everything goes fine a `COMMIT` is executed once the chain has been completed.
If a `before_*` callback cancels the action a `ROLLBACK` is issued. You can also trigger a `ROLLBACK` raising an exception in any of the callbacks, including `after_*` hooks. Note, however, that in that case the client needs to be aware of it because an ordinary [#save](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save) will raise such exception instead of quietly returning `false`.

## Debugging callbacks
The callback chain is accessible via the `_*_callbacks` method on an object. Active Model Callbacks support `:before`, `:after` and `:around` as values for the `kind` property. The `kind` property defines what part of the chain the callback runs in.
To find all callbacks in the `before_save` callback chain:

```
Topic._save_callbacks.select { || .kind.(:before) }

Returns an array of callback objects that form the `before_save` chain.
To further check if the before_save chain contains a proc defined as `rest_when_dead` use the `filter` property of the callback object:

```
Topic._save_callbacks.select { || .kind.(:before) }.collect(:filter).include?(:rest_when_dead)

Returns true or false depending on whether the proc is contained in the `before_save` callback chain on a Topic model.
Namespace
  * MODULE [ActiveRecord::Callbacks::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks/ClassMethods.html)

Included Modules
  * [ ActiveModel::Validations::Callbacks ](https://api.rubyonrails.org/classes/ActiveModel/Validations/Callbacks.html)

## Constants
| CALLBACKS  | =  | [ :after_initialize, :after_find, :after_touch, :before_validation, :after_validation, :before_save, :around_save, :after_save, :before_create, :around_create, :after_create, :before_update, :around_update, :after_update, :before_destroy, :around_destroy, :after_destroy, :after_commit, :after_rollback ]  |
| --- | --- | --- |