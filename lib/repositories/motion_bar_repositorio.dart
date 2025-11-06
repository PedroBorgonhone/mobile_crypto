// lib/repositories/motion_bar_repositorio.dart

import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:pedropaulo_cryptos/pages/tela_carteira_menu.dart';
import 'package:pedropaulo_cryptos/pages/tela_menu.dart';
import 'package:pedropaulo_cryptos/pages/tela_perfil.dart';
import 'package:pedropaulo_cryptos/pages/tela_login.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedropaulo_cryptos/services/auth_service.dart';
import 'package:pedropaulo_cryptos/services/firestore_service.dart';

class MainTabNavigator extends StatefulWidget {
  const MainTabNavigator({super.key});

  @override
  State<MainTabNavigator> createState() => _MainTabNavigatorState();
}

class _MainTabNavigatorState extends State<MainTabNavigator> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;

  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _authUser; 
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1, 
      length: 3,
      vsync: this, 
    );
    _loadUserData();
  }

  // ESTA É A FUNÇÃO QUE QUEREMOS CHAMAR DE NOVO
  Future<void> _loadUserData() async {
    // Garante que a tela saiba que estamos carregando
    setState(() => _isLoading = true);

    _authUser = _authService.currentUser;

    if (_authUser == null) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const TelaLogin()),
          (route) => false,
        );
      }
      return;
    }
    
    try {
      _userData = await _firestoreService.getUserData(_authUser!.uid);
      if (_userData == null) {
        print("Erro: Usuário não encontrado no Firestore.");
      }
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
    }

    // Avisa à tela que paramos de carregar
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF16213E),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    
    if (_authUser == null || _userData == null) {
      // (Tela de erro, como antes)
      return Scaffold(
        backgroundColor: const Color(0xFF16213E),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Erro ao carregar seu perfil.', style: TextStyle(color: Colors.white)),
              TextButton(
                child: const Text('Voltar ao Login'),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const TelaLogin()),
                    (route) => false,
                  );
                },
              )
            ],
          ),
        ),
      );
    }

    // --- MUDANÇA PRINCIPAL AQUI ---
    final List<Widget> screens = [
      TelaCarteira(
        uid: _authUser!.uid,
        userData: _userData!,
      ),
      TelaMenu(
        userData: _userData!,
      ),
      // 1. Passa a *função de recarregar* para a TelaPerfil
      TelaPerfil(
        uid: _authUser!.uid,
        userData: _userData!,
        onProfileUpdated: _loadUserData, // <-- NOVA LINHA (O "Callback")
      ),
    ];
    
    return Scaffold(
      backgroundColor: const Color(0xFF16213E),
      
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: screens,
      ),
      
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        // ... (O resto do seu MotionTabBar continua 100% igual)
        initialSelectedTab: "Notícias",
        useSafeArea: true,
        labelAlwaysVisible: true,
        labels: const ["Carteira", "Notícias", "Perfil"],
        icons: const [
          Icons.account_balance_wallet_outlined,
          Icons.newspaper, 
          Icons.person,
        ],
        tabSize: 50,
        tabBarHeight: 60,
        tabBarColor: const Color(0xFF003366), 
        tabIconColor: Colors.white70,
        tabIconSize: 24.0, 
        tabIconSelectedSize: 28.0, 
        tabSelectedColor: Colors.white,
        tabIconSelectedColor: const Color(0xFF16213E),
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
        onTabItemSelected: (int index) {
          setState(() {
            _motionTabBarController.index = index;
          });
        },
      ),
    );
  }
}