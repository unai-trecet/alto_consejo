import flatpickr from "flatpickr";

flatpickr("#match_start_at", {
        enableTime: true,
        dateFormat: "F, d Y H:i"
    });

flatpickr("#match_end_at", {
    enableTime: true,
    dateFormat: "F, d Y H:i"
});
