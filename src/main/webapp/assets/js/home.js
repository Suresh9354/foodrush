// Carousel Sliding Functionality
function slideCarousel(carouselId, direction) {
    const carousel = document.getElementById(carouselId);
    if (!carousel) return;
    const cardWidth = carousel.firstElementChild ? carousel.firstElementChild.offsetWidth + 24 : 300;
    const scrollAmount = direction === 'next' ? cardWidth * 2 : -cardWidth * 2;
    carousel.scrollBy({ left: scrollAmount, behavior: 'smooth' });
}
function slideCategories(dir) { slideCarousel('categoryCarousel', dir); }
function slideRestaurants(dir) { slideCarousel('restaurantCarousel', dir); }
function slideOffers(dir) { slideCarousel('offersCarousel', dir); }
function slideTestimonials(dir) { slideCarousel('testimonialsCarousel', dir); }

// Live Search Filter Logic
function triggerSearch() {
    applyFilters();
}

// Bind input typing for real-time search
document.addEventListener('DOMContentLoaded', () => {
    const searchBox = document.getElementById('restaurantSearch');
    if (searchBox) {
        searchBox.addEventListener('keyup', () => {
            applyFilters();
        });
    }
});

function applyFilters() {
    const searchBox = document.getElementById('restaurantSearch');
    const searchQuery = searchBox ? searchBox.value.toLowerCase().trim() : "";
    
    const cards = document.querySelectorAll('.restaurant-card-wrapper');
    let visibleCount = 0;
    
    cards.forEach(card => {
        const name = card.getAttribute('data-name');
        const cuisine = card.getAttribute('data-cuisine');
        
        const matchesSearch = name.includes(searchQuery) || cuisine.includes(searchQuery);
        
        if (matchesSearch) {
            card.style.display = 'block';
            visibleCount++;
        } else {
            card.style.display = 'none';
        }
    });
    
    const message = document.getElementById('noResultsMessage');
    if (visibleCount === 0) {
        message.style.display = 'flex';
    } else {
        message.style.display = 'none';
    }

    const title = document.getElementById('restaurant-section-title');
    const subtitle = document.getElementById('restaurant-section-subtitle');
    if (searchQuery !== "") {
        title.textContent = "Search Results";
        subtitle.textContent = "Showing " + visibleCount + " matching restaurants near you";
    } else {
        title.textContent = "Top Restaurants";
        subtitle.textContent = "Best food options available near you";
    }
}

function resetFilters() {
    const searchBox = document.getElementById('restaurantSearch');
    if (searchBox) searchBox.value = "";
    applyFilters();
}
