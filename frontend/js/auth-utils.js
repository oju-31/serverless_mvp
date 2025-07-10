// auth-utils.js - Authentication utility functions

/**
 * Check if user is currently authenticated
 * @returns {boolean} - True if user has valid token
 */
function isAuthenticated() {
    const accessToken = localStorage.getItem('accessToken');
    const loginTime = localStorage.getItem('loginTime');
    const expiresIn = localStorage.getItem('expiresIn');
    
    if (!accessToken || !loginTime || !expiresIn) {
        return false;
    }
    
    // Check if token has expired
    const tokenAge = Date.now() - parseInt(loginTime);
    const tokenExpiry = parseInt(expiresIn) * 1000; // Convert to milliseconds
    
    if (tokenAge >= tokenExpiry) {
        clearAuthData();
        return false;
    }
    
    return true;
}

/**
 * Get current access token
 * @returns {string|null} - Access token or null if not authenticated
 */
function getAccessToken() {
    if (!isAuthenticated()) {
        return null;
    }
    return localStorage.getItem('accessToken');
}

/**
 * Store authentication tokens
 * @param {object} tokens - Token object from login response
 */
function storeAuthTokens(tokens) {
    localStorage.setItem('accessToken', tokens.access_token);
    localStorage.setItem('refreshToken', tokens.refresh_token);
    localStorage.setItem('tokenType', tokens.token_type);
    localStorage.setItem('expiresIn', tokens.expires_in);
    localStorage.setItem('loginTime', Date.now().toString());
}

/**
 * Clear all authentication data
 */
function clearAuthData() {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('tokenType');
    localStorage.removeItem('expiresIn');
    localStorage.removeItem('loginTime');
}

/**
 * Logout user and redirect to login page
 * @param {boolean} redirect - Whether to redirect to login page
 */
function logout(redirect = true) {
    clearAuthData();
    localStorage.removeItem('rememberMe');
    localStorage.removeItem('userEmail');
    
    if (redirect) {
        // Determine the correct path to login based on current location
        const currentPath = window.location.pathname;
        let loginPath = 'pages/auth/login.html';
        
        // Adjust path based on current directory depth
        if (currentPath.includes('/pages/')) {
            loginPath = 'login.html';
        } else if (currentPath.includes('/auth/')) {
            loginPath = 'login.html';
        }
        
        window.location.href = loginPath;
    }
}

/**
 * Redirect to login if not authenticated
 * @param {string} customRedirect - Custom redirect path
 */
function requireAuth(customRedirect = null) {
    if (!isAuthenticated()) {
        if (customRedirect) {
            window.location.href = customRedirect;
        } else {
            logout(true);
        }
        return false;
    }
    return true;
}

/**
 * Get current user data (cached or from API)
 * @param {boolean} forceRefresh - Force API call instead of using cache
 * @returns {Promise<object|null>} - User data or null if error
 */
async function getCurrentUser(forceRefresh = false) {
    const accessToken = getAccessToken();
    if (!accessToken) {
        return null;
    }
    
    // Check cache first (unless force refresh)
    const cachedUser = sessionStorage.getItem('currentUser');
    if (!forceRefresh && cachedUser) {
        try {
            return JSON.parse(cachedUser);
        } catch (e) {
            // Invalid cache, continue to API call
        }
    }
    
    try {
        const config = getEnvironmentConfig();
        const formData = {
            type: 'get_user',
            auth: accessToken
        };

        const response = await fetch(config.userMngtURL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': accessToken
            },
            body: JSON.stringify(formData)
        });

        const data = await response.json();

        if (response.ok && data.status === 'Success') {
            // Cache the user data
            sessionStorage.setItem('currentUser', JSON.stringify(data.message));
            return data.message;
        } else {
            // API call failed, likely invalid token
            clearAuthData();
            return null;
        }
    } catch (error) {
        console.error('Error fetching current user:', error);
        return null;
    }
}

/**
 * Make authenticated API request
 * @param {string} url - API endpoint URL
 * @param {object} data - Request data
 * @param {object} options - Additional fetch options
 * @returns {Promise<Response>} - Fetch response
 */
async function authenticatedFetch(url, data, options = {}) {
    const accessToken = getAccessToken();
    if (!accessToken) {
        throw new Error('Not authenticated');
    }
    
    const defaultOptions = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': accessToken
        },
        body: JSON.stringify(data)
    };
    
    return fetch(url, { ...defaultOptions, ...options });
}

/**
 * Format user display name
 * @param {object} userData - User data object
 * @returns {string} - Formatted display name
 */
