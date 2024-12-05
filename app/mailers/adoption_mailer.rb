class AdoptionMailer < ApplicationMailer
  def new_adoption(match)
    @organization = match.organization
    @person = match.person
    @pet = match.pet

    mail(to: @person.email, subject: "No reply: #{@pet.name}'s Adoption")
  end
end
