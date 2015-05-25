class Pin
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  include Mongoid::Geospatial
  # include Geocoder::Model::Mongoid

  # field <name>, type: <type>, :default => <value>
  field :message, type: String
  field :coordinates, type: Array
  field :recipient, type: String
  field :url, type: String
  field :loc, type: Point

  # geocoded_by :ip_address, latitude: :lat, longitude: :lon
  # after_validation :geocode

  # index( { location: Mongoid::GEO2D })
  # index( { location: Mongo::GEO2D }, { min: -180, max: 180 })

  belongs_to :user

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>

  validates :message, :recipient, presence: true
  validates :message, length: { maximum: 140 }
  # validate  :legit_url
  validate  :legit_recipient

  def legit_url
    # don't throw an error unless it's a valid url (regex) OR the url was empty
    unless /^(https?:\/\/[a-zA-Z|\d]{2,}\.[a-zA-Z|\d|\.]{2,})/.match(url) || url == ""
      errors.add(:url, "--- your URL input was not legit! (please try again and include 'http://')")
    end
  end

  def legit_recipient
    unless User.find_by(name: recipient).present? || recipient == ""
      errors.add(:recipient, "--- you must select a valid recipient (please see link below for full list)")
    end
  end

  def ip_address
    request[:REMOTE_ADDR]
  end
end
