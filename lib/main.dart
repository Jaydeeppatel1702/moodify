import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_web_auth/flutter_web_auth.dart';

const String clientId = '5da963e07306431e91e18353000c9a9d';
const String redirectUri = 'moodifyt://callback';
const String scopes = 'user-read-email user-read-private';
const String clientsec = '974b70f00d8141c8862c1604539dd131';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Spotify Auth Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Spotify Auth Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _authenticate,
                child: const Text('Authorize with Spotify'),
              ),
              const SizedBox(height: 16),
              Text('Token: $token'),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _authenticate() async {
    final url =
        'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&scope=user-read-email%20user-read-private';
    await Future.delayed(Duration(seconds: 1));
    final result = await FlutterWebAuth.authenticate(
        url:
            'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri',
        callbackUrlScheme: 'moodifyt');
    final code = Uri.parse(result).queryParameters['code'];
    final tokenEndpoint = 'https://accounts.spotify.com/api/token';
    final credentials = '$clientId:$clientsec';
    final encodedCredentials = base64.encode(utf8.encode(credentials));
    final response = await http.post(Uri.parse(tokenEndpoint), headers: {
      'Authorization': 'Basic $encodedCredentials',
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      'grant_type': 'authorization_code',
      'code': code!,
      'redirect_uri': redirectUri
    });
    final token = jsonDecode(response.body)['access_token'];
    setState(() {
      this.token = token;
    });
    print("hello");
    return token;
  }
}
