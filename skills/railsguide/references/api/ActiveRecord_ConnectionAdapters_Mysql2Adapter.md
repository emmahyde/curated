# Active Record MySQL2 Adapter
Methods

A

C

D

E

N

S

* savepoint_errors_invalidate_transactions?,
  * supports_comments_in_create?,
  * supports_lazy_transactions?,

Included Modules
  * [ ActiveRecord::ConnectionAdapters::Mysql2::DatabaseStatements ](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2/DatabaseStatements.html)

## Constants
| ADAPTER_NAME  | =  | "Mysql2"  |
| --- | --- | --- |
| ER_ACCESS_DENIED_ERROR  | =  | 1045  |
| ER_BAD_DB_ERROR  | =  | 1049  |
| ER_CONN_HOST_ERROR  | =  | 2003  |
| ER_DBACCESS_DENIED_ERROR  | =  | 1044  |
| ER_UNKNOWN_HOST_ERROR  | =  | 2005  |
| ER_UNKNOWN_STMT_HANDLER  | =  | 1243  |
| TYPE_MAP  | =  | Type::TypeMap.new.tap { |m| initialize_type_map(m) }  |

## Class Public methods

###  **new**(...) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-c-new)
Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L56)

```

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 56
def initialize(...)
  super

@affected_rows_before_warnings = nil
  @config[:flags] ||= 0

if @config[:flags].kind_of? Array
    @config[:flags].push "FOUND_ROWS"
  else
    @config[:flags] |= ::Mysql2::Client::FOUND_ROWS
  end

@connection_parameters ||= @config
end
```

###  **new_client**(config) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-c-new_client)
Source: [show](javascript:toggleSource\('method-c-new_client_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L25)

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 25
def new_client(config)
  ::Mysql2::Client.new(config)
rescue ::Mysql2::Error => error
  case error.error_number
  when ER_BAD_DB_ERROR
    raise ActiveRecord::NoDatabaseError.db_error(config[:database])
  when ER_DBACCESS_DENIED_ERROR, ER_ACCESS_DENIED_ERROR
    raise ActiveRecord::DatabaseConnectionError.username_error(config[:username])
  when ER_CONN_HOST_ERROR, ER_UNKNOWN_HOST_ERROR
    raise ActiveRecord::DatabaseConnectionError.hostname_error(config[:host])
  else
    raise ActiveRecord::ConnectionNotEstablished, error.message
  end
end
```

## Instance Public methods

###  **active?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-i-active-3F)
Source: [show](javascript:toggleSource\('method-i-active-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L107)

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 107
def active?
  if connected?
    @lock.synchronize do
      if @raw_connection&.ping
        verified!
        true
      end
    end
  end || false
end
```

###  **connected?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-i-connected-3F)
Source: [show](javascript:toggleSource\('method-i-connected-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L103)

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 103
def connected?
  !(@raw_connection.nil? || @raw_connection.closed?)
end
```

###  **disconnect!**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-i-disconnect-21)
Disconnects from the database if already connected. Otherwise, this method does nothing.
Source: [show](javascript:toggleSource\('method-i-disconnect-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L122)

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 122
def disconnect!
  @lock.synchronize do
    super
    @raw_connection&.close
    @raw_connection = nil
  end
end
```

###  **error_number**(exception) [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-i-error_number)
Source: [show](javascript:toggleSource\('method-i-error_number_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L95)

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 95
def error_number(exception)
  exception.error_number if exception.respond_to?(:error_number)
end
```

###  **savepoint_errors_invalidate_transactions?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-i-savepoint_errors_invalidate_transactions-3F)
Source: [show](javascript:toggleSource\('method-i-savepoint_errors_invalidate_transactions-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L87)

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 87
def savepoint_errors_invalidate_transactions?
  true
end
```

###  **supports_comments?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-i-supports_comments-3F)
Source: [show](javascript:toggleSource\('method-i-supports_comments-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L75)

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 75
def supports_comments?
  true
end
```

###  **supports_comments_in_create?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-i-supports_comments_in_create-3F)
Source: [show](javascript:toggleSource\('method-i-supports_comments_in_create-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L79)

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 79
def supports_comments_in_create?
  true
end
```

###  **supports_json?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-i-supports_json-3F)
Source: [show](javascript:toggleSource\('method-i-supports_json-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L71)

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 71
def supports_json?
  !mariadb?  database_version >= "5.7.8"
end
```

###  **supports_lazy_transactions?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-i-supports_lazy_transactions-3F)
Source: [show](javascript:toggleSource\('method-i-supports_lazy_transactions-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L91)

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 91
def supports_lazy_transactions?
  true
end
```

###  **supports_savepoints?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Mysql2Adapter.html#method-i-supports_savepoints-3F)
Source: [show](javascript:toggleSource\('method-i-supports_savepoints-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb#L83)

# File activerecord/lib/active_record/connection_adapters/mysql2_adapter.rb, line 83
def supports_savepoints?
  true
end
```