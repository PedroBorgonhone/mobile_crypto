// lib/repositories/motion_bar_repositorio.dart

import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:pedropaulo_cryptos/pages/tela_carteira_menu.dart';
import 'package:pedropaulo_cryptos/pages/tela_menu.dart';
import 'package:pedropaulo_cryptos/pages/tela_perfil.dart';
import 'package:pedropaulo_cryptos/pages/tela_login.dart';

// 1. IMPORTAR OS NOVOS SERVIÇOS
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pedropaulo_cryptos/services/auth_service.dart';
import 'package:pedropaulo_cryptos/services/firestore_service.dart';
// import 'package:pedropaulo_cryptos/repositories/usuario_repositorio.dart'; // <- REMOVIDO

class MainTabNavigator extends StatefulWidget {
  const MainTabNavigator({super.key});

  @override
  State<MainTabNavigator> createState() => _MainTabNavigatorState();
}

class _MainTabNavigatorState extends State<MainTabNavigator> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;

  // 2. INSTANCIAR NOVOS SERVIÇOS E GUARDAR DADOS
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _authUser; // O usuário da "Portaria" (Auth)
  Map<String, dynamic>? _userData; // Os dados do "Arquivo" (Firestore)
  bool _isLoading = true; // Começamos carregando

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1, 
      length: 3,
      vsync: this, 
    );
    // 3. Chamar a função para carregar os dados
    _loadUserData();
  }

  // 4. NOVA FUNÇÃO DE CARREGAMENTO
  Future<void> _loadUserData() async {
    // 4.1. Pega o usuário da "Portaria"
    _authUser = _authService.currentUser;

    if (_authUser == null) {
      // Se, por algum motivo, não há usuário, volta ao Login
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const TelaLogin()),  //erro aqui
          (route) => false,
        );
      }
      return;
    }

    // 4.2. Pega os dados do "Arquivo"
    try {
      _userData = await _firestoreService.getUserData(_authUser!.uid);
      if (_userData == null) {
        // Isso não deveria acontecer se o registro funcionou
        print("Erro: Usuário não encontrado no Firestore.");
        // (Poderia deslogar aqui, mas vamos deixar carregar por enquanto)
      }
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
    }

    // 4.3. Avisa à tela que paramos de carregar
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  // 5. O BUILD AGORA TRATA O ESTADO DE LOADING
  @override
  Widget build(BuildContext context) {
    // 5.1. Se estamos carregando, mostra um "loading" central
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF16213E),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    
    // 5.2. Se o usuário não carregou (deu erro), mostra um "erro"
    // (O _userData é nulo se o Firestore falhar)
    if (_authUser == null || _userData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF16213E),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Erro ao carregar seu perfil.',
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                child: const Text('Voltar ao Login'),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const TelaLogin()), //erro aqui
                    (route) => false,
                  );
                },
              )
            ],
          ),
        ),
      );
    }

    // 5.3. Se deu tudo certo, constrói a tela principal
    // (O seu código original daqui para baixo)

    // Criamos a lista de telas AQUI, agora que temos os dados
    final List<Widget> screens = [
      const TelaCarteira(),
      const TelaMenu(),
      // 6. Passa os dados REAIS para a TelaPerfil
      TelaPerfil(
        uid: _authUser!.uid,
        userData: _userData!,
      ),
    ];
    
    return Scaffold(
      backgroundColor: const Color(0xFF16213E),
      
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: screens, // Usa a lista de telas criada
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