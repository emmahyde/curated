# Active Record Transactions
Transactions are protective blocks where SQL statements are only permanent if they can all succeed as one atomic action. The classic example is a transfer between two accounts where you can only have a deposit if the withdrawal succeeded and vice versa. Transactions enforce the integrity of the database and guard the data against program errors or database break-downs. So basically you should use transaction blocks whenever you have a number of statements that must be executed together or not at all.
For example:

```
ActiveRecord::Base.transaction
  david.withdrawal()
  mary.deposit()

```

This example will only take money from David and give it to Mary if neither `withdrawal` nor `deposit` raise an exception. Exceptions will force a ROLLBACK that returns the database to the state before the transaction began. Be aware, though, that the objects will _not_ have their instance data returned to their pre-transactional state.

## Different Active Record classes in a single transaction
Though the [`transaction`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-transaction) class method is called on some Active Record class, the objects within the transaction block need not all be instances of that class. This is because transactions are per-database connection, not per-model.
In this example a `balance` record is transactionally saved even though [`transaction`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-transaction) is called on the `Account` class:

```
Account.transaction
  balance.save!
  account.save!

The [`transaction`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-transaction) method is also available as a model instance method. For example, you can also do this:

```
balance.transaction
  balance.save!
  account.save!

##  [`Transactions`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions.html) are not distributed across database connections
A transaction acts on a single database connection. If you have multiple class-specific databases, the transaction will not protect interaction among them. One workaround is to begin a transaction on each class whose models you alter:

```
Student.transaction
  Course.transaction
    course.enroll(student)
    student.units += course.units

This is a poor solution, but fully distributed transactions are beyond the scope of Active Record.

##  `save` and `destroy` are automatically wrapped in a transaction
Both [#save](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save) and [#destroy](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-destroy) come wrapped in a transaction that ensures that whatever you do in validations or callbacks will happen under its protected cover. So you can use validations to check for values that the transaction depends on or you can raise exceptions in the callbacks to rollback, including `after_*` callbacks.
As a consequence changes to the database are not seen outside your connection until the operation is complete. For example, if you try to update the index of a search engine in `after_save` the indexer won’t see the updated record. The [`after_commit`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_commit) callback is the only one that is triggered once the update is committed. See below.

##  [`Exception`](https://api.rubyonrails.org/classes/Exception.html) handling and rolling back
Also have in mind that exceptions thrown within a transaction block will be propagated (after triggering the ROLLBACK), so you should be ready to catch those in your application code.
One exception is the [`ActiveRecord::Rollback`](https://api.rubyonrails.org/classes/ActiveRecord/Rollback.html) exception, which will trigger a ROLLBACK when raised, but not be re-raised by the transaction block. Any other exception will be re-raised.
**Warning** : one should not catch [`ActiveRecord::StatementInvalid`](https://api.rubyonrails.org/classes/ActiveRecord/StatementInvalid.html) exceptions inside a transaction block. [`ActiveRecord::StatementInvalid`](https://api.rubyonrails.org/classes/ActiveRecord/StatementInvalid.html) exceptions indicate that an error occurred at the database level, for example when a unique constraint is violated. On some database systems, such as PostgreSQL, database errors inside a transaction cause the entire transaction to become unusable until it’s restarted from the beginning. Here is an example which demonstrates the problem:

# Suppose that we have a Number model with a unique column called 'i'.
Number.transaction
  Number.create( )
  begin
    # This will raise a unique constraint error...
    Number.create( )
  rescue ActiveRecord::StatementInvalid
    # ...which we ignore.

# On PostgreSQL, the transaction is now unusable. The following

# statement will cause a PostgreSQL error, even though the unique

# constraint is no longer violated:
  Number.create( )

# => "PG::Error: ERROR:  current transaction is aborted, commands

#     ignored until end of transaction block"

One should restart the entire transaction if an [`ActiveRecord::StatementInvalid`](https://api.rubyonrails.org/classes/ActiveRecord/StatementInvalid.html) occurred.

## Nested transactions
[`transaction`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-transaction) calls can be nested. By default, this makes all database statements in the nested transaction block become part of the parent transaction. For example, the following behavior may be surprising:

```
User.transaction
  User.create(username: 'Kotori')
  User.transaction
    User.create(username: 'Nemu')
    raise ActiveRecord::Rollback

