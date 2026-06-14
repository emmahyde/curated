# Active Record Validations
Active Record includes the majority of its validations from [`ActiveModel::Validations`](https://api.rubyonrails.org/classes/ActiveModel/Validations.html).
In Active Record, all validations are performed on save by default. [`Validations`](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) accept the `:on` argument to define the context where the validations are active. Active Record will pass either the context of `:create` or `:update` depending on whether the model is a [new_record?](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-new_record-3F).
Namespace
  * MODULE [ActiveRecord::Validations::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Validations/ClassMethods.html)

Methods

S

V

## Instance Public methods

###  **save**(**options) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html#method-i-save)
The validation process on save can be skipped by passing `validate: false`. The validation context can be changed by passing `context: context`. The regular [ActiveRecord::Base#save](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save) method is replaced with this when the validations module is mixed in, which it is by default.
Source: [show](javascript:toggleSource\('method-i-save_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/validations.rb#L47)

```

# File activerecord/lib/active_record/validations.rb, line 47
def save(**options)
  perform_validations(options) ? super : false
end
```

###  **save!**(**options) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html#method-i-save-21)
Attempts to save the record just like [ActiveRecord::Base#save](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html#method-i-save) but will raise an [`ActiveRecord::RecordInvalid`](https://api.rubyonrails.org/classes/ActiveRecord/RecordInvalid.html) exception instead of returning `false` if the record is not valid.
Source: [show](javascript:toggleSource\('method-i-save-21_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/validations.rb#L53)

# File activerecord/lib/active_record/validations.rb, line 53
def save!(**options)
  perform_validations(options) ? super : raise_validation_error
end
```

###  **valid?**(context = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html#method-i-valid-3F)
Runs all the validations within the specified context. Returns `true` if no errors are found, `false` otherwise.
Aliased as [`validate`](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html#method-i-validate).
If the argument is `false` (default is `nil`), the context is set to `:create` if [new_record?](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-new_record-3F) is `true`, and to `:update` if it is not. If the argument is an array of contexts, `post.valid?([:create, :update])`, the validations are run within multiple contexts.
Validations with no `:on` option will run no matter the context. Validations with some `:on` option will only run in the specified context.
Also aliased as: [validate](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html#method-i-validate)
Source: [show](javascript:toggleSource\('method-i-valid-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/validations.rb#L69)

# File activerecord/lib/active_record/validations.rb, line 69
def valid?(context = nil)
  context ||= default_validation_context
  output = super(context)
  errors.empty?  output
end
```

###  **validate**(context = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html#method-i-validate)
Alias for: [valid?](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html#method-i-valid-3F)