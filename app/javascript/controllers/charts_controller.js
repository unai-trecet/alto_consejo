// app/javascript/controllers/charts.js

import { Controller } from "@hotwired/stimulus"
import { Chart } from 'chart.js';

export default class extends Controller {
  chartInstances = {};

  connect() {
    console.log("Charts controller connected!")
    this.updateChart(null, 'user_played_matches', 'user_played_matches_chart');
    this.updateChart(null, 'user_organized_matches', 'user_organized_matches_chart');
  }

  updateChart(event, defaultEndpoint, defaultCanvasId) {
    let selectedValue, endpoint, canvasId;
  
    if (event) {
      selectedValue = event.target.value;
      endpoint = event.target.dataset.chartsEndpoint;
      canvasId = event.target.dataset.chartsCanvasId;
    } else {
      selectedValue = 'default_value';
      endpoint = defaultEndpoint;
      canvasId = defaultCanvasId;
    }
  
    fetch(`/graphs/${endpoint}?from_date=${selectedValue}`, {
      headers: { accept: "application/json" }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    })
    .then(data => {
      // Transform the data into the format expected by Chart.js
      const labels = Object.keys(data);
      const datasetData = Object.values(data);
      const transformedData = {
        labels: labels,
        datasets: [{
          label: 'Played Matches',
          data: datasetData,
          fill: false,
          borderColor: 'rgb(0, 0, 255)',
          tension: 0.1
        }]
      };
  
      // Get the canvas from the DOM
      const canvas = document.getElementById(canvasId);

      // Destroy the existing chart if there is one
      if (this.chartInstances[canvasId]) {
        this.chartInstances[canvasId].destroy();
      }
  
      // Create a new chart on the canvas
      this.chartInstances[canvasId] = new Chart(canvas, {
        type: 'line',
        data: transformedData,
        options: {
          scales: {
            y: {
              ticks: {
                callback: function(value, index, values) {
                  return Number.isInteger(value) ? value : null;
                }
              }
            }
          }
        } // add your chart options here
      });
    })
    .catch(error => console.log('There was an error:', error));
  }  
}