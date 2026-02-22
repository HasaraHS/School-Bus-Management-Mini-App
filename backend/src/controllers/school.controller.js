const supabase = require("../utils/supabase");

const getSchoolDetails = async (req, res, next) => {
  try {
    const { schoolId } = req.params;

    const { data: school, error } = await supabase
      .from("schools")
      .select(
        `
                *,
                users (
                    id,
                    full_name,
                    email
                )
            `,
      )
      .eq("id", schoolId)
      .single();

    if (error) {
      return res.status(404).json({ error: "School not found" });
    }

    res.json(school);
  } catch (err) {
    next(err);
  }

  const getAllSchools = async (req, res, next) => {
    try {
      const { data: schools, error } = await supabase
        .from("schools")
        .select("*");

      if (error) {
        return res.status(500).json({ error: "Failed to fetch schools" });
      }

      res.json(schools);
    } catch (err) {
      next(err);
    }
  };

  module.exports = {
    getSchoolDetails,
    getAllSchools,
  };
};
