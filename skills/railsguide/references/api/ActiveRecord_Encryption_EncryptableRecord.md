This is the concern mixed in Active Record models to make them encryptable. It adds the `encrypts` attribute declaration, as well as the API to encrypt and decrypt records.
Methods

A

* add_length_validation_for_encrypted_columns

C

D

* deterministic_encrypted_attributes

E

G

* global_previous_schemes_for

O

* override_accessors_to_preserve_original

P

* preserve_original_encrypted

S

* source_attribute_from_preserved_attribute

V

## Constants
| ORIGINAL_ATTRIBUTE_PREFIX  | =  | "original_"  |
| --- | --- | --- |

## Instance Public methods

###  **add_length_validation_for_encrypted_columns**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-add_length_validation_for_encrypted_columns)
Source: [show](javascript:toggleSource\('method-i-add_length_validation_for_encrypted_columns_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L132)

```

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 132
def add_length_validation_for_encrypted_columns
  encrypted_attributes&.each do |attribute_name|
    validate_column_size attribute_name
  end
end
```

###  **ciphertext_for**(attribute_name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-ciphertext_for)
Returns the ciphertext for `attribute_name`.
Source: [show](javascript:toggleSource\('method-i-ciphertext_for_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L157)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 157
def ciphertext_for(attribute_name)
  if encrypted_attribute?(attribute_name)
    read_attribute_before_type_cast(attribute_name)
  else
    read_attribute_for_database(attribute_name)
  end
end
```

###  **decrypt**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-decrypt)
Decrypts all the encryptable attributes and saves the changes.
Source: [show](javascript:toggleSource\('method-i-decrypt_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L171)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 171
def decrypt
  decrypt_attributes if has_encrypted_attributes?
end
```

###  **deterministic_encrypted_attributes**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-deterministic_encrypted_attributes)
Returns the list of deterministic encryptable attributes in the model class.
Source: [show](javascript:toggleSource\('method-i-deterministic_encrypted_attributes_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L58)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 58
def deterministic_encrypted_attributes
  @deterministic_encrypted_attributes ||= encrypted_attributes&.find_all do |attribute_name|
    type_for_attribute(attribute_name).deterministic?
  end
end
```

###  **encrypt**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-encrypt)
Encrypts all the encryptable attributes and saves the changes.
Source: [show](javascript:toggleSource\('method-i-encrypt_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L166)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 166
def encrypt
  encrypt_attributes if has_encrypted_attributes?
end
```

###  **encrypt_attribute**(name, key_provider: nil, key: nil, deterministic: false, support_unencrypted_data: nil, downcase: false, ignore_case: false, previous: [], compress: true, compressor: nil, **context_properties) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-encrypt_attribute)
Source: [show](javascript:toggleSource\('method-i-encrypt_attribute_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L84)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 84
def encrypt_attribute(name, key_provider: nil, key: nil, deterministic: false, support_unencrypted_data: nil, downcase: false, ignore_case: false, previous: [], compress: true, compressor: nil, **context_properties)
  encrypted_attributes << name.to_sym

decorate_attributes([name]) do |name, cast_type|
    scheme = scheme_for key_provider: key_provider, key: key, deterministic: deterministic, support_unencrypted_data: support_unencrypted_data, \
      downcase: downcase, ignore_case: ignore_case, previous: previous, compress: compress, compressor: compressor, **context_properties

ActiveRecord::Encryption::EncryptedAttributeType.new(scheme: scheme, cast_type: cast_type, default: columns_hash[name.to_s]&.default)
  end

preserve_original_encrypted(name) if ignore_case
  ActiveRecord::Encryption.encrypted_attribute_was_declared(self, name)
end
```

###  **encrypted_attribute?**(attribute_name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-encrypted_attribute-3F)
Returns whether a given attribute is encrypted or not.
Source: [show](javascript:toggleSource\('method-i-encrypted_attribute-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L146)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 146
def encrypted_attribute?(attribute_name)
  name = attribute_name.to_s
  name = self.class.attribute_aliases[name] || name

return false unless self.class.encrypted_attributes&.include? name.to_sym

type = type_for_attribute(name)
  type.encrypted? read_attribute_before_type_cast(name)
end
```

###  **encrypts**(*names, key_provider: nil, key: nil, deterministic: false, support_unencrypted_data: nil, downcase: false, ignore_case: false, previous: [], compress: true, compressor: nil, **context_properties) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-encrypts)
Encrypts the `name` attribute.

#### Options
  * `:key_provider` - A key provider to provide encryption and decryption keys. Defaults to `ActiveRecord::Encryption.key_provider`.
  * `:key` - A password to derive the key from. It’s a shorthand for a `:key_provider` that serves derivated keys. Both options can’t be used at the same time.
  * `:deterministic` - By default, encryption is not deterministic. It will use a random initialization vector for each encryption operation. This means that encrypting the same content with the same key twice will generate different ciphertexts. When set to `true`, it will generate the initialization vector based on the encrypted content. This means that the same content will generate the same ciphertexts. This enables querying encrypted text with Active Record. Deterministic encryption will use the oldest encryption scheme to encrypt new data by default. You can change this by setting `deterministic: { fixed: false }`. That will make it use the newest encryption scheme for encrypting new data.
  * `:support_unencrypted_data` - When true, unencrypted data can be read normally. When false, it will raise errors. Falls back to `config.active_record.encryption.support_unencrypted_data` if no value is provided. This is useful for scenarios where you encrypt one column, and want to disable support for unencrypted data without having to tweak the global setting.
  * `:downcase` - When true, it converts the encrypted content to downcase automatically. This allows to effectively ignore case when querying data. Notice that the case is lost. Use `:ignore_case` if you are interested in preserving it.
  * `:ignore_case` - When true, it behaves like `:downcase` but, it also preserves the original case in a specially designated column +original_<name>+. When reading the encrypted content, the version with the original case is served. But you can still execute queries that will ignore the case. This option can only be used when `:deterministic` is true.
  * `:context_properties` - Additional properties that will override [`Context`](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/Context.html) settings when this attribute is encrypted and decrypted. E.g: `encryptor:`, `cipher:`, `message_serializer:`, etc.
  * `:previous` - List of previous encryption schemes. When provided, they will be used in order when trying to read the attribute. Each entry of the list can contain the properties supported by [`encrypts`](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-encrypts). Also, when deterministic encryption is used, they will be used to generate additional ciphertexts to check in the queries.

Source: [show](javascript:toggleSource\('method-i-encrypts_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L49)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 49
def encrypts(*names, key_provider: nil, key: nil, deterministic: false, support_unencrypted_data: nil, downcase: false, ignore_case: false, previous: [], compress: true, compressor: nil, **context_properties)
  self.encrypted_attributes ||= Set.new # not using :default because the instance would be shared across classes

names.each do |name|
    encrypt_attribute name, key_provider: key_provider, key: key, deterministic: deterministic, support_unencrypted_data: support_unencrypted_data, downcase: downcase, ignore_case: ignore_case, previous: previous, compress: compress, compressor: compressor, **context_properties
  end
end
```

###  **global_previous_schemes_for**(scheme) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-global_previous_schemes_for)
Source: [show](javascript:toggleSource\('method-i-global_previous_schemes_for_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L78)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 78
def global_previous_schemes_for(scheme)
  ActiveRecord::Encryption.config.previous_schemes.filter_map do |previous_scheme|
    scheme.merge(previous_scheme) if scheme.compatible_with?(previous_scheme)
  end
end
```

###  **override_accessors_to_preserve_original**(name, original_attribute_name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-override_accessors_to_preserve_original)
Source: [show](javascript:toggleSource\('method-i-override_accessors_to_preserve_original_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L109)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 109
def override_accessors_to_preserve_original(name, original_attribute_name)
  include(Module.new do
    define_method name do
      if ((value = super())  encrypted_attribute?(name)) || !ActiveRecord::Encryption.config.support_unencrypted_data
        send(original_attribute_name)
      else
        value
      end
    end

define_method "#{name}=" do |value|
      self.send "#{original_attribute_name}=", value
      super(value)
    end
  end)
end
```

###  **preserve_original_encrypted**(name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-preserve_original_encrypted)
Source: [show](javascript:toggleSource\('method-i-preserve_original_encrypted_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L98)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 98
def preserve_original_encrypted(name)
  original_attribute_name = "#{ORIGINAL_ATTRIBUTE_PREFIX}#{name}".to_sym

if !ActiveRecord::Encryption.config.support_unencrypted_data  !column_names.include?(original_attribute_name.to_s)
    raise Errors::Configuration, "To use :ignore_case for '#{name}' you must create an additional column named '#{original_attribute_name}'"
  end

encrypts original_attribute_name
  override_accessors_to_preserve_original name, original_attribute_name
end
```

###  **scheme_for**(key_provider: nil, key: nil, deterministic: false, support_unencrypted_data: nil, downcase: false, ignore_case: false, previous: [], **context_properties) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-scheme_for)
Source: [show](javascript:toggleSource\('method-i-scheme_for_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L70)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 70
def scheme_for(key_provider: nil, key: nil, deterministic: false, support_unencrypted_data: nil, downcase: false, ignore_case: false, previous: [], **context_properties)
  ActiveRecord::Encryption::Scheme.new(key_provider: key_provider, key: key, deterministic: deterministic,
    support_unencrypted_data: support_unencrypted_data, downcase: downcase, ignore_case: ignore_case, **context_properties).tap do |scheme|
    scheme.previous_schemes = global_previous_schemes_for(scheme) +
    Array.wrap(previous).collect { |scheme_config| ActiveRecord::Encryption::Scheme.new(**scheme_config) }
  end
end
```

###  **source_attribute_from_preserved_attribute**(attribute_name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-source_attribute_from_preserved_attribute)
Given a attribute name, it returns the name of the source attribute when it’s a preserved one.
Source: [show](javascript:toggleSource\('method-i-source_attribute_from_preserved_attribute_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L65)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 65
def source_attribute_from_preserved_attribute(attribute_name)
  attribute_name.to_s.sub(ORIGINAL_ATTRIBUTE_PREFIX, "") if attribute_name.start_with?(ORIGINAL_ATTRIBUTE_PREFIX)
end
```

###  **validate_column_size**(attribute_name) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html#method-i-validate_column_size)
Source: [show](javascript:toggleSource\('method-i-validate_column_size_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/encryption/encryptable_record.rb#L138)

# File activerecord/lib/active_record/encryption/encryptable_record.rb, line 138
def validate_column_size(attribute_name)
  if limit = columns_hash[attribute_name.to_s]&.limit
    validates_length_of attribute_name, maximum: limit
  end
end
```