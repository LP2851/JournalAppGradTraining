class Entry < ApplicationRecord
  has_many :entry_taggings
  has_many :tags, through: :entry_taggings

  def self.tagged_with(name)
    Tag.find_by!(name: name).entries
  end

  def tag_list_s
    tags.map(&:name).sort.join(',')
  end

  def tag_list_a
    tags.map(&:name).sort
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
end
