# Active Model Translation
Provides integration between your object and the Rails internationalization (i18n) framework.
A minimal implementation could be:

```
class TranslatedPerson
  extend ActiveModel::Translation

TranslatedPerson.human_attribute_name('my_attribute')

# => "My attribute"

```

This also provides the required class methods for hooking into the Rails internationalization [`API`](https://api.rubyonrails.org/classes/ActiveModel/API.html), including being able to define a class-based [`i18n_scope`](https://api.rubyonrails.org/classes/ActiveModel/Translation.html#method-i-i18n_scope) and [`lookup_ancestors`](https://api.rubyonrails.org/classes/ActiveModel/Translation.html#method-i-lookup_ancestors) to find translations in parent classes.
Methods

H

I

L

Included Modules

## Attributes
|  [RW]   | raise_on_missing_translations  |
| --- | --- |

## Instance Public methods

###  **human_attribute_name**(attribute, options = {}) [Link](https://api.rubyonrails.org/classes/ActiveModel/Translation.html#method-i-human_attribute_name)
Transforms attribute names into a more human format, such as “First name” instead of “first_name”.

```
Person.human_attribute_name("first_name") # => "First name"

Specify `options` with additional translating options.
Source: [show](javascript:toggleSource\('method-i-human_attribute_name_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/translation.rb#L48)

# File activemodel/lib/active_model/translation.rb, line 48
def human_attribute_name(attribute, options = {})
  attribute = attribute.to_s

if attribute.include?(".")
    namespace, _, attribute = attribute.rpartition(".")
    namespace.tr!(".", "/")

if attribute.present?
      key = "#{namespace}.#{attribute}"
      separator = "/"
    else
      key = namespace
      separator = "."
    end

defaults = lookup_ancestors.map do |klass|
      :"#{i18n_scope}.attributes.#{klass.model_name.i18n_key}#{separator}#{key}"
    end
    defaults << :"#{i18n_scope}.attributes.#{key}"
    defaults << :"attributes.#{key}"
  else
    defaults = lookup_ancestors.map do |klass|
      :"#{i18n_scope}.attributes.#{klass.model_name.i18n_key}.#{attribute}"
    end
  end

raise_on_missing = options.fetch(:raise, Translation.raise_on_missing_translations)

defaults << :"attributes.#{attribute}"
  defaults << options[:default] if options[:default]
  defaults << MISSING_TRANSLATION unless raise_on_missing

translation = I18n.translate(defaults.shift, count: 1, raise: raise_on_missing, **options, default: defaults)
  if translation == MISSING_TRANSLATION
    translation = attribute.present? ? attribute.humanize : namespace.humanize
  end
  translation
end
```

###  **i18n_scope**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Translation.html#method-i-i18n_scope)
Returns the [`i18n_scope`](https://api.rubyonrails.org/classes/ActiveModel/Translation.html#method-i-i18n_scope) for the class. Override if you want custom lookup.
Source: [show](javascript:toggleSource\('method-i-i18n_scope_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/translation.rb#L28)

# File activemodel/lib/active_model/translation.rb, line 28
def i18n_scope
  :activemodel
end
```

###  **lookup_ancestors**() [Link](https://api.rubyonrails.org/classes/ActiveModel/Translation.html#method-i-lookup_ancestors)
When localizing a string, it goes through the lookup returned by this method, which is used in [`ActiveModel::Name#human`](https://api.rubyonrails.org/classes/ActiveModel/Name.html#method-i-human), [`ActiveModel::Errors#full_messages`](https://api.rubyonrails.org/classes/ActiveModel/Errors.html#method-i-full_messages) and [`ActiveModel::Translation#human_attribute_name`](https://api.rubyonrails.org/classes/ActiveModel/Translation.html#method-i-human_attribute_name).
Source: [show](javascript:toggleSource\('method-i-lookup_ancestors_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/translation.rb#L36)

# File activemodel/lib/active_model/translation.rb, line 36
def lookup_ancestors
  ancestors.select { |x| x.respond_to?(:model_name) }
end
```