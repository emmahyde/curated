Superclass for all database execution errors.
Wraps the underlying database error as `cause`.
Methods

N

S

## Attributes
|  [R]   | binds  |
| --- | --- |
|  [R]   | sql  |

## Class Public methods

###  **new**(message = nil, sql: nil, binds: nil, connection_pool: nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/StatementInvalid.html#method-c-new)
Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/errors.rb#L204)

```

# File activerecord/lib/active_record/errors.rb, line 204
def initialize(message = nil, sql: nil, binds: nil, connection_pool: nil)
  super(message || $!&.message, connection_pool: connection_pool)
  @sql = sql
  @binds = binds
end
```

## Instance Public methods

###  **set_query**(sql, binds) [Link](https://api.rubyonrails.org/classes/ActiveRecord/StatementInvalid.html#method-i-set_query)
Source: [show](javascript:toggleSource\('method-i-set_query_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/errors.rb#L212)

# File activerecord/lib/active_record/errors.rb, line 212
def set_query(sql, binds)
  unless @sql
    @sql = sql
    @binds = binds
  end

self
end
```