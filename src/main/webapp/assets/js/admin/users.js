document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('table-search-input');
    const roleFilter = document.getElementById('table-role-filter');
    const statusFilter = document.getElementById('table-status-filter');
    const tableRows = document.querySelectorAll('.admin-table tbody tr:not(#table-empty-state)');
    const emptyState = document.getElementById('table-empty-state');
    const paginationInfo = document.getElementById('pagination-info');
    const paginationButtons = document.getElementById('pagination-buttons');

    let currentPage = 1;
    const pageSize = 10; // 10 items per page as shown in Users mockup

    function customFilterTable() {
        const searchText = searchInput ? searchInput.value.toLowerCase().trim() : '';
        const roleVal = roleFilter ? roleFilter.value.toLowerCase().trim() : 'all';
        const statusVal = statusFilter ? statusFilter.value.toLowerCase().trim() : 'all';

        let matchingRows = [];

        tableRows.forEach(row => {
            let matchesSearch = true;
            let matchesRole = true;
            let matchesStatus = true;

            // Search by name, email or phone
            if (searchText) {
                const nameText = row.querySelector('.item-cell-title') ? row.querySelector('.item-cell-title').innerText.toLowerCase() : '';
                const emailText = row.cells[2] ? row.cells[2].innerText.toLowerCase() : '';
                const phoneText = row.cells[3] ? row.cells[3].innerText.toLowerCase() : '';
                matchesSearch = nameText.includes(searchText) || emailText.includes(searchText) || phoneText.includes(searchText);
            }

            // Role filter
            if (roleVal !== 'all') {
                const roleBadge = row.querySelector('.role-badge-item');
                if (roleBadge) {
                    const roleText = roleBadge.innerText.toLowerCase().trim();
                    matchesRole = (roleText === roleVal);
                }
            }

            // Status filter
            if (statusVal !== 'all') {
                const statusBadge = row.querySelector('.status-badge-item');
                if (statusBadge) {
                    const statusText = statusBadge.innerText.toLowerCase().trim();
                    matchesStatus = (statusText === statusVal);
                }
            }

            if (matchesSearch && matchesRole && matchesStatus) {
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
                paginationInfo.innerText = 'Showing 0 to 0 of 0 users';
            } else {
                paginationInfo.innerText = 'Showing ' + (startIndex + 1) + ' to ' + endIndex + ' of ' + totalMatches + ' users';
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
    if (roleFilter) roleFilter.addEventListener('change', () => { currentPage = 1; customFilterTable(); });
    if (statusFilter) statusFilter.addEventListener('change', () => { currentPage = 1; customFilterTable(); });

    window.resetFilters = function() {
        if (searchInput) searchInput.value = '';
        if (roleFilter) roleFilter.value = 'all';
        if (statusFilter) statusFilter.value = 'all';
        currentPage = 1;
        customFilterTable();
    };

    // CSV Export functionality
    window.exportUsers = function() {
        let csv = [];
        const rows = document.querySelectorAll(".admin-table tr");
        
        for (let i = 0; i < rows.length; i++) {
            let row = [], cols = rows[i].querySelectorAll("td, th");
            
            for (let j = 0; j < cols.length - 1; j++) { // exclude actions column
                let text = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, " ").trim();
                row.push('"' + text.replace(/"/g, '""') + '"');
            }
            
            csv.push(row.join(","));
        }

        const csvFile = new Blob([csv.join("\n")], {type: "text/csv"});
        const downloadLink = document.createElement("a");
        downloadLink.download = "foodrush-users-export.csv";
        downloadLink.href = window.URL.createObjectURL(csvFile);
        downloadLink.style.display = "none";
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);
    };

    // Case normalization for Role dropdown and Dynamic labels for Status switch
    document.querySelectorAll('.btn-edit-action[data-modal-id="edit-user-modal"]').forEach(btn => {
        btn.addEventListener('click', () => {
            const role = btn.getAttribute('data-field-edit-role');
            const roleSelect = document.getElementById('edit-role');
            if (roleSelect && role) {
                roleSelect.value = role.toLowerCase();
            }
            
            // Set edit switch label text correctly on load
            setTimeout(() => {
                const statusSwitch = document.getElementById('edit-status');
                const label = document.getElementById('edit-status-label');
                if (statusSwitch && label) {
                    label.textContent = statusSwitch.checked ? 'Active' : 'Inactive';
                }
            }, 50);
        });
    });

    // Toggle Switch Listeners
    const addSw = document.getElementById('add-status');
    const addLbl = document.getElementById('add-status-label');
    if (addSw && addLbl) {
        addSw.addEventListener('change', function() {
            addLbl.textContent = this.checked ? 'Active' : 'Inactive';
        });
    }

    const editSw = document.getElementById('edit-status');
    const editLbl = document.getElementById('edit-status-label');
    if (editSw && editLbl) {
        editSw.addEventListener('change', function() {
            editLbl.textContent = this.checked ? 'Active' : 'Inactive';
        });
    }
});
