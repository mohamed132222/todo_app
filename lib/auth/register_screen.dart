import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/custom_text_form_field.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/my_theme.dart';

import '../providers/auth_provider.dart';
import '../utils/dialog_utils.dart';
import '../utils/firebase_utils.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // 🔹 Cache MediaQuery (performance)
  late final double _screenHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenHeight = MediaQuery.of(context).size.height;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: [_buildBackground(), _buildForm()]),
    );
  }

  // ================= UI Parts =================
  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset("assets/images/background.png", fit: BoxFit.cover),
    );
  }

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
              _buildUsernameField(),
              _buildEmailField(),
              _buildPasswordField(),
              _buildConfirmPasswordField(),
              _buildRegisterButton(),
              _buildLoginNavigation(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return CustomTextFormField(
      controller: _usernameController,
      hintText: "enter your username",
      prefixIcon: const Icon(Icons.person),
      validator: _validateUsername,
    );
  }

  Widget _buildEmailField() {
    return CustomTextFormField(
      controller: _emailController,
      hintText: "enter your email",
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email),
      validator: _validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextFormField(
      controller: _passwordController,
      hintText: "enter your password",
      obscureText: true,
      prefixIcon: const Icon(Icons.lock),
      validator: _validatePassword,
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextFormField(
      controller: _confirmPasswordController,
      hintText: "confirm your password",
      obscureText: true,
      prefixIcon: const Icon(Icons.lock_outline),
      validator: _validateConfirmPassword,
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: MyTheme.primaryColor,
          foregroundColor: MyTheme.whiteColor,
        ),
        child: const Text("Register"),
      ),
    );
  }

  Widget _buildLoginNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          },
          child: const Text("Login"),
        ),
      ],
    );
  }

  // ================= Validators =================
  String? _validateUsername(String? text) {
    if (text == null || text.trim().isEmpty)
      return "please enter your username";
    return null;
  }

  String? _validateEmail(String? text) {
    if (text == null || text.trim().isEmpty) return "please enter your email";
    final emailValid = RegExp(
      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(text);
    if (!emailValid) return "please enter a valid email";
    return null;
  }

  String? _validatePassword(String? text) {
    if (text == null || text.isEmpty) return "please enter your password";
    if (text.length < 6) return "password must be at least 6 characters";
    return null;
  }

  String? _validateConfirmPassword(String? text) {
    if (text == null || text.isEmpty) return "please confirm your password";
    if (text != _passwordController.text) return "password does not match";
    return null;
  }

  // ================= Register Logic =================
  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    DialogUtils.showLoading(context);

    try {
      // 🔹 إنشاء المستخدم في FirebaseAuth
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

      // 🔹 إنشاء كائن MyUser لحفظ بيانات المستخدم في Firestore
      MyUser user = MyUser(
        email: _emailController.text,
        username: _usernameController.text,
        id: credential.user?.uid ?? "",
      );

      await FirebaseUtils.addUser(user);

      // 🔹 تحديث Provider بالمستخدم الجديد
      var authProvider = Provider.of<AuthProviderApp>(context, listen: false);
      authProvider.changeUser(user);

      DialogUtils.hideLoading(context);

      // 🔹 عرض رسالة نجاح
      DialogUtils.showMessage(
        context,
        message: "register successfully",
        title: "success",
        isDismissible: true,
        posActionName: "ok",
        posAction: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        },
      );
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideLoading(context);

      if (e.code == 'weak-password') {
        _showError("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        _showError("The account already exists for that email.");
      }
    } catch (e) {
      DialogUtils.hideLoading(context);
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    DialogUtils.showMessage(
      context,
      message: message,
      isDismissible: true,
      title: "error",
      posActionName: "ok",
      posAction: () =>
          Navigator.pushReplacementNamed(context, RegisterScreen.routeName),
    );
  }
}
