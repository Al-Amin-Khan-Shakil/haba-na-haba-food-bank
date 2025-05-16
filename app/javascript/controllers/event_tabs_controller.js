import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "content"]

  connect() {
    if (this.hasButtonTarget) {
      this.showTab(this.buttonTargets[0])
    }
  }

  switch(event) {
    event.preventDefault()
    this.showTab(event.currentTarget)
  }

  showTab(button) {
    this.contentTargets.forEach(content => {
      content.classList.add('hidden')
    })

    this.buttonTargets.forEach(btn => {
      btn.classList.remove(
        'border-blue-500',
        'text-blue-600'
      )
      btn.classList.add(
        'border-transparent',
        'text-gray-500',
        'hover:text-gray-700',
        'hover:border-gray-300'
      )
    })

    const tabId = button.dataset.tab
    if (tabId) {
      const content = this.element.querySelector(tabId)
      if (content) {
        content.classList.remove('hidden')
        button.classList.add('border-blue-500', 'text-blue-600')
        button.classList.remove(
          'border-transparent',
          'text-gray-500',
          'hover:text-gray-700',
          'hover:border-gray-300'
        )
      }
    }
  }
}