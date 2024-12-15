import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  static targets = ["country", "state"];

  updateStates() {
    const path = this.countryTarget.dataset.path;

    const params = new URLSearchParams({
      country: this.countryTarget.value,
      target: this.stateTarget.id,
      name: this.stateTarget.name,
    });

    get(`${path}?${params}`, { responseKind: "turbo-stream" });
  }

  connect() {
    if (this.countryTarget.value) {
      this.updateStates();
    }
  }
}