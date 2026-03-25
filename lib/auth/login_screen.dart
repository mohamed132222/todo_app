import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/custom_text_form_field.dart';
import 'package:todo_app/auth/register_screen.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/utils/dialog_utils.dart';
import 'package:todo_app/utils/firebase_utils.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final double _screenHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenHeight = MediaQuery.of(context).size.height;
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
      resizeToAvoidBottomInset: true,
      body: Stack(children: [_buildBackground(), _buildForm()]),
    );
  }

  // خلفية الشاشة
  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset("assets/images/background.png", fit: BoxFit.cover),
    );
  }

  // الفورم الرئيسي
  Widget _buildForm() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: _screenHeight * .25),
              _buildEmailField(),
              _buildPasswordField(),
              _buildLoginButton(),
              _buildRegisterNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  // حقل البريد الإلكتروني
  Widget _buildEmailField() {
    return CustomTextFormField(
      controller: _emailController,
      hintText: "enter your email",
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
      prefixIcon: Icon(Icons.email),
    );
  }

  // حقل كلمة المرور
  Widget _buildPasswordField() {
    return CustomTextFormField(
      controller: _passwordController,
      hintText: "enter your password",
      obscureText: true,
      validator: _validatePassword,
      prefixIcon: Icon(Icons.lock),
    );
  }

  // زر تسجيل الدخول
  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: MyTheme.primaryColor,
          foregroundColor: MyTheme.whiteColor,
        ),
        child: const Text("Login"),
      ),
    );
  }

  // الانتقال لشاشة التسجيل
  Widget _buildRegisterNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
          },
          child: const Text("Register"),
        ),
      ],
    );
  }

  // ================= Validators =================
  String? _validateEmail(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "please enter your email";
    }
    return null;
  }

  String? _validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return "please enter your password";
    }
    return null;
  }

  // ================= Login Logic =================
  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    DialogUtils.showLoading(context);

    try {
      // تسجيل الدخول باستخدام FirebaseAuth
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // جلب بيانات المستخدم من Firestore
      MyUser? user = await FirebaseUtils.readUser(credential.user?.uid ?? "");

      if (user == null) return;

      // تحديث Provider
      var authProvider = Provider.of<AuthProviderApp>(context, listen: false);
      authProvider.changeUser(user);

      print("login success");
      DialogUtils.hideLoading(context);

      // إظهار رسالة نجاح
      DialogUtils.showMessage(
        context,
        message: "login success",
        isDismissible: true,
        title: "success",
        posActionName: "ok",
        posAction: () =>
            Navigator.pushReplacementNamed(context, HomeScreen.routeName),
      );
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideLoading(context);

      if (e.code == 'user-not-found') {
        _showError("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        _showError("Wrong password provided for that user.");
      }
    } catch (e) {
      DialogUtils.hideLoading(context);
      _showError(e.toString());
    }

    debugPrint("login");
  }

  void _showError(String message) {
    DialogUtils.showMessage(
      context,
      message: message,
      isDismissible: true,
      title: "error",
      posActionName: "ok",
      posAction: () =>
          Navigator.pushReplacementNamed(context, LoginScreen.routeName),
    );
  }
}
