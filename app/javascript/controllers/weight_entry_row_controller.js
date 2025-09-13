import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="weight-entry-row"
export default class extends Controller {
  static targets = ["display", "edit"];
  static values = { id: Number };

  connect() {
    console.log("WeightEntryRowController connected for entry", this.idValue);
  }

  edit() {
    this.displayTarget.classList.add("hidden");
    this.editTarget.classList.remove("hidden");
    
    // Focus on the weight input field
    const weightInput = this.editTarget.querySelector('input[name*="weight"]');
    if (weightInput) {
      weightInput.focus();
      weightInput.select();
    }
  }

  cancel() {
    this.editTarget.classList.add("hidden");
    this.displayTarget.classList.remove("hidden");
  }

  // Handle successful form submission
  save() {
    // This will be called after successful turbo frame update
    this.cancel();
  }
}