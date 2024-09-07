import 'dart:convert';
import 'dart:async';
import 'dart:io'; // For handling SocketException
import 'package:bloc/bloc.dart';
import 'package:guidanclyflutter/cubit/intercepteurs/auth_intercepteur.dart';
import 'package:guidanclyflutter/cubit/visitor/visitor_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/visitor_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:logger/logger.dart';

class VisitorCubit extends Cubit<VisitorState> {
  // Constructor and initial state
  VisitorCubit() : super(VisitorStateInitializer());

  // Logger instance for better logging
  final Logger logger = Logger();
  VisitorModel? visitorModel;

  // Http Client with Interceptor
  final http.Client client = InterceptedClient.build(
    interceptors: [AuthInterceptor()],
    requestTimeout: const Duration(seconds: 30),
  );

  // Helper method to handle POST requests
  Future<VisitorModel?> _postRequest(String endpoint) async {
    try {
      emit(VisitorStateLoading());

      // Perform POST request
      var response = await client.post(Uri.parse('$apiurl$endpoint'));

      // Log the response
      logger.d("Response: ${response.body}");

      // Check if the response is empty
      if (response.body.isEmpty) {
        logger.e('Empty response body');
        emit(VisitorStateFailure());
        return null;
      }

      // Check for status code 200 (success)
      if (response.statusCode == 200) {
        emit(VisitorStateSuccess());

        // Try to parse JSON and return VisitorModel
        try {
          return VisitorModel.fromJson(jsonDecode(response.body));
        } catch (e) {
          logger.e('Error parsing JSON: $e');
          emit(VisitorStateFailure());
          return null;
        }
      } else {
        // Log failure if status code is not 200
        logger.e('Failed to complete request: ${response.body}');
        emit(VisitorStateFailure());
        return null;
      }
    } on SocketException {
      // Handle no internet connection error
      logger.e('No Internet connection.');
      emit(VisitorStateFailure());
      return null;
    } on TimeoutException {
      // Handle timeout error
      logger.e('The connection has timed out.');
      emit(VisitorStateFailure());
      return null;
    } catch (e) {
      // Log and handle any other errors
      logger.e('Error during request: $e');
      emit(VisitorStateFailure());
      return null;
    }
  }

  // Method to book a tour
  Future<VisitorModel?> book(int tourId) async {
    logger.d("Booking tour with ID: $tourId");

    try {
      emit(VisitorStateLoading());
      var response = await client.post(
        Uri.parse('$apiurl/api/visitor/book?id=$tourId'),
      );

      logger.d("Response status: ${response.statusCode}");
      logger.d("Response body: ${response.body}");

      if (response.statusCode == 200) {
        emit(VisitorStateSuccess());
        visitorModel = VisitorModel.fromJson(jsonDecode(response.body));
        return VisitorModel.fromJson(jsonDecode(response.body));
      } else {
        logger.e('Failed to book tour: ${response.body}');
        emit(VisitorStateFailure());
        return null;
      }
    } catch (e) {
      logger.e('Error booking tour: $e');
      emit(VisitorStateFailure());
      return null;
    }
  }


  // Method to check visitor's tour
  Future<VisitorModel?> checkVisitorTour(int tourId) async {
    logger.d("Checking visitor tour with ID: $tourId");
    return _postRequest('/api/visitor/checkVisitorTour?id=$tourId');
  }

  @override
  Future<void> close() {
    // Dispose of any resources here if needed (e.g., timers, streams)
    return super.close();
  }
}
