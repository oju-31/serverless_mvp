// app.js

// Wait for the DOM to fully load
document.addEventListener('DOMContentLoaded', () => {
    // Change the text of the <h1> element
    const header = document.querySelector('h1');
    header.textContent = 'Welcome to My Dynamic S3 Hosted App!';

    // Add a new paragraph to the body
    const newParagraph = document.createElement('p');
    newParagraph.textContent = 'This paragraph was added dynamically by app.js.';
    document.body.appendChild(newParagraph);

    // Modify the 'About' link to show an alert when clicked
    const aboutLink = document.querySelector('a[href="/about.html"]');
    aboutLink.addEventListener('click', (event) => {
        event.preventDefault(); // Prevent the default navigation
        alert('You clicked the About link!');
    });
});
