import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CardLayout(),
    );
  }
}

class CardLayout extends StatefulWidget {
  @override
  _CardLayoutState createState() => _CardLayoutState();
}

class _CardLayoutState extends State<CardLayout> with SingleTickerProviderStateMixin {
  List<String> imageOptions = [
    'assets/card/cups/Cups01.jpg',
    'assets/card/cups/Cups02.jpg',
    'assets/card/cups/Cups03.jpg',
    'assets/card/cups/Cups04.jpg',
    'assets/card/cups/Cups05.jpg',
    'assets/card/cups/Cups06.jpg',
    'assets/card/cups/Cups07.jpg',
    'assets/card/cups/Cups08.jpg',
    'assets/card/cups/Cups09.jpg',
    'assets/card/cups/Cups10.jpg',
    'assets/card/cups/Cups11.jpg',
    'assets/card/cups/Cups12.jpg',
    'assets/card/cups/Cups13.jpg',
    'assets/card/cups/Cups14.jpg',
  ];
  List<String?> selectedImages = [null, null, null, null, null, null, null];
  bool showColorPicker = false;
  int? selectedIndex;

  late AnimationController _animationController;
  late Animation<Offset> _animationOffset;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationOffset = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("카드 레이아웃"),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/bg/bg1.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildSelectableArea(1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSelectableArea(5),
                    _buildSelectableArea(6),
                  ],
                ),
                _buildSelectableArea(7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSelectableArea(3),
                    _buildSelectableArea(2),
                  ],
                ),
                _buildSelectableArea(4),
              ],
            ),
          ),
          if (showColorPicker) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => showColorPicker = false),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            _buildColorOptions(),
          ]
        ],
      ),
      // bottomNavigationBar: BottomAppBar(color: Colors.white24),
    );
  }

  Widget _buildSelectableArea(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showColorPicker = true;
          selectedIndex = index;
          _animationController.forward(from: 0);
        });
      },
      child: Container(
        width: 80,
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24, width: 2),
          image: selectedImages[index - 1] != null
              ? DecorationImage(
            image: AssetImage(selectedImages[index - 1]!),
            fit: BoxFit.cover,
          )
              : null,
          color: selectedImages[index - 1] == null
              ? Colors.grey.withOpacity(0.5)
              : null,
        ),
        child: Center(
          child: Text('$index'),
        ),
      ),
    );
  }

  Widget _buildColorOptions() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SlideTransition(
            position: _animationOffset,
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageOptions.length,
                itemBuilder: (context, position) {
                  bool isSelected = selectedImages[selectedIndex! - 1] ==
                      imageOptions[position];
                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        setState(() {
                          selectedImages[selectedIndex! - 1] = null;
                          showColorPicker = false;
                        });
                      } else if (!selectedImages.contains(imageOptions[position])) {
                        setState(() {
                          selectedImages[selectedIndex! - 1] = imageOptions[position];
                          showColorPicker = false;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 80,
                        height: 140,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imageOptions[position]),
                            fit: BoxFit.cover,
                            colorFilter: selectedImages.contains(imageOptions[position])
                                ? ColorFilter.mode(
                              Colors.black.withOpacity(isSelected ? 0 : 0.5),
                              BlendMode.srcOver,
                            )
                                : null,
                          ),
                          border: isSelected
                              ? Border.all(color: Colors.red, width: 3)
                              : null,
                        ),
                        child: Center(
                          child: selectedImages.contains(imageOptions[position])
                              ? (isSelected
                              ? null
                              : Icon(Icons.block, color: Colors.white, size: 40))
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