function formatUserDisplayName(userData) {
    if (!userData) return 'User';
    
    const firstName = userData.given_name || '';
    const lastName = userData.family_name || '';
    const fullName = `${firstName} ${lastName}`.trim();
    
    return fullName || userData.email || 'User';
}

/**
 * Check token expiry and warn user
 * @param {number} warningMinutes - Minutes before expiry to show warning
 */
function checkTokenExpiry(warningMinutes = 5) {
    const loginTime = localStorage.getItem('loginTime');
    const expiresIn = localStorage.getItem('expiresIn');
    
    if (!loginTime || !expiresIn) {
        return;
    }
    
    const tokenAge = Date.now() - parseInt(loginTime);
    const tokenExpiry = parseInt(expiresIn) * 1000;
    const warningTime = tokenExpiry - (warningMinutes * 60 * 1000);
    
    if (tokenAge >= warningTime && tokenAge < tokenExpiry) {
        const remainingMinutes = Math.floor((tokenExpiry - tokenAge) / (60 * 1000));
        console.warn(`Session expires in ${remainingMinutes} minutes`);
        
        // Show user warning (optional)
        if (window.confirm(`Your session expires in ${remainingMinutes} minutes. Would you like to refresh it?`)) {
            // Attempt to refresh token or redirect to login
            window.location.reload();
        }
    }
}

/**
 * Auto-refresh token before expiry
 * @param {number} refreshMinutes - Minutes before expiry to refresh
 */
function autoRefreshToken(refreshMinutes = 10) {
    const loginTime = localStorage.getItem('loginTime');
    const expiresIn = localStorage.getItem('expiresIn');
    
    if (!loginTime || !expiresIn) {
        return;
    }
    
    const tokenAge = Date.now() - parseInt(loginTime);
    const tokenExpiry = parseInt(expiresIn) * 1000;
    const refreshTime = tokenExpiry - (refreshMinutes * 60 * 1000);
    
    if (tokenAge >= refreshTime) {
        // Token needs refresh - could implement refresh token logic here
        // For now, just redirect to login
        console.log('Token refresh needed');
        logout(true);
    }
}

/**
 * Initialize authentication check for a page
 * @param {object} options - Configuration options
 */
function initAuthCheck(options = {}) {
    const {
        requireAuth: authRequired = false,
        redirectUrl = null,
        checkInterval = 60000, // Check every minute
        showUserInfo = false
    } = options;
    
    // Initial auth check
    if (authRequired && !requireAuth(redirectUrl)) {
        return false;
    }
    
    // Set up periodic token expiry checks
    if (isAuthenticated()) {
        setInterval(() => {
            checkTokenExpiry();
            autoRefreshToken();
        }, checkInterval);
        
        // Show user info if requested
        if (showUserInfo) {
            updateUserDisplay();
        }
    }
    
    return true;
}

/**
 * Update user display elements on page
 */
async function updateUserDisplay() {
    const user = await getCurrentUser();
    if (!user) return;
    
    const displayName = formatUserDisplayName(user);
    
    // Update common user display elements
    const userNameElements = document.querySelectorAll('[data-user-name]');
    userNameElements.forEach(el => {
        el.textContent = displayName;
    });
    
    const userEmailElements = document.querySelectorAll('[data-user-email]');
    userEmailElements.forEach(el => {
        el.textContent = user.email || '';
    });
    
    const userStatusElements = document.querySelectorAll('[data-user-status]');
    userStatusElements.forEach(el => {
        el.textContent = user.status || '';
        el.className = `badge ${user.status === 'ACTIVE' ? 'bg-success' : 'bg-warning'}`;
    });
}

/**
 * Handle authentication state changes
 */
function handleAuthStateChange() {
    // Listen for storage changes (login/logout in other tabs)
    window.addEventListener('storage', function(e) {
        if (e.key === 'accessToken') {
            if (e.newValue === null) {
                // User logged out in another tab
                window.location.reload();
            } else if (e.oldValue === null) {
                // User logged in in another tab
                window.location.reload();
            }
        }
    });
    
    // Listen for visibility change (tab becomes active)
    document.addEventListener('visibilitychange', function() {
        if (!document.hidden) {
            // Tab became visible, check if still authenticated
            if (!isAuthenticated()) {
                logout(true);
            }
        }
    });
}

// Initialize auth state change listeners
if (typeof window !== 'undefined') {
    document.addEventListener('DOMContentLoaded', handleAuthStateChange);
}