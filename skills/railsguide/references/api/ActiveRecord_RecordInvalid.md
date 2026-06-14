# Active Record RecordInvalid
Raised by [ActiveRecord::Base#save!](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21) and [ActiveRecord::Base#create!](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-create-21) when the record is invalid. Use the [`record`](https://api.rubyonrails.org/classes/ActiveRecord/RecordInvalid.html#attribute-i-record) method to retrieve the record which did not validate.

```
begin
  complex_operation_that_internally_calls_save!
rescue ActiveRecord::RecordInvalid => invalid
   invalid.record.errors

```

Methods

N

## Attributes
|  [R]   | record  |
| --- | --- |

## Class Public methods

###  **new**(record = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/RecordInvalid.html#method-c-new)
Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/validations.rb#L18)

# File activerecord/lib/active_record/validations.rb, line 18
def initialize(record = nil)
  if record
    @record = record
    errors = @record.errors.full_messages.join(", ")
    message = I18n.t(:"#{@record.class.i18n_scope}.errors.messages.record_invalid", errors: errors, default: :"errors.messages.record_invalid")
  else
    message = "Record invalid"
  end

super(message)
end
```