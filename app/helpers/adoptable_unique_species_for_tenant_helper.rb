module AdoptableUniqueSpeciesForTenantHelper
  def adoptable_unique_species(organization)
    organization.pets.adoptable_unique_species
  end
end
