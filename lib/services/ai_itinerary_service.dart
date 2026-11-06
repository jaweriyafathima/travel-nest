
import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';

class AIItineraryService {
  final GenerativeModel _primaryModel =
      FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.8-flash',
    generationConfig: GenerationConfig(
      maxOutputTokens: 1800,
    ),
  );

  final GenerativeModel _backupModel =
      FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.5-flash-lite',
    generationConfig: GenerationConfig(
      maxOutputTokens: 1800,
    ),
  );

  Future<String> generateItinerary({
    required String country,
    required String city,
    required int numberOfDays,
    required String budget,
    required String travelWith,
    required String interests,
    required String foodPreference,
    required String travelStyle,
  }) async {
    if (numberOfDays < 1 || numberOfDays > 30) {
      throw Exception('Please select between 1 and 30 travel days.');
    }

    final prompt = '''
You are Travel Nest AI, a professional travel planner.

Create a personalized $numberOfDays-day travel itinerary.

Destination: $city, $country
Duration: $numberOfDays days
Budget: $budget
Travelling with: $travelWith
Interests: $interests
Food preference: $foodPreference
Travel style: $travelStyle

RULES:
1. Generate exactly $numberOfDays days.
2. Do not skip any day.
3. Include Morning, Afternoon, Evening and Night for every day.
4. Include real famous attractions and sightseeing places.
5. Suggest local vegetarian or other food according to the preference.
6. Group nearby attractions to reduce travel time.
7. Avoid repeating attractions.
8. Include practical transport suggestions.
9. Include one useful travel tip for each day.
10. Do not invent live weather, current prices or opening hours.

Keep each activity short and useful.
Return only the itinerary with clear Day headings.
''';

    // Try the primary model twice.
    for (int attempt = 0; attempt < 2; attempt++) {
      try {
        return await _request(_primaryModel, prompt);
      } catch (e) {
        if (attempt == 0) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }

    // If the primary model fails, try the backup model.
    try {
      return await _request(_backupModel, prompt);
    } catch (e) {
      throw Exception(
        'Travel Nest AI is temporarily unavailable. '
        'Please try again in a few minutes.',
      );
    }
  }

  Future<String> _request(
    GenerativeModel model,
    String prompt,
  ) async {
    final response = await model
        .generateContent([Content.text(prompt)])
        .timeout(const Duration(seconds: 60));

    final result = response.text?.trim();

    if (result == null || result.isEmpty) {
      throw Exception('AI returned an empty itinerary.');
    }

    return result;
  }
}
