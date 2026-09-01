import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../controllers/weather_controller.dart';
import '../widgets/search_history_list.dart';

class WeatherSearchView extends StatefulWidget {
  const WeatherSearchView({super.key});

  @override
  State<WeatherSearchView> createState() => _WeatherSearchViewState();
}

class _WeatherSearchViewState extends State<WeatherSearchView> {
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final WeatherController _weatherController;

  @override
  void initState() {
    super.initState();
    _weatherController = Get.find<WeatherController>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    FocusScope.of(context).unfocus();
    final success = await _weatherController.fetchWeatherByCity(trimmed);
    if (success && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              // Search Input Field
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        validator: Validators.validateCity,
                        onFieldSubmitted: (val) {
                          if (_formKey.currentState?.validate() ?? false) {
                            _performSearch(val);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter city name (e.g. Paris, Tokyo)...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(() => IconButton.filled(
                          onPressed: _weatherController.isLoading.value
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    _performSearch(_searchController.text);
                                  }
                                },
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(16),
                          ),
                          icon: _weatherController.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                        )),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),
              const SizedBox(height: 24),

              // Search History & Popular Destinations
              Expanded(
                child: Obx(() => SearchHistoryList(
                      history: _weatherController.searchHistory,
                      onSelectCity: (city) {
                        _searchController.text = city;
                        _performSearch(city);
                      },
                      onDeleteItem: (city) {
                        _weatherController.removeSearchHistoryItem(city);
                      },
                      onClearAll: () {
                        _weatherController.clearAllSearchHistory();
                      },
                    )).animate().fadeIn(delay: 150.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
