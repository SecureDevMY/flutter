import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paywall Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Display'
      ),
      home: const PaywallScreen(),
    );
  }
}

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  late PageController _pageController;
  int _currentPage = 1; //Start with Yearly (middle card)

  final List<PricingOptions> _pricingOptions = [
    PricingOptions(
      title: '3-day free',
      price: 'Then \$39.99 / week',
      buttonText: 'Try 3-day for free',
      isBestOffer: false,
      subtitle: 'Auto-renews after trial',
    ),
    PricingOptions(
      title: 'Yearly',
      price: '\$129.99 / year',
      buttonText: 'Try for \$129.99 / year',
      isBestOffer: true,
    ),
    PricingOptions(
      title: 'Monthly',
      price: '\$39.99 / week',
      buttonText: 'Try for \$39.99 / week',
      isBestOffer: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: _currentPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
              Colors.transparent, 
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                //Pricing Cards
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pricingOptions.length,
                    scrollBehavior: MaterialScrollBehavior().copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      }
                    ),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildPricingCard(_pricingOptions[index]);
                    },
                  ),
                ),

                const SizedBox(height: 20),

                //Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pricingOptions.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                          ? const Color(0xFF9D4EFF)
                          : Colors.white.withOpacity(0.5),
                      ),
                    )
                  ),
                ),

                const SizedBox(height: 40),

                //Features List
                _buildFeaturesList(),

                const Spacer(),

                //CTA Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (_pricingOptions[_currentPage].subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _pricingOptions[_currentPage].subtitle!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {}, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _pricingOptions[_currentPage].buttonText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                //Footer Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFooterLink('Terms of Use'),
                    _buildFooterLink('Restore'),
                    _buildFooterLink('Privacy Policy'),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _buildPricingCard(PricingOptions option) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (option.isBestOffer)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF9D4EFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'BEST OFFER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          if (option.isBestOffer) const SizedBox(height: 16),
          Text(
            option.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            option.price,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              height: 1.3,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {'icon': Icons.auto_awesome, 'text': 'Unlimited art creation'},
      {'icon': Icons.bolt, 'text': 'Faster image processing'},
      {'icon': Icons.card_giftcard, 'text': 'Ad-free experience'},
      {'icon': Icons.image, 'text': 'The best image quality'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: features.map((feature) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D4EFF),Color(0xFF4E9AFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  feature['text'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return TextButton(
      onPressed: () {}, 
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white.withOpacity(0.7),
        ),
      )
    );
  }
}

class PricingOptions {
  final String title;
  final String price;
  final String buttonText;
  final bool isBestOffer;
  final String? subtitle;

  PricingOptions({
    required this.title,
    required this.price,
    required this.buttonText,
    required this.isBestOffer,
    this.subtitle,
  });
}
