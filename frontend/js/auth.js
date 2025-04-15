import { configa } from './config.js';

document.addEventListener('DOMContentLoaded', () => {
    const page = document.body.dataset.page;
  
    switch (page) {
      case 'login':
        initLogin();
        break;
      case 'signup':
        initSignup();
        break;
      case 'confirm-signup':
        initConfirmSignup();
        break;
      case 'forgot-password':
        initForgotPassword();
        break;
      case 'confirm-forgot-password':
        initConfirmForgotPassword();
        break;
      default:
        console.warn(`No auth logic defined for page: ${page}`);
    }
  });

  function initSignup() {
    const form = document.querySelector('.signup-form');
    if (!form) return;
  
    form.addEventListener('submit', async (event) => {
      event.preventDefault();
  
      const name = form.name.value.trim();
      const email = form.email.value.trim();
      const password = form.password.value;
      const confirmPassword = form['confirm-password'].value;
  
      // Basic validation
      if (password !== confirmPassword) {
        alert("Passwords do not match.");
        return;
      }
  
      try {
        const response = await fetch(configa.API_URL, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ name, email, password })
        });
  
        const data = await response.json();
  
        if (response.ok) {
          alert("Signup successful! Redirecting to login...");
          window.location.href = 'login.html';
        } else {
          alert(data.message || "Signup failed. Try again.");
        }
      } catch (error) {
        console.error('Error:', error);
        alert("Network error. Please try again later.");
      }
    });
  }
  