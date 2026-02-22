const express = require('express');
const router = express.Router();
const {getSchoolDetails, getAllSchools} = require('../controllers/school.controller');
const {verifyToken} = require('../middleware/auth.middleware');

router.get('/', verifyToken, getAllSchools);
router.get('/:schoolId', verifyToken, getSchoolDetails);

module.exports = router;