Raised when there are multiple errors while doing a mass assignment through the [ActiveRecord::Base#attributes=](https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html#method-i-attributes-3D) method. The exception has an `errors` property that contains an array of [`AttributeAssignmentError`](https://api.rubyonrails.org/classes/ActiveRecord/AttributeAssignmentError.html) objects, each corresponding to the error while assigning to an attribute.
Methods

N

## Attributes
|  [R]   | errors  |
| --- | --- |

## Class Public methods

###  **new**(errors = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/MultiparameterAssignmentErrors.html#method-c-new)
Source: [show](javascript:toggleSource\('method-c-new_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/errors.rb#L473)

```

# File activerecord/lib/active_record/errors.rb, line 473
def initialize(errors = nil)
  @errors = errors
end
```