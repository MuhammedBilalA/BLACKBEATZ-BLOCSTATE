import 'package:action_slider/action_slider.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/core/widgets/snackbar.dart';
import 'package:black_beatz/presentation/navbar_screens/bottom_navigation_bar.dart';
import 'package:black_beatz/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userNameController = TextEditingController();
String userName = userNameController.text;
final formkey = GlobalKey<FormState>();

class WelcomeScreen2 extends StatelessWidget {
  const WelcomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/welcome2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  blackBeatzWelcomeScreen2(context),
                  marshMellowHoriz(context),
                  musicIsTheLanguageOfSoul(context),
                  namingFormField(),
                  redirectionText(),
                  const SizedBox(
                    height: 50,
                  ),
                  slideToConfirm(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text redirectionText() {
    return const Text(
      'By entering name you will be redirected to the app',
      style: TextStyle(
          color: whiteColor,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
          fontSize: 19,
          fontFamily: 'Peddana'),
    );
  }

  ActionSlider slideToConfirm(BuildContext context) {
    return ActionSlider.standard(
        backgroundColor: actionSliderBagroundColorDark,
        toggleColor: actionSliderToggleColor,
        icon: const Icon(
          Icons.navigate_next,
          color: whiteColor,
        ),
        successIcon: const Icon(
          Icons.check_rounded,
          color: whiteColor,
        ),
        failureIcon: const Icon(
          Icons.close_rounded,
          color: whiteColor,
        ),
        width: 250,
        actionThresholdType: ThresholdType.release,
        child: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Slide to Confirm',
            style: TextStyle(color: whiteColor),
          ),
        ),
        action: (controller) async {
          controller.loading(); //starts loading animation
          await Future.delayed(const Duration(seconds: 3));

          if (formkey.currentState!.validate()) {
            controller.success(); //starts success animation
            await Future.delayed(const Duration(seconds: 2));
            checkLogin(context);
          } else {
            await Future.delayed(const Duration(seconds: 1));
            controller.reset(); //resets the slider
          }
        });
  }

  Padding namingFormField() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 10),
      child: Form(
        key: formkey,
        child: TextFormField(
          style: const TextStyle(color: whiteColor),
          controller: userNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '         Please Enter Your Name';
            }
            return null;
          },
          decoration: InputDecoration(
              hoverColor: redColor,
              hintText: 'Enter Your Name',
              hintStyle: const TextStyle(color: whiteColor),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: yellowColor,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 14, top: 8, right: 25),
                child: FaIcon(
                  FontAwesomeIcons.userPen,
                  size: 27,
                  color: Color.fromARGB(205, 0, 0, 0),
                ),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              fillColor: whiteColor.withOpacity(.3),
              filled: true),
        ),
      ),
    );
  }

  Container musicIsTheLanguageOfSoul(BuildContext context) {
    return Container(
      height: 95,
      width: MediaQuery.of(context).size.width * 1,
      color: welcomeScreenContainerColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Spacer(),
              Text(
                'MUSIC IS THE LANGUAGE OF SOUL',
                style: TextStyle(
                    color: whiteColor,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    fontSize: 27,
                    fontFamily: 'Peddana',
                    height: 1),
              ),
              Spacer(
                flex: 5,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Spacer(flex: 5),
              Text(
                'A MUSIC PLAYER IS THE TRANSLATOR',
                style: TextStyle(
                    color: whiteColor,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    fontSize: 27,
                    fontFamily: 'Peddana',
                    height: 1),
              ),
              Spacer()
            ],
          ),
        ],
      ),
    );
  }

  ClipRRect marshMellowHoriz(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/images/marshmellowhorizondal.jpg',
        width: MediaQuery.of(context).size.width * 0.85,
      ),
    );
  }

  SizedBox blackBeatzWelcomeScreen2(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: Image.asset(
        'assets/images/blackbeatz.png',
        scale: 3.5,
      ),
    );
  }

  void checkLogin(BuildContext ctx) async {
    if (userName.isNotEmpty) {
      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setString(saveKeyName, userName);

      snackbarAdding(text: 'Login Successfully', context: ctx);

      Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(builder: ((ctx1) =>  NavBar())));
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: redColor,
          margin: EdgeInsets.all(10),
          content: Text('Enter username Properly')));
    }
  }
}
