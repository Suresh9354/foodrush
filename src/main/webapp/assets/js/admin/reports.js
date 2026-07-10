function resetFilters() {
    document.getElementById('report-date-filter').value = 'week';
    document.getElementById('report-restaurant-filter').value = 'all';
    document.getElementById('report-category-filter').value = 'all';
    document.getElementById('report-payment-filter').value = 'all';
}

function exportReport() {
    const reportEl = document.getElementById('report-data');
    if (!reportEl) return;

    const totalRevenue = reportEl.getAttribute('data-total-revenue');
    const totalOrders = reportEl.getAttribute('data-total-orders');
    const avgOrderValue = reportEl.getAttribute('data-avg-order-value');
    const activeUsers = reportEl.getAttribute('data-active-users');
    const cancelledOrders = reportEl.getAttribute('data-cancelled-orders');
    const topRestaurants = JSON.parse(reportEl.getAttribute('data-top-restaurants') || '[]');
    const categorySales = JSON.parse(reportEl.getAttribute('data-category-sales') || '[]');

    let csv = [];
    csv.push("FoodRush Reports & Analytics Export");
    csv.push("Generated On," + new Date().toLocaleString());
    csv.push("");
    
    // Stats
    csv.push("Metric,Value");
    csv.push("Total Revenue,₹" + totalRevenue);
    csv.push("Total Orders," + totalOrders);
    csv.push("Average Order Value,₹" + avgOrderValue);
    csv.push("Total Customers," + activeUsers);
    csv.push("Cancelled Orders," + cancelledOrders);
    csv.push("");

    // Top Restaurants
    csv.push("Restaurant Revenue Breakdown");
    csv.push("Rank,Restaurant,Revenue");
    topRestaurants.forEach((rMap, idx) => {
        csv.push((idx + 1) + ",\"" + rMap.name + "\",₹" + rMap.revenue);
    });
    csv.push("");

    // Category breakdown
    csv.push("Category Sales Breakdown");
    csv.push("Category,Orders Count,Revenue");
    categorySales.forEach(cMap => {
        csv.push("\"" + cMap.category + "\"," + cMap.count + ",₹" + cMap.revenue);
    });

    const csvFile = new Blob([csv.join("\n")], {type: "text/csv"});
    const downloadLink = document.createElement("a");
    downloadLink.download = "foodrush-reports-analytics.csv";
    downloadLink.href = window.URL.createObjectURL(csvFile);
    downloadLink.style.display = "none";
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);
}
