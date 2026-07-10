/* ==========================================================================
   FOODRUSH ADMIN DASHBOARD - INTERACTIVE CONTROLS & CRUD JS
   ========================================================================== */

// 1. Modal Show/Hide Helper Functions
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.add('show');
        document.body.style.overflow = 'hidden'; // Lock background scroll
    }
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.remove('show');
        document.body.style.overflow = ''; // Release scroll
    }
}

document.addEventListener('DOMContentLoaded', () => {
    // Close modal when clicking on close buttons or overlay background
    document.querySelectorAll('.modal-overlay').forEach(overlay => {
        overlay.addEventListener('click', (e) => {
            if (e.target === overlay) {
                closeModal(overlay.id);
            }
        });
        
        const closeBtn = overlay.querySelector('.modal-close-btn');
        if (closeBtn) {
            closeBtn.addEventListener('click', () => {
                closeModal(overlay.id);
            });
        }
    });

    // 2. Client-side Real-time Search and Filter functionality for tables
    const searchInput = document.getElementById('table-search-input');
    const statusFilter = document.getElementById('table-status-filter');
    const tableRows = document.querySelectorAll('.admin-table tbody tr:not(.empty-row)');

    function filterTable() {
        if (!searchInput && !statusFilter) return;
        
        const searchText = searchInput ? searchInput.value.toLowerCase().trim() : '';
        const filterVal = statusFilter ? statusFilter.value.toLowerCase().trim() : '';

        tableRows.forEach(row => {
            let matchesSearch = true;
            let matchesFilter = true;

            // Search text matches any column
            if (searchText) {
                const text = row.innerText.toLowerCase();
                matchesSearch = text.includes(searchText);
            }

            // Filter value matches specific row attributes
            if (filterVal && filterVal !== 'all') {
                const statusBadge = row.querySelector('.status-badge');
                if (statusBadge) {
                    const badgeText = statusBadge.innerText.toLowerCase().trim();
                    if (filterVal === 'active') {
                        matchesFilter = (badgeText === 'active' || badgeText === 'available');
                    } else if (filterVal === 'inactive') {
                        matchesFilter = (badgeText === 'inactive' || badgeText === 'unavailable');
                    } else {
                        matchesFilter = badgeText.includes(filterVal);
                    }
                }
            }

            if (matchesSearch && matchesFilter) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
        
        // Show/hide empty state message
        const visibleRows = Array.from(tableRows).filter(row => row.style.display !== 'none');
        const emptyState = document.getElementById('table-empty-state');
        if (emptyState) {
            emptyState.style.display = (visibleRows.length === 0) ? '' : 'none';
        }
    }

    if (searchInput) searchInput.addEventListener('input', filterTable);
    if (statusFilter) statusFilter.addEventListener('change', filterTable);

    // 3. Dynamic Populating Form Fields for "Edit" actions
    // Setup listeners on edit buttons with data attributes
    document.querySelectorAll('.btn-edit-action').forEach(btn => {
        btn.addEventListener('click', () => {
            const modalId = btn.getAttribute('data-modal-id');
            
            // Auto populate matching inputs in the target modal
            // Searches for data-field attributes on the button and injects their value into elements with matching ID
            const dataAttributes = btn.attributes;
            for (let i = 0; i < dataAttributes.length; i++) {
                const attr = dataAttributes[i];
                if (attr.name.startsWith('data-field-')) {
                    const fieldId = attr.name.replace('data-field-', '');
                    const inputElement = document.getElementById(fieldId);
                    if (inputElement) {
                        if (inputElement.type === 'checkbox') {
                            inputElement.checked = (attr.value === 'true');
                        } else {
                            inputElement.value = attr.value;
                        }
                    }
                }
            }
            
            openModal(modalId);
        });
    });

    // 4. Setup Confirm Delete Dialouge Helper
    document.querySelectorAll('.btn-delete-action').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const confirmMsg = btn.getAttribute('data-confirm-message') || 'Are you sure you want to delete this item?';
            if (!confirm(confirmMsg)) {
                e.preventDefault(); // cancel action/navigation
            }
        });
    });

    // 5. Setup Profile Picture Preview in Settings
    const avatarInput = document.getElementById('admin-avatar-input');
    const avatarPreview = document.getElementById('admin-avatar-preview');
    if (avatarInput && avatarPreview) {
        avatarInput.addEventListener('input', () => {
            const url = avatarInput.value.trim();
            if (url) {
                avatarPreview.src = url;
            } else {
                avatarPreview.src = '../assets/images/default-avatar.png'; // fallback placeholder
            }
        });
    }

    // 6. Premium Alert Auto-Dismiss Handler with transitions
    document.querySelectorAll('.admin-alert').forEach(alert => {
        // Add a close button if not already present
        if (!alert.querySelector('.alert-close-btn')) {
            const closeBtn = document.createElement('button');
            closeBtn.className = 'alert-close-btn';
            closeBtn.innerHTML = '&times;';
            closeBtn.addEventListener('click', (e) => {
                e.preventDefault();
                dismissAlert(alert);
            });
            alert.appendChild(closeBtn);
        }

        // Set timeout to auto-dismiss after 3 seconds
        setTimeout(() => {
            dismissAlert(alert);
        }, 3000);
    });

    function dismissAlert(alert) {
        if (!alert) return;
        alert.style.transition = 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)';
        const currentHeight = alert.offsetHeight;
        alert.style.height = currentHeight + 'px';
        
        alert.offsetHeight; // Force reflow

        alert.style.opacity = '0';
        alert.style.transform = 'translateY(-8px)';
        alert.style.height = '0';
        alert.style.paddingTop = '0';
        alert.style.paddingBottom = '0';
        alert.style.marginTop = '0';
        alert.style.marginBottom = '0';
        alert.style.borderWidth = '0';
        alert.style.overflow = 'hidden';

        setTimeout(() => {
            alert.remove();
        }, 300);
    }
});
