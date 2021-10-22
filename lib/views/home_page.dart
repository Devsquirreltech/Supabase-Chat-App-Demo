import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase/supabase.dart';
import 'package:supachat/utils/auth_utils.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = provider.Provider.of<AuthUtils>(context).getUser!;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(child: Text('Hello ${user.email}')),
    );
  }
}
