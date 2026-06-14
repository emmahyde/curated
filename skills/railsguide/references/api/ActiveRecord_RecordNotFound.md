Raised when Active Record cannot find a record by given id or set of ids.
Methods

N

## Attributes
|  [R]   | id  |
| --- | --- |
|  [R]   | model  |
|  [R]   | primary_key  |

## Class Public methods

###  **new**(message = nil, model = nil, primary_key = nil, id = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html#method-c-new)
Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/errors.rb#L138)

```

# File activerecord/lib/active_record/errors.rb, line 138
def initialize(message = nil, model = nil, primary_key = nil, id = nil)
  @primary_key = primary_key
  @model = model
  @id = id

super(message)
end
```