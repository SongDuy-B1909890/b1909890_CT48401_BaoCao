import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myshop_b1909890/models/order_item.dart';
import '../models/cart_item.dart';
import '../models/auth_token.dart';
import 'firebase_service.dart';

class OrderItemService extends FirebaseService {
  OrderItemService([AuthToken? authToken]) : super(authToken);

  Future<List<OrderItem>> fetchorderItems([bool filterByUser = false]) async {
    final List<OrderItem> orderItems = [];

    try {
      final filters =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final orderItemsUrl =
          Uri.parse('$databaseUrl/orderItems.json?auth=$token&$filters');
      final response = await http.get(orderItemsUrl);
      final orderItemsMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(orderItemsMap['error']);
        return orderItems;
      }

      final userFavoritesUrl =
          Uri.parse('$databaseUrl/userFavorites/$userId.json?auth=$token');
      final userFavoritesResponse = await http.get(userFavoritesUrl);
      final userFavoritesMap = json.decode(userFavoritesResponse.body);

      orderItemsMap.forEach((orderItemId, orderItem) {
        final isFavorite = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[orderItemId] ?? false);
        orderItems.add(
          OrderItem.fromJson({
            'id': orderItemId,
            ...orderItem,
          }).copyWith(isFavorite: isFavorite),
        );
      });
      return orderItems;
    } catch (error) {
      print(error);
      return orderItems;
    }
  }

  Future<OrderItem?> addorderItem(OrderItem orderItem) async {
    try {
      final url = Uri.parse('$databaseUrl/orderItems.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(
          orderItem.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return orderItem.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateorderItem(OrderItem orderItem) async {
    try {
      final url =
          Uri.parse('$databaseUrl/orderItems/${orderItem.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(orderItem.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteorderItem(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/orderItems/$id.json?auth=$token');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> saveFavoriteStatus(OrderItem orderItem) async {
    try {
      final url = Uri.parse(
          '$databaseUrl/userFavorites/$userId/${orderItem.id}.json?auth=$token');
      final response = await http.put(
        url,
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}