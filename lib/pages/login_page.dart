import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';
import 'package:trial1/components/my_button.dart';
import 'package:trial1/components/my_textfield.dart';
import 'package:trial1/components/square_tile.dart';

class LoginPage extends StatefulWidget{
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Text control
  final emailController  = TextEditingController();
  final passwordController = TextEditingController();

  //Sign in
  void signUserIn() async { 
    // Validasi input kosong
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorMessage("Please fill in all fields");
      return;
    }
    
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
      );
      
      // Close dialog only if widget is still mounted
      if (mounted) {
        Navigator.pop(context);
      }      
    } on FirebaseAuthException catch (e){
      // Close dialog only if widget is still mounted
      if (mounted) {
        Navigator.pop(context);
        //show error message
        showErrorMessage(e.code);
      }
    } catch (e) {
      // Catch any other unexpected errors
      if (mounted) {
        Navigator.pop(context);
        showErrorMessage("An unexpected error occurred: ${e.toString()}");
      }
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
                const SizedBox(height: 50,),
              
                // Logo
                Icon(            
                  Icons.lock,
                  size: 100,
                ),
                
                const SizedBox(height: 50,),
                
                // Welcome, User!
                Text(
                  'Welcome, User!', 
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
            
                const SizedBox(height: 25),
            
                // Forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 25),
                
                // Sign in button
                MyButton(
                  text: "Sign in",
                  onTap: signUserIn,
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
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register now',
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