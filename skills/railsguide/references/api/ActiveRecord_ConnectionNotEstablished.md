Raised when connection to the database could not been established (for example when [ActiveRecord::Base.lease_connection=](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-lease_connection) is given a `nil` object).
Methods

N

S

## Class Public methods

###  **new**(message = nil, connection_pool: nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionNotEstablished.html#method-c-new)
Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/errors.rb#L67)

```

# File activerecord/lib/active_record/errors.rb, line 67
def initialize(message = nil, connection_pool: nil)
  super(message, connection_pool: connection_pool)
end
```

## Instance Public methods

###  **set_pool**(connection_pool) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionNotEstablished.html#method-i-set_pool)
Source: [show](javascript:toggleSource\('method-i-set_pool_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/errors.rb#L71)

# File activerecord/lib/active_record/errors.rb, line 71
def set_pool(connection_pool)
  unless @connection_pool
    @connection_pool = connection_pool
  end

self
end
```