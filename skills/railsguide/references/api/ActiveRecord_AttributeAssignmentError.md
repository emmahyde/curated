Raised when an error occurred while doing a mass assignment to an attribute through the [ActiveRecord::Base#attributes=](https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html#method-i-attributes-3D) method. The exception has an `attribute` property that is the name of the offending attribute.
Methods

N

## Attributes
|  [R]   | attribute  |
| --- | --- |
|  [R]   | exception  |

## Class Public methods

###  **new**(message = nil, exception = nil, attribute = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AttributeAssignmentError.html#method-c-new)
Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/errors.rb#L459)

```

# File activerecord/lib/active_record/errors.rb, line 459
def initialize(message = nil, exception = nil, attribute = nil)
  super(message)
  @exception = exception
  @attribute = attribute
end
```