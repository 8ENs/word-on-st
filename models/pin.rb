class Pin
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>
  field :message, :type => String
  field :location, :type => String
  field :recipient, :type => String, default: 'Public'
  field :url, :type => String
  belongs_to :user

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>

  validates :message, :location, :recipient, presence: true
  validate  :legit_url

  def legit_url
    # don't throw an error unless it's a valid url (regex) OR the url was empty
    unless /^(https?:\/\/[a-zA-Z|\d]{2,}\.[a-zA-Z|\d|\.]{2,})/.match(url) || url == ""
      errors.add(:legit_url, "--- your URL input was not legit! (please try again and include 'http://')")
    end
  end
end
