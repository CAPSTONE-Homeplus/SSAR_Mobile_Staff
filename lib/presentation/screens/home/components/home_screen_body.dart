import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean_crew/core/app_text_styles.dart';

class HomeScreenBody extends StatefulWidget {
  HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHomeScreen();
  }
}

Widget _buildHomeScreen() {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ho Chi Minh City',
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  'Ho Chi Minh City',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Balance Card
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1CAF7D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Balance',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '500,000 đ',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF1CAF7D),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text('Top up'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Services',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Xem tất cả',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1CAF7D),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
              ],
            ),
          ),

          // Recent Bookings
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Bookings',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                _buildBookingCard(),
                SizedBox(height: 12),
                _buildBookingCard(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildServiceItem({
  required IconData icon,
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  List<String> words = title.split(' ');
  String firstLine = words.length > 2 ? words.sublist(0, 2).join(' ') : title;
  String secondLine = words.length > 2 ? words.sublist(2).join(' ') : '';

  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        SizedBox(height: 8),
        Text(
          firstLine,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          secondLine,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildPromotionCard() {
  return Container(
    width: 280,
    margin: EdgeInsets.only(right: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      image: DecorationImage(
        image: NetworkImage(
            'https://i.pinimg.com/736x/11/4c/60/114c609160dbcb99469d74fad218cf82.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _buildBookingCard() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF1CAF7D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.cleaning_services, color: Color(0xFF1CAF7D)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Home Cleaning',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Today, 15:00',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'In Progress',
                style: GoogleFonts.notoSans(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '300,000 đ',
              style: AppTextStyles.heading,
            ),
            TextButton(
              onPressed: () {},
              child: Text('View Details'),
            ),
          ],
        ),
      ],
    ),
  );
}
