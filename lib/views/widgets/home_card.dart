import 'package:flutter/material.dart';

class HomeButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const HomeButton({Key? key, required this.icon, required this.label, required this.onTap}) : super(key: key);

  @override
  _HomeButtonState createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.95).animate(_controller),
        child: Container(
          width: MediaQuery.of(context).size.width / 2.35,
          height: 210,
          decoration: BoxDecoration(
            color: Color.fromRGBO(28, 90, 64, 0.03),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color.fromRGBO(28, 90, 64, 0.07)),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 8,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Icon(widget.icon, size: 40, color: Color.fromRGBO(28, 90, 64, 1)),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14,0,0,0),
                          child: Text(
                            widget.label.split(' ')[0],
                            style: TextStyle(fontSize: 16, color: Color.fromRGBO(28, 90, 64, 1)),
                          ),
                        ),
                        Spacer(), // Spacer to push the arrow to the extreme right
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_forward, color: Color.fromRGBO(28, 90, 64, 1)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14,0,0,8),
                      child: Text(
                        widget.label.split(' ')[1],
                        style: TextStyle(fontSize: 16, color: Color.fromRGBO(28, 90, 64, 1)),
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