creates both “Kotori” and “Nemu”. Reason is the [`ActiveRecord::Rollback`](https://api.rubyonrails.org/classes/ActiveRecord/Rollback.html) exception in the nested block does not issue a ROLLBACK. Since these exceptions are captured in transaction blocks, the parent block does not see it and the real transaction is committed.
In order to get a ROLLBACK for the nested transaction you may ask for a real sub-transaction by passing `requires_new: true`. If anything goes wrong, the database rolls back to the beginning of the sub-transaction without rolling back the parent transaction. If we add it to the previous example:

```
User.transaction
  User.create(username: 'Kotori')
  User.transaction(requires_new: )
    User.create(username: 'Nemu')
    raise ActiveRecord::Rollback

only “Kotori” is created.
Most databases don’t support true nested transactions. At the time of writing, the only database that we’re aware of that supports true nested transactions, is MS-SQL. Because of this, Active Record emulates nested transactions by using savepoints. See [dev.mysql.com/doc/refman/en/savepoint.html](https://dev.mysql.com/doc/refman/en/savepoint.html) for more information about savepoints.

### Callbacks
There are two types of callbacks associated with committing and rolling back transactions: [`after_commit`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_commit) and [`after_rollback`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_rollback).
[`after_commit`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_commit) callbacks are called on every record saved or destroyed within a transaction immediately after the transaction is committed. [`after_rollback`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_rollback) callbacks are called on every record saved or destroyed within a transaction immediately after the transaction or savepoint is rolled back.
These callbacks are useful for interacting with other systems since you will be guaranteed that the callback is only executed when the database is in a permanent state. For example, [`after_commit`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_commit) is a good spot to put in a hook to clearing a cache since clearing it from within a transaction could trigger the cache to be regenerated before the database is updated.

#### NOTE: [`Callbacks`](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) are deduplicated per callback by filter.
Trying to define multiple callbacks with the same filter will result in a single callback being run.
For example:

```
after_commit :do_something
after_commit :do_something # only the last one will be called

This applies to all variations of `after_*_commit` callbacks as well.

```
after_commit :do_something
after_create_commit :do_something
after_save_commit :do_something

It is recommended to use the `on:` option to specify when the callback should be run.

```
after_commit :do_something,  [:create, :update]

This is equivalent to using [`after_create_commit`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_create_commit) and [`after_update_commit`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_update_commit), but will not be deduplicated.

### Caveats
If you’re on MySQL, then do not use Data Definition Language (DDL) operations in nested transactions blocks that are emulated with savepoints. That is, do not execute statements like ‘CREATE TABLE’ inside such blocks. This is because MySQL automatically releases all savepoints upon executing a DDL operation. When `transaction` is finished and tries to release the savepoint it created earlier, a database error will occur because the savepoint has already been automatically released. The following example demonstrates the problem:

```
Model.transaction                            # BEGIN
  Model.transaction(requires_new: true)      # CREATE SAVEPOINT active_record_1
    Model.lease_connection.create_table(...)   # active_record_1 now automatically released
                                            # RELEASE SAVEPOINT active_record_1
                                            # ^^^^ BOOM! database error!
```

Note that “TRUNCATE” is also a MySQL DDL statement!
Methods

A

C

P

* pool_transaction_isolation_level

S

T

W

* with_pool_transaction_isolation_level

## Instance Public methods

###  **after_commit**(*args, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_commit)
This callback is called after a record has been created, updated, or destroyed.
You can specify that the callback should only be fired by a certain action with the `:on` option:

```
after_commit :do_foo,  :create
after_commit :do_bar,  :update
after_commit :do_baz,  :destroy

after_commit :do_foo_bar,  [:create, :update]
after_commit :do_bar_baz,  [:update, :destroy]

Source: [show](javascript:toggleSource\('method-i-after_commit_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/transactions.rb#L285)

# File activerecord/lib/active_record/transactions.rb, line 285
def after_commit(*args, block)
  set_options_for_callbacks!(args, prepend_option)
  set_callback(:commit, :after, *args, block)
end
```

###  **after_create_commit**(*args, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_create_commit)
Shortcut for `after_commit :hook, on: :create`.
Source: [show](javascript:toggleSource\('method-i-after_create_commit_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/transactions.rb#L297)

# File activerecord/lib/active_record/transactions.rb, line 297
def after_create_commit(*args, block)
  set_options_for_callbacks!(args, on: :create, **prepend_option)
  set_callback(:commit, :after, *args, block)
end
```

###  **after_destroy_commit**(*args, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_destroy_commit)
Shortcut for `after_commit :hook, on: :destroy`.
Source: [show](javascript:toggleSource\('method-i-after_destroy_commit_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/transactions.rb#L309)

# File activerecord/lib/active_record/transactions.rb, line 309
def after_destroy_commit(*args, block)
  set_options_for_callbacks!(args, on: :destroy, **prepend_option)
  set_callback(:commit, :after, *args, block)
end
```

###  **after_rollback**(*args, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_rollback)
This callback is called after a create, update, or destroy are rolled back.
Please check the documentation of [`after_commit`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_commit) for options.
Source: [show](javascript:toggleSource\('method-i-after_rollback_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/transactions.rb#L317)

# File activerecord/lib/active_record/transactions.rb, line 317
def after_rollback(*args, block)
  set_options_for_callbacks!(args, prepend_option)
  set_callback(:rollback, :after, *args, block)
end
```

###  **after_save_commit**(*args, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_save_commit)
Shortcut for `after_commit :hook, on: [ :create, :update ]`.
Source: [show](javascript:toggleSource\('method-i-after_save_commit_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/transactions.rb#L291)

# File activerecord/lib/active_record/transactions.rb, line 291
def after_save_commit(*args, block)
  set_options_for_callbacks!(args, on: [ :create, :update ], **prepend_option)
  set_callback(:commit, :after, *args, block)
end
```

###  **after_update_commit**(*args, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_update_commit)
Shortcut for `after_commit :hook, on: :update`.
Source: [show](javascript:toggleSource\('method-i-after_update_commit_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/transactions.rb#L303)

# File activerecord/lib/active_record/transactions.rb, line 303
def after_update_commit(*args, block)
  set_options_for_callbacks!(args, on: :update, **prepend_option)
  set_callback(:commit, :after, *args, block)
end
```

###  **current_transaction**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-current_transaction)
Returns a representation of the current transaction state, which can be a top level transaction, a savepoint, or the absence of a transaction.
An object is always returned, whether or not a transaction is currently active. To check if a transaction was opened, use `current_transaction.open?`.
See the [`ActiveRecord::Transaction`](https://api.rubyonrails.org/classes/ActiveRecord/Transaction.html) documentation for detailed behavior.
Source: [show](javascript:toggleSource\('method-i-current_transaction_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/transactions.rb#L264)

# File activerecord/lib/active_record/transactions.rb, line 264
def current_transaction
  connection_pool.active_connection&.current_transaction&.user_transaction || Transaction::NULL_TRANSACTION
end
```

###  **pool_transaction_isolation_level**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-pool_transaction_isolation_level)
Returns the default isolation level for the connection pool, set earlier by [`with_pool_transaction_isolation_level`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-with_pool_transaction_isolation_level).
Source: [show](javascript:toggleSource\('method-i-pool_transaction_isolation_level_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/transactions.rb#L253)

# File activerecord/lib/active_record/transactions.rb, line 253
def pool_transaction_isolation_level
  connection_pool.pool_transaction_isolation_level
end
```

###  **set_callback**(name, *filter_list, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-set_callback)
Similar to [`ActiveSupport::Callbacks::ClassMethods#set_callback`](https://api.rubyonrails.org/classes/ActiveSupport/Callbacks/ClassMethods.html#method-i-set_callback), but with support for options available on [`after_commit`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_commit) and [`after_rollback`](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-after_rollback) callbacks.
Source: [show](javascript:toggleSource\('method-i-set_callback_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/transactions.rb#L324)

# File activerecord/lib/active_record/transactions.rb, line 324
def set_callback(name, *filter_list, block)
  options = filter_list.extract_options!
  filter_list << options

if name.in?([:commit, :rollback])  options[:on]
    fire_on = Array(options[:on])
    assert_valid_transaction_action(fire_on)
    options[:if] = [
      -> { transaction_include_any_action?(fire_on) },
      *options[:if]
    ]
  end

super(name, *filter_list, block)
end
```

###  **transaction**(**options, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-transaction)
See the [`ConnectionAdapters::DatabaseStatements#transaction`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/DatabaseStatements.html#method-i-transaction) API docs.
Source: [show](javascript:toggleSource\('method-i-transaction_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/transactions.rb#L231)

# File activerecord/lib/active_record/transactions.rb, line 231
def transaction(**options, block)
  with_connection do |connection|
    connection.pool.with_pool_transaction_isolation_level(ActiveRecord.default_transaction_isolation_level, connection.transaction_open?) do
      connection.transaction(**options, block)
    end
  end
end
```

###  **with_pool_transaction_isolation_level**(isolation_level, &block) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html#method-i-with_pool_transaction_isolation_level)
Makes all transactions the current pool use the isolation level initiated within the block.
Source: [show](javascript:toggleSource\('method-i-with_pool_transaction_isolation_level_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/transactions.rb#L240)

# File activerecord/lib/active_record/transactions.rb, line 240
def with_pool_transaction_isolation_level(isolation_level, block)
  if current_transaction.open?
    raise ActiveRecord::TransactionIsolationError, "cannot set default isolation level while transaction is open"
  end

old_level = connection_pool.pool_transaction_isolation_level
  connection_pool.pool_transaction_isolation_level = isolation_level
  yield
ensure
  connection_pool.pool_transaction_isolation_level = old_level
end
```