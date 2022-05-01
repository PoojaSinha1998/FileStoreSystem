import 'package:flutter/material.dart';
import 'package:flutter_folder/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: ListView(
              children: <Widget>[

                SizedBox(height: 50,),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20),
                    )),
                Column(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),

                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Login'),
                          onPressed: () {
                            print(nameController.text);
                            print(passwordController.text);

                            addUserPass(nameController.text,passwordController.text);
                          },
                        )
                    ),
                    Row(
                      children: <Widget>[
                        const Text('Does not have account?'),
                        TextButton(
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            //signup screen
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),

              ],
            ),
          )),
    );
  }

  Future<void> addUserPass(String username, String password) async {
    SharedPreferences preferences;
    preferences = await SharedPreferences.getInstance();
    preferences.setString(Global.NAME,username);
    preferences.setString(Global.PASS, password);

    Navigator.of(context).pushReplacementNamed('homepage');

  }
}