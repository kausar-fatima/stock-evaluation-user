import 'package:stock_management/headers.dart';
import 'dart:async';

class OTPBody extends StatefulWidget {
  const OTPBody({super.key});

  @override
  State<OTPBody> createState() => _OTPBodyState();
}

class _OTPBodyState extends State<OTPBody> {
  // Add a timerDuration variable to manage the countdown
  int timerDuration = 60;
  Timer? _timer;
  final GlobalKey<OptFormState> _formKey =
      GlobalKey<OptFormState>(); // Use _OptFormState here

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (timerDuration == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          timerDuration--;
        });
      }
    });
  }

  void resetTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    setState(() {
      timerDuration = 60;
    });
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpController>();

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.padh, vertical: Sizes.padv),
          child: SingleChildScrollView(
            child: Column(
              children: [
                sizeBox.TitlesizedBox(),
                Text(
                  'OPT Verification',
                  style: TextWidgets.titleTextStyle(primaryColor),
                ),
                sizeBox.BodysizedBox(),
                Text('We sent OTP code at ${controller.email.value}'),
                Center(child: buildTimer()),
                sizeBox.TitlesizedBox(),
                OptForm(
                  key: _formKey,
                  email: controller.email.value,
                ),
                sizeBox.TitlesizedBox(),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Api.generateOTP(controller.email.value);
                      setState(() {
                        resetTimer();
                        _formKey.currentState?.resetFields();
                      });
                    },
                    child: Text(
                      'Resend OTP Code',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('This code expires in '),
        Text(
          '00:${timerDuration.toString().padLeft(2, '0')}',
          style: TextStyle(color: Colors.red), // Adjust color as needed
        ),
      ],
    );
  }
}
