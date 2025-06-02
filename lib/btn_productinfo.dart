import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/language_model.dart';
import 'models/background_model.dart';

// =================== BOTTOM ACTION BUTTONS WIDGET ===================
/// BottomActionButtons
///
/// Stateless widget that displays two main action buttons at the bottom of the product info screen:
/// - "Add to Cart" (or "Idagdag sa Cart" in Filipino)
/// - "Buy Now" (or "Bumili Na" in Filipino)
///
/// Uses Provider to access language and theme settings.
class BottomActionButtons extends StatelessWidget {
  const BottomActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isFilipino = Provider.of<LanguageModel>(context).isFilipino();
    final backgroundModel = Provider.of<Backgroundmodel>(context);

    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Add to Cart button
          Expanded(
            child: ElevatedButton.icon(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              label: Text(
                isFilipino ? "Idagdag sa Cart" : "Add to Cart",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundModel.cartBtn,
                padding: EdgeInsets.symmetric(vertical: 15),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          // Buy Now button
          Expanded(
            child: ElevatedButton.icon(
              icon: Icon(Icons.payment, color: Colors.white),
              label: Text(
                isFilipino ? "Bumili Na" : "Buy Now",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundModel.buyBtn,
                padding: EdgeInsets.symmetric(vertical: 15),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// =================== END BOTTOM ACTION BUTTONS WIDGET ===================
