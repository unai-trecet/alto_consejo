// app/javascript/controllers/charts.js

import { Controller } from "@hotwired/stimulus"
import { Chart } from 'chart.js';

export default class extends Controller {
  playedMatchesChartInstance = null;
  organizedMatchesChartInstance = null;

  connect() {
    // console.log("Charts controller connected!")
    this.updateUserPlayedMatches();
    this.updateUserOrganizedMatches();
  }

  updateUserPlayedMatches(event) {
    const selectedValue = event ? event.target.value : 'default_value';
  
    fetch(`/graphs/user_played_matches?from_date=${selectedValue}`, {
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
      const canvas = document.getElementById('user_played_matches_chart');

      // Destroy the existing chart if there is one
      if (this.playedMatchesChartInstance) {
        this.playedMatchesChartInstance.destroy();
      }
  
      // Create a new chart on the canvas
      this.playedMatchesChartInstance = new Chart(canvas, {
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

  updateUserOrganizedMatches(event) {
    console.log("updateUserOrganizedMatches");
    const selectedValue = event ? event.target.value : 'default_value';
  
    fetch(`/graphs/user_organized_matches?from_date=${selectedValue}`, {
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
      const canvas = document.getElementById('user_organized_matches_chart');

      // Destroy the existing chart if there is one
      if (this.organizedMatchesChartInstance) {
        this.organizedMatchesChartInstance.destroy();
      }
  
      // Create a new chart on the canvas
      this.organizedMatchesChartInstance = new Chart(canvas, {
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