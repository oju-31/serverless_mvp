// Mobile menu toggle
const hamburger = document.querySelector('.hamburger');
const navMenu = document.querySelector('.nav-menu');

hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('active');
    navMenu.classList.toggle('active');
});

// Close mobile menu when clicking on a link
document.querySelectorAll('.nav-link').forEach(n => n.addEventListener('click', () => {
    hamburger.classList.remove('active');
    navMenu.classList.remove('active');
}));

// FAQ accordion functionality
document.querySelectorAll('.faq-question').forEach(button => {
    button.addEventListener('click', () => {
        const faqItem = button.parentElement;
        const isActive = faqItem.classList.contains('active');
        
        // Close all FAQ items
        document.querySelectorAll('.faq-item').forEach(item => {
            item.classList.remove('active');
        });
        
        // Open clicked item if it wasn't already active
        if (!isActive) {
            faqItem.classList.add('active');
        }
    });
});

// Email signup form handling
document.querySelector('.signup-form').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const email = this.querySelector('input[type="email"]').value;
    const submitBtn = this.querySelector('.submit-btn');
    
    // Simple email validation
    if (!email || !email.includes('@')) {
        alert('Please enter a valid email address.');
        return;
    }
    
    // Simulate form submission
    submitBtn.textContent = 'Subscribing...';
    submitBtn.disabled = true;
    
    // Simulate API call
    setTimeout(() => {
        alert('Thank you for subscribing! We\'ll notify you when Ahlorq launches.');
        this.reset();
        submitBtn.textContent = 'Get Early Access';
        submitBtn.disabled = false;
    }, 2000);
});

// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Intersection Observer for animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('visible');
        }
    });
}, observerOptions);

// Add animation classes and observe elements
document.addEventListener('DOMContentLoaded', () => {
    // Add fade-in animation to sections
    document.querySelectorAll('.feature-card, .step, .testimonial').forEach(el => {
        el.classList.add('fade-in');
        observer.observe(el);
    });
    
    // Add slide animations to feature sections
    document.querySelectorAll('.feature-text').forEach(el => {
        el.classList.add('slide-in-left');
        observer.observe(el);
    });
    
    document.querySelectorAll('.feature-visual').forEach(el => {
        el.classList.add('slide-in-right');
        observer.observe(el);
    });
});

// Add parallax effect to hero section
window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const parallax = document.querySelector('.hero');
    if (parallax) {
        const speed = scrolled * 0.5;
        parallax.style.transform = `translateY(${speed}px)`;
    }
});

// Navigation background on scroll
window.addEventListener('scroll', () => {
    const navbar = document.querySelector('.navbar');
    if (window.scrollY > 100) {
        navbar.style.background = 'rgba(255, 255, 255, 0.95)';
        navbar.style.backdropFilter = 'blur(10px)';
    } else {
        navbar.style.background = 'var(--white)';
        navbar.style.backdropFilter = 'none';
    }
});

// Add dynamic hover effects to floating elements
document.querySelectorAll('.float-element').forEach(element => {
    element.addEventListener('mouseenter', () => {
        element.style.animationPlayState = 'paused';
        element.style.transform = 'scale(1.2) rotate(360deg)';
    });
    
    element.addEventListener('mouseleave', () => {
        element.style.animationPlayState = 'running';
        element.style.transform = '';
    });
});

// Progress bar animation on scroll
const animateProgressBars = () => {
    const progressSection = document.querySelector('.progress-section');
    const progressBars = document.querySelectorAll('.project-progress');
    
    if (progressSection) {
        const rect = progressSection.getBoundingClientRect();
        const isVisible = rect.top < window.innerHeight && rect.bottom > 0;
        
        if (isVisible) {
            progressBars.forEach(bar => {
                const width = bar.style.width;
                bar.style.width = '0%';
                setTimeout(() => {
                    bar.style.width = width;
                }, 500);
            });
        }
    }
};

// Trigger progress animation once when scrolling into view
let progressAnimated = false;
window.addEventListener('scroll', () => {
    if (!progressAnimated) {
        animateProgressBars();
        progressAnimated = true;
    }
});