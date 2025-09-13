import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="weight-chart"
// lazy import, only import when the controller is used
export default class extends Controller {
  static targets = ["canvas"];
  static values = {
    data: Array,
    labels: Array,
  };

  connect() {
    this.initializeChart();
    console.log("WeightChartController connected");
    console.log(window.Stimulus.application.controllers);
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy();
    }
  }

  initializeChart() {
    const ctx = this.canvasTarget.getContext("2d");

    this.chart = new Chart(ctx, {
      type: "line",
      data: {
        labels: this.labelsValue,
        datasets: [
          {
            label: "Weight (kg)",
            data: this.dataValue,
            borderColor: "rgb(59, 130, 246)",
            backgroundColor: "rgba(59, 130, 246, 0.1)",
            tension: 0.4,
            fill: true,
            pointBackgroundColor: "rgb(59, 130, 246)",
            pointBorderColor: "white",
            pointBorderWidth: 2,
            pointRadius: 6,
            pointHoverRadius: 8,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false,
          },
          tooltip: {
            mode: "index",
            intersect: false,
            backgroundColor: "rgba(0, 0, 0, 0.8)",
            titleColor: "white",
            bodyColor: "white",
            borderColor: "rgb(59, 130, 246)",
            borderWidth: 1,
            cornerRadius: 8,
            displayColors: false,
            callbacks: {
              title: function (tooltipItems) {
                return tooltipItems[0].label;
              },
              label: function (context) {
                return `${context.parsed.y} kg`;
              },
            },
          },
        },
        scales: {
          x: {
            display: true,
            grid: {
              display: false,
            },
            ticks: {
              color: "rgb(107, 114, 128)",
            },
          },
          y: {
            display: true,
            grid: {
              color: "rgba(107, 114, 128, 0.1)",
            },
            ticks: {
              color: "rgb(107, 114, 128)",
              callback: function (value) {
                return value + " kg";
              },
            },
          },
        },
        interaction: {
          mode: "nearest",
          axis: "x",
          intersect: false,
        },
      },
    });
  }

  // Method to update chart data (useful for real-time updates)
  updateChart(newData, newLabels) {
    if (this.chart) {
      this.chart.data.labels = newLabels;
      this.chart.data.datasets[0].data = newData;
      this.chart.update();
    }
  }
}
