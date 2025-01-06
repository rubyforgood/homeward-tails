import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tooltip", "hover"];

  showTooltip() {
    this.tooltipTarget.style.display = "block";
    this.tooltipTarget.classList.add("show");
  }

  hideTooltip() {
    this.tooltipTarget.style.display = "none";
    this.tooltipTarget.classList.remove("show");
  }
}
