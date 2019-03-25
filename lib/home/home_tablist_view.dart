import 'package:flutter/material.dart';

import 'package:flutter_book/public.dart';
import 'home_model.dart';
import 'home_banner.dart';
import 'home_menu.dart';

import 'novel_first_card.dart';
import 'novel_second_card.dart';
import 'novel_third_card.dart';
import 'novel_four_card.dart';


enum HomeListType {
  excellent,
  male,
  female,
  cartoon
}

class HomeListView extends StatefulWidget {
  final HomeListType type;
  HomeListView(this.type);

  _HomeListViewState createState() => _HomeListViewState();
}

class _HomeListViewState extends State<HomeListView> with AutomaticKeepAliveClientMixin{

  List<CarouselInfo> carouselInfos = [];
  int pageIndex = 1;
  List<HomeModule> modules = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future<void> fetchData() async {
    try {
      var action;
      switch (this.widget.type) {
        case HomeListType.excellent:
          action = 'home_excellent';
          break;

        case HomeListType.female:
          action = 'home_female';
          break;

        case HomeListType.male:
          action = 'home_male';
          break;

        case HomeListType.cartoon:
          action = 'home_cartoon';
          break;      

        default:
          break;
      }

      var responseJson =await Request.get(action: action);
      List moduleData =responseJson['module'];
      List<HomeModule> modules = [];
      moduleData.forEach((data){
        modules.add(HomeModule.fromJson(data));
      });

      setState(() {
       this.modules =modules;
       this.carouselInfos =carouselInfos; 
      });
      
    } catch (e) {
      Toast.showCenter(e.toString());
    }
  }

  Widget bookCardWithInfo(HomeModule module) {
    Widget card;
    switch (module.style) {
      case 1:
        card =NovelFirstCard(module);
        break;

      case 2:
        card =NovelSecondCard(module);
        break;  

      case 3:
        card = NovelThridCard(module);
        break; 

      case 4:
        card =NovelFourCard(module);
        break;

      default:
    }

    return card;
  }

  Widget buildModule(BuildContext context,HomeModule module) {
    if (module.carousels != null) {
      return HomeBanner(module.carousels);
    }else if (module.menus != null) {
      return HomeMenu(module.menus);
    }else if (module.books != null) {
      return bookCardWithInfo(module);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
          itemCount: modules.length,
          itemBuilder: (BuildContext context,int index) {
            return buildModule(context, modules[index]);
          },
        ),
      ),
       
    );
  }


}


