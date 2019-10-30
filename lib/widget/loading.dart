import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  bool show = false;

  Loading(this.show);

  @override
  Widget build(BuildContext context) {
    return Positioned(
    child: show
    ? Material(
        child: Center(
          child: Container(
            width: 100.0,
            height: 100.0,
            decoration: new BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: new BorderRadius.all(
                new Radius.circular(15.0)
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                Text("Loading...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.0))
              ],
            ),
          ),
        ),
        color: Colors.white.withOpacity(0.8),
      )
    : Container());
  }
}

class LoadingBlock extends StatelessWidget {
  Color colors;
  LoadingBlock(this.colors);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colors),
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  bool loading;
  Widget child;
  LoadingPage({this.loading = false, this.child});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: loading,
      child: Stack(
        children: <Widget>[
          AnimatedOpacity(
            opacity: loading ? 0 : 1,
            duration: Duration(milliseconds: 500),
            child: child
          ),
          loading ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitThreeBounce(color: Theme.of(context).primaryColor, size: 30),
                SizedBox(height: 10),
                Text("Mohon Tunggu", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                SizedBox(height: 5),
                Text("Sedang memuat halaman", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
              ],
            ),
          ):Container(),
        ],
      ),
    );
  }
}