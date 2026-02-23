const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const supabase = require("../utils/supabase");

// user login
const login = async (req, res, next) => {
  try {
    const { email, password, schoolId } = req.body;

    // check empty fields
    if (!email || !password || !schoolId) {
      return res
        .status(400)
        .json({ message: "Email, password and school are required" });
    }

    //  email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res
        .status(400)
        .json({ message: "Invalid email format" });
    }

    // password length 
    if (password.length < 6) {
      return res
        .status(400)
        .json({ message: "Password must be at least 6 characters long" });
    }

    // get user from database
    const { data: user, error } = await supabase
      .from("users")
      .select("*, schools(*)")
      .eq("email", email)
      .single();

    if (error || !user) {
      return res.status(401).json({ message: "Invalid credentials" });
    }


    // compare password
    const validPassword = await bcrypt.compare(password, user.password);

    // debug log: show the password hash and result
   console.log("Password hash:", user.password);
   console.log("Password valid:", validPassword);


    if (!validPassword) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Ensure selected school belongs to this user
    if (String(user.school_id) !== String(schoolId)) {
      return res
        .status(401)
        .json({ message: "Selected school does not belong to this user" });
    }

    // generate JWT
    const token = jwt.sign(
      { id: user.id, email: user.email, schoolId: user.school_id },
      process.env.JWT_SECRET,
      { expiresIn: "24h" }
    );

    // remove password from response
    delete user.password;

    res.json({
      message: "Login successful",
      token,
      user,
    });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  login,
};
