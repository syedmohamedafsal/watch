import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class DetailPage extends StatefulWidget {
  final String modelPath;
  final String watchName;
  final String price;
  final String description;

  const DetailPage({
    super.key,
    required this.modelPath,
    required this.watchName,
    required this.price,
    required this.description,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  final GlobalKey _cartIconKey = GlobalKey();
  final GlobalKey _modelViewerKey = GlobalKey();
  bool _cartHasItem = false;

  late final AnimationController _cartScaleController;
  late final Animation<double> _cartScaleAnimation;

  late final AnimationController _contentAnimationController;

  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleOffset;

  late final Animation<double> _featuresOpacity;
  late final Animation<Offset> _featuresOffset;

  late final Animation<double> _descOpacity;
  late final Animation<Offset> _descOffset;

  @override
  void initState() {
    super.initState();
    _cartScaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _cartScaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _cartScaleController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    // Content Animation Controller for staggered animation
    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Title Animation: fade in & slide up
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _titleOffset =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Features Animation: fade in & slide up, after title
    _featuresOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );
    _featuresOffset =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    // Description & buttons Animation: fade in & slide up, last
    _descOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );
    _descOffset =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start the content animation on page load
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _cartScaleController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  void _runFlyToCartAnimation() async {
    final overlay = Overlay.of(context);

    final modelBox =
        _modelViewerKey.currentContext!.findRenderObject() as RenderBox;
    final cartBox =
        _cartIconKey.currentContext!.findRenderObject() as RenderBox;

    final startOffset = modelBox.localToGlobal(Offset.zero);
    final endOffset = cartBox.localToGlobal(Offset.zero);

    final boundary = _modelViewerKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final imageBytes = byteData!.buffer.asUint8List();

    final entry = OverlayEntry(
      builder: (context) => _FlyingImageAnimation(
        imageBytes: imageBytes,
        startPosition: startOffset,
        endPosition: endOffset,
        onCompleted: () {
          _cartScaleController.forward().then((_) {
            _cartScaleController.reverse();
          });

          setState(() {
            _cartHasItem = true;
          });
        },
      ),
    );

    overlay.insert(entry);
    await Future.delayed(const Duration(milliseconds: 900));
    entry.remove();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final String originalPrice = "\$6,999";

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFEDC174),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(CupertinoIcons.left_chevron,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      AnimatedBuilder(
                        animation: _cartScaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _cartScaleAnimation.value,
                            child: Stack(
                              key: _cartIconKey,
                              children: [
                                const Icon(CupertinoIcons.cart,
                                    color: Colors.white),
                                if (_cartHasItem)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: ui.Color.fromARGB(
                                            255, 232, 210, 45),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Title with animation
                SlideTransition(
                  position: _titleOffset,
                  child: FadeTransition(
                    opacity: _titleOpacity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 12),
                      child: Center(
                        child: Text(
                          widget.watchName,
                          style: GoogleFonts.aldrich(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFCEED5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Features with animation
                SlideTransition(
                  position: _featuresOffset,
                  child: FadeTransition(
                    opacity: _featuresOpacity,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFeatureIcon(
                              CupertinoIcons.drop_fill, "30m Water"),
                          _buildFeatureIcon(
                              CupertinoIcons.bluetooth, "Bluetooth"),
                          _buildFeatureIcon(
                              CupertinoIcons.battery_100, "Long Life"),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3D Model stays as is
                RepaintBoundary(
                  key: _modelViewerKey,
                  child: SizedBox(
                    height: screenSize.height * 0.35,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ModelViewer(
                        key: const Key('main_model_viewer'),
                        src: widget.modelPath,
                        alt: "Watch Model",
                        autoRotate: true,
                        cameraControls: true,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Description & Buttons with animation
                Expanded(
                  child: SlideTransition(
                    position: _descOffset,
                    child: FadeTransition(
                      opacity: _descOpacity,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(30)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.description,
                                  style: GoogleFonts.aldrich(
                                    fontSize: 14,
                                    color: const Color(0xFFEBD3A3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  originalPrice,
                                  style: GoogleFonts.aldrich(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  widget.price,
                                  style: GoogleFonts.aldrich(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFCEED5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEBD3A3),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    icon: const Icon(CupertinoIcons.cart,
                                        color: Colors.black),
                                    label: Text(
                                      "Add to Cart",
                                      style: GoogleFonts.aldrich(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: _runFlyToCartAnimation,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Builder(
                                  builder: (context) {
                                    return Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        icon: const Icon(
                                            CupertinoIcons.bag_fill,
                                            color: Colors.black),
                                        label: Text(
                                          "Buy Now",
                                          style: GoogleFonts.aldrich(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Thank you for choosing excellence — your order is being processed 🚚✨",
                                                style: GoogleFonts.aldrich(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.black87,
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
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
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFEBD3A3), size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.aldrich(
            color: const Color(0xFFFCEED5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _FlyingImageAnimation extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final Uint8List imageBytes;
  final VoidCallback onCompleted;

  const _FlyingImageAnimation({
    required this.startPosition,
    required this.endPosition,
    required this.imageBytes,
    required this.onCompleted,
  });

  @override
  State<_FlyingImageAnimation> createState() => _FlyingImageAnimationState();
}

class _FlyingImageAnimationState extends State<_FlyingImageAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward().whenComplete(widget.onCompleted);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final position = _positionAnimation.value;
        return Positioned(
          top: position.dy,
          left: position.dx,
          child: Opacity(
            opacity: 0.85,
            child: Image.memory(
              widget.imageBytes,
              width: 60,
              height: 60,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
