class AdoptionMailer < ApplicationMailer
  def new_adoption(match)
    person = match.person
    @pet = match.pet

    mail(to: person.email, subject: "#{@pet.name}'s Adoption")
  end
end
