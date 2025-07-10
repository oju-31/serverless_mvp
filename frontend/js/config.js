const getEnvironmentConfig = () => {
  const hostname = window.location.hostname;
  
  // Production CloudFront
  if (hostname === 'dxxx.cloudfront.net') { // Replace with actual production URL
    return {
      environment: 'production',
      userMngtURL: 'xxxxxx', // Replace with actual production URL
      myMVPURL: 'xxxxxx' // Replace with actual production URL
    };
  }
  
  // Development CloudFront  
  if (hostname === 'd3giqaug8sjk3.cloudfront.net') {
    return {
      environment: 'development', 
      userMngtURL: 'https://d4grbgks4be7h5rlmzq7i4qbm40nflyh.lambda-url.us-east-1.on.aws/',
      myMVPURL: 'https://ekkr5mu4lljynydavqguvlktuq0owoos.lambda-url.us-east-1.on.aws/'
    };
  }
  
  // Local development
  return {
    environment: 'local',
    userMngtURL: 'https://d4grbgks4be7h5rlmzq7i4qbm40nflyh.lambda-url.us-east-1.on.aws/',
    myMVPURL: 'https://ekkr5mu4lljynydavqguvlktuq0owoos.lambda-url.us-east-1.on.aws/'
  };
};