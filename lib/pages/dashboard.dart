import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:watch/pages/detail_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _topFadeAnimation;
  late final Animation<Offset> _topSlideAnimation;

  late final Animation<double> _bottomFadeAnimation;
  late final Animation<Offset> _bottomSlideAnimation;

  late final Animation<double> _bottomBarFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Top section fades in and slides up
    _topFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _topSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Bottom info section fades in and slides up, delayed
    _bottomFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.85, curve: Curves.easeOut),
      ),
    );
    _bottomSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.85, curve: Curves.easeOut),
      ),
    );

    // Bottom navigation bar fade in last
    _bottomBarFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Split background (static, no animation)
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFFEDC174),
                      Color.fromARGB(255, 0, 0, 0),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Animated main content
          Column(
            children: [
              // Animate top 3D watch and UI
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _topFadeAnimation.value,
                    child: FractionalTranslation(
                      translation: _topSlideAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: SizedBox(
                  height: screenSize.height * 0.6,
                  child: Stack(
                    children: [
                      // Watch model
                      const Positioned(
                        top: 50,
                        left: 10,
                        child: SizedBox(
                          width: 450,
                          height: 500,
                          child: ModelViewer(
                            src: 'assets/model/chronograph_watch_mudmaster.glb',
                            alt: "Golden Watch",
                            autoRotate: false,
                            cameraControls: false,
                            backgroundColor: Colors.transparent,
                            cameraOrbit: '-320deg 110deg auto',
                          ),
                        ),
                      ),

                      // Add icon near belt
                      Positioned(
                        top: 410, // Adjust this to fine-tune position
                        left: 250, // Adjust to align with watch belt
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(184, 237, 193, 116),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.add,
                              size: 60,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 470,
                        left: 350,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.cart,
                              size: 30,
                              color: Colors.black,
                            ),
                            Positioned(
                              top: 4,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 245, 200, 121),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Logo
                      Positioned(
                        top: 60,
                        left: 24,
                        child: Text(
                          "GS",
                          style: GoogleFonts.aldrich(
                            color: const Color(0xFFFCEED5),
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      // Menu
                      const Positioned(
                        top: 70,
                        right: 24,
                        child: Icon(Icons.menu, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),

              // Animate bottom info section
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _bottomFadeAnimation.value,
                    child: FractionalTranslation(
                      translation: _bottomSlideAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Garner & Spruces",
                      style: GoogleFonts.aldrich(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFCEED5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Display a high-quality image of the watch",
                      style: GoogleFonts.aldrich(
                        color: const Color(0xFFFCEED5),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "\$4,999",
                      style: GoogleFonts.aldrich(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFCEED5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEBD3A3),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DetailPage(
                                  modelPath:
                                      'assets/model/chronograph_watch_mudmaster.glb',
                                  watchName: 'Garner & Spruces',
                                  price: '\$4,999',
                                  description:
                                      'This luxury timepiece redefines precision and elegance, blending classic craftsmanship with cutting-edge technology. Featuring both analog and digital displays, it offers the best of both worlds — timeless style and modern functionality. Built with military-grade protection, this watch withstands the harshest conditions while maintaining a sleek and sophisticated design. Whether you’re navigating the city or venturing into the wild, it ensures reliability, durability, and unmatched style.',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Buy now",
                            style: GoogleFonts.aldrich(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // Animate BottomAppBar fade in
      bottomNavigationBar: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _bottomBarFadeAnimation.value,
            child: child,
          );
        },
        child: BottomAppBar(
          color: Colors.black,
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
            height: screenSize.height * 0.1,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  CupertinoIcons.home,
                  color: Color(0xFFEBD3A3), // Active color (sandal shade)
                ),
                Icon(
                  CupertinoIcons.share,
                  color: Colors.white, // Inactive
                ),
                Icon(
                  CupertinoIcons.search,
                  color: Colors.white, // Inactive
                ),
                Icon(
                  CupertinoIcons.cart,
                  color: Colors.white, // Inactive
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
