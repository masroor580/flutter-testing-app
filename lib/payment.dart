import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Provider for managing OTP state.
class OTPProvider extends ChangeNotifier {
  final List<String> otpValues = List.filled(6, "");

  void updateOTP(int index, String value) {
    if (otpValues[index] != value) {
      otpValues[index] = value;
      notifyListeners();
    }
  }
}

// The PaymentScreen widget
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  // Use a context that is below the provider.
  void _onChanged(String value, int index, BuildContext ctx) {
    Provider.of<OTPProvider>(ctx, listen: false).updateOTP(index, value);
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(ctx).requestFocus(_focusNodes[index + 1]);
    }
  }

  // Use a context that is below the provider.
  void _onKeyPressed(RawKeyEvent event, int index, BuildContext ctx) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        FocusScope.of(ctx).requestFocus(_focusNodes[index - 1]);
        _controllers[index - 1].clear();
        Provider.of<OTPProvider>(ctx, listen: false).updateOTP(index - 1, "");
      } else {
        _controllers[index].clear();
        Provider.of<OTPProvider>(ctx, listen: false).updateOTP(index, "");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Payment Build');
    return ChangeNotifierProvider(
      create: (_) => OTPProvider(),
      child: Builder(
        builder: (ctx) {
          // Now this context is below the provider.
          return Scaffold(
            // appBar: AppBar(
            //   title: const Text("Payment"),
            //   backgroundColor: Colors.blueAccent,
            //   centerTitle: true,
            body: LayoutBuilder(
              builder: (ctx, constraints) {
                bool isDesktop = constraints.maxWidth > 800;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildContent(ctx, isDesktop),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDesktop) {
    print('Payment BuildContent');
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main content section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   "Payment",
                  //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  // ),
                  const SizedBox(height: 20),
                  _otpWidget(context),
                  const SizedBox(height: 20),
                  // Extracted widget to prevent rebuilds
                  const PaymentHistoryTable(),
                ],
              ),
            ),
            if (isDesktop)
              SizedBox(
                width: 320,
                // Extracted widget to prevent rebuilds
                child: const EarningsCards(isMobile: false),
              ),
          ],
        ),
        if (!isDesktop) ...[
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            // Extracted widget to prevent rebuilds
            child: const EarningsCards(isMobile: true),
          ),
        ],
      ],
    );
  }

  Widget _otpWidget(BuildContext context) {
    print('OTP Build');
    // Wrap in a Builder so the context here is under the provider.
    return Builder(
      builder: (ctx) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Enter OTP',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please enter the OTP sent to your phone',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 400, // Fixed width to match "Continue" button
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 40,
                            height: 50,
                            child: RawKeyboardListener(
                              focusNode: FocusNode(),
                              onKey: (event) =>
                                  _onKeyPressed(event, index, ctx),
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  hintText: "-",
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) =>
                                    _onChanged(value, index, ctx),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Continue",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Extract PaymentHistoryTable as a separate widget.
// Since its content is static, mark its constructor as const.
class PaymentHistoryTable extends StatelessWidget {
  const PaymentHistoryTable({Key? key}) : super(key: key);

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            cell,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: isHeader ? 16 : 14,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Payment History Build');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Payment History",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                bool isDesktop = constraints.maxWidth > 600;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: isDesktop ? constraints.maxWidth : 600,
                    child: Table(
                      columnWidths: {
                        0: const FlexColumnWidth(1),
                        1: isDesktop
                            ? const FlexColumnWidth(2)
                            : const FlexColumnWidth(1.5),
                        2: isDesktop
                            ? const FlexColumnWidth(2)
                            : const FlexColumnWidth(1.5),
                        3: isDesktop
                            ? const FlexColumnWidth(2)
                            : const FlexColumnWidth(1.5),
                        4: isDesktop
                            ? const FlexColumnWidth(2)
                            : const FlexColumnWidth(1.5),
                      },
                      children: [
                        _buildTableRow([
                          "ID",
                          "Status",
                          "Payment Method",
                          "Date",
                          "Amount"
                        ], isHeader: true),
                        _buildTableRow([
                          "001",
                          "Success",
                          "Credit Card",
                          "20 Feb 2024",
                          "\$50.00"
                        ]),
                        _buildTableRow([
                          "002",
                          "Pending",
                          "Transfer",
                          "20 Feb 2024",
                          "\$150.00"
                        ]),
                        _buildTableRow([
                          "003",
                          "Failed",
                          "Bank Transfer",
                          "21 Feb 2024",
                          "\$75.00"
                        ]),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Since earnings data is static, we define it as a const list.
const List<Map<String, String>> earningsData = [
  {"title": "Total Earnings", "amount": "PKR 150,000"},
  {"title": "Monthly Revenue", "amount": "PKR 50,000"},
  {"title": "Investments", "amount": "PKR 200,000"},
  {"title": "Other Income", "amount": "PKR 30,000"},
];

// Extract EarningsCards as a separate widget to avoid unnecessary rebuilds.
class EarningsCards extends StatelessWidget {
  final bool isMobile;

  const EarningsCards({Key? key, required this.isMobile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: earningsData.map((data) {
        return EarningsCard(
          isMobile: isMobile,
          title: data["title"]!,
          amount: data["amount"]!,
        );
      }).toList(),
    );
  }
}

class EarningsCard extends StatelessWidget {
  final bool isMobile;
  final String title;
  final String amount;

  const EarningsCard(
      {Key? key,
      required this.isMobile,
      required this.title,
      required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Earning Cards Build');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: isMobile ? double.infinity : 300,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(amount,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Row(
                children: const [
                  Icon(Icons.trending_up, color: Colors.green),
                  SizedBox(width: 4),
                  Text("Income",
                      style: TextStyle(color: Colors.green, fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
