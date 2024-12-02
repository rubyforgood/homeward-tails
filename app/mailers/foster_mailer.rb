class FosterMailer < ApplicationMailer
  def new_foster(foster)
    person = foster.person
    @pet = foster.pet

    mail(from: Rails.application.config.from_email,
      to: person.email,
      subject: "#{@pet.name}'s Foster")
  end
end
