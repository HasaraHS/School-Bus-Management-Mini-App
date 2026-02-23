import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_bus_management_mini_app/constant/app_dimensions.dart';
import 'package:school_bus_management_mini_app/constant/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../constant/app_string.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../constant/app_colors.dart';
import '../providers/school_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedSchoolId;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final schoolProvider = Provider.of<SchoolProvider>(context, listen: false);
      if (schoolProvider.schools.isEmpty) {
        schoolProvider.loadPublicSchools();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingSmall),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image container
                    SizedBox(
                      height: screenHeight * 0.27,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/Picture.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge),

                    // App Title
                    Text(
                      AppString.busbuddy,
                      style: AppTextStyles.headline,
                      textAlign: TextAlign.center,
                    ),

                    Text(
                      AppString.logInToYourAccount,
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppDimensions.paddingLarge * 2),

                    // School Dropdown (top of email field)
                    Consumer<SchoolProvider>(
                      builder: (context, schoolProvider, child) {
                        if (schoolProvider.isLoading && schoolProvider.schools.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        String? selectedSchoolName;
                        if (_selectedSchoolId != null) {
                          for (final school in schoolProvider.schools) {
                            if (school.id == _selectedSchoolId) {
                              selectedSchoolName = school.name;
                              break;
                            }
                          }
                        }

                        return CustomTextField(
                          label: AppString.selectYourSchool,
                          isDropdown: true,
                          items: schoolProvider.schools.map((s) => s.name).toList(),
                          selectedValue: selectedSchoolName,
                          onChanged: (value) {
                            if (value == null) {
                              setState(() => _selectedSchoolId = null);
                              return;
                            }

                            final selected = schoolProvider.schools.firstWhere(
                              (s) => s.name == value,
                            );

                            setState(() {
                              _selectedSchoolId = selected.id;
                            });
                            schoolProvider.loadSchoolDetails(selected.id);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a school';
                            }
                            return null;
                          },
                        );
                      },
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Email Field
                    CustomTextField(
                      label: AppString.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Password Field + Forgot Password
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          label: AppString.password,
                          controller: _passwordController,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                            },
                            child: Text(
                              AppString.forgotPassword,
                              style: AppTextStyles.body.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Login Button
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return CustomButton(
                          text: AppString.login,
                          isLoading: auth.isLoading,
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.07,
                          color: AppColors.primary,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedSchoolId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select a school'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }

                              final success = await auth.login(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _selectedSchoolId!,
                              );
                              if (success && mounted) {
                                final schoolProvider = Provider.of<SchoolProvider>(
                                  context,
                                  listen: false,
                                );
                                if (auth.token != null) {
                                  await schoolProvider.loadSchools(auth.token!);
                                }
                                Navigator.pushReplacementNamed(
                                    context, '/dashboard');
                              } else if (!success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Invalid email, password, or school selection',
                                    ),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
