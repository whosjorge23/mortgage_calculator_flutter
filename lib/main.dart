import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MortgageCalculatorApp());
}

class MortgageCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mortgage Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MortgageCalculatorScreen(),
    );
  }
}

class MortgageCalculatorScreen extends StatefulWidget {
  @override
  _MortgageCalculatorScreenState createState() =>
      _MortgageCalculatorScreenState();
}

class _MortgageCalculatorScreenState extends State<MortgageCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _interestController = TextEditingController();
  final _yearsController = TextEditingController();
  final _resultFormat = NumberFormat.currency(symbol: '\$');

  String? _principalError;
  String? _interestError;
  String? _yearsError;

  double _mortgage = 0.0;

  @override
  void dispose() {
    _principalController.dispose();
    _interestController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mortgage Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _principalController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Principal',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the principal amount.';
                  }
                  final principal = int.tryParse(value);
                  if (principal == null || principal < 1000 || principal > 1000000) {
                    return 'Please enter a value between 1,000 and 1,000,000.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _principalError = null;
                  });
                },
              ),
              TextFormField(
                controller: _interestController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Annual Interest Rate',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the annual interest rate.';
                  }
                  final interest = double.tryParse(value);
                  if (interest == null || interest < 1 || interest > 30) {
                    return 'Please enter a value between 1 and 30.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _interestError = null;
                  });
                },
              ),
              TextFormField(
                controller: _yearsController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Period in Years',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the period in years.';
                  }
                  final years = int.tryParse(value);
                  if (years == null || years < 1 || years > 30) {
                    return 'Please enter a value between 1 and 30.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _yearsError = null;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    calculateMortgage();
                  }
                },
                child: Text('Calculate'),
              ),
              SizedBox(height: 16.0),
              Text(
                'Mortgage: ${_resultFormat.format(_mortgage)}',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateMortgage() {
    final principal = int.parse(_principalController.text);
    final annualInterest = double.parse(_interestController.text);
    final years = int.parse(_yearsController.text);

    if (principal == null || annualInterest == null || years == null) {
      setState(() {
        _principalError = 'Invalid principal amount.';
        _interestError = 'Invalid annual interest rate.';
        _yearsError = 'Invalid period in years.';
        _mortgage = 0.0;
      });
      return;
    }

    final monthlyInterest = annualInterest / 100 / 12;
    final numberOfPayments = years * 12;

    final mortgage = principal *
        (monthlyInterest * pow(1 + monthlyInterest, numberOfPayments)) /
        (pow(1 + monthlyInterest, numberOfPayments) - 1);

    setState(() {
      _mortgage = mortgage;
    });
  }

  double pow(double base, int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
