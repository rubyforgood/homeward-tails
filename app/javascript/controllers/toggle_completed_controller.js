import { Controller } from "@hotwired/stimulus";

export default class ToggleCompletedController extends Controller {
  connect() {
    this.completedTasks = document.querySelectorAll('.bg-success-subtle');
    this.hideCompletedTasks();
  }

  toggleCompletedTasks() {
    const isChecked = this.element.checked;
    if (isChecked) {
      this.showCompletedTasks();
    } else {
      this.hideCompletedTasks();
    }
  }

  hideCompletedTasks() {
    this.completedTasks.forEach((item) => {
      item.classList.add('d-none');
    });
  }

  showCompletedTasks() {
    this.completedTasks.forEach((item) => {
      item.classList.remove('d-none');
    });
  }
}
