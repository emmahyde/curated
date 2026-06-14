# Pessimistic Locking
[`Locking::Pessimistic`](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html) provides support for row-level locking using SELECT … FOR UPDATE and other lock types.
Chain `ActiveRecord::Base#find` to [`ActiveRecord::QueryMethods#lock`](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-lock) to obtain an exclusive lock on the selected rows:

```

# select * from accounts where id=1 for update
Account.lock.()

Call `lock('some locking clause')` to use a database-specific locking clause of your own such as ‘LOCK IN SHARE MODE’ or ‘FOR UPDATE NOWAIT’. Example:

```
Account.transaction

# select * from accounts where name = 'shugo' limit 1 for update nowait
  shugo = Account.lock("FOR UPDATE NOWAIT").find_by(name: "shugo")
  yuko = Account.lock("FOR UPDATE NOWAIT").find_by(name: "yuko")
  shugo.balance -=
  shugo.save!
  yuko.balance +=
  yuko.save!

You can also use [`ActiveRecord::Base#lock!`](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html#method-i-lock-21) method to lock one record by id. This may be better if you don’t need to lock every row. Example:

# select * from accounts where ...
  accounts = Account.where(...)
  account1 = accounts.detect { |account| ... }
  account2 = accounts.detect { |account| ... }

# select * from accounts where id=? for update
  account1.lock!
  account2.lock!
  account1.balance -= 100
  account1.save!
  account2.balance += 100
  account2.save!

You can start a transaction and acquire the lock in one go by calling [`with_lock`](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html#method-i-with_lock) with a block. The block is called from within a transaction, the object is already locked. Example:

```
account = Account.first
account.with_lock

# This block is called within a transaction,

# account is already locked.
  account.balance -=
  account.save!

Database-specific information on row locking:

MySQL

[dev.mysql.com/doc/refman/en/innodb-locking-reads.html](https://dev.mysql.com/doc/refman/en/innodb-locking-reads.html)

PostgreSQL

[www.postgresql.org/docs/current/interactive/sql-select.html#SQL-FOR-UPDATE-SHARE](https://www.postgresql.org/docs/current/interactive/sql-select.html#SQL-FOR-UPDATE-SHARE)
Methods

L

W

## Instance Public methods

###  **lock!**(lock = true) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html#method-i-lock-21)
Obtain a row lock on this record. Reloads the record to obtain the requested lock. Pass an SQL locking clause to append the end of the SELECT statement or pass true for “FOR UPDATE” (the default, an exclusive row lock). Returns the locked record.
Source: [show](javascript:toggleSource\('method-i-lock-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/locking/pessimistic.rb#L69)

# File activerecord/lib/active_record/locking/pessimistic.rb, line 69
      def lock!(lock = true)
        if self.class.current_preventing_writes
          raise ActiveRecord::ReadOnlyError, "Lock query attempted while in readonly mode"
        end

if persisted?
          if has_changes_to_save?
            raise(<<-MSG.squish)
              Locking a record with unpersisted changes is not supported. Use
              `save` to persist the changes, or `reload` to discard them
              explicitly.
              Changed attributes: #{changed.map(&:inspect).join(', ')}.
            MSG
          end

reload(lock: lock)
        end

self
      end
```

###  **with_lock**(*args) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html#method-i-with_lock)
Wraps the passed block in a transaction, reloading the object with a lock before yielding. You can pass the SQL locking clause as an optional argument (see [`lock!`](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html#method-i-lock-21)).
You can also pass options like `requires_new:`, `isolation:`, and `joinable:` to the wrapping transaction (see [`ActiveRecord::ConnectionAdapters::DatabaseStatements#transaction`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/DatabaseStatements.html#method-i-transaction)).
Source: [show](javascript:toggleSource\('method-i-with_lock_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/locking/pessimistic.rb#L97)

# File activerecord/lib/active_record/locking/pessimistic.rb, line 97
def with_lock(*args)
  transaction_opts = args.extract_options!
  lock = args.present? ? args.first : true
  transaction(**transaction_opts) do
    lock!(lock)
    yield
  end
end
```