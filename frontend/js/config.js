// config.js
export const configa = {
    lambdaUrl: 'https://i4otrcsddqhqiuhddlgq6e7lrm0arlol.lambda-url.us-east-1.on.aws/',
    appVersion: '1.0.0',
    type: "module",
  };
  
const config = {
    API_URL: 'https://i4otrcsddqhqiuhddlgq6e7lrm0arlol.lambda-url.us-east-1.on.aws/'
  };

  // Make it globally available
window.apiUrl = config.API_URL;
  export default config.API_URL