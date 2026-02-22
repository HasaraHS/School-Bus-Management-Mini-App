const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

// error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(err.status || 500) .json ({
        message: err.message || 'Internal Server Error',
        error: process.env.NODE_ENV === 'development' ? err : {}
    });
});

app.listen(process.env.PORT, () => {
    console.log(`Server is running on port ${PORT}`);
})