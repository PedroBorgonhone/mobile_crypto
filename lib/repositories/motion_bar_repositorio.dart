import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:pedropaulo_cryptos/pages/tela_carteira_menu.dart';
import 'package:pedropaulo_cryptos/pages/tela_menu.dart';
import 'package:pedropaulo_cryptos/pages/tela_perfil.dart';
import 'package:pedropaulo_cryptos/repositories/usuario_repositorio.dart';

class MainTabNavigator extends StatefulWidget {
  const MainTabNavigator({super.key});

  @override
  State<MainTabNavigator> createState() => _MainTabNavigatorState();
}

class _MainTabNavigatorState extends State<MainTabNavigator> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;

  final UsuarioRepositorio _usuarioRepo = UsuarioRepositorio();

  @override
  void initState() {
    super.initState();
    
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1, 
      length: 3,
      vsync: this, 
    );
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  List<Widget> get _screens => [
    const TelaCarteira(),
    const TelaMenu(),
    TelaPerfil(usuario: _usuarioRepo.usuarioLogado!),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16213E),
      
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: _screens,
      ),
      
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        
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
