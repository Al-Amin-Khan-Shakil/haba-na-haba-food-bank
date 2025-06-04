// app/javascript/controllers/user_dropdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button", "hiddenInput", "selectedUser"]

  connect() {
    this.closeOnOutsideClick = this.closeOnOutsideClick.bind(this)
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
    if (!this.menuTarget.classList.contains("hidden")) {
      document.addEventListener("click", this.closeOnOutsideClick)
    } else {
      document.removeEventListener("click", this.closeOnOutsideClick)
    }
  }

  select(event) {
    const item = event.currentTarget
    const userId = item.dataset.userId
    const userName = item.dataset.userName
    this.selectedUserTarget.textContent = userName
    this.hiddenInputTarget.value = userId
    this.menuTarget.classList.add("hidden")
    document.removeEventListener("click", this.closeOnOutsideClick)
  }

  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
      document.removeEventListener("click", this.closeOnOutsideClick)
    }
  }
}
