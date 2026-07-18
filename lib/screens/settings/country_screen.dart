import 'package:flutter/material.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final TextEditingController _searchController = TextEditingController();

  String searchText = '';

  final List<Map<String, String>> countries = [
    {'flag': '🇻🇳', 'name': 'Việt Nam'},
    {'flag': '🇺🇸', 'name': 'United States'},
    {'flag': '🇯🇵', 'name': 'Japan'},
    {'flag': '🇰🇷', 'name': 'South Korea'},
    {'flag': '🇨🇳', 'name': 'China'},
    {'flag': '🇸🇬', 'name': 'Singapore'},
    {'flag': '🇹🇭', 'name': 'Thailand'},
    {'flag': '🇲🇾', 'name': 'Malaysia'},
    {'flag': '🇮🇩', 'name': 'Indonesia'},
    {'flag': '🇵🇭', 'name': 'Philippines'},
    {'flag': '🇦🇺', 'name': 'Australia'},
    {'flag': '🇨🇦', 'name': 'Canada'},
    {'flag': '🇬🇧', 'name': 'United Kingdom'},
    {'flag': '🇫🇷', 'name': 'France'},
    {'flag': '🇩🇪', 'name': 'Germany'},
    {'flag': '🇮🇹', 'name': 'Italy'},
    {'flag': '🇮🇳', 'name': 'India'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCountries = countries.where((country) {
      return country['name']!
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Quốc Gia & Khu Vực',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 44),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tìm quốc gia',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white38,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = filteredCountries[index];

                  return InkWell(
                    onTap: () {
                      Navigator.pop(
                        context,
                        country['name'],
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            country['flag']!,
                            style: const TextStyle(fontSize: 28),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Text(
                              country['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white38,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}