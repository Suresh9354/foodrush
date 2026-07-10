document.addEventListener('DOMContentLoaded', () => {
    // Handle openAdd query param
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('openAdd') === 'true') {
        openModal('add-menu-modal');
    }

    const searchInput = document.getElementById('table-search-input');
    const restaurantFilter = document.getElementById('table-restaurant-filter');
    const categoryFilter = document.getElementById('table-category-filter');
    const statusFilter = document.getElementById('table-status-filter');
    const tableRows = document.querySelectorAll('.admin-table tbody tr:not(#table-empty-state)');
    const emptyState = document.getElementById('table-empty-state');
    const paginationInfo = document.getElementById('pagination-info');
    const paginationButtons = document.getElementById('pagination-buttons');

    let currentPage = 1;
    const pageSize = 8; // Match the 8 items per page from the mockup

    function customFilterTable() {
        const searchText = searchInput ? searchInput.value.toLowerCase().trim() : '';
        const restaurantVal = restaurantFilter ? restaurantFilter.value.toLowerCase().trim() : 'all';
        const categoryVal = categoryFilter ? categoryFilter.value.toLowerCase().trim() : 'all';
        const statusVal = statusFilter ? statusFilter.value.toLowerCase().trim() : 'all';

        let matchingRows = [];

        tableRows.forEach(row => {
            let matchesSearch = true;
            let matchesRestaurant = true;
            let matchesCategory = true;
            let matchesStatus = true;

            // Search matches item name or restaurant name
            if (searchText) {
                const itemName = row.querySelector('.item-cell-title') ? row.querySelector('.item-cell-title').innerText.toLowerCase() : '';
                const restaurantName = row.querySelector('.restaurant-name-cell') ? row.querySelector('.restaurant-name-cell').innerText.toLowerCase() : '';
                matchesSearch = itemName.includes(searchText) || restaurantName.includes(searchText);
            }

            // Restaurant filter
            if (restaurantVal !== 'all') {
                const restaurantName = row.querySelector('.restaurant-name-cell') ? row.querySelector('.restaurant-name-cell').innerText.toLowerCase().trim() : '';
                matchesRestaurant = (restaurantName === restaurantVal);
            }

            // Category filter
            if (categoryVal !== 'all') {
                const categoryCell = row.querySelector('.category-cell');
                if (categoryCell) {
                    const categoryText = categoryCell.innerText.toLowerCase().trim();
                    matchesCategory = (categoryText === categoryVal);
                }
            }

            // Status/Availability filter
            if (statusVal !== 'all') {
                const statusBadge = row.querySelector('.status-badge-item');
                const availabilityBadge = row.querySelector('.availability-badge-item');
                const statusText = statusBadge ? statusBadge.innerText.toLowerCase().trim() : '';
                const availabilityText = availabilityBadge ? availabilityBadge.innerText.toLowerCase().trim() : '';
                
                if (statusVal === 'active' || statusVal === 'inactive') {
                    matchesStatus = (statusText === statusVal);
                } else if (statusVal === 'in stock' || statusVal === 'out of stock') {
                    matchesStatus = (availabilityText === statusVal);
                }
            }

            if (matchesSearch && matchesRestaurant && matchesCategory && matchesStatus) {
                matchingRows.push(row);
            } else {
                row.style.display = 'none';
            }
        });

        // Paginate matching rows
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

        // Display rows for the current page
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

        // Empty state display
        if (emptyState) {
            emptyState.style.display = (totalMatches === 0) ? '' : 'none';
        }

        // Update pagination info label
        if (paginationInfo) {
            if (totalMatches === 0) {
                paginationInfo.innerText = 'Showing 0 to 0 of 0 items';
            } else {
                paginationInfo.innerText = 'Showing ' + (startIndex + 1) + ' to ' + endIndex + ' of ' + totalMatches + ' items';
            }
        }

        // Render pagination control buttons
        if (paginationButtons) {
            paginationButtons.innerHTML = '';

            // Previous Button
            const prevBtn = document.createElement('button');
            prevBtn.className = 'btn';
            prevBtn.style.cssText = 'padding: 6px 10px; background: transparent; border: 1px solid var(--border-color); color: var(--text-color); cursor: pointer; border-radius: var(--radius-sm); display: flex; align-items: center; justify-content: center;';
            prevBtn.innerHTML = '<i class="bi bi-chevron-left" style="font-size: 0.8rem;"></i>';
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
            nextBtn.style.cssText = 'padding: 6px 10px; background: transparent; border: 1px solid var(--border-color); color: var(--text-color); cursor: pointer; border-radius: var(--radius-sm); display: flex; align-items: center; justify-content: center;';
            nextBtn.innerHTML = '<i class="bi bi-chevron-right" style="font-size: 0.8rem;"></i>';
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
    if (restaurantFilter) restaurantFilter.addEventListener('change', () => { currentPage = 1; customFilterTable(); });
    if (categoryFilter) categoryFilter.addEventListener('change', () => { currentPage = 1; customFilterTable(); });
    if (statusFilter) statusFilter.addEventListener('change', () => { currentPage = 1; customFilterTable(); });

    window.resetFilters = function() {
        if (searchInput) searchInput.value = '';
        if (restaurantFilter) restaurantFilter.value = 'all';
        if (categoryFilter) categoryFilter.value = 'all';
        if (statusFilter) statusFilter.value = 'all';
        currentPage = 1;
        customFilterTable();
    };
});
