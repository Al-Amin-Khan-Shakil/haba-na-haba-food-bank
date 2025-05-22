import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "filterButton", "clearButton", "submitButton"];

  connect() {
    // Ensure the form is hidden by default when the page loads
    this.formTarget.classList.add("hidden");
    // Remove animation classes on load to prevent unwanted animations
    this.formTarget.classList.remove("animate-grow", "animate-shrink");
  }

  toggleForm() {
    if (this.formTarget.classList.contains("hidden")) {
      // Show the form with grow animation
      this.formTarget.classList.remove("hidden", "animate-shrink");
      this.formTarget.classList.add("animate-grow");
      this.filterButtonTarget.classList.add("hidden");
    } else {
      // Hide the form with shrink animation
      this.formTarget.classList.remove("animate-grow");
      this.formTarget.classList.add("animate-shrink");
      this.filterButtonTarget.classList.remove("hidden");
      // Wait for animation to complete before hiding the form
      this.formTarget.addEventListener(
        "animationend",
        () => {
          this.formTarget.classList.add("hidden");
          this.formTarget.classList.remove("animate-shrink");
        },
        { once: true }
      );
    }
  }

  hideForm() {
    if (!this.formTarget.classList.contains("hidden")) {
      // Hide the form with shrink animation
      this.formTarget.classList.remove("animate-grow");
      this.formTarget.classList.add("animate-shrink");
      this.filterButtonTarget.classList.remove("hidden");
      // Wait for animation to complete before hiding the form
      this.formTarget.addEventListener(
        "animationend",
        () => {
          this.formTarget.classList.add("hidden");
          this.formTarget.classList.remove("animate-shrink");
        },
        { once: true }
      );
    }
  }
}