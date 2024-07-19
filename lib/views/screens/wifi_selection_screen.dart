import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WiFiSelectionScreen extends StatefulWidget {
  @override
  _WiFiSelectionScreenState createState() => _WiFiSelectionScreenState();
}

class _WiFiSelectionScreenState extends State<WiFiSelectionScreen> {
  List<WifiNetwork?>? _networks = [];
  String? _selectedSSID;
  String? _savedSSID;
  String? _savedPassword;
  TextEditingController _passwordController = TextEditingController();
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _loadSavedWiFiInfo();
    _scanForNetworks();
  }

  Future<void> _loadSavedWiFiInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedSSID = prefs.getString('ssid');
      _savedPassword = prefs.getString('password');
    });
  }

  Future<void> _scanForNetworks() async {
    List<WifiNetwork?>? networks = await WiFiForIoTPlugin.loadWifiList();
    setState(() {
      _networks = networks;
    });
  }

  Future<void> _connectToWiFi(String ssid, String password) async {
    setState(() {
      _isConnecting = true;
    });

    // Enable WiFi if it's not already enabled
    bool wifiEnabled = await WiFiForIoTPlugin.isEnabled();
    if (!wifiEnabled) {
      bool wifiEnabledSuccessfully = await WiFiForIoTPlugin.setEnabled(true);
      if (!wifiEnabledSuccessfully) {
        setState(() {
          _isConnecting = false;
        });
        _showConnectionResult(false, ssid, "Failed to enable WiFi.");
        return;
      }
    }

    // Check if the WiFi is now enabled
    wifiEnabled = await WiFiForIoTPlugin.isEnabled();
    if (!wifiEnabled) {
      setState(() {
        _isConnecting = false;
      });
      _showConnectionResult(false, ssid, "WiFi is not enabled.");
      return;
    }

    // Connect to the WiFi network
    bool connected = await WiFiForIoTPlugin.connect(ssid, password: password);
    setState(() {
      _isConnecting = false;
    });
    _showConnectionResult(connected, ssid);
    if (connected) {
      // Save Wi-Fi information for future connections
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('ssid', ssid);
      await prefs.setString('password', password);
    }
  }

  void _showConnectionResult(bool success, String ssid, [String? message]) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(success ? 'Success' : 'Failure'),
          content: Text(message ?? (success
              ? 'Successfully connected to $ssid!'
              : 'Failed to connect to $ssid. Please try again.')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (!success) {
                  _showPasswordDialog(ssid);
                }
              },
              child: Text(success ? 'OK' : 'Retry'),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordDialog(String ssid) {
    _passwordController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Password for $ssid'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _connectToWiFi(ssid, _passwordController.text);
              },
              child: Text('Connect'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Wi-Fi Network'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _scanForNetworks,
          ),
        ],
      ),
      body: _isConnecting
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _networks?.length ?? 0,
        itemBuilder: (context, index) {
          String ssid = _networks![index]?.ssid ?? '';
          return ListTile(
            title: Text(ssid),
            trailing: _savedSSID == ssid
                ? Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              if (_savedSSID == ssid && _savedPassword != null) {
                _connectToWiFi(ssid, _savedPassword!);
              } else {
                _showPasswordDialog(ssid);
              }
            },
          );
        },
      ),
    );
  }
}
