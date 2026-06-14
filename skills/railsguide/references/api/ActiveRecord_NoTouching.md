# Active Record No Touching
Namespace
  * MODULE [ActiveRecord::NoTouching::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/NoTouching/ClassMethods.html)

Methods

N

## Instance Public methods

###  **no_touching?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/NoTouching.html#method-i-no_touching-3F)
Returns `true` if the class has [no_touching](https://api.rubyonrails.org/files/activerecord/lib/active_record/no_touching_rb.html) set, `false` otherwise.

```
Project.no_touching
  Project.first.no_touching? # true
  Message.first.no_touching? # false

```

Source: [show](javascript:toggleSource\('method-i-no_touching-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/no_touching.rb#L53)

# File activerecord/lib/active_record/no_touching.rb, line 53
def no_touching?
  NoTouching.applied_to?(self.class)
end
```