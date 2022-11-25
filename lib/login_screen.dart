import 'package:animation_login/animation_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtboard;

  final focusPass = FocusNode();

  late RiveAnimationController idleController;
  late RiveAnimationController handsUpController;
  late RiveAnimationController handsDownController;
  late RiveAnimationController succesController;
  late RiveAnimationController failController;
  late RiveAnimationController lookDownRightController;
  late RiveAnimationController lookDownLeftController;

  @override
  void initState() {
    super.initState();

    idleController = SimpleAnimation(AnimationEmun.idle.name);
    handsUpController = SimpleAnimation(AnimationEmun.Hands_up.name);
    handsDownController = SimpleAnimation(AnimationEmun.hands_down.name);
    succesController = SimpleAnimation(AnimationEmun.success.name);
    failController = SimpleAnimation(AnimationEmun.fail.name);
    lookDownRightController =
        SimpleAnimation(AnimationEmun.Look_down_right.name);
    lookDownLeftController = SimpleAnimation(AnimationEmun.Look_down_left.name);

    rootBundle.load('assets/animation/animated_login.riv').then(
      (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(idleController);
        setState(
          () {
            riveArtboard = artboard;
          },
        );
      },
    );
    checkPasswordFocus();
  }

  bool isLookingLeft = false;
  bool isLookingRight = false;

  removeAllController() {
    riveArtboard?.artboard.removeController(idleController);
    riveArtboard?.artboard.removeController(handsUpController);
    riveArtboard?.artboard.removeController(handsDownController);
    riveArtboard?.artboard.removeController(succesController);
    riveArtboard?.artboard.removeController(failController);
    riveArtboard?.artboard.removeController(lookDownRightController);
    riveArtboard?.artboard.removeController(lookDownLeftController);

    isLookingLeft = false;
    isLookingRight = false;
  }

  addIdleController() {
    removeAllController();
    riveArtboard?.artboard.addController(idleController);
  }

  addHandsUpController() {
    removeAllController();
    riveArtboard?.artboard.addController(handsUpController);
  }

  addHandsDownController() {
    removeAllController();
    riveArtboard?.artboard.addController(handsDownController);
  }

  addSuccesController() {
    removeAllController();
    riveArtboard?.artboard.addController(succesController);
  }

  addFailController() {
    removeAllController();
    riveArtboard?.artboard.addController(failController);
  }

  addLookDownRightController() {
    removeAllController();
    riveArtboard?.artboard.addController(lookDownRightController);
    isLookingRight = true;
  }

  addLookDownLeftController() {
    removeAllController();
    riveArtboard?.artboard.addController(lookDownLeftController);
    isLookingLeft = true;
  }

  checkPasswordFocus() {
    focusPass.addListener(
      () {
        if (focusPass.hasFocus) {
          addHandsUpController();
        } else if (!focusPass.hasFocus) {
          addHandsDownController();
        }
      },
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  validate() {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (formKey.currentState!.validate()) {
          addSuccesController();
        } else {
          addFailController();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 3.3,
                child: riveArtboard == null
                    ? const SizedBox.shrink()
                    : Rive(artboard: riveArtboard!),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                      validator: (value) =>
                          value != 'mohamedhussein529@outlook.com'
                              ? 'Wrong Email'
                              : null,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            value.length < 16 &&
                            !isLookingLeft) {
                          addLookDownLeftController();
                        } else if (value.isNotEmpty &&
                            value.length > 16 &&
                            !isLookingRight) {
                          addLookDownRightController();
                        }
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                      validator: (value) =>
                          value != '123456' ? 'Wrong Password' : null,
                      focusNode: focusPass,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 18,
                      child: MaterialButton(
                        onPressed: () {
                          focusPass.unfocus();
                          validate();
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
