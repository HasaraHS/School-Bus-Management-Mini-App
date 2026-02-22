const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const supabase = require("../utils/supabase");

// user login
const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    //validation
    if (email === "" || password === "") {
      return res
        .status(400)
        .json({ message: "Email and password are required" });
    }

    //get user from database
    const { data: user, error } = await supabase
      .from("users")
      .select("*, schools(*)")
      .eq("email", email)
      .single();

    if (error || !user) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    //compare password
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    //generate JWT
    const token = jwt.sign(
      { id: user.id, email: user.email, schoolId: user.school_id },
      process.env.JWT_SECRET,
      { expiresIn: "24h" },
    );

    //remove password from response
    delete user.password;

    res.json({
      message: "Login successful",
      token,
      user,
    });
  } catch (err) {
    next(err);
  }

  module.exports = {
    login,
  };
};
