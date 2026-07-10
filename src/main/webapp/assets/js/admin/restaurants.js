document.addEventListener('DOMContentLoaded', () => {
    // Handle openAdd query param
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('openAdd') === 'true') {
        openModal('add-restaurant-modal');
    }

    const searchInput = document.getElementById('table-search-input');
    const statusFilter = document.getElementById('table-status-filter');
    const cuisineFilter = document.getElementById('table-cuisine-filter');
    const tableRows = document.querySelectorAll('.admin-table tbody tr:not(#table-empty-state)');
    const emptyState = document.getElementById('table-empty-state');
    const paginationInfo = document.getElementById('pagination-info');
    const paginationButtons = document.getElementById('pagination-buttons');

    let currentPage = 1;
    const pageSize = 10;

    function customFilterTable() {
        const searchText = searchInput ? searchInput.value.toLowerCase().trim() : '';
        const statusVal = statusFilter ? statusFilter.value.toLowerCase().trim() : 'all';
        const cuisineVal = cuisineFilter ? cuisineFilter.value.toLowerCase().trim() : 'all';

        let matchingRows = [];

        tableRows.forEach(row => {
            let matchesSearch = true;
            let matchesStatus = true;
            let matchesCuisine = true;

            // Search matches row content
            if (searchText) {
                const text = row.innerText.toLowerCase();
                matchesSearch = text.includes(searchText);
            }

            // Status filter
            if (statusVal !== 'all' && statusVal !== 'select status') {
                const badge = row.querySelector('.status-badge');
                if (badge) {
                    const badgeText = badge.innerText.toLowerCase().trim();
                    matchesStatus = (badgeText === statusVal);
                }
            }

            // Cuisine filter
            if (cuisineVal !== 'all' && cuisineVal !== 'select cuisine') {
                const cuisineCell = row.cells[3]; // Cuisine column
                if (cuisineCell) {
                    const cuisineText = cuisineCell.innerText.toLowerCase().trim();
                    matchesCuisine = cuisineText.includes(cuisineVal);
                }
            }

            if (matchesSearch && matchesStatus && matchesCuisine) {
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
                paginationInfo.innerText = 'Showing 0 to 0 of 0 restaurants';
            } else {
                paginationInfo.innerText = 'Showing ' + (startIndex + 1) + ' to ' + endIndex + ' of ' + totalMatches + ' restaurants';
            }
        }

        // Render pagination control buttons
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
    if (cuisineFilter) cuisineFilter.addEventListener('change', () => { currentPage = 1; customFilterTable(); });

    window.resetFilters = function() {
        if (searchInput) searchInput.value = '';
        if (statusFilter) statusFilter.value = 'all';
        if (cuisineFilter) cuisineFilter.value = 'all';
        currentPage = 1;
        customFilterTable();
    };
});
