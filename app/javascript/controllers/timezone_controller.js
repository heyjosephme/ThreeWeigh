import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="timezone"
export default class extends Controller {
  connect() {
    this.detectAndSetTimezone();
  }

  detectAndSetTimezone() {
    // Get user's timezone
    const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    console.log("Detected timezone:", timezone);

    // Check if we need to send timezone to server
    const storedTimezone = sessionStorage.getItem('user_timezone');

    if (storedTimezone !== timezone) {
      this.sendTimezoneToServer(timezone);
      sessionStorage.setItem('user_timezone', timezone);
    }
  }

  sendTimezoneToServer(timezone) {
    // Send timezone to Rails via fetch
    fetch('/set_timezone', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ timezone: timezone })
    }).then(response => {
      if (response.ok) {
        console.log("Timezone set successfully:", timezone);
      } else {
        console.error("Failed to set timezone");
      }
    }).catch(error => {
      console.error("Error setting timezone:", error);
    });
  }
}