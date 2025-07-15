import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { type: String }
  static targets = ["title"]

  connect() {
    
    if (this.hasTitleTarget) {
      this.updateForm()
    }
  }

  switch(event) {
    const type = event.currentTarget.dataset.formType
    this.typeValue = type
    this.updateForm()
  }

  updateForm() {
    if (!this.hasTitleTarget) return

    if (this.typeValue === "donate") {
      
      this.titleTarget.textContent = "Donate Food"
    } else if (this.typeValue === "request") {
      this.titleTarget.textContent = "Request Food"
    }
  }
}
