// generateHash.js
const bcrypt = require('bcrypt');

const password = 'password123'; // the password you want to hash

bcrypt.hash(password, 10, (err, hash) => {
    if (err) throw err;
    console.log('Hashed password:', hash);
});