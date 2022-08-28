import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../bussiness_logic/register/register_cubit.dart';
import '../../constant/colors.dart';
import '../../constant/global_variables.dart';
import '../../constant/strings.dart';
import '../../constant/style.dart';
import '../widgets/text_button.dart';
import '../widgets/text_form_filed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key,this.acc}) : super(key: key);

  final acc;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController text = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<RegisterCubit>(context).getUserData(prefs.getString('token')!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {},
      builder: (context, state) {
        return DefaultTabController(
            initialIndex: widget.acc == true ? 1 : 0,
            length: 2,
            child: Scaffold(
              backgroundColor: whiteColor,
              appBar: AppBar(
                backgroundColor: textColor,
                leading: IconButton(
                  onPressed: () {
                    prefs.setBool("ISLOGGED", false);
                    prefs.setString('token', '');
                    Navigator.pushNamedAndRemoveUntil(
                            context, login, (route) => false);
                  },
                  icon: const Icon(Icons.logout,color: Colors.red,),
                ),
                bottom: TabBar(
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        'Home',
                        style: headerStyle.copyWith(color: Colors.white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Profile',
                        style: headerStyle.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButtonWidget(
                          btnTxt: 'Current location on map',
                          btnWidth: 90.w,
                          btnHeight: 6.h,
                          onPressed: () => Navigator.pushNamed(context, map),
                          color: buttonColor,
                          borderColor: buttonColor,
                          weight: FontWeight.w600,
                          textSize: 14.sp,
                          textColor: whiteColor),
                      SizedBox(height: 4.h),
                      MyButtonWidget(
                          btnTxt: 'add manually location',
                          btnWidth: 90.w,
                          btnHeight: 6.h,
                          onPressed: () => Navigator.pushNamed(context, city),
                          color: whiteColor,
                          borderColor: buttonColor,
                          weight: FontWeight.w600,
                          textSize: 14.sp,
                          textColor: buttonColor),
                    ],
                  ),
                  profile()
                ],
              ),
            ));
      },
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController email = TextEditingController();
  final TextEditingController fName = TextEditingController();
  final TextEditingController lName = TextEditingController();

  Widget profile() {
    return SingleChildScrollView(
      child: ConditionalBuilder(
        condition: BlocProvider.of<RegisterCubit>(context).userModel != null,
        builder: (context) {
          var model = BlocProvider.of<RegisterCubit>(context).userModel;
          email.text = model!.email!;
          fName.text = model.fName!;
          lName.text = model.lName!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
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
                        return 'please enter your email';
                      }
                      return null;
                    },
                    color: fieldColor,
                    isPass: false,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'First Name',
                    style: textFieldStyle,
                  ),
                  SizedBox(height: 1.h),
                  MyTextFormFieldWidget(
                    controller: fName,
                    style:
                    const TextStyle(fontSize: 23, color: Colors.grey),
                    type: TextInputType.name,
                    validation: (v) {
                      if (v == '') {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    color: fieldColor,
                    isPass: false,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Last Name',
                    style: textFieldStyle,
                  ),
                  SizedBox(height: 1.h),
                  MyTextFormFieldWidget(
                    controller: lName,
                    style:
                    const TextStyle(fontSize: 23, color: Colors.grey),
                    type: TextInputType.name,
                    validation: (v) {
                      if (v == '') {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    color: fieldColor,
                    isPass: false,
                  ),
                  SizedBox(height: 4.h),
                  ConditionalBuilder(
                    condition: BlocProvider.of<RegisterCubit>(context).state != UpdateUserLoading(),
                    fallback: (context) => const Center(child: LinearProgressIndicator()),
                    builder: (context) => MyButtonWidget(
                        btnTxt: 'Edit',
                        btnWidth: 100.w,
                        btnHeight: 6.h,
                        onPressed: () => _validate(context),
                        color: buttonColor,
                        borderColor: buttonColor,
                        weight: FontWeight.w600,
                        textSize: 14.sp,
                        textColor: whiteColor),
                  ),
                ],
              ),
            ),
          );
        },
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _validate(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      BlocProvider.of<RegisterCubit>(context).updateUser(
          email.text, fName.text, lName.text);
    }
  }
}
