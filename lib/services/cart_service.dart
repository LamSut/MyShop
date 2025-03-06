import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cart_item.dart';

class CartService {
  static final CartService instance = CartService._sharedInstance();
  CartService._sharedInstance();

  Database? _cartDatabase;

  Future<Database> get database async {
    if (_cartDatabase != null) {
      return _cartDatabase!;
    } else {
      _cartDatabase = await _initDatabase('cart.db');
      return _cartDatabase!;
    }
  }

  Future<Database> _initDatabase(String fileName) async {
    final databasePath = await getDatabasesPath();
    final filePath = join(databasePath, fileName);
    return await openDatabase(
      filePath,
      version: 1,
      onCreate: _createCartItemsTable,
    );
  }

  Future<void> _createCartItemsTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items (
        id TEXT PRIMARY KEY NOT NULL,
        title TEXT NOT NULL,
        imageUrl TEXT,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL
      )
    ''');
  }

  Future<Map<String, CartItem>> fetchCartItems() async {
    final db = await database;
    final result = await db.query('cart_items');
    return {
      for (var item in result) item['id'] as String: CartItem.fromJson(item)
    };
  }

  Future<CartItem?> addCartItem(CartItem item) async {
    final db = await database;
    await db.insert(
      'cart_items',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return item;
  }

  Future<int> updateCartItem(CartItem item) async {
    final db = await database;
    return db.update(
      'cart_items',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<bool> deleteCartItem(String id) async {
    final db = await database;
    int rowsAffected = await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [id],
    );
    return rowsAffected > 0;
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart_items');
  }

  void close() {
    if (_cartDatabase != null) {
      _cartDatabase!.close();
      _cartDatabase = null;
    }
  }
}
