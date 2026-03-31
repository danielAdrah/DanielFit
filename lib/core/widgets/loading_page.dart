// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import '../../features/home/home_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final List<String> _motivationalQuotes = [
    "Your body can stand almost anything.\nIt's your mind you have to convince.",
    "The only bad workout is the one that didn't happen.",
    "Success starts with self-discipline.",
    "Don't wish for it, work for it!",
    "Your fitness is what you do, not what you wish for.",
  ];

  int _currentQuoteIndex = 0;

  @override
  void initState() {
    super.initState();
    // Select a random quote on startup for variety
    _currentQuoteIndex =
        DateTime.now().millisecond % _motivationalQuotes.length;

    // Navigate to home page after
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Get.to(() => HomePage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset('assets/img/loading1.jpg', fit: BoxFit.cover),
            ),

            // Semi-transparent dark overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
              ),
            ),

            // Center content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.1),
                    Row(
                      children: [
                        FadeInLeft(
                          delay: Duration(milliseconds: 500),
                          duration: Duration(milliseconds: 900),
                          child: Image.asset(
                            "assets/img/leftlogo.png",
                            height: height * 0.35,
                            width: width * 0.5,
                          ),
                        ),
                        FadeInRight(
                          delay: Duration(milliseconds: 500),
                          duration: Duration(milliseconds: 900),
                          child: Image.asset(
                            "assets/img/rightlogo.png",
                            height: height * 0.3,
                            width: width * 0.35,
                          ),
                        ),
                      ],
                    ),

                    // Logo
                    const SizedBox(height: 50),

                    // Modern glassmorphic quote container with carousel effect
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ZoomIn(
                          duration: const Duration(milliseconds: 1000),
                          delay: const Duration(milliseconds: 600),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.09),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Decorative top line
                                Container(
                                  width: 60,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.red, Colors.redAccent],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Quote text with typewriter-style appearance
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Opening quote symbol
                                    FadeInUp(
                                      duration: const Duration(
                                        milliseconds: 800,
                                      ),
                                      delay: const Duration(milliseconds: 900),
                                      child: Text(
                                        '"',
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white.withOpacity(0.4),
                                          fontFamily: 'Poppins',
                                          height: 0.8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    // Actual quote text
                                    Expanded(
                                      child: FadeInUp(
                                        duration: const Duration(
                                          milliseconds: 1000,
                                        ),
                                        delay: const Duration(
                                          milliseconds: 1000,
                                        ),
                                        child: Text(
                                          _motivationalQuotes[_currentQuoteIndex],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white.withOpacity(
                                              0.95,
                                            ),
                                            letterSpacing: 0.8,
                                            fontFamily: "Montserrat",
                                            height: 1.6,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(
                                                  0.5,
                                                ),
                                                offset: const Offset(1, 1),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                // Decorative dots
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
