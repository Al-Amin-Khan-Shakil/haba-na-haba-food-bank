import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 30000 }
  }

  connect() {
    setTimeout(() => {
      this.element.classList.add("opacity-0", "transition-opacity", "duration-1000")
      setTimeout(() => this.element.remove(), 1000)
    }, this.delayValue)
  }
}
