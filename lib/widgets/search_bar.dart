import 'package:flutter/material.dart';

import 'package:chat_app/search/users_search.dart';

class SearchContactsBar extends StatelessWidget {
  const SearchContactsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            showSearch(context: context, delegate: UsersSeach());
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(17, 24, 39, .8),
            ),
            width: double.infinity,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Buscar...",
                  style: TextStyle(color: Colors.white24),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
