class Book < ApplicationRecord
  belongs_to :author

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :search_query,
      :with_author_id,
      :with_release_date
    ]
  )
  
  scope :sorted_by, ->(sort_option) {
    direction = sort_option =~ /desc$/ ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("Books.created_at_ #{direction}")
    when /^name_/
      order("Books.name #{direction}")
    when /^created_at_/
      order("Books.release_date #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }
  
  scope :search_query, ->(query) {
    return nil if query.blank?
    terms = query.downcase.split(/\s+/)
    terms = terms.map { |e|
      ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 1
    where(
      terms.map { |term|
        "(LOWER(Books.name) LIKE ?"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :with_name, ->(name) {
    where('name = ?', name)
  }

  scope :with_author_id, ->(author_ids) {
    where(author_id: [*author_ids])
  }

  scope :with_release_date, ->(date) {
    where(release_date: date)
  }
  
  def self.options_for_sorted_by(sort_option = nil)
    [
      ['Book (A-Z)', 'name_asc'],
      ['Book (Z-A)', 'name_desc'],
      ['Created date (Newest first)', 'created_at_desc'],
      ['Created date (Oldest first)', 'created_at_asc']
    ]
  end
end
