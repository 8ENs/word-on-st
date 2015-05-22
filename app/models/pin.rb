class Pin
  include Mongoid::Document
  include Mongoid::Timestamps
  field :message, type: String
  field :location, type: String
  field :recipient, type: String
  field :url, type: String
  belongs_to :user
  
  validates :message, :location, :recipient, presence: true
  validate  :legit_url

  def legit_url
    # don't throw an error unless it's a valid url (regex) OR the url was empty
    unless /^(https?:\/\/[a-zA-Z|\d]{2,}\.[a-zA-Z|\d|\.]{2,})/.match(url) || url == ""
      errors.add(:legit_url, "--- your URL input was not legit! (please try again and include 'http://')")
    end
  end
end