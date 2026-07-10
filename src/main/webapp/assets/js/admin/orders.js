document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('table-search-input');
    const statusFilter = document.getElementById('table-status-filter');
    const restaurantFilter = document.getElementById('table-restaurant-filter');
    const dateFilter = document.getElementById('table-date-filter');
    const tableRows = document.querySelectorAll('.admin-table tbody tr:not(#table-empty-state)');
    const emptyState = document.getElementById('table-empty-state');
    const paginationInfo = document.getElementById('pagination-info');
    const paginationButtons = document.getElementById('pagination-buttons');

    let currentPage = 1;
    const pageSize = 10;

    function customFilterTable() {
        const searchText = searchInput ? searchInput.value.toLowerCase().trim() : '';
        const statusVal = statusFilter ? statusFilter.value.toLowerCase().trim() : 'all';
        const restVal = restaurantFilter ? restaurantFilter.value.toLowerCase().trim() : 'all';
        const dateVal = dateFilter ? dateFilter.value.toLowerCase().trim() : 'all';

        // 1. Identify which rows match the filters
        let matchingRows = [];

        tableRows.forEach(row => {
            let matchesSearch = true;
            let matchesStatus = true;
            let matchesRestaurant = true;
            let matchesDate = true;

            // Search matches text in row
            if (searchText) {
                const text = row.innerText.toLowerCase();
                matchesSearch = text.includes(searchText);
            }

            // Status filter matching
            if (statusVal !== 'all' && statusVal !== 'select status') {
                const statusBadge = row.querySelector('.status-badge');
                if (statusBadge) {
                    const badgeText = statusBadge.innerText.toLowerCase().trim().replace(/_/g, ' ');
                    const filterText = statusVal.replace(/_/g, ' ');
                    matchesStatus = (badgeText === filterText);
                }
            }

            // Restaurant filter matching
            if (restVal !== 'all') {
                const restCell = row.querySelector('.restaurant-cell');
                if (restCell) {
                    const restText = restCell.innerText.toLowerCase().trim();
                    matchesRestaurant = restText.includes(restVal);
                }
            }

            if (matchesSearch && matchesStatus && matchesRestaurant && matchesDate) {
                matchingRows.push(row);
            } else {
                row.style.display = 'none';
            }
        });

        // 2. Paginate the matching rows
        const totalMatches = matchingRows.length;
        const totalPages = Math.ceil(totalMatches / pageSize) || 1;

        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }

        const startIndex = (currentPage - 1) * pageSize;
        const endIndex = Math.min(startIndex + pageSize, totalMatches);

        // Display only the rows for the current page
        tableRows.forEach(row => {
            if (matchingRows.includes(row)) {
                const idx = matchingRows.indexOf(row);
                if (idx >= startIndex && idx < endIndex) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            }
        });

        // Update empty state
        if (emptyState) {
            emptyState.style.display = (totalMatches === 0) ? '' : 'none';
        }

        // 3. Update pagination details
        if (paginationInfo) {
            if (totalMatches === 0) {
                paginationInfo.innerText = 'Showing 0 to 0 of 0 orders';
            } else {
                paginationInfo.innerText = 'Showing ' + (startIndex + 1) + ' to ' + endIndex + ' of ' + totalMatches + ' orders';
            }
        }

        // 4. Render pagination buttons
        if (paginationButtons) {
            paginationButtons.innerHTML = '';

            // Previous Button
            const prevBtn = document.createElement('button');
            prevBtn.className = 'btn';
            prevBtn.style.cssText = 'padding: 6px 10px; background: transparent; border: 1px solid var(--border-color); color: var(--text-color); cursor: pointer;';
            prevBtn.innerHTML = '<i class="bi bi-chevron-left"></i>';
            if (currentPage === 1) {
                prevBtn.disabled = true;
                prevBtn.style.opacity = '0.5';
                prevBtn.style.cursor = 'default';
            } else {
                prevBtn.addEventListener('click', () => {
                    currentPage--;
                    customFilterTable();
                });
            }
            paginationButtons.appendChild(prevBtn);

            // Page Number Buttons
            for (let i = 1; i <= totalPages; i++) {
                const pageBtn = document.createElement('button');
                pageBtn.className = 'btn';
                pageBtn.innerText = i;
                if (i === currentPage) {
                    pageBtn.style.cssText = 'padding: 6px 12px; background: #FF5A1F; border: 1px solid #FF5A1F; color: #FFFFFF; font-weight: 600; cursor: default; border-radius: var(--radius-sm);';
                } else {
                    pageBtn.style.cssText = 'padding: 6px 12px; background: var(--card-bg); border: 1px solid var(--border-color); color: var(--text-color); cursor: pointer; border-radius: var(--radius-sm);';
                    pageBtn.addEventListener('click', () => {
                        currentPage = i;
                        customFilterTable();
                    });
                }
                paginationButtons.appendChild(pageBtn);
            }

            // Next Button
            const nextBtn = document.createElement('button');
            nextBtn.className = 'btn';
            nextBtn.style.cssText = 'padding: 6px 10px; background: transparent; border: 1px solid var(--border-color); color: var(--text-color); cursor: pointer;';
            nextBtn.innerHTML = '<i class="bi bi-chevron-right"></i>';
            if (currentPage === totalPages) {
                nextBtn.disabled = true;
                nextBtn.style.opacity = '0.5';
                nextBtn.style.cursor = 'default';
            } else {
                nextBtn.addEventListener('click', () => {
                    currentPage++;
                    customFilterTable();
                });
            }
            paginationButtons.appendChild(nextBtn);
        }
    }

    // Initialize Filter & Pagination
    customFilterTable();

    if (searchInput) searchInput.addEventListener('input', () => { currentPage = 1; customFilterTable(); });
    if (statusFilter) statusFilter.addEventListener('change', () => { currentPage = 1; customFilterTable(); });
    if (restaurantFilter) restaurantFilter.addEventListener('change', () => { currentPage = 1; customFilterTable(); });
    if (dateFilter) dateFilter.addEventListener('change', () => { currentPage = 1; customFilterTable(); });

    window.resetFilters = function() {
        if (searchInput) searchInput.value = '';
        if (statusFilter) statusFilter.value = 'all';
        if (restaurantFilter) restaurantFilter.value = 'all';
        if (dateFilter) dateFilter.value = 'all';
        currentPage = 1;
        customFilterTable();
    };

    window.exportOrders = function() {
        alert('Exporting list to CSV...');
    };
});
