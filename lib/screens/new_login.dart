import 'package:attendance/screens/home/home_screen.dart';
import 'package:attendance/screens/register_screen/Register_Screen.dart';
import 'package:flutter/material.dart';
//import 'package:smartboard/screens/home/home_screen.dart';
 
//import 'package:smartboard/screens/register_screen/register_screen.dart';
//import 'package:smartboard/screens/varification_screen/varify.dart';
 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

   String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    final RegExp emailRegExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return ' يرجي كتابه البريد الإلكتروني بشكل صحيح  ';
    }
    return null;
  }

   String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  GlobalKey<FormState> formkey = GlobalKey();

    bool  showpassword=true;

  @override
  Widget build(BuildContext context) {
    
    return Directionality(
     textDirection: TextDirection.rtl,
        child:  Scaffold(
    //  appBar: AppBar(
        backgroundColor: Colors.white,
     // ),
      body: Padding(
        //padding: const EdgeInsets.all(18.0),
        padding: const EdgeInsets.fromLTRB(25, 110, 25, 0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //Text(
                   // 'تسجيل الدخول',
                    //style: TextStyle(
                      //fontSize: 30.0,
                     // fontWeight: FontWeight.bold,
                   // ),
                 // ),
                 Center(
                        child:
                       SizedBox(
                        height: 250,
                        width: 250,
                        child: Image.asset('assets/images/splash.png'),
                      ),
                      ),


                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (String value) {
                      // print(value);
                    },
                    onChanged: (String value) {
                      // print(value);
                    },
                    //validator: (value) {
                      ////////////////////erroe
                    //  if (value!.isEmpty) {
                      //  return 'يجب كتابه عنوان البريد الالكترونى';
                     // }

                   // },
                    validator: _validateEmail ,
                  
                    decoration: const InputDecoration(
                      labelText: 'عنوان البريد الالكترونى',
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      border: 
                      //OutlineInputBorder(),
                       OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText:showpassword,

                    onFieldSubmitted: (String value) {
                      // print(value);
                    },
                    onChanged: (String value) {
                      // print(value);
                    },
                  //  validator: (value) {
                      /////////////////////////////error
                    ////  if (value!.isEmpty) {
                       // return 'يجب كتابه كلمه المرور';
                      //}

                   // },
                   validator: _validatePassword,
                    decoration: InputDecoration(
                      labelText: 'كلمه المرور',
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                       suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showpassword = !showpassword;
                                 
                              });
                            },
                            icon: showpassword
                                ? const Icon(Icons.visibility_off)
                                : const Icon(
                                    Icons.visibility,
                                  ),
                          ),
                    //  suffixIcon: Icon(
                  //   Icons.remove_red_eye,
                    //  ),
                      border: 
                      //OutlineInputBorder(),
                       const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                    ),
                  ),
                  
                 
                      Padding(
                       padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: SizedBox(
                        // height: 50,
                        width: double.infinity,
                        //padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        //color: Color(0xFF536DFE),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        
                          child: Material(
                            elevation: 5,
                           // color: Color(0xFF508AFF),
                            color: const Color(0xff2e386b),
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            child: MaterialButton(
                               onPressed: () {
                      if (formkey.currentState!.validate())
                       {
                        formkey.currentState!.save();
                        // print(emailController.text);
                        // print(passwordController.text);

                        var router =  MaterialPageRoute(
                      builder: (BuildContext context) =>const HomeScreens(),
                    );
                    //can back for previos page
                    Navigator.of(context).pushReplacement(router);
                      }
                
                      },
                              minWidth: 50,
                              height: 20,
                              child: const Text(
                                   'تسجيل دخول ' ,
                                style: TextStyle(
                                   // fontFamily: 'Keyan Coffee',
                                    color: Colors.white,
                                    fontSize: 18,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ليس لديك حساب ؟',
                         style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            ),
                      ),
                    //  const SizedBox(
                       // width: 5.0,
                     // ),
                      TextButton(
                        onPressed: () {
                            setState(() {
                    var router =  MaterialPageRoute(
                      builder: (BuildContext context) =>const Register_screen(),
                    );
                    //can back for previos page
                    Navigator.of(context).push(router);
                  
                  });

                        },
                        child: const Text(
                          'سجل الان',
                          style: TextStyle(
                          //  color: Colors.teal,
                           color: Color.fromARGB(255, 13, 73, 194),
                            fontSize: 17,
                            ),
                        ),
                      ),
                    ],
                  ),
                   

                        Center(
                            child: TextButton(
                              
                               onPressed: () {
                              setState(() {
                                 var router =  MaterialPageRoute(
                                  builder: (BuildContext context) =>const Register_screen(),
                               );
                                                  //can back for previos page
                               Navigator.of(context).push(router);
                                                
                               });
                              },
                            child: const Text(
                                'نسيت كلمه المرور؟'        ,
                            style: TextStyle(
                            //  color: Color.fromARGB(255, 6, 66, 60),
                             // color: Color(0xff2e386b),
                               //color: Colors.blue,
                                color: Color.fromARGB(255, 13, 73, 194),
                              fontSize: 17,
                              //fontWeight: FontWeight.bold
                              ),
                                                    ),
                                                  ),
                         ),

                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
