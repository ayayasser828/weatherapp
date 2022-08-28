import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../bussiness_logic/register/register_cubit.dart';
import '../../constant/colors.dart';
import '../../constant/strings.dart';
import '../../constant/style.dart';
import '../widgets/loading_indecator.dart';
import '../widgets/text_button.dart';
import '../widgets/text_form_filed.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if(state is LoginLoading){
          LoadingScreen.show(context);
        }if(state is LoginError){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }if(state is LoginSuccess){
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, home, (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.h),
                    Center(
                        child: Text(
                      'Login',
                      style: headerStyle,
                    )),
                    SizedBox(height: 6.h),
                    Text(
                      'Email',
                      style: textFieldStyle,
                    ),
                    SizedBox(height: 1.h),
                    MyTextFormFieldWidget(
                      controller: email,
                      style:
                          const TextStyle(fontSize: 23, color: Colors.grey),
                      type: TextInputType.name,
                      validation: (v) {
                        if (v == '') {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      color: fieldColor,
                      isPass: false,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Password',
                      style: textFieldStyle,
                    ),
                    SizedBox(height: 1.h),
                    MyTextFormFieldWidget(
                      controller: password,
                      style:
                          const TextStyle(fontSize: 23, color: Colors.grey),
                      type: TextInputType.name,
                      validation: (v) {
                        if (v == '') {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      icon: IconButton(
                        onPressed: () {
                          BlocProvider.of<RegisterCubit>(context)
                              .changePasswordVisibility();
                        },
                        icon: BlocProvider.of<RegisterCubit>(context)
                            .suffix,
                      ),
                      color: fieldColor,
                      isPass: BlocProvider.of<RegisterCubit>(context)
                          .isPassword,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forget Password ?',
                          style: textStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    MyButtonWidget(
                        btnTxt: 'Login',
                        btnWidth: 100.w,
                        btnHeight: 6.h,
                        onPressed: () => _validate(context),
                        color: buttonColor,
                        borderColor: buttonColor,
                        weight: FontWeight.w600,
                        textSize: 14.sp,
                        textColor: whiteColor),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 0.1.h,
                          width: 40.w,
                          color: lineColor,
                        ),
                        Text(
                          'OR',
                          style: textFieldStyle,
                        ),
                        Container(
                          height: 0.1.h,
                          width: 40.w,
                          color: lineColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Center(
                        child: Text(
                      'If you dont have account',
                      style: textFieldStyle,
                    )),
                    SizedBox(height: 4.h),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, signup),
                      child: Container(
                        width: 100.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(color: buttonColor, width: 1.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: textButtonColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp),
                              ),
                              const Icon(
                                Icons.person_add_alt,
                                color: buttonColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _validate(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      // Navigator.pop(context);
      BlocProvider.of<RegisterCubit>(context)
          .userLogin(email.text, password.text);
    }
  }
}
