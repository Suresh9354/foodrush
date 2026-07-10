// Toggle address editor display
function toggleAddressEdit() {
    const displayBox = document.getElementById('addressDisplayBox');
    const editBox = document.getElementById('addressEditBox');
    
    if (displayBox.style.display === 'none') {
        displayBox.style.display = 'flex';
        editBox.style.display = 'none';
    } else {
        displayBox.style.display = 'none';
        editBox.style.display = 'block';
        document.getElementById('addressTextarea').focus();
    }
}

// Save address inline
function saveAddress() {
    const textValue = document.getElementById('addressTextarea').value.trim();
    if (textValue === '') {
        alert('Please enter a valid delivery address.');
        return;
    }
    
    // Update hidden textarea
    document.getElementById('addressInput').value = textValue;
    
    // Update text layout
    document.getElementById('addressDisplayText').innerHTML = textValue.replace(/\n/g, '<br>');
    
    // Switch displays
    toggleAddressEdit();
}

// Toggle custom payment dropdown list
function togglePaymentDropdown() {
    const dropdown = document.getElementById('customPaymentSelect');
    const chevron = document.getElementById('dropdownChevron');
    dropdown.classList.toggle('open');
    
    if (dropdown.classList.contains('open')) {
        chevron.style.transform = 'rotate(180deg)';
    } else {
        chevron.style.transform = 'rotate(0deg)';
    }
}

// Select payment method option
function selectPaymentOption(element) {
    const value = element.getAttribute('data-value');
    
    // Set the hidden input value
    document.getElementById('paymentMethodHidden').value = value;
    
    // Update selected view
    const selectedContainer = document.getElementById('triggerSelectedValue');

    const path = window.contextPath || '';
    
    if (value === 'COD') {
        selectedContainer.innerHTML = `
            <img src="${path}/assets/images/icons/cash-on-delivery.png" alt="Cash on Delivery" class="payment-icon-img" style="width: 24px; height: 24px; object-fit: contain; margin-right: 12px;">
            <span class="selected-text-main">Cash on Delivery</span>
        `;
    } else if (value === 'UPI') {
        selectedContainer.innerHTML = `
            <div class="option-item-icon-col" style="margin-right: 12px; display: inline-flex; align-items: center; justify-content: center;">
                <div class="upi-logo-custom">UPI</div>
            </div>
            <span class="selected-text-main">UPI</span>
        `;
    } else if (value === 'CARD') {
        selectedContainer.innerHTML = `
            <img src="${path}/assets/images/icons/credit-card.png"
                 alt="Cards"
                 class="payment-icon-img"
                 style="width:24px;height:24px;object-fit:contain;margin-right:12px;">
            <span class="selected-text-main">Cards</span>
        `;
    }
    
    // Remove selected classes and set to active
    const options = document.querySelectorAll('.payment-option-item');
    options.forEach(opt => opt.classList.remove('selected'));
    element.classList.add('selected');
    
    // Toggle dropdown closed
    const selectBox = document.getElementById('customPaymentSelect');
    selectBox.classList.remove('open');
    document.getElementById('dropdownChevron').style.transform = 'rotate(0deg)';
    
    // Update footer helper notice
    const notice = document.getElementById('paymentNoticeText');
    if (value === 'COD') {
        notice.innerText = 'You will pay when your order is delivered';
    } else if (value === 'UPI') {
        notice.innerText = 'You will pay using UPI app on delivery';
    } else if (value === 'CARD') {
        notice.innerText = 'You will pay using Credit / Debit Card on delivery';
    }
}

// Close dropdown when clicked outside
document.addEventListener('click', function(event) {
    const customSelect = document.getElementById('customPaymentSelect');
    const chevron = document.getElementById('dropdownChevron');
    if (customSelect && !customSelect.contains(event.target)) {
        customSelect.classList.remove('open');
        if (chevron) {
            chevron.style.transform = 'rotate(0deg)';
        }
    }
});

// Bind UI actions via event listeners
document.addEventListener('DOMContentLoaded', () => {
    // Edit Address Trigger
    const editAddressBtns = document.querySelectorAll('.btn-edit-address, .btn-cancel-address');
    editAddressBtns.forEach(btn => {
        btn.addEventListener('click', toggleAddressEdit);
    });

    // Save Address Trigger
    const saveAddressBtn = document.querySelector('.btn-save-address');
    if (saveAddressBtn) {
        saveAddressBtn.addEventListener('click', saveAddress);
    }

    // Payment Dropdown Toggle Trigger
    const paymentTrigger = document.querySelector('.select-trigger-box');
    if (paymentTrigger) {
        paymentTrigger.addEventListener('click', togglePaymentDropdown);
    }

    // Payment Option Selection Trigger
    const paymentOptions = document.querySelectorAll('.payment-option-item');
    paymentOptions.forEach(option => {
        option.addEventListener('click', () => {
            selectPaymentOption(option);
        });
    });
});
