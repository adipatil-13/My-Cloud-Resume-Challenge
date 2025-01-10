window.addEventListener('DOMContentLoaded', event => {

    // 1. ScrollSpy Initialization
    const sideNav = document.body.querySelector('#sideNav');
    if (sideNav) {
        new bootstrap.ScrollSpy(document.body, {
            target: '#sideNav',
            rootMargin: '0px 0px -40%',
        });
    }

    // 2. Navbar Toggler (responsive navbar)
    const navbarToggler = document.body.querySelector('.navbar-toggler');
    const responsiveNavItems = [].slice.call(
        document.querySelectorAll('#navbarResponsive .nav-link')
    );
    responsiveNavItems.map(function (responsiveNavItem) {
        responsiveNavItem.addEventListener('click', () => {
            if (window.getComputedStyle(navbarToggler).display !== 'none') {
                navbarToggler.click();
            }
        });
    });

    // Initialize DynamoDB table by calling Lambda Function URL with the table name
    fetch('INITIALIZE_FUNCTION_URL', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ tableName: "DYNAMODB_TABLE_NAME" })
    })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => { throw new Error(text) });
            }
            return response.text();
        })
        .then(data => {
            console.log('DynamoDB initialization response:', data);
            // Fetch count value from Lambda Function and update the page
            return fetch('LAMBDA_FUNCTION_URL', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ tableName: "DYNAMODB_TABLE_NAME" })
            });
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.text();
        })
        .then(data => {
            document.getElementById('count-value').textContent = data;
        })
        .catch(error => {
            console.error('There was a problem with the fetch operation:', error);
            document.getElementById('count-value').textContent = 'Error loading count value';
        });
});


