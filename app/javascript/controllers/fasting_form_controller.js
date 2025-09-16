import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="fasting-form"
export default class extends Controller {
  static targets = ["startTime", "presets"];

  connect() {
    console.log("FastingFormController connected");
  }

  setTime(event) {
    const timeString = event.target.dataset.time;
    if (timeString && this.hasStartTimeTarget) {
      this.startTimeTarget.value = timeString;
      this.highlightButton(event.target);
    }
  }

  setNow(event) {
    const now = new Date();
    // Format as datetime-local string: YYYY-MM-DDTHH:MM
    const timeString = now.getFullYear() + '-' +
                      String(now.getMonth() + 1).padStart(2, '0') + '-' +
                      String(now.getDate()).padStart(2, '0') + 'T' +
                      String(now.getHours()).padStart(2, '0') + ':' +
                      String(now.getMinutes()).padStart(2, '0');

    if (this.hasStartTimeTarget) {
      this.startTimeTarget.value = timeString;
      this.highlightButton(event.target);
    }
  }

  highlightButton(clickedButton) {
    // Remove highlight from all preset buttons
    if (this.hasPresetsTarget) {
      const buttons = this.presetsTarget.querySelectorAll('button');
      buttons.forEach(button => {
        button.classList.remove('ring-2', 'ring-blue-500', 'bg-blue-100', 'bg-green-100');
        if (button.classList.contains('text-blue-700')) {
          button.classList.add('bg-blue-50');
        } else if (button.classList.contains('text-green-700')) {
          button.classList.add('bg-green-50');
        }
      });
    }

    // Highlight the clicked button
    clickedButton.classList.add('ring-2');
    if (clickedButton.classList.contains('text-blue-700')) {
      clickedButton.classList.remove('bg-blue-50');
      clickedButton.classList.add('bg-blue-100', 'ring-blue-500');
    } else if (clickedButton.classList.contains('text-green-700')) {
      clickedButton.classList.remove('bg-green-50');
      clickedButton.classList.add('bg-green-100', 'ring-blue-500');
    }
  }
}