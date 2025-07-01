import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Split background
          Row(
            children: [
              Container(
                width: screenSize.width * 0.5,
                height: screenSize.height,
                color: Colors.black,
              ),
              Container(
                width: screenSize.width * 0.5,
                height: screenSize.height,
                color: const Color(0xFFFCEED5),
              ),
            ],
          ),

          // Main Content
          Column(
            children: [
              // 3D Watch and Top UI
              SizedBox(
                height: screenSize.height * 0.6,
                child: Stack(
                  children: [
                    const Center(
                      child: ModelViewer(
                        src: 'assets/model/golden_watch.glb',
                        alt: "Golden Watch",
                        autoRotate: true,
                        cameraControls: true,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Positioned(
                      top: 32,
                      left: 24,
                      child: Text(
                        "GS",
                        style: GoogleFonts.playfairDisplay(
                          color: const Color(0xFFFCEED5),
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 32,
                      right: 24,
                      child: Icon(Icons.menu, color: Colors.black),
                    ),
                  ],
                ),
              ),

              // Bottom Info Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      height: screenSize.height * 0.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromARGB(0, 0, 0, 0),
                            Color.fromARGB(96, 0, 0, 0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Garner & Spruces",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Display a high-quality image of the watch",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "\$4,999",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEBD3A3),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Buy now",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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

              // Bottom Navigation
              Container(
                height: screenSize.height * 0.1,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Icon(Icons.home, color: Colors.white),
                    Icon(Icons.share, color: Colors.white),
                    Icon(Icons.search, color: Colors.white),
                    Icon(Icons.shopping_cart, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
