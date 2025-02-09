import 'package:stock_management/headers.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final control = Get.find<LoginController>();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.padh, vertical: Sizes.padv),
          child: SingleChildScrollView(
              child: GetBuilder<LoginController>(
                  init: control,
                  builder: (_) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sizeBox.TitlesizedBox(),
                        Text(
                          "Login",
                          style: TextWidgets.titleTextStyle(primaryColor),
                        ),
                        sizeBox.BodysizedBox(),
                        Text(
                          "Login to your account",
                          style: TextWidgets.bodyTextStyle(primaryColor),
                        ),
                        sizeBox.TitlesizedBox(),
                        buildEmailFormField(),
                        sizeBox.BodysizedBox(),
                        buildPasswordFormField(),
                        sizeBox.BodysizedBox(),
                        Row(
                          children: [
                            Checkbox(
                              value: control.remember.value,
                              activeColor: primaryColor,
                              onChanged: (value) {
                                control.setRemember(value!);
                              },
                            ),
                            const Text('Remember me '),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(MyGet.forgotPassword);
                              },
                              child: Text(
                                'Forget Password',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            // As We Know We come from Login Screen
                            debugPrint("PREVIOUS ROUTE ${Get.previousRoute}");
                            Get.toNamed(MyGet.singup);
                          },
                          child: Text(
                            'Register your account',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                        sizeBox.BodysizedBox(),
                        sizeBox.BodysizedBox(),
                        Buttons.CustomButton(
                          10.h,
                          10.w,
                          "Login",
                          () {
                            try {
                              if (formKey.currentState!.validate()) {
                                debugPrint(control.remember.value.toString());
                                if (control.remember.value == false) {
                                  // Show bottom sheet if remember me is not marked
                                  Get.bottomSheet(
                                      SubWidgets.BottomSheetDialog(context));
                                } else {
                                  formKey.currentState!.save();

                                  Api.login(control.email.value,
                                      control.password.value);
                                }
                              }
                            } catch (e) {
                              debugPrint("ERROR $e");
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
        onChanged: control.setPassword,
        obscureText: !control.showPassword.value,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.h, vertical: 18.w),
          hintText: 'Enter your Password',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: Decorations.InputFieldBorder(),
          focusedBorder: Decorations.InputFieldFocusBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              control.toggleShowPassword();
            },
            icon: Icon(
              control.showPassword.value
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
        control.setEmail(newValue!);
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
}
