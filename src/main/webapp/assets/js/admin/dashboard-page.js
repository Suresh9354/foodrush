document.addEventListener('DOMContentLoaded', () => {
    // 1. Order Overview Line Chart
    const lineCanvas = document.getElementById('orderOverviewChart');
    if (lineCanvas) {
        const lineCtx = lineCanvas.getContext('2d');
        const labels = JSON.parse(lineCanvas.getAttribute('data-labels') || '[]');
        const values = JSON.parse(lineCanvas.getAttribute('data-values') || '[]');
        
        const orangeGradient = lineCtx.createLinearGradient(0, 0, 0, 200);
        orangeGradient.addColorStop(0, 'rgba(255, 90, 31, 0.25)');
        orangeGradient.addColorStop(1, 'rgba(255, 90, 31, 0.00)');
        
        new Chart(lineCtx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Orders',
                    data: values,
                    borderColor: '#FF5A1F',
                    borderWidth: 3,
                    fill: true,
                    backgroundColor: orangeGradient,
                    tension: 0.4,
                    pointBackgroundColor: '#FF5A1F',
                    pointBorderColor: '#FFFFFF',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { color: '#9CA3AF', font: { family: 'Outfit', size: 10 } }
                    },
                    y: {
                        grid: { color: '#F3F4F6', drawBorder: false },
                        ticks: { color: '#9CA3AF', font: { family: 'Outfit', size: 10 } }
                    }
                }
            }
        });
    }

    // 2. Order Status Donut Chart
    const donutCanvas = document.getElementById('orderStatusChart');
    if (donutCanvas) {
        const donutCtx = donutCanvas.getContext('2d');
        const delivered = parseInt(donutCanvas.getAttribute('data-delivered') || '0', 10);
        const preparing = parseInt(donutCanvas.getAttribute('data-preparing') || '0', 10);
        const delivery = parseInt(donutCanvas.getAttribute('data-delivery') || '0', 10);
        const cancelled = parseInt(donutCanvas.getAttribute('data-cancelled') || '0', 10);

        new Chart(donutCtx, {
            type: 'doughnut',
            data: {
                labels: ['Delivered', 'Preparing', 'Out for Delivery', 'Cancelled'],
                datasets: [{
                    data: [delivered, preparing, delivery, cancelled],
                    backgroundColor: ['#10B981', '#F59E0B', '#3B82F6', '#EF4444'],
                    borderWidth: 3,
                    borderColor: '#FFFFFF',
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '75%',
                plugins: {
                    legend: { display: false }
                }
            }
        });
    }

    // 3. Revenue Overview Bar Chart
    const barCanvas = document.getElementById('revenueOverviewChart');
    if (barCanvas) {
        const barCtx = barCanvas.getContext('2d');
        const labels = JSON.parse(barCanvas.getAttribute('data-labels') || '[]');
        const values = JSON.parse(barCanvas.getAttribute('data-values') || '[]');
        
        const barOrangeGradient = barCtx.createLinearGradient(0, 0, 0, 200);
        barOrangeGradient.addColorStop(0, '#FF5A1F');
        barOrangeGradient.addColorStop(1, '#FF7E40');
        
        new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Revenue',
                    data: values,
                    backgroundColor: barOrangeGradient,
                    borderRadius: 5,
                    borderSkipped: false,
                    barPercentage: 0.5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { color: '#9CA3AF', font: { family: 'Outfit', size: 10 } }
                    },
                    y: {
                        grid: { color: '#F3F4F6', drawBorder: false },
                        ticks: { color: '#9CA3AF', font: { family: 'Outfit', size: 10 } }
                    }
                }
            }
        });
    }
});
