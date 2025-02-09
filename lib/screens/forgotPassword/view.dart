import 'package:stock_management/headers.dart';

class ForgotPassBody extends StatefulWidget {
  const ForgotPassBody({super.key});

  @override
  State<ForgotPassBody> createState() => _ForgotPassBodyState();
}

class _ForgotPassBodyState extends State<ForgotPassBody> {
  final forgotcontroller = Get.find<forgotPassController>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.padh, vertical: Sizes.padv),
          child: SingleChildScrollView(
              child: GetBuilder<forgotPassController>(
                  init: forgotcontroller,
                  builder: (_) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sizeBox.TitlesizedBox(),
                        Text(
                          "Forgot Password",
                          style: TextWidgets.titleTextStyle(primaryColor),
                        ),
                        sizeBox.BodysizedBox(),
                        Text(
                          "Recover your Password",
                          style: TextWidgets.bodyTextStyle(primaryColor),
                        ),
                        sizeBox.TitlesizedBox(),
                        buildEmailFormField(),
                        sizeBox.BodysizedBox(),
                        buildPasswordFormField(),
                        sizeBox.BodysizedBox(),
                        buildConFormField(),
                        sizeBox.BodysizedBox(),
                        Row(children: [
                          Checkbox(
                            value: forgotcontroller.remember.value,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              forgotcontroller.setRemember(value!);
                            },
                          ),
                          const Text('Remember me '),
                        ]),
                        GestureDetector(
                          onTap: () {
                            // Get.back();
                            // YEAH WAPIS LOGIN PE JANEY KEH LE? use kia hai ?no
                            Get.toNamed(MyGet.login);
                          },
                          child: Text(
                            'Login your account',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                        sizeBox.BodysizedBox(),
                        sizeBox.BodysizedBox(),
                        Buttons.CustomButton(
                          10.h,
                          10.w,
                          "Change Password",
                          () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              // Send request to server to check if email exists and update password
                              Api.forgotPassword(
                                forgotcontroller.email.value,
                                forgotcontroller.newpassword.value,
                              );
                            }
                          },
                        ),
                      ],
                    );
                  })),
        ),
      ),
    );
  }

  Widget buildPasswordFormField() {
    return Obx(
      () => TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return Texts.kPassNullError;
          } else if (value.length < 8) {
            return Texts.kShortPassError;
          }
          return null;
        },
        onChanged: forgotcontroller.setNewPassword,
        obscureText: !forgotcontroller.showPassword.value,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.h, vertical: 18.w),
          hintText: 'Enter your new Password',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: Decorations.InputFieldBorder(),
          focusedBorder: Decorations.InputFieldFocusBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              forgotcontroller.toggleShowPassword();
            },
            icon: Icon(
              forgotcontroller.showPassword.value
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      onChanged: (value) {},
      validator: (value) {
        if (value!.isEmpty) {
          return Texts.kEmailNullError;
        } else if (!Texts.emailValidatorRegExp.hasMatch(value)) {
          return Texts.kInvalidEmailError;
        }
        return null;
      },
      onSaved: (newValue) {
        forgotcontroller.setEmail(newValue!);
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 18.w),
        hintText: 'Enter your Email',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: Decorations.InputFieldBorder(),
        focusedBorder: Decorations.InputFieldFocusBorder(),
      ),
    );
  }

  Widget buildConFormField() {
    return Obx(
      () => TextFormField(
        onChanged: forgotcontroller.setConfirmPassword,
        obscureText: !forgotcontroller.showConfirmPassword.value,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.h, vertical: 18.w),
          hintText: 'Enter your Confirm Password',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: Decorations.InputFieldBorder(),
          focusedBorder: Decorations.InputFieldFocusBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              forgotcontroller.toggleShowConfirmPassword();
            },
            icon: Icon(
              forgotcontroller.showConfirmPassword.value
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return Texts.kPassNullError;
          } else if (forgotcontroller.newpassword.value != value) {
            return Texts.kMatchPassError;
          }
          return null;
        },
      ),
    );
  }
}
