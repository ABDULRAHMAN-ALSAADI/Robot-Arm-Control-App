// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(RobotArmApp());
}

class RobotArmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Arm Control',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0D0D0D), // Darker black like the website
        scaffoldBackgroundColor: Color(0xFF0D0D0D),
        cardColor: Color(0xFF1A1A1A),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF0D0D0D),
          secondary: Color(0xFF1A1A1A),
          surface: Color(0xFF1A1A1A),
          background: Color(0xFF0D0D0D),
        ),
        // Apply font family through textTheme
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'SF Pro Display', // Modern clean font similar to the website
        ),
      ),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late AnimationController _wifiController;
  late Animation<double> _wifiAnimation;

  @override
  void initState() {
    super.initState();
    
    // Dots loading animation - repeats every 1.5 seconds
    _dotsController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    // WiFi up-down animation - repeats every 2 seconds
    _wifiController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _wifiAnimation = Tween<double>(begin: -3.0, end: 3.0).animate(
      CurvedAnimation(parent: _wifiController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _wifiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF0D0D0D), // Darker background like the website
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Status bar area
                Row(
                  children: [
                    Spacer(),
                    // Animated WiFi signal on the right
                    AnimatedBuilder(
                      animation: _wifiAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _wifiAnimation.value),
                          child: Icon(Icons.wifi, color: Colors.white, size: 20),
                        );
                      },
                    ),
                  ],
                ),
                
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Robot Icon (Just the icon, no background)
                      Icon(
                        Icons.precision_manufacturing_outlined, // 6-DOF robotic arm icon
                        size: 80,
                        color: Colors.white,
                      ),
                      
                      SizedBox(height: 40),
                      
                      // Title Text
                      Text(
                        'Arm Control',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600, // Semi-bold like the website
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: -0.5, // Tight letter spacing for modern look
                          fontFamily: 'SF Pro Display', // Apply font family directly to TextStyle
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'System',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: -0.5,
                          fontFamily: 'SF Pro Display', // Apply font family directly to TextStyle
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 60),
                      
                      // Start Button
                      Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      ControlPanelScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: animation.drive(
                                        Tween(begin: Offset(1.0, 0.0), end: Offset.zero),
                                      ),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Center(
                              child: Text(
                                'START',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 80),
                      
                      // Animated three dots indicator
                      AnimatedBuilder(
                        animation: _dotsController,
                        builder: (context, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              // Calculate the delay for each dot
                              double delay = index * 0.33;
                              double animationValue = (_dotsController.value - delay) % 1.0;
                              
                              // Create a bounce effect for each dot
                              double opacity = 0.3;
                              if (animationValue >= 0 && animationValue <= 0.33) {
                                opacity = 0.3 + (animationValue * 3) * 0.7;
                              } else if (animationValue > 0.33 && animationValue <= 0.66) {
                                opacity = 1.0 - ((animationValue - 0.33) * 3) * 0.7;
                              }
                              
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(opacity),
                                  shape: BoxShape.circle,
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Version info at bottom
                Text(
                  'v0.1 | AA Co.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ControlPanelScreen extends StatefulWidget {
  @override
  _ControlPanelScreenState createState() => _ControlPanelScreenState();
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {
  List<double> motorValues = [90, 90, 90, 90, 90, 90];
  TextEditingController moveNameController = TextEditingController();
  List<RobotMove> savedMoves = [];
  bool isLoading = false;
  bool isRunning = false;
  Timer? _statusTimer;

  // Replace with your actual server URL
  final String baseUrl = 'http://192.168.100.5/robot_control';

  @override
  void initState() {
    super.initState();
    loadSavedMoves();
    checkRobotStatus();
    // Check robot status every 3 seconds to sync with website
    _statusTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkRobotStatus();
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  Future<void> loadSavedMoves() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$baseUrl/robot_control.php?action=list'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            savedMoves = (data['moves'] as List).map((move) => RobotMove.fromJson(move)).toList();
          });
        }
      }
    } catch (e) {
      print('Error loading moves: $e');
    }
    setState(() => isLoading = false);
  }

  Future<void> checkRobotStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/status.php'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            isRunning = data['status'] == 1;
          });
        }
      }
    } catch (e) {
      // Silently handle connection errors during status check
    }
  }

  Future<void> saveMove() async {
    if (moveNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter a move name', Color(0xFFDC3545)); // Bright red
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/robot_control.php?action=save'),
        body: {
          'move_name': moveNameController.text.trim(),
          'motor1': motorValues[0].round().toString(),
          'motor2': motorValues[1].round().toString(),
          'motor3': motorValues[2].round().toString(),
          'motor4': motorValues[3].round().toString(),
          'motor5': motorValues[4].round().toString(),
          'motor6': motorValues[5].round().toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          _showSnackBar('Move saved successfully!', Color(0xFF28A745)); // Bright green
          moveNameController.clear();
          loadSavedMoves();
        } else {
          _showSnackBar(data['message'] ?? 'Error saving move', Color(0xFFDC3545));
        }
      }
    } catch (e) {
      _showSnackBar('Error saving move', Color(0xFFDC3545));
    }
  }

  Future<void> runMove() async {
    try {
      setState(() => isRunning = true);
      final response = await http.post(
        Uri.parse('$baseUrl/get_run_pose.php'),
        body: {
          'motor1': motorValues[0].round().toString(),
          'motor2': motorValues[1].round().toString(),
          'motor3': motorValues[2].round().toString(),
          'motor4': motorValues[3].round().toString(),
          'motor5': motorValues[4].round().toString(),
          'motor6': motorValues[5].round().toString(),
          'ajax': 'true',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          _showSnackBar('Move executed!', Color(0xFF28A745)); // Bright green
        } else {
          _showSnackBar(data['message'] ?? 'Error running move', Color(0xFFDC3545)); // Bright red
        }
      }
    } catch (e) {
      _showSnackBar('Error running move', Color(0xFFDC3545)); // Bright red
    }
    setState(() => isRunning = false);
  }

  Future<void> stopMove() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_status.php'),
        body: {'ajax': 'true'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          _showSnackBar('Robot stopped', Color(0xFFFF8C00)); // Orange
          setState(() => isRunning = false);
        } else {
          _showSnackBar(data['message'] ?? 'Error stopping robot', Color(0xFFDC3545)); // Bright red
        }
      }
    } catch (e) {
      _showSnackBar('Error stopping robot', Color(0xFFDC3545)); // Bright red
    }
  }

  void resetMotors() {
    setState(() {
      motorValues = [90, 90, 90, 90, 90, 90];
    });
    _showSnackBar('Motors reset to 90°', Color(0xFF007BFF)); // Bright blue
  }

  void loadMove(RobotMove move) {
    setState(() {
      motorValues = [
        move.motor1.toDouble(),
        move.motor2.toDouble(),
        move.motor3.toDouble(),
        move.motor4.toDouble(),
        move.motor5.toDouble(),
        move.motor6.toDouble(),
      ];
      moveNameController.text = move.moveName;
    });
    _showSnackBar('Move "${move.moveName}" loaded', Color(0xFF28A745)); // Bright green
  }

  Future<void> deleteMove(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/robot_control.php?action=delete'),
        body: {'id': id.toString()},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          _showSnackBar('Move deleted', Color(0xFFFF8C00)); // Orange
          loadSavedMoves();
        } else {
          _showSnackBar(data['message'] ?? 'Error deleting move', Color(0xFFDC3545)); // Bright red
        }
      }
    } catch (e) {
      _showSnackBar('Error deleting move', Color(0xFFDC3545)); // Bright red
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Robot Arm Control'),
            SizedBox(width: 10),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRunning ? Color(0xFF28A745) : Color(0xFFDC3545), // Bright green/red
                boxShadow: [
                  BoxShadow(
                    color: isRunning ? Color(0xFF28A745) : Color(0xFFDC3545), // Bright green/red
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            SizedBox(width: 5),
            Text(
              isRunning ? 'RUNNING' : 'STOPPED',
              style: TextStyle(
                fontSize: 12,
                color: isRunning ? Color(0xFF2E7D32) : Color(0xFF8B0000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF0D0D0D), // Darker background
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0D0D0D), // Darker background
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Motor Controls
              Text(
                'Motor Controls',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600, // Modern semi-bold
                  color: Colors.white,
                  letterSpacing: -0.3,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              SizedBox(height: 20),
              
              ...List.generate(6, (index) => _buildMotorSlider(index)),
              
              SizedBox(height: 30),
              
              // Move Name Input
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A), // Slightly lighter for contrast
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xFF2A2A2A)),
                ),
                child: TextField(
                  controller: moveNameController,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SF Pro Display',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter move name',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'SF Pro Display',
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                    prefixIcon: Icon(Icons.edit, color: Color(0xFF555555)),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Control Buttons
              Row(
                children: [
                  Expanded(child: _buildControlButton('Reset', Icons.refresh, resetMotors, Color(0xFFFF8C00))), // Orange
                  SizedBox(width: 10),
                  Expanded(child: _buildControlButton('Save', Icons.save, saveMove, Color(0xFF28A745))), // Bright green
                  SizedBox(width: 10),
                  Expanded(child: _buildControlButton(
                    isRunning ? 'Running...' : 'Run', 
                    Icons.play_arrow, 
                    isRunning ? null : runMove, 
                    Color(0xFF007BFF) // Bright blue
                  )),
                  SizedBox(width: 10),
                  Expanded(child: _buildControlButton('Stop', Icons.stop, stopMove, Color(0xFFDC3545))), // Bright red
                ],
              ),
              
              SizedBox(height: 30),
              
              // Saved Moves
              Text(
                'Saved Moves',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600, // Modern semi-bold
                  color: Colors.white,
                  letterSpacing: -0.3,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              SizedBox(height: 20),
              
              if (isLoading)
                Center(child: CircularProgressIndicator(color: Color(0xFF333333)))
              else if (savedMoves.isEmpty)
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Color(0xFF2A2A2A)),
                  ),
                  child: Text(
                    'No saved moves yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600], 
                      fontSize: 16,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                )
              else
                ...savedMoves.map((move) => _buildMoveCard(move)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMotorSlider(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A), // Slightly lighter containers
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Motor ${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17, // Slightly larger for better readability
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF141414), // Darker container for value
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFF2A2A2A)),
                ),
                child: Text(
                  '${motorValues[index].round()}°',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600, // Semi-bold for emphasis
                    letterSpacing: -0.1,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Color(0xFF333333),
              inactiveTrackColor: Color(0xFF1A1A1A),
              thumbColor: Color(0xFF666666),
              overlayColor: Color(0xFF333333).withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: motorValues[index],
              min: 0,
              max: 180,
              divisions: 180,
              onChanged: (value) {
                setState(() {
                  motorValues[index] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(String text, IconData icon, VoidCallback? onPressed, Color color) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: onPressed != null ? color : Color(0xFF2A2A2A), // Darker disabled state
        border: Border.all(color: Color(0xFF3A3A3A), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                SizedBox(width: 5),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600, // Semi-bold
                    fontSize: 13,
                    letterSpacing: -0.1,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoveCard(RobotMove move) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A), // Consistent with other containers
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  move.moveName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20, // Larger for better hierarchy
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.play_arrow, color: Color(0xFF007BFF)), // Bright blue
                    onPressed: () => loadMove(move),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Color(0xFFDC3545)), // Bright red
                    onPressed: () => deleteMove(move.id),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              _buildMotorTag('M1: ${move.motor1}°'),
              _buildMotorTag('M2: ${move.motor2}°'),
              _buildMotorTag('M3: ${move.motor3}°'),
              _buildMotorTag('M4: ${move.motor4}°'),
              _buildMotorTag('M5: ${move.motor5}°'),
              _buildMotorTag('M6: ${move.motor6}°'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMotorTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Color(0xFF141414), // Darker for tags
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF2A2A2A)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF888888), // Lighter gray for better contrast
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }
}

class RobotMove {
  final int id;
  final String moveName;
  final int motor1, motor2, motor3, motor4, motor5, motor6;

  RobotMove({
    required this.id,
    required this.moveName,
    required this.motor1,
    required this.motor2,
    required this.motor3,
    required this.motor4,
    required this.motor5,
    required this.motor6,
  });

  factory RobotMove.fromJson(Map<String, dynamic> json) {
    return RobotMove(
      id: int.parse(json['id'].toString()),
      moveName: json['move_name'].toString(),
      motor1: int.parse(json['motor1'].toString()),
      motor2: int.parse(json['motor2'].toString()),
      motor3: int.parse(json['motor3'].toString()),
      motor4: int.parse(json['motor4'].toString()),
      motor5: int.parse(json['motor5'].toString()),
      motor6: int.parse(json['motor6'].toString()),
    );
  }
}