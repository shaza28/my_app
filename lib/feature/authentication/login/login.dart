import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/UI_Utils.dart';
import 'package:movie_app/core/resourses/app_colors.dart';
import 'package:movie_app/feature/firebase/firebase_service.dart';
import 'package:movie_app/feature/models/login_request.dart';
import 'package:movie_app/feature/models/user_model.dart';
import '../../../core/resourses/app_images.dart';
import '../../../core/resourses/widget/custom_text_form_field.dart';
import '../../../core/routers.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const routeName = "/login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool securePassword = true;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 47.h,
            left: 24.w,
            right: 24.w,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  AppImages.logo,
                  width: 200.w,
                  height: 200.h,
                ),
                SizedBox(height: 40.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFormField(
                      controller: _emailController,
                      validator: _validateEmail,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.email, color: AppColors.white),
                    ),
                    SizedBox(height: 16.h),
                    CustomTextFormField(
                      controller: _passwordController,
                      validator: _validatePassword,
                      isSecure: securePassword,
                      hintText: "Password",
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: Icon(Icons.lock, color: AppColors.white),
                      suffixIcon: IconButton(
                        onPressed: _onTogglePasswordIconClicked,
                        icon: Icon(
                          securePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoutes.forgetPassword);
                        },
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    // Login Button
                    SizedBox(
                      height: 50.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have Account?",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.register);
                          },
                          child: Text(
                            "Create One",
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.yellow,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            "Or",
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.yellow,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    // Login With Google Button
                    SizedBox(
                      height: 50.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _googleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.googleIcon,
                              height: 24.h,
                              width: 24.w,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Login With Google",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTogglePasswordIconClicked() {
    setState(() {
      securePassword = !securePassword;
    });
  }
  Future<void>_googleSignIn()async{

  }

  void _login()async {
    if (_formKey.currentState?.validate() == true) {
     try
      {
        UIUtils.showLoading(context,isDismissible: false);
        UserCredential userCredential=await FirebaseServices.login(LoginRequest(email:_emailController.text, password:_passwordController.text));
        UserModel.currentUser = await FirebaseServices.getUserFromFireStore(userCredential.user!.uid);

        UIUtils.hideDialog(context);
        UIUtils.showToastMessage("User LoggedIn Successfully",AppColors.green);
        Navigator.pushReplacementNamed(context, '/home');
      }on FirebaseAuthException catch(exception){
         UIUtils.hideDialog(context);
         UIUtils.showToastMessage("Invalid email or password ",AppColors.red );
     }catch(exception){
       UIUtils.hideDialog(context);
       UIUtils.showToastMessage("Failed to login",AppColors.red);
     }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!value.contains('@')) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}












