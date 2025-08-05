import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/announcement/announcement_model.dart';
import 'announcement_data_source.dart';

class AnnouncementRemoteDataSource implements AnnouncementDataSource {
  final http.Client client;
  final String baseUrl;

  AnnouncementRemoteDataSource({required this.client, required this.baseUrl});

  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    final response = await client.get(
      Uri.parse('$baseUrl/announcements'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      return jsonList.map((json) => AnnouncementModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load announcements: ${response.statusCode}');
    }
  }

  @override
  Future<List<AnnouncementModel>> getNewAnnouncements() async {
    final response = await client.get(
      Uri.parse('$baseUrl/announcements?filter=new'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      return jsonList.map((json) => AnnouncementModel.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load new announcements: ${response.statusCode}',
      );
    }
  }

  @override
  Future<AnnouncementModel?> getAnnouncementById(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/announcements/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body)['data'];
      return AnnouncementModel.fromJson(json);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load announcement: ${response.statusCode}');
    }
  }

  @override
  Future<void> markAnnouncementAsRead(String id) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/announcements/$id/mark-read'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'is_new': false}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to mark announcement as read: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> markAllAnnouncementsAsRead() async {
    final response = await client.patch(
      Uri.parse('$baseUrl/announcements/mark-all-read'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to mark all announcements as read: ${response.statusCode}',
      );
    }
  }
}
