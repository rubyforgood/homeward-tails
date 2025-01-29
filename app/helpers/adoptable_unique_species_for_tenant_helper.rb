module AdoptableUniqueSpeciesForTenantHelper
  def adoptable_unique_species(organization)
    organization.pets
      .unadopted
      .where(placement_type: ["Adoptable", "Adoptable and Fosterable"])
      .distinct
      .pluck(:species)
  end
end
