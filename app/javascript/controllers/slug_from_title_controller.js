import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['title', 'slug']

  updateSlug() {
    const titleInput = this.titleTarget
    const slugInput = this.slugTarget

    slugInput.value = this.slugFromTitle(titleInput.value)
  }

  slugFromTitle(title) {
    return title
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, ' ')
      .trim()
      .replace(/\s+/g, '-')
  }
}

