class FosterMailer < ApplicationMailer
  def new_foster(foster)
    @organization = foster.organization
    @person = foster.person
    @pet = foster.pet

    mail(to: @person.email, subject: "#{@pet.name}'s Foster")
  end
end
