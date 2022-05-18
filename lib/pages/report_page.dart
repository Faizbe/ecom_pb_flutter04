import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  static const String routeName = '/report';
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//1. total order by month/year/day
//2. total pending/delivered/cancelled order with percentage
//3. top sold product
//4. top category
//5. product per category
//6. total active users
//7. total new user per day/month/year
//8. total order by particular user
//9. top 5 user
//10. total sale per day/month/year
