# Active Record Signed Id
Namespace
  * MODULE [ActiveRecord::SignedId::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/SignedId/ClassMethods.html)
  * MODULE [ActiveRecord::SignedId::DeprecateSignedIdVerifierSecret](https://api.rubyonrails.org/classes/ActiveRecord/SignedId/DeprecateSignedIdVerifierSecret.html)

Methods

S

* signed_id_verifier_secret

## Class Public methods

###  **signed_id_verifier_secret** [Link](https://api.rubyonrails.org/classes/ActiveRecord/SignedId.html#method-c-signed_id_verifier_secret)
Set the secret used for the signed id verifier instance when using Active Record outside of Rails. Within Rails, this is automatically set using the Rails application key generator.
Source: [show](javascript:toggleSource\('method-c-signed_id_verifier_secret_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/signed_id.rb#L15)

```

# File activerecord/lib/active_record/signed_id.rb, line 15
class_attribute :signed_id_verifier_secret, instance_writer: false

## Instance Public methods

###  **signed_id**(expires_in: nil, expires_at: nil, purpose: nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/SignedId.html#method-i-signed_id)
Returns a signed id that’s generated using a preconfigured [`ActiveSupport::MessageVerifier`](https://api.rubyonrails.org/classes/ActiveSupport/MessageVerifier.html) instance.
This signed id is tamper proof, so it’s safe to send in an email or otherwise share with the outside world. However, as with any message signed with a [`ActiveSupport::MessageVerifier`](https://api.rubyonrails.org/classes/ActiveSupport/MessageVerifier.html), [the signed id is not encrypted](https://api.rubyonrails.org/classes/ActiveSupport/MessageVerifier.html#class-ActiveSupport::MessageVerifier-label-Signing+is+not+encryption). It’s just encoded and protected against tampering.
This means that the ID can be decoded by anyone; however, if tampered with (so to point to a different ID), the cryptographic signature will no longer match, and the signed id will be considered invalid and return nil when passed to `find_signed` (or raise with `find_signed!`).
It can furthermore be set to expire (the default is not to expire), and scoped down with a specific purpose. If the expiration date has been exceeded before `find_signed` is called, the id won’t find the designated record. If a purpose is set, this too must match.
If you accidentally let a signed id out in the wild that you wish to retract sooner than its expiration date (or maybe you forgot to set an expiration date while meaning to!), you can use the purpose to essentially version the [`signed_id`](https://api.rubyonrails.org/classes/ActiveRecord/SignedId.html#method-i-signed_id), like so:

```
user.signed_id purpose:

And you then change your `find_signed` calls to require this new purpose. Any old signed ids that were not created with the purpose will no longer find the record.
Source: [show](javascript:toggleSource\('method-i-signed_id_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/signed_id.rb#L160)

# File activerecord/lib/active_record/signed_id.rb, line 160
def signed_id(expires_in: nil, expires_at: nil, purpose: nil)
  raise ArgumentError, "Cannot get a signed_id for a new record" if new_record?

self.class.signed_id_verifier.generate id, expires_in: expires_in, expires_at: expires_at, purpose: self.class.combine_signed_id_purposes(purpose)
end
```