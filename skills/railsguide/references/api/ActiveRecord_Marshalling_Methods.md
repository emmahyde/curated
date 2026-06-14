Methods

#

M

## Instance Public methods

###  **_marshal_dump_7_1**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/Marshalling/Methods.html#method-i-_marshal_dump_7_1)
Source: [show](javascript:toggleSource\('method-i-_marshal_dump_7_1_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/marshalling.rb#L24)

```

# File activerecord/lib/active_record/marshalling.rb, line 24
def _marshal_dump_7_1
  payload = [attributes_for_database, new_record?]

cached_associations = self.class.reflect_on_all_associations.select do |reflection|
    if association_cached?(reflection.name)
      association = association(reflection.name)
      association.loaded? || association.target.present?
    end
  end

unless cached_associations.empty?
    payload << cached_associations.map do |reflection|
      [reflection.name, association(reflection.name).target]
    end
  end

payload
end
```

###  **marshal_load**(state) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Marshalling/Methods.html#method-i-marshal_load)
Source: [show](javascript:toggleSource\('method-i-marshal_load_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/marshalling.rb#L43)

# File activerecord/lib/active_record/marshalling.rb, line 43
def marshal_load(state)
  attributes_from_database, new_record, associations = state

attributes = self.class.attributes_builder.build_from_database(attributes_from_database)
  init_with_attributes(attributes, new_record)

if associations
    associations.each do |name, target|
      association(name).target = target
    rescue ActiveRecord::AssociationNotFoundError
      # the association no longer exist, we can just skip it.
    end
  end
end
```