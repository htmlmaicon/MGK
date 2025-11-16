import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Serviço para gerenciar notificações push do Firebase Cloud Messaging
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Inicializa o serviço de notificações
  Future<void> initialize() async {
    if (_initialized) return;

    // Solicita permissão para notificações
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Usuário concedeu permissão para notificações');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Usuário concedeu permissão provisória');
    } else {
      print('Usuário negou permissão para notificações');
      return;
    }

    // Configuração para notificações locais (Android)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Cria canal de notificação para Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'Notificações Importantes', // nome
      description: 'Canal para notificações importantes do app',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Obtém o token do dispositivo
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Listener para quando o app está em foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listener para quando o usuário toca na notificação (app em background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Verifica se o app foi aberto por uma notificação
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    _initialized = true;
  }

  /// Manipula mensagens recebidas quando o app está em foreground
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Mensagem recebida em foreground: ${message.notification?.title}');

    // Mostra notificação local
    if (message.notification != null) {
      await _showLocalNotification(
        title: message.notification!.title ?? 'Nova notificação',
        body: message.notification!.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  /// Mostra uma notificação local
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'Notificações Importantes',
          channelDescription: 'Canal para notificações importantes do app',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond, // ID único
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Manipula o toque em uma notificação
  void _handleNotificationTap(RemoteMessage message) {
    print('Notificação tocada: ${message.notification?.title}');
    // Aqui você pode navegar para uma tela específica baseado nos dados
    // Por exemplo: Navigator.pushNamed(context, '/detalhes', arguments: message.data);
  }

  /// Callback quando usuário toca em notificação local
  void _onNotificationTap(NotificationResponse response) {
    print('Notificação local tocada: ${response.payload}');
    // Aqui você pode navegar para uma tela específica
  }

  /// Monitora mudanças de status de aprovação de um cliente
  /// e envia notificação quando aprovado
  void monitorarStatusCliente(String cpf) {
    FirebaseFirestore.instance.collection('clientes').doc(cpf).snapshots().listen((
      DocumentSnapshot snapshot,
    ) async {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String? status = data['status'];

        if (status == 'aprovado') {
          await _showLocalNotification(
            title: '🎉 Cadastro Aprovado!',
            body: 'Parabéns! Seu cadastro foi aprovado com sucesso.',
          );
        } else if (status == 'rejeitado') {
          await _showLocalNotification(
            title: '❌ Cadastro não aprovado',
            body:
                'Infelizmente seu cadastro não foi aprovado. Entre em contato para mais informações.',
          );
        }
      }
    });
  }

  /// Envia notificação quando um cliente é aprovado
  Future<void> notificarAprovacao({
    required String nomeCliente,
    required String cpf,
  }) async {
    await _showLocalNotification(
      title: '🎉 Cliente Aprovado!',
      body: '$nomeCliente foi aprovado com sucesso!',
      payload: cpf,
    );
  }

  /// Obtém o token FCM do dispositivo
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Salva o token FCM no Firestore associado ao CPF do cliente
  Future<void> salvarTokenNoFirestore(String cpf) async {
    String? token = await getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('clientes').doc(cpf).update({
        'fcmToken': token,
        'tokenAtualizadoEm': FieldValue.serverTimestamp(),
      });
      print('Token FCM salvo no Firestore para CPF: $cpf');
    }
  }
}

/// Handler para mensagens em background (deve estar no escopo global)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Mensagem recebida em background: ${message.notification?.title}');
}
