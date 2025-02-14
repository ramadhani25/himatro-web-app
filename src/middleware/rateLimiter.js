require('dotenv').config();

const rateLimit = require('express-rate-limit');

const loginLimiter = rateLimit({
  windowMs: process.env.LOGIN_TIME_LIMIT_MS,
  max: process.env.MAX_LOGIN_TRIAL,
  handler(req, res) {
    res.status(429).render('errorPage', {
      errorMessage: 'Too many failed attempt. Please wait another 2 hours or contact admin to resolve.',
    });
  },
});

const uploadLimiter = rateLimit({
  windowMs: process.env.LOGIN_TIME_LIMIT_MS,
  max: process.env.MAX_UPLOAD_TRIAL,
  handler(req, res) {
    res.status(429).render('errorPage', {
      errorMessage: 'Too many uploads. Please wait another 2 hours or contact admin to resolve.',
    });
  },
});

module.exports = {
  loginLimiter,
  uploadLimiter,
};
