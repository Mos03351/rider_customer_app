import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';

class SearchDestinationScreen extends StatefulWidget {
  const SearchDestinationScreen({Key? key}) : super(key: key);

  @override
  State<SearchDestinationScreen> createState() => _SearchDestinationScreenState();
}

class _SearchDestinationScreenState extends State<SearchDestinationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentLocations = [
    'สถานีรถไฟลำพูน',
    'ตลาดหนองดอก',
    'บิ๊กซี ลำพูน',
  ];
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    // TODO: ดึงข้อมูลสถานที่จาก API จริงๆ (เช่น Google Places API)
    setState(() {
      _searchResults = _recentLocations
          .where((location) => location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectLocation(String location) {
    Navigator.pop(context, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ค้นหาจุดหมาย',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme?.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Input Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาสถานที่หรือที่อยู่',
                prefixIcon: Icon(Icons.search, color: AppTheme.lightTextColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: AppTheme.lightTextColor),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                          });
                        },
                      )
                    : null,
                border: Theme.of(context).inputDecorationTheme.border,
                enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                filled: Theme.of(context).inputDecorationTheme.filled,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                contentPadding: Theme.of(context).inputDecorationTheme.contentPadding,
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
            ),
            const SizedBox(height: 20),

            // Display Results or Recent Locations
            Expanded(
              child: _searchResults.isNotEmpty
                  ? ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final location = _searchResults[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            leading: Icon(Icons.location_on, color: AppTheme.primaryColor),
                            title: Text(
                              location,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
                            ),
                            onTap: () => _selectLocation(location),
                          ),
                        );
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'สถานที่ล่าสุด',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _recentLocations.length,
                            itemBuilder: (context, index) {
                              final location = _recentLocations[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  leading: Icon(Icons.history, color: AppTheme.lightTextColor),
                                  title: Text(
                                    location,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
                                  ),
                                  onTap: () => _selectLocation(location),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}