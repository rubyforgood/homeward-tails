class AdoptionMailer < ApplicationMailer
  def new_adoption(match)
    person = match.person
    @pet = match.pet

    mail( from: Rails.application.config.from_email,
          to: person.email,
          subject: "#{@pet.name}'s Adoption" )
  end
end
