import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    console.log("✅ autocomplete controller connected for field:", this.inputTarget.dataset.field)
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)

    const query = this.inputTarget.value
    const field = this.inputTarget.dataset.field

    if (query.length < 2) {
      this.resultsTarget.innerHTML = ""
      return
    }

    this.timeout = setTimeout(() => {
      fetch(`/autocomplete?query=${encodeURIComponent(query)}&field=${field}`)
        .then(response => response.json())
        .then(data => {
          this.resultsTarget.innerHTML = `
            <div class="list-group">
              ${data.map(item =>
                `<button type="button" class="list-group-item list-group-item-action"
                  data-action="click->autocomplete#select"
                  data-value="${item}">${item}</button>`
              ).join("")}
            </div>
          `
        })
    }, 300)
  }

  select(event) {
    this.inputTarget.value = event.target.dataset.value
    this.resultsTarget.innerHTML = ""
  }
}
