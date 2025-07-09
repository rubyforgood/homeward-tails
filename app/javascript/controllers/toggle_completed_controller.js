import { Controller } from "@hotwired/stimulus";

export default class ToggleCompletedController extends Controller {
  static classes = ["show"];

  connect() {
    this.completedTasks = document.querySelectorAll('.task-list .bg-success-subtle');
    this.taskFrames = document.querySelectorAll('.task-list turbo-frame');
    this.emptyState = document.querySelector('.task-list li.only-child-block')
  }

  toggleCompletedTasks() {
    const isChecked = this.element.checked;
    if (isChecked) {
      this.emptyState.classList.remove(this.showClass);
      this.showCompletedTasks();
    } else {
      this.hideCompletedTasks();
      if (this.#requiresEmptyState()) {
        this.emptyState.classList.add(this.showClass);
      }
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

  #requiresEmptyState() {
    if (this.completedTasks.length == this.taskFrames.length) {
      return true;
    } else {
      return false;
    }
  }
}
