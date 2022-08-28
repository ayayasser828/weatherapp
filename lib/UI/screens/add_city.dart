import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../constant/colors.dart';
import '../../constant/strings.dart';
import '../../constant/style.dart';
import '../widgets/text_button.dart';
import '../widgets/text_form_filed.dart';

class AddCityScreen extends StatelessWidget {
  AddCityScreen({Key? key}) : super(key: key);

  final TextEditingController city = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add City"),
        centerTitle: true,
        backgroundColor: textColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Text(
                  'Add Country',
                  style: textFieldStyle,
                ),
                SizedBox(height: 2.h),
                MyTextFormFieldWidget(
                  controller: city,
                  style:
                  const TextStyle(fontSize: 23, color: Colors.grey),
                  type: TextInputType.name,
                  validation: (v) {
                    if (v == '') {
                      return 'Please enter your country';
                    }
                    return null;
                  },
                  color: fieldColor,
                  isPass: false,
                ),
                SizedBox(height: 4.h),
                MyButtonWidget(
                    btnTxt: 'Get Weather',
                    btnWidth: 100.w,
                    btnHeight: 6.h,
                    onPressed: ()  {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      } else {
                        Navigator.pushNamed(context, weather,arguments: city.text);
                      }
                    },
                    color: buttonColor,
                    borderColor: buttonColor,
                    weight: FontWeight.w600,
                    textSize: 14.sp,
                    textColor: whiteColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
