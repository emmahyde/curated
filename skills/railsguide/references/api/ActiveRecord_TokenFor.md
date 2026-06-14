Namespace
  * MODULE [ActiveRecord::TokenFor::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/TokenFor/ClassMethods.html)
  * MODULE [ActiveRecord::TokenFor::RelationMethods](https://api.rubyonrails.org/classes/ActiveRecord/TokenFor/RelationMethods.html)

Methods

G

## Instance Public methods

###  **generate_token_for**(purpose) [Link](https://api.rubyonrails.org/classes/ActiveRecord/TokenFor.html#method-i-generate_token_for)
Generates a token for a predefined `purpose`.
Use [`ClassMethods#generates_token_for`](https://api.rubyonrails.org/classes/ActiveRecord/TokenFor/ClassMethods.html#method-i-generates_token_for) to define a token purpose and behavior.
Source: [show](javascript:toggleSource\('method-i-generate_token_for_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/token_for.rb#L119)

```

# File activerecord/lib/active_record/token_for.rb, line 119
def generate_token_for(purpose)
  self.class.token_definitions.fetch(purpose).generate_token(self)
end
```