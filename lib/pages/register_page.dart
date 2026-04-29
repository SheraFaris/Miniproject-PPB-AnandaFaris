import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';
import 'package:trial1/components/my_button.dart';
import 'package:trial1/components/my_textfield.dart';
import 'package:trial1/components/square_tile.dart';

class RegisterPage extends StatefulWidget{
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Text control
  final emailController  = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //Sign up
  void signUserUp() async { 
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try{
      if(passwordController == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text,
        );
      } else {
        showErrorMessage("Password incorrect");
      }
      Navigator.pop(context);      
    } on FirebaseAuthException catch (e){
      Navigator.pop(context);

      //show errot message
      showErrorMessage(e.code);
    }
  }
  
  void showErrorMessage(String message){
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25,),
              
                // Logo
                Icon(            
                  Icons.lock,
                  size: 50,
                ),
                
                const SizedBox(height: 25,),
                
                // Welcome, User!
                Text(
                  'Create new account, User!', 
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
            
                const SizedBox(height: 25),
                
                // Username
                MyTextfield(
                  controller: emailController,
                  hintText: 'Username',
                  obscureText: false,
                ),
            
                const SizedBox(height: 25),
            
                // Password 
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
            
                // Confirm Password 
                MyTextfield(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 25),
                
                // Sign up button
                MyButton(
                  text: "Sign Up",
                  onTap: signUserUp,
                ),
            
                const SizedBox(height: 50),
                
                // Or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.green,
                        ),
                      ),
                  
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'or Continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
            
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                
            
                const SizedBox(height: 50),
                
                // google/apple member
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    //google button
                    SquareTile(imagePath: 'lib/image/google.png'),
                    
                    SizedBox(width: 25),
            
                    //apple button
                    SquareTile(imagePath: 'lib/image/apple.png'),
                  ],
                ),
            
                const SizedBox(height: 50),
            
                //not a member? register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
} 