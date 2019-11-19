import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:laundry/util/session.dart';
import 'package:responsive_screen/responsive_screen.dart';

class HomePage extends StatelessWidget {
  Auth user;
  HomePage(this.user);

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    Widget cardButton({String title, Color color, IconData icon, Function onTap}) {
      return InkWell(
        onTap: onTap,
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: <Widget>[
                Text(title, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Icon(icon, color: Colors.white54, size: 60),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: <Widget>[
        Container(
          height: hp(35),
          width: wp(100),
          padding: const EdgeInsets.fromLTRB(22, 60, 22, 0),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(100), bottomLeft: Radius.circular(100))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Halo, ", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600)),
              SizedBox(height: hp(3)),
              Text("Selamat datang Kembali di,", style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w600)),
              Text(user != null ? "${user.name[0].toUpperCase()}${user.name.substring(1)} Laundry":"", style: TextStyle(fontSize: 38, color: Colors.white, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        Container(
          height: hp(56),
          width: wp(100),
          padding: const EdgeInsets.fromLTRB(16, 0, 18, 0),
          child: GridView(
            // physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.8),
            children: <Widget>[
              cardButton(title: "Produk", color: Colors.red, icon: FontAwesomeIcons.tshirt, onTap: () => navService.navigateTo("/products")),
              cardButton(title: "Customer", color: Colors.deepPurple, icon: FontAwesomeIcons.userFriends, onTap: () => navService.navigateTo("/customers")),
              cardButton(title: "Pengeluaran", color: Colors.lightGreen, icon: FontAwesomeIcons.moneyBillWave, onTap: () => navService.navigateTo("/expenses")),
              cardButton(title: "Pengembalian", color: Colors.lightBlue, icon: FontAwesomeIcons.undo, onTap: () => navService.navigateTo("/return")),
              cardButton(title: "Laporan", color: Colors.amber, icon: FontAwesomeIcons.chartLine, onTap: () => navService.navigateTo("/report")),
              cardButton(title: "Printer", color: Colors.blue, icon: FontAwesomeIcons.print, onTap: () => navService.navigateTo("/setting-printer")),
            ],
          ),
        )
      ],
    );
  }
}