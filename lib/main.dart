import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://grdafrazzvsjribvvcha.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdyZGFmcmF6enZzanJpYnZ2Y2hhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkwOTkxOTksImV4cCI6MjA5NDY3NTE5OX0.0NHfZCvhSApPcotMBU-8o6tKLtcb6KokX8rThc8mOok',
  );
  runApp(const MyApp());
}