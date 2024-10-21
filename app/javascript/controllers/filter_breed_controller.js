import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["breeds", "species"];

  // Necessary if page is refreshed with a species selected
  connect() {
    this.update();
  }

  update() {
    const speciesNode = this.speciesTarget.selectedOptions[0]
    const speciesValue = speciesNode.value
    const speciesText = speciesNode.innerText

    // If selected value is an empty string, "All" has been selected so display all breeds
    speciesValue == "" ? this._displayAllBreeds() : this._filterBreedsBySpecies(speciesText)
  }

  _filterBreedsBySpecies(species) {
    for (const child of this.breedsTarget.children) {
      // Always display the breed option of "All"
      if (child.nodeName.toLowerCase() == "option") {
        continue;
      }

      // Hide breeds from other species
      if (child.label == species) {
        child.style.display = "block";
      } else {
        child.style.display = "none";
      }
    }
  }

  _displayAllBreeds() {
    for (const child of this.breedsTarget.children) {
      child.style.display = "block";
    }
  }
}
