import 'package:stock_management/headers.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final controller = Get.find<SignUpController>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    debugPrint("controller.formState ${formKey}");
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.padh, vertical: Sizes.padv),
          child: SingleChildScrollView(
              child: GetBuilder<SignUpController>(
                  init: controller,
                  builder: (_) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sizeBox.TitlesizedBox(),
                        Text(
                          "Sign Up",
                          style: TextWidgets.titleTextStyle(primaryColor),
                        ),
                        sizeBox.BodysizedBox(),
                        Text(
                          "Create your account",
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
                            value: controller.remember.value,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              controller.setRemember(value!);
                            },
                          ),
                          const Text('Remember me '),
                        ]),
                        GestureDetector(
                          onTap: () {
                            // Get.back();

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
                          "Sign Up",
                          () {
                            try {
                              if (formKey.currentState!.validate()) {
                                debugPrint(
                                    controller.remember.value.toString());
                                if (controller.remember.value == false) {
                                  // Show bottom sheet if remember me is not marked
                                  Get.bottomSheet(
                                      SubWidgets.BottomSheetDialog(context));
                                } else {
                                  formKey.currentState!.save();
                                  var data = {
                                    "email": controller.email.value,
                                    "password": controller.password.value,
                                  };
                                  Api.addUser(data, controller.email.value);
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
        onChanged: controller.setPassword,
        obscureText: !controller.showPassword.value,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.h, vertical: 18.w),
          hintText: 'Enter your Password',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: Decorations.InputFieldBorder(),
          focusedBorder: Decorations.InputFieldFocusBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              controller.toggleShowPassword();
            },
            icon: Icon(
              controller.showPassword.value
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
        controller.setEmail(newValue!);
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
        onChanged: controller.setConfirmPassword,
        obscureText: !controller.showConfirmPassword.value,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.h, vertical: 18.w),
          hintText: 'Enter your Confirm Password',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: Decorations.InputFieldBorder(),
          focusedBorder: Decorations.InputFieldFocusBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              controller.toggleShowConfirmPassword();
            },
            icon: Icon(
              controller.showConfirmPassword.value
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return Texts.kPassNullError;
          } else if (controller.password.value != value) {
            return Texts.kMatchPassError;
          }
          return null;
        },
      ),
    );
  }
}
