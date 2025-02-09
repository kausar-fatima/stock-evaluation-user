import 'package:stock_management/headers.dart';

class OptForm extends StatefulWidget {
  const OptForm({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<OptForm> createState() => OptFormState();
}

class OptFormState extends State<OptForm> {
  final otpcontroller = Get.find<OTPController>();
  FocusNode? pin1FocusNode;
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;

  final TextEditingController pin1Controller = TextEditingController();
  final TextEditingController pin2Controller = TextEditingController();
  final TextEditingController pin3Controller = TextEditingController();
  final TextEditingController pin4Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    pin1FocusNode!.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin1Controller.dispose();
    pin2Controller.dispose();
    pin3Controller.dispose();
    pin4Controller.dispose();
    super.dispose();
  }

  void resetFields() {
    setState(() {
      pin1Controller.clear();
      pin2Controller.clear();
      pin3Controller.clear();
      pin4Controller.clear();
      Future.delayed(Duration(milliseconds: 100), () {
        if (pin1FocusNode != null) {
          pin1FocusNode!.requestFocus();
          print("Focus set to pin1FocusNode");
        }
      });
    });
  }

  void nextField({required String value, required FocusNode? focusNode}) {
    if (value.isNotEmpty) {
      if (focusNode == pin1FocusNode) {
        otpcontroller.setOTP(value);
      } else if (focusNode == pin2FocusNode &&
          otpcontroller.OTPvalue.value.isNotEmpty) {
        otpcontroller
            .setOTP(otpcontroller.OTPvalue.value.substring(0, 1) + value);
      } else if (focusNode == pin3FocusNode &&
          otpcontroller.OTPvalue.value.length >= 2) {
        otpcontroller
            .setOTP(otpcontroller.OTPvalue.value.substring(0, 2) + value);
      } else if (focusNode == pin4FocusNode &&
          otpcontroller.OTPvalue.value.length >= 3) {
        otpcontroller
            .setOTP(otpcontroller.OTPvalue.value.substring(0, 3) + value);
      }
      focusNode!.requestFocus();
    }
  }

  void backspace({required FocusNode? focusNode}) {
    if (otpcontroller.OTPvalue.value.isNotEmpty) {
      otpcontroller.setOTP(otpcontroller.OTPvalue.value
          .substring(0, otpcontroller.OTPvalue.value.length - 1));
      if (focusNode != null && focusNode.hasFocus) {
        focusNode.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OTPBox(pin1FocusNode, pin1Controller),
              OTPBox(pin2FocusNode, pin2Controller),
              OTPBox(pin3FocusNode, pin3Controller),
              SizedBox(
                width: 55.w,
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  controller: pin4Controller,
                  obscureText: true,
                  style: TextWidgets.bodyTextStyle(primaryColor),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 18.w),
                    focusedBorder: Decorations.InputFieldFocusBorder(),
                    //border: Decorations.InputFieldBorder(controller.errors),
                  ),
                  onChanged: (value) {
                    nextField(value: value, focusNode: pin4FocusNode);
                  },
                  onFieldSubmitted: (value) {
                    // Use the entered OTP when submitted
                    Api.verifyOTP(otpcontroller.OTPvalue.value, widget.email);
                  },
                ),
              ),
            ],
          ),
          sizeBox.TitlesizedBox(),
          Buttons.CustomButton(10.h, 10.w, "Continue", () {
            Api.verifyOTP(
                otpcontroller.OTPvalue.value, widget.email); // Use entered OTP
          }),
        ],
      ),
    );
  }

  SizedBox OTPBox(FocusNode? pinFocusNode, TextEditingController controller) {
    return SizedBox(
      width: 55.w,
      child: TextFormField(
        autofocus: true,
        obscureText: true,
        controller: controller,
        style: TextWidgets.bodyTextStyle(primaryColor),
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.h, vertical: 18.w),
          focusedBorder: Decorations.InputFieldFocusBorder(),
          //border: Decorations.InputFieldBorder(controller.errors),
        ),
        onChanged: (value) {
          nextField(value: value, focusNode: pinFocusNode);
        },
        onEditingComplete: () {
          pinFocusNode!.unfocus();
        },
      ),
    );
  }
}
