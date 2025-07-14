// app/javascript/controllers/triple_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
    console.log("TripleToggleController connected")
    this.updateDisplay()
  }

  toggle() {
    console.log("Toggle clicked")
    const checkbox = this.checkboxTarget
    const currentValue = checkbox.value

    if (currentValue === "true") {
      checkbox.value = "false"
      checkbox.checked = false
    } else if (currentValue === "false") {
      checkbox.value = "unset"
      checkbox.checked = false
    } else {
      checkbox.value = "true"
      checkbox.checked = true
    }
  }
}