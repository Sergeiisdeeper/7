document.addEventListener("DOMContentLoaded", () => {
    function updateClock() {
        const timeZones = {
            "Kyiv": "Europe/Kyiv",
            "Toronto": "America/Toronto",
            "San Francisco": "America/Los_Angeles",
            "Harvard": "America/New_York"
        };

        const clockContainer = document.getElementById("clock-container");
        clockContainer.innerHTML = ""; // Clear previous clock data

        for (const [city, timeZone] of Object.entries(timeZones)) {
            const now = new Date().toLocaleString("en-US", { timeZone: timeZone });
            const timeElement = document.createElement("div");
            timeElement.innerHTML = `<strong>${city}:</strong> ${now}`;
            clockContainer.appendChild(timeElement);
        }
    }

    setInterval(updateClock, 1000);
    updateClock();
});
