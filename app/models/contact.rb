class Contact
  include ActiveModel::Model
  attr_accessor :name, :email, :subject, :message

  validates :name, :email, :subject, :message, presence: true

  # credit: https://medium.com/@limichelle21/building-and-debugging-a-contact-form-with-rails-mailgun-heroku-c0185b8bf419
end
