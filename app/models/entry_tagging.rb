class EntryTagging < ApplicationRecord
  belongs_to :tag
  belongs_to :entry
end
